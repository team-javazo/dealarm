package kr.co.dong.sms.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Map;

import org.springframework.stereotype.Service;


import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.dong.sms.dto.SmsDTO;

// JSON을 만들어서 python으로 보내는 동작

@Service
public class SmsApiServiceImpl implements SmsApiService {

	// Jackson 라이브러리: DTO <-> JSON 변환 담당
	private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public Map<String, Object> sendSms(SmsDTO dto) {
    	try {
            // DTO → JSON 변환
            String json = mapper.writeValueAsString(dto);
            System.out.println("👉 Python으로 보낼 JSON = " + json);

            // Python 실행
            ProcessBuilder pb = new ProcessBuilder(
                "python", "src/main/resources/python/sms/sms_service2.py", json);
            pb.redirectErrorStream(true); // 에러도 표준 출력으로 합침
            Process process = pb.start();

            // STDOUT 읽기
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder output = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line);
            }

            // 4. Python 실행 종료 코드 확인
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                return Map.of("error", "python exit code: " + exitCode);
            }

            // 5. Python에서 출력한 JSON → Java Map 변환
            return mapper.readValue(output.toString(), Map.class);

        } catch (Exception e) {
            e.printStackTrace();
            return Map.of("error", e.getMessage());
        }
    }
}
