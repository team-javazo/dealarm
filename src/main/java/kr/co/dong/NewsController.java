package kr.co.dong;

import java.util.*;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.dong.UserKeyword.UserKeywordDTO;
import kr.co.dong.UserKeyword.UserKeywordService;
import kr.co.dong.news.NaverNewsdto;
import kr.co.dong.news.NaverNewsService;

@Controller
public class NewsController {

    @Inject
    private NaverNewsService naverNewsService;

    @Inject
    private UserKeywordService userKeywordService;

    @GetMapping("/news")
    public String showNews(
            @RequestParam(required = false) String query,
            Model model,
            HttpSession session) throws Exception {

        Map<String, List<NaverNewsdto.NewsItem>> keywordNewsMap = new LinkedHashMap<>();
        Set<String> addedLinks = new HashSet<>();

        // 검색어 뉴스: 갯수 제한 없음
        if (query != null && !query.isEmpty()) {
            NaverNewsdto newsResponse = naverNewsService.searchNews(query);
            List<NaverNewsdto.NewsItem> items = newsResponse.getItems()
                    .stream()
                    .filter(n -> !addedLinks.contains(n.getLink()))
                    .collect(Collectors.toList());
            items.forEach(n -> addedLinks.add(n.getLink()));
            keywordNewsMap.put(query, items);
        }

        // 로그인 사용자 키워드 뉴스: 각 키워드별 최대 5개
        String userId = (String) session.getAttribute("userId");
        if (userId == null) userId = (String) session.getAttribute("id");

        if (userId != null && !userId.isEmpty()) {
            List<UserKeywordDTO> keywordDTOs = userKeywordService.getKeywords(userId);

            for (UserKeywordDTO dto : keywordDTOs) {
                try {
                    NaverNewsdto newsResponse = naverNewsService.searchNews(dto.getKeyword());

                    Set<String> keywordLinks = new HashSet<>();
                    List<NaverNewsdto.NewsItem> items = newsResponse.getItems()
                            .stream()
                            .filter(n -> !keywordLinks.contains(n.getLink()))
                            .peek(n -> keywordLinks.add(n.getLink()))
                            .limit(5)
                            .collect(Collectors.toList());

                    keywordNewsMap.put(dto.getKeyword(), items);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        model.addAttribute("keywordNewsMap", keywordNewsMap);
        return "news"; // JSP로 이동
    }
}
