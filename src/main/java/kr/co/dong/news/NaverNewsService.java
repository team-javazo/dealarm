package kr.co.dong.news;

import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.dong.UserKeyword.UserKeywordDTO;
import kr.co.dong.UserKeyword.UserKeywordService;

@Service
public class NaverNewsService {

    private static final String CLIENT_ID = "3XWB4YotcPwPrZ0rZdUa";
    private static final String CLIENT_SECRET = "wQC3oL7RGQ";

    // Naver 뉴스 검색
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

    // 로그인 사용자 키워드별 뉴스 가져오기
    public Map<String, List<NaverNewsdto.NewsItem>> getKeywordNewsForUser(String userId, UserKeywordService userKeywordService) throws Exception {
        Map<String, List<NaverNewsdto.NewsItem>> keywordNewsMap = new LinkedHashMap<>();
        Set<String> addedLinks = new HashSet<>();

        List<UserKeywordDTO> keywordDTOs = userKeywordService.getKeywords(userId);

        for (UserKeywordDTO dto : keywordDTOs) {
            // 자기 자신 호출 제거, 그냥 this.searchNews() 사용
            NaverNewsdto newsResponse = this.searchNews(dto.getKeyword());
            List<NaverNewsdto.NewsItem> items = newsResponse.getItems();

            items.removeIf(n -> addedLinks.contains(n.getLink()));
            items = items.size() > 5 ? items.subList(0, 5) : items; // 최대 5개
            items.forEach(n -> addedLinks.add(n.getLink()));
            keywordNewsMap.put(dto.getKeyword(), items);
        }

        return keywordNewsMap;
    }
}
