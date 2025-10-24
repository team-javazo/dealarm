package kr.co.dong.sms;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Map;

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** DB기반 자동 발송 → Python(--b64) 호출 */
@Service
public class SmsApiServiceImpl implements SmsApiService {
	
	private static final Logger log = LoggerFactory.getLogger(SmsApiServiceImpl.class);
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
        private final StringBuilder buffer;
        StreamGobbler(InputStream is, StringBuilder buffer) { this.is = is; this.buffer = buffer; }
        @Override
        public void run() {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    buffer.append(line).append("\n");
                }
            } catch (IOException ignored) {}
        }
    }

    @Override
    public Map<String, Object> sendSms(SmsDTO dto) {
    	log.info("========== 📩 sendSMS 시작 ==========");

        try {
            // 1) DTO → JSON 직렬화
            String json = mapper.writeValueAsString(dto);

            // 2) Base64 인코딩
            String b64 = Base64.getEncoder().encodeToString(json.getBytes(StandardCharsets.UTF_8));
            log.info("👉 [Api] JSON(len={}) → b64(len={})", json.length(), b64.length());
            
            // 3) Python 호출 (manual 방식과 동일)
            ProcessBuilder pb = new ProcessBuilder("python", PYTHON_SCRIPT, "--b64", b64);
            pb.environment().put("PYTHONIOENCODING", "utf-8");

            Process process = pb.start();

            // 4) stdout/stderr 분리해서 동시에 읽기
            StringBuilder stdout = new StringBuilder();
            StringBuilder stderr = new StringBuilder();
            Thread tOut = new Thread(new StreamGobbler(process.getInputStream(), stdout));
            Thread tErr = new Thread(new StreamGobbler(process.getErrorStream(), stderr));
            tOut.start(); tErr.start();

            int exitCode = process.waitFor();
            tOut.join(); tErr.join();

            String out = stdout.toString().trim();
            String err = stderr.toString().trim();

            // 5) 에러 처리
            if (exitCode != 0) {
                log.error("❌ Python script failed (exitCode={}) stderr={}", exitCode, err);
                return Map.of("error", "Python script failed", "stderr", err);
            }
            if (out.isEmpty()) {
                log.error("❌ Python returned empty output stderr={}", err);
                return Map.of("error", "Python returned empty output", "stderr", err);
            }

            // 6) Python → JSON 파싱
            try {
                return mapper.readValue(out, Map.class);
            } catch (Exception parseEx) {
                log.error("❌ Invalid JSON from Python. stdout={}, stderr={}", out, err);
                return Map.of("error", "Invalid JSON from Python", "stdout", out, "stderr", err);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Map.of("error", e.getMessage());
        }
    }
}
