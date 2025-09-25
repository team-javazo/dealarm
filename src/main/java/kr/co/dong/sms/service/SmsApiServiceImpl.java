package kr.co.dong.sms.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import kr.co.dong.sms.dto.SmsDTO;

@Service
public class SmsApiServiceImpl implements SmsApiService {

	@Autowired
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
