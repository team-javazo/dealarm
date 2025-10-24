package kr.co.dong.scheduler;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.co.dong.deal.DealSummaryService;
import kr.co.dong.deal.DealSummaryDTO;
import kr.co.dong.sms.SmsDBService;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.inject.Inject;

@Component
public class CrawlScheduler {

    private static final Logger log = LoggerFactory.getLogger(CrawlScheduler.class);

    @Inject
    private DealSummaryService dealSummaryService;

    @Inject
    private SmsDBService smsDBService;

    private static final String PPOM_JSON = System.getProperty("user.home") + "/dealarm-data/ppomppu_crawling.json";
    private static final String QUASAR_JSON = System.getProperty("user.home") + "/dealarm-data/quasarzone_crawling.json";
    private static final String IMAGE_DIR = System.getProperty("user.home") + "/dealarm-data/images";

    @Scheduled(fixedDelay = 300000)
    public void deleteOldDeals() {
        try {
            File imageDir = new File(IMAGE_DIR);

            if (!imageDir.exists()) {
                if (imageDir.mkdirs()) {
                    log.info("📁 이미지 디렉토리 자동 생성됨: {}", IMAGE_DIR);
                } else {
                    log.error("❌ 이미지 디렉토리 생성 실패: {}", IMAGE_DIR);
                    return;
                }
            }

            if (imageDir.exists() && imageDir.isDirectory()) {
                File[] files = imageDir.listFiles();
                if (files != null) {
                    int deletedCount = 0;
                    for (File file : files) {
                        if (file.isFile() && file.delete()) {
                            deletedCount++;
                        }
                    }
                    log.info("로컬 이미지 {}개 삭제 완료 (경로: {})", deletedCount, IMAGE_DIR);
                }
            }
        } catch (Exception e) {
            log.error("❌ 로컬 이미지 파일 삭제 실패: {}", e.getMessage(), e);
        }

        try {
            int deleted = dealSummaryService.deleteOldDeals();
            log.info("[🧹스케줄러] 오래된 딜 {}건 삭제 완료 (posted_at 기준 7일 경과)", deleted);
        } catch (Exception e) {
            log.error("❌ 오래된 딜 삭제 실패: {}", e.getMessage(), e);
        }
    }

    @Scheduled(fixedDelay = 300000)
    public void runCrawlerAndReadJson() {
        try {
            // ====================== 뽐뿌 ======================
            String PYTHON_SCRIPT = new ClassPathResource("python/crawler/ppompu_crawler.py").getFile().getAbsolutePath();
            ProcessBuilder pb = new ProcessBuilder("python", PYTHON_SCRIPT);
            pb.redirectErrorStream(true);
            pb.environment().put("PYTHONIOENCODING", "utf-8");

            Process process = pb.start();

            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    log.debug("[Python-ppom] {}", line);
                }
            }

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                log.error("❌ 뽐뿌 크롤러 실행 실패 (exitCode={})", exitCode);
                return;
            }

            log.info("PPOM_JSON: {}", PPOM_JSON);
            Path json_path = Paths.get(PPOM_JSON);
            String json_string = Files.readString(json_path, StandardCharsets.UTF_8);

            JSONParser json_parser = new JSONParser();
            JSONArray deals = (JSONArray) json_parser.parse(json_string);

            log.info("===== 크롤링 데이터 ({}건) (ppomppu) =====", deals.size());
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

                boolean isSaved = dealSummaryService.saveIfNotExists(dto);
                if (!isSaved) {
                    log.info("🚨 뽐뿌에서 중복 딜 발견! 순회 종료.");
                    break;
                }
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
                    log.debug("[Python-quasar] {}", line);
                }
            }

            exitCode = process.waitFor();
            if (exitCode != 0) {
                log.error("❌ 퀘이사존 크롤러 실행 실패 (exitCode={})", exitCode);
                return;
            }

            log.info("QUASAR_JSON: {}", QUASAR_JSON);
            json_path = Paths.get(QUASAR_JSON);
            json_string = Files.readString(json_path, StandardCharsets.UTF_8);

            JSONParser json_parser2 = new JSONParser();
            JSONArray deals2 = (JSONArray) json_parser2.parse(json_string);

            log.info("===== 크롤링 데이터 ({}건) (quasarzone) =====", deals2.size());
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

                boolean isSaved = dealSummaryService.saveIfNotExists(dto);
                if (!isSaved) {
                    log.info("🚨 퀘이사존에서 중복 딜 발견! 순회 종료.");
                    break;
                }
            }

            // ====================== 문자 발송 ======================
            log.info("========== 📩 SMS 발송 시작 ==========");
            smsDBService.processDeals();

        } catch (Exception e) {
            log.error("❌ 크롤러 실행/DB 저장/문자 발송 실패: {}", e.getMessage(), e);
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
