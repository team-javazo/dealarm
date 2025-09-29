package kr.co.dong.sms;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Map;

@Service
public class SmsManualService {

    private final ObjectMapper mapper = new ObjectMapper();
    private static final String PYTHON_SCRIPT;

    static {
        try {
            PYTHON_SCRIPT = new ClassPathResource("python/sms/sms_service2.py")
                    .getFile()
                    .getAbsolutePath();
            System.out.println("PYTHON_SCRIPT = " + PYTHON_SCRIPT);
        } catch (Exception e) {
            throw new RuntimeException("❌ Python script not found in resources", e);
        }
    }

    private static class StreamGobbler implements Runnable {
        private final InputStream is;
        private final StringBuilder out;
        StreamGobbler(InputStream is, StringBuilder out) { this.is = is; this.out = out; }
        @Override public void run() {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) out.append(line).append('\n');
            } catch (IOException ignored) {}
        }
    }

    public Map<String, Object> sendManualSms(String userId, String phone, String title, String url, int dealId) {
        try {
            SmsDTO dto = new SmsDTO(userId, phone, title, url, dealId);
            String json = mapper.writeValueAsString(dto);
            String b64  = Base64.getEncoder().encodeToString(json.getBytes(StandardCharsets.UTF_8));
            System.out.println("👉 [Manual] JSON(len=" + json.length() + ") → b64(len=" + b64.length() + ")");

            ProcessBuilder pb = new ProcessBuilder("python", PYTHON_SCRIPT, "--b64", b64);
            pb.environment().put("PYTHONIOENCODING", "utf-8");

            // ✅ stderr와 stdout 분리
            pb.redirectErrorStream(false);
            Process p = pb.start();

            // ✅ 동시에 읽기 (버퍼 막힘 방지)
            StringBuilder stdout = new StringBuilder();
            StringBuilder stderr = new StringBuilder();
            Thread tOut = new Thread(new StreamGobbler(p.getInputStream(), stdout));
            Thread tErr = new Thread(new StreamGobbler(p.getErrorStream(), stderr));
            tOut.start(); tErr.start();

            int exit = p.waitFor();
            tOut.join(); tErr.join();

            String out = stdout.toString().trim();
            String err = stderr.toString().trim();

            if (exit != 0) {
                // 파이썬은 에러 시 stdout을 비우고 stderr만 보냄 → 그대로 사용자에게 보여줌
                return Map.of("error", "Python script failed", "stderr", err);
            }
            if (out.isEmpty()) {
                return Map.of("error", "Python returned empty output", "stderr", err);
            }

            // ✅ stdout(JSON)만 파싱
            return mapper.readValue(out, Map.class);

        } catch (Exception e) {
            return Map.of("error", e.getMessage());
        }
    }
}
