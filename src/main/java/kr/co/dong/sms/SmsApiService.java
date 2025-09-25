package kr.co.dong.sms;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class SmsApiService {

    private final RestTemplate restTemplate;
    private final String pythonApiUrl = "http://localhost:5000/sms/send"; // Flask 서버 주소

    public SmsApiService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public Map<String, Object> sendSms(SmsDTO dto) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<SmsDTO> entity = new HttpEntity<>(dto, headers);

        try {
            ResponseEntity<Map> response = restTemplate.exchange(
                pythonApiUrl, HttpMethod.POST, entity, Map.class);
            
            return response.getBody();
        } catch (org.springframework.web.client.ResourceAccessException rae) {
            // 연결 불가(연결 거부, 타임아웃 등)
            return Map.of("error", "python service unreachable: " + rae.getMessage());
        } catch (org.springframework.web.client.HttpClientErrorException hce) {
            // 4xx
            return Map.of("error", "http error: " + hce.getStatusCode() + " - " + hce.getResponseBodyAsString());
        } catch (Exception e) {
            return Map.of("error", e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
}