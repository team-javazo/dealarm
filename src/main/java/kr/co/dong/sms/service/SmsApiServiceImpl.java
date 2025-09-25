package kr.co.dong.sms.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.dong.sms.dto.SmsDTO;

// JSON을 만들어서 python으로 보내는 동작

@Service
public class SmsApiServiceImpl implements SmsApiService {

    private final RestTemplate restTemplate;
    private final String pythonApiUrl = "http://localhost:5000/sms/send"; // Flask 서버 주소

    public SmsApiServiceImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @Override
    public Map<String, Object> sendSms(SmsDTO dto) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<SmsDTO> entity = new HttpEntity<>(dto, headers);
        
        try {
        	ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(dto);
            System.out.println("👉 Flask로 보낼 JSON = " + json);
            System.out.println(dto);
        	
            ResponseEntity<Map> response = restTemplate.exchange(
                pythonApiUrl, HttpMethod.POST, entity, Map.class
            );
            return response.getBody();
        } catch (org.springframework.web.client.ResourceAccessException rae) {
            return Map.of("error", "python service unreachable: " + rae.getMessage());
        } catch (org.springframework.web.client.HttpClientErrorException hce) {
            return Map.of("error", "http error: " + hce.getStatusCode() + " - " + hce.getResponseBodyAsString());
        } catch (Exception e) {
            return Map.of("error", e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
}
