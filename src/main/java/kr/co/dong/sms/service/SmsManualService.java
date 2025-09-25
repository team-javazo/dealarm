package kr.co.dong.sms.service;

import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import kr.co.dong.sms.dto.SmsDTO;

@Service
public class SmsManualService {

    private final RestTemplate restTemplate;
    private final String smsApiUrl = "http://localhost:5000/sms/send"; // Flask 서버 주소

    
    public SmsManualService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public Map<String, Object> sendManualSms(String userId, String phone, String title, String url, int dealId) {
        SmsDTO dto = new SmsDTO(userId, phone, title, url, dealId);  // ✅ DTO 직접 사용

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<SmsDTO> request = new HttpEntity<>(dto, headers);

        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(smsApiUrl, request, Map.class);
            return response.getBody();
        } catch (Exception e) {
            return Map.of("error", e.getMessage());
        }
    }
}
