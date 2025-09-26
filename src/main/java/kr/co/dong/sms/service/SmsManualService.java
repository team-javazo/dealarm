package kr.co.dong.sms.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Map;

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.dong.sms.dto.SmsDTO;

/** 수동 발송(테스트) → Python(stdin b64) 호출 */
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

    public Map<String, Object> sendManualSms(String userId, String phone, String title, String url, int dealId) {
        try {
            SmsDTO dto = new SmsDTO(userId, phone, title, url, dealId);
            String json = mapper.writeValueAsString(dto);
            String b64 = Base64.getEncoder().encodeToString(json.getBytes(StandardCharsets.UTF_8));
            System.out.println("👉 [Manual] JSON(len=" + json.length() + ") → b64(len=" + b64.length() + ")");

            ProcessBuilder pb = new ProcessBuilder("python", PYTHON_SCRIPT, "--b64-stdin");
            pb.redirectErrorStream(true);
            pb.environment().put("PYTHONIOENCODING", "utf-8");
            Process process = pb.start();

            // stdin으로 Base64 전달
            try (BufferedWriter writer = new BufferedWriter(
                    new OutputStreamWriter(process.getOutputStream(), StandardCharsets.UTF_8))) {
            	writer.write(b64);
            	writer.newLine();   // Python에서 read() 끝을 인식하도록 개행
            	writer.flush();
            	writer.close();     // 꼭 닫아야 Python이 stdin EOF 인식
            }

            StringBuilder output = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    output.append(line);
                }
            }
            
            // 로그 찍기 나중에 지워도 됨
            System.out.println("👉 Python Output = " + output);

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                return Map.of("error", "Python script failed", "details", output.toString());
            }
            if (output.toString().isBlank()) {
                return Map.of("error", "Python returned empty output");
            }

            return mapper.readValue(output.toString(), Map.class);

        } catch (Exception e) {
            return Map.of("error", e.getMessage());
        }
    }
}
