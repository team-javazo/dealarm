package kr.co.dong.scheduler;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

@Component
public class CrawlScheduler {

    // ✅ 절대 경로 고정 (Python이 저장하는 곳)
    private static final Path JSON_PATH =
            Path.of("C:/hys/git/dealarm/src/main/resources/crawler/ppomppu_crawling.json");

    // 5분마다 실행 (이전 실행이 끝난 후 5분 뒤)
    @Scheduled(fixedDelay = 300000)
    public void readCrawledJson() {
        try {
            // 파일 읽기
            String json = Files.readString(JSON_PATH, StandardCharsets.UTF_8);

            // JSON 파싱
            ObjectMapper mapper = new ObjectMapper();
            List<Map<String, Object>> deals = mapper.readValue(json, new TypeReference<>() {});

            // 콘솔 출력
            System.out.println("===== 크롤링 데이터 (" + deals.size() + "건) =====");
            for (Map<String, Object> deal : deals) {
                System.out.println("제목: " + deal.get("title"));
                System.out.println("링크: " + deal.get("link"));
                System.out.println("가격: " + deal.get("price"));
                System.out.println("사이트: " + deal.get("site"));
                System.out.println("게시일: " + deal.get("posted_at"));
                System.out.println("추천수: " + deal.get("recommend"));
                System.out.println("----------------------------");
            }

        } catch (Exception e) {
            System.err.println("❌ JSON 읽기 실패: " + e.getMessage());
        }
    }
}
