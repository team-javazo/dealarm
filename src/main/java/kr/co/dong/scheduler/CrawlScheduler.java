package kr.co.dong.scheduler;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.co.dong.deal.DealSummaryService;
import kr.co.dong.deal.DealSummaryDTO2;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.inject.Inject;

@Component
public class CrawlScheduler {
	@Inject
	private DealSummaryService dealSummaryService;

	private static final String PPOM_JSON = System.getProperty("user.home") + "/dealarm-data/ppomppu_crawling.json";

	// 5분마다 실행
	@Scheduled(fixedDelay = 300000)

	public void runCrawlerAndReadJson() {
		try {
			// 1. 파이썬 실행
			String PYTHON_SCRIPT = new ClassPathResource("python/crawler/ppompu_crawler.py").getFile()
					.getAbsolutePath();
			ProcessBuilder pb = new ProcessBuilder("python", PYTHON_SCRIPT);
			pb.redirectErrorStream(true);

			// 파이썬 stdout 인코딩을 UTF-8로 강제
			pb.environment().put("PYTHONIOENCODING", "utf-8");

			Process process = pb.start();

			// 파이썬 실행 로그 출력
			try (BufferedReader reader = new BufferedReader(
					new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
				String line;
				while ((line = reader.readLine()) != null) {
					System.out.println("[Python] " + line);// 이거 굳이 안해도 됨
				}
			}

			int exitCode = process.waitFor();
			if (exitCode != 0) {
				System.err.println("❌ Python script 실행 실패 (exitCode=" + exitCode + ")");
				return;
			}
			// 1. JSON 파일 경로
			System.out.println(PPOM_JSON);
			Path ppom_json_path = Paths.get(PPOM_JSON); // PPOM_JSON은 절대경로 또는 설정값

			// 2. JSON 문자열 읽기
			String ppom_json_string = Files.readString(ppom_json_path, StandardCharsets.UTF_8);

			// 3. JSON 파싱
			JSONParser ppom_parser = new JSONParser();
			JSONArray ppom_deals = (JSONArray) ppom_parser.parse(ppom_json_string);

			System.out.println("===== 크롤링 데이터 (" + ppom_deals.size() + "건) =====");
			for (Object obj : ppom_deals) {
			    JSONObject deal = (JSONObject) obj;

			    DealSummaryDTO2 dto = new DealSummaryDTO2();
			    dto.setTitle((String) deal.get("title"));
			    dto.setUrl((String) deal.get("url"));
			    dto.setPrice(safeParseInt(deal.get("price")));  // 가격 안전 변환
			    dto.setSite((String) deal.get("site"));
			    dto.setLikes(safeParseInt(deal.get("likes")));  // 좋아요 안전 변환
			    dto.setImg((String) deal.get("img"));

			    // posted_at (문자열 → Date 변환)
			    Object postedAtObj = deal.get("posted_at");
			    if (postedAtObj != null) {
			        String postedAtStr = String.valueOf(postedAtObj);
			        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			        dto.setPostedAt(sdf.parse(postedAtStr));
			    }

			    // DB 저장 (중복 방지)
			    dealSummaryService.saveIfNotExists(dto);
			}

		} catch (Exception e) {
            System.err.println("❌ 크롤러 실행/DB 저장 실패: " + e.getMessage());
            e.printStackTrace();
        }
		
    }

	private int safeParseInt(Object obj) {
        if (obj == null) return 0;
        try {
            return Integer.parseInt(String.valueOf(obj).replaceAll("[^0-9]", ""));
        } catch (Exception e) {
            return 0;
        }
    }
}
