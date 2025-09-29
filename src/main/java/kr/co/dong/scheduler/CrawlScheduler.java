package kr.co.dong.scheduler;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.co.dong.sms.SmsDBService;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;


@Component
public class CrawlScheduler {

    private static final String PPOM_JSON = System.getProperty("user.home") + "/dealarm-data/ppomppu_crawling.json";
 
    private final SmsDBService smsDBService;

    public CrawlScheduler(SmsDBService smsDBService) {
        this.smsDBService = smsDBService;
    }
    
    // 5분마다 실행
    @Scheduled(fixedDelay = 300000)

    public void runCrawlerAndReadJson() {
        try {
            //1. 파이썬 실행
        	String PYTHON_SCRIPT = new ClassPathResource("python/crawler/ppompu_crawler.py").getFile().getAbsolutePath();
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
                    System.out.println("[Python] " + line);//이거 굳이 안해도 됨
                }
            }

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                System.err.println("❌ Python script 실행 실패 (exitCode=" + exitCode + ")");
                return;
            }

            //2. JSON 읽기
         // 1. JSON 파일 경로
            System.out.println(PPOM_JSON);
            Path ppom_json_path = Paths.get(PPOM_JSON); // PPOM_JSON은 절대경로 또는 설정값

            // 2. JSON 문자열 읽기
            String ppom_json_string = Files.readString(ppom_json_path, StandardCharsets.UTF_8);

            // 3. JSON 파싱
            JSONParser ppom_parser = new JSONParser();
            JSONArray ppom_deals = (JSONArray) ppom_parser.parse(ppom_json_string);
            
            // 4. 크롤링 완료 후 → sms 발송 프로세스 실행
            smsDBService.processDeals();
            
            System.out.println("===== 크롤링 데이터 (" + ppom_deals.size() + "건) =====");
            for (Object obj : ppom_deals) {
                JSONObject deal = (JSONObject) obj;
                System.out.println("제목: " + deal.get("title"));
                System.out.println("링크: " + deal.get("url"));
                System.out.println("가격: " + deal.get("price"));
                System.out.println("사이트: " + deal.get("site"));
                System.out.println("게시일: " + deal.get("posted_at"));
                System.out.println("추천수: " + deal.get("likes"));
                System.out.println("----------------------------");
            }

        } catch (Exception e) {
            System.err.println("❌ 크롤러 실행/JSON 읽기 실패: " + e.getMessage());
        }
    }
}
