package kr.co.dong.sms;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Map;

@Service
public class SmsManualService {

	private static final Logger log = LoggerFactory.getLogger(SmsManualService.class);
    private final ObjectMapper mapper = new ObjectMapper();
    private static final String PYTHON_SCRIPT;

    static {
        try {
            PYTHON_SCRIPT = new ClassPathResource("python/sms/sms_service3.py")
                    .getFile()
                    .getAbsolutePath();
            log.info("PYTHON_SCRIPT = " + PYTHON_SCRIPT);
        } catch (Exception e) {
            throw new RuntimeException("❌ Python script not found in resources", e);
        }
    }

    private static class StreamGobbler implements Runnable {
        private final InputStream is;
        private final StringBuilder out;
        StreamGobbler(InputStream is, StringBuilder out) {
            this.is = is;
            this.out = out;
        }
        @Override public void run() {
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(is, StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    out.append(line).append('\n');
                }
            } catch (IOException ignored) {}
        }
    }

    public Map<String, Object> sendManualSms(
            String userId, String phone, String title, String url, int dealId) {
        try {
            // 1) DTO → JSON → base64
            SmsDTO dto = new SmsDTO(userId, phone, title, url, dealId);
            String json = mapper.writeValueAsString(dto);
            String b64  = Base64.getEncoder()
                                .encodeToString(json.getBytes(StandardCharsets.UTF_8));
            System.out.println("👉 [Manual] JSON(len=" + json.length() +
                    ") → b64(len=" + b64.length() + ")");

            // 2) Python 프로세스 실행
            ProcessBuilder pb = new ProcessBuilder("python", PYTHON_SCRIPT, "--b64", b64);
            pb.environment().put("PYTHONIOENCODING", "utf-8");
            pb.redirectErrorStream(false);
            Process p = pb.start();

            // 3) stdout / stderr 동시에 읽기
            StringBuilder stdout = new StringBuilder();
            StringBuilder stderr = new StringBuilder();
            Thread tOut = new Thread(new StreamGobbler(p.getInputStream(), stdout));
            Thread tErr = new Thread(new StreamGobbler(p.getErrorStream(), stderr));
            tOut.start(); tErr.start();

            int exit = p.waitFor();
            tOut.join(); tErr.join();

            String out = stdout.toString().trim();
            String err = stderr.toString().trim();

            // 4) 디버깅 로그
            System.out.println(">>> PYTHON STDOUT RAW = " + out);
            if (!err.isEmpty()) {
                System.out.println(">>> PYTHON STDERR RAW = " + err);
            }

            // 5) 결과 처리
            if (exit != 0) {
                return Map.of("error", "Python script failed", "stderr", err);
            }
            if (out.isEmpty()) {
                return Map.of("error", "Python returned empty output", "stderr", err);
            }

            // ✅ Python이 단일 JSON 객체 출력한다고 가정 → Map으로 파싱
            return mapper.readValue(out, Map.class);

        } catch (Exception e) {
            return Map.of("error", e.getMessage());
        }
    }
}
