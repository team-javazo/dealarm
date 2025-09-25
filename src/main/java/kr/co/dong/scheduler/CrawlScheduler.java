package kr.co.dong.scheduler;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

@Component
public class CrawlScheduler {

    private static final String JSON_CLASSPATH = "crawler/ppomppu_crawling.json";
 
  private static final String PYTHON_SCRIPT = "C:/hys/git/dealarm/src/main/python/crawler/ppompu_crawler.py";     //절대경로 변경 필요 

    // 5분마다 실행
    @Scheduled(fixedDelay = 300000)
    public void runCrawlerAndReadJson() {
        try {
            //1. 파이썬 실행
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
            ClassPathResource resource = new ClassPathResource(JSON_CLASSPATH);
            String json = Files.readString(resource.getFile().toPath(), StandardCharsets.UTF_8);

            JSONParser parser = new JSONParser();
            JSONArray deals = (JSONArray) parser.parse(json);

            System.out.println("===== 크롤링 데이터 (" + deals.size() + "건) =====");
            for (Object obj : deals) {
                JSONObject deal = (JSONObject) obj;
                System.out.println("제목: " + deal.get("title"));
                System.out.println("링크: " + deal.get("link"));
                System.out.println("가격: " + deal.get("price"));
                System.out.println("사이트: " + deal.get("site"));
                System.out.println("게시일: " + deal.get("posted_at"));
                System.out.println("추천수: " + deal.get("recommend"));
                System.out.println("----------------------------");
            }

        } catch (Exception e) {
            System.err.println("❌ 크롤러 실행/JSON 읽기 실패: " + e.getMessage());
        }
    }
}
