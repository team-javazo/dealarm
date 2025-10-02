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
    public String showNews(@RequestParam(required = false) String query,
                           Model model,
                           HttpSession session) {

        Map<String, List<NaverNewsdto.NewsItem>> keywordNewsMap = new LinkedHashMap<>();
        Set<String> addedLinks = new HashSet<>();

        try {
            // 검색어 뉴스 처리
            if (query != null && !query.isEmpty()) {
                // 검색어 뉴스만 보여주고 싶으면 keywordNewsMap 초기화
                keywordNewsMap.clear();
                addedLinks.clear();

                NaverNewsdto newsResponse = naverNewsService.searchNews(query);
                List<NaverNewsdto.NewsItem> items = newsResponse.getItems();
                items.removeIf(n -> addedLinks.contains(n.getLink()));
                items.forEach(n -> addedLinks.add(n.getLink()));
                keywordNewsMap.put(query, items);

            } else {
                // 로그인 사용자 키워드 뉴스 처리
                String userId = (String) session.getAttribute("id");
                if (userId != null && !userId.isEmpty()) {
                    List<UserKeywordDTO> keywordDTOs = userKeywordService.getKeywords(userId);

                    for (UserKeywordDTO dto : keywordDTOs) {
                        NaverNewsdto newsResponse = naverNewsService.searchNews(dto.getKeyword());
                        List<NaverNewsdto.NewsItem> items = newsResponse.getItems();
                        items.removeIf(n -> addedLinks.contains(n.getLink()));
                        items = items.size() > 5 ? items.subList(0, 5) : items;
                        items.forEach(n -> addedLinks.add(n.getLink()));
                        keywordNewsMap.put(dto.getKeyword(), items);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        model.addAttribute("keywordNewsMap", keywordNewsMap);
        return "news";
    }


}
