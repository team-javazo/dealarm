package kr.co.dong.scheduler;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.co.dong.deal.DealSummaryService;
import kr.co.dong.deal.DealSummaryDTO;
import kr.co.dong.sms.SmsDBService;   // ✅ 문자 발송 서비스 import

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
    private DealSummaryService dealSummaryService; // 크롤링 데이터 DB 저장 서비스

    @Inject
    private SmsDBService smsDBService; // ✅ 키워드 매칭 + 문자 발송 서비스

    private static final String PPOM_JSON = System.getProperty("user.home") + "/dealarm-data/ppomppu_crawling.json";
    private static final String QUASAR_JSON = System.getProperty("user.home")
            + "/dealarm-data/quasarzone_crawling.json";

    // 5분마다 실행
    @Scheduled(fixedDelay = 300000)
    public void runCrawlerAndReadJson() {
        try {
            // ====================== 뽐뿌 ======================
            String PYTHON_SCRIPT = new ClassPathResource("python/crawler/ppompu_crawler.py").getFile()
                    .getAbsolutePath();
            ProcessBuilder pb = new ProcessBuilder("python", PYTHON_SCRIPT);
            pb.redirectErrorStream(true);
            pb.environment().put("PYTHONIOENCODING", "utf-8");

            Process process = pb.start();

            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println("[Python-ppom] " + line);
                }
            }

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                System.err.println("❌ 뽐뿌 크롤러 실행 실패 (exitCode=" + exitCode + ")");
                return;
            }

            System.out.println(PPOM_JSON);
            Path json_path = Paths.get(PPOM_JSON);
            String json_string = Files.readString(json_path, StandardCharsets.UTF_8);

            JSONParser json_parser = new JSONParser();
            JSONArray deals = (JSONArray) json_parser.parse(json_string);

            System.out.println("===== 크롤링 데이터 (" + deals.size() + "건) (ppomppu) =====");
            for (Object obj : deals) {
                JSONObject deal = (JSONObject) obj;

                DealSummaryDTO dto = new DealSummaryDTO();
                dto.setTitle((String) deal.get("title"));
                dto.setUrl((String) deal.get("url"));
                dto.setPrice(safeParseInt(deal.get("price")));
                dto.setSite((String) deal.get("site"));
                dto.setLikes(safeParseInt(deal.get("likes")));
                dto.setImg((String) deal.get("img"));

                Object postedAtObj = deal.get("posted_at");
                if (postedAtObj != null) {
                    String postedAtStr = String.valueOf(postedAtObj);
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    dto.setPostedAt(sdf.parse(postedAtStr));
                }

                dealSummaryService.saveIfNotExists(dto);
            }

            // ====================== 퀘이사존 ======================
            PYTHON_SCRIPT = new ClassPathResource("python/crawler/quasar_crawler.py").getFile().getAbsolutePath();
            pb = new ProcessBuilder("python", PYTHON_SCRIPT);
            pb.redirectErrorStream(true);
            pb.environment().put("PYTHONIOENCODING", "utf-8");

            process = pb.start();

            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println("[Python-quasar] " + line);
                }
            }

            exitCode = process.waitFor();
            if (exitCode != 0) {
                System.err.println("❌ 퀘이사존 크롤러 실행 실패 (exitCode=" + exitCode + ")");
                return;
            }

            System.out.println(QUASAR_JSON);
            json_path = Paths.get(QUASAR_JSON);
            json_string = Files.readString(json_path, StandardCharsets.UTF_8);

            JSONParser json_parser2 = new JSONParser();
            JSONArray deals2 = (JSONArray) json_parser2.parse(json_string);

            System.out.println("===== 크롤링 데이터 (" + deals2.size() + "건) (quasarzone) =====");
            for (Object obj : deals2) {
                JSONObject deal2 = (JSONObject) obj;

                DealSummaryDTO dto = new DealSummaryDTO();
                dto.setTitle((String) deal2.get("title"));
                dto.setUrl((String) deal2.get("url"));
                dto.setPrice(safeParseInt(deal2.get("price")));
                dto.setSite((String) deal2.get("site"));
                dto.setLikes(safeParseInt(deal2.get("likes")));
                dto.setImg((String) deal2.get("img"));

                Object postedAtObj = deal2.get("posted_at");
                if (postedAtObj != null) {
                    String postedAtStr = String.valueOf(postedAtObj);
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    dto.setPostedAt(sdf.parse(postedAtStr));
                }

                dealSummaryService.saveIfNotExists(dto);
            }

            // ====================== 문자 발송 시작 ======================
            System.out.println("========== 📩 SMS 발송 시작 ==========");
            smsDBService.processDeals();

        } catch (Exception e) {
            System.err.println("❌ 크롤러 실행/DB 저장/문자 발송 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private int safeParseInt(Object obj) {
        if (obj == null)
            return 0;
        try {
            return Integer.parseInt(String.valueOf(obj).replaceAll("[^0-9]", ""));
        } catch (Exception e) {
            return 0;
        }
    }
}
