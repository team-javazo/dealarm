package kr.co.dong.news;

import java.util.List;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class NaverNewsService {

    private static final String CLIENT_ID = "3XWB4YotcPwPrZ0rZdUa";
    private static final String CLIENT_SECRET = "wQC3oL7RGQ";

    public NaverNewsdto searchNews(String query) throws Exception {
        String url = "https://openapi.naver.com/v1/search/news.json?query=" + query;

        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", CLIENT_ID);
        headers.set("X-Naver-Client-Secret", CLIENT_SECRET);

        HttpEntity<String> entity = new HttpEntity<>("", headers);

        ResponseEntity<String> response = restTemplate.exchange(
                url,
                HttpMethod.GET,
                entity,
                String.class
        );

        ObjectMapper mapper = new ObjectMapper();
        return mapper.readValue(response.getBody(), NaverNewsdto.class);
    }
}
