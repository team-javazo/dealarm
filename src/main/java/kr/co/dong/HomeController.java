package kr.co.dong;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.co.dong.UserKeyword.UserKeywordDTO;
import kr.co.dong.UserKeyword.UserKeywordService;
import kr.co.dong.news.NaverNewsService;
import kr.co.dong.news.NaverNewsdto;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
   
   @Inject
   private NaverNewsService naverNewsService;

   @Inject
   private UserKeywordService userKeywordService;
   
   private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
   
   /**
    * Simply selects the home view to render by returning its name.
    */
   @RequestMapping(value = "/", method = RequestMethod.GET)
   public String home(Locale locale, Model model) {
      logger.info("Welcome home! The client locale is {}.", locale);
      
      Date date = new Date();
      DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
      
      String formattedDate = dateFormat.format(date);
      
      model.addAttribute("serverTime", formattedDate );
      
      logger.info("import->git->clone URI->주소지정");
      
      return "home";
   }
   @RequestMapping(value = "/include/footer", method = RequestMethod.GET)
   public String footer(Locale locale, Model model) {
      logger.info("Welcome home! The client locale is {}.", locale);
      
      Date date = new Date();
      DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
      
      String formattedDate = dateFormat.format(date);
      
      model.addAttribute("serverTime", formattedDate );
      
      logger.info("import->git->clone URI->주소지정");
      
      return "include/footer";
   }
   
   
   @GetMapping(value = "/Update")
   public String Update() {
      return "Update";
      
   }
   @GetMapping("/main")
   public String main(HttpSession session) {
       Object userId = session.getAttribute("id");

       List<Map<String, String>> latestNews = new ArrayList<>();
       Set<String> addedLinks = new HashSet<>();

       try {
           if (userId != null) {
               // 로그인 O → 유저 키워드 뉴스
               List<UserKeywordDTO> keywordDTOs = userKeywordService.getKeywords((String) userId);

               for (UserKeywordDTO dto : keywordDTOs) {
                   NaverNewsdto newsResponse = naverNewsService.searchNews(dto.getKeyword());
                   for (NaverNewsdto.NewsItem item : newsResponse.getItems()) {
                       if (addedLinks.contains(item.getLink())) continue;
                       addedLinks.add(item.getLink());

                       Map<String, String> newsMap = new HashMap<>();
                       newsMap.put("title", item.getTitle());
                       newsMap.put("pubDate", item.getPubDate());
                       newsMap.put("keyword", dto.getKeyword());
                       newsMap.put("link", item.getLink());
                       latestNews.add(newsMap);
                   }
               }
           } else {
               // 로그인 X → 최신 트렌드 키워드 뉴스
               String[] trendingKeywords = {
                   "인공지능", "전기차", "메타버스", "환경", "건강",
                   "스타트업", "여행", "스마트폰", "K-콘텐츠", "요리"
               };

               for (String keyword : trendingKeywords) {
                   NaverNewsdto newsResponse = naverNewsService.searchNews(keyword);
                   for (NaverNewsdto.NewsItem item : newsResponse.getItems()) {
                       if (addedLinks.contains(item.getLink())) continue;
                       addedLinks.add(item.getLink());

                       Map<String, String> newsMap = new HashMap<>();
                       newsMap.put("title", item.getTitle());
                       newsMap.put("pubDate", item.getPubDate());
                       newsMap.put("keyword", keyword);
                       newsMap.put("link", item.getLink());
                       latestNews.add(newsMap);
                   }
               }
           }
       } catch (Exception e) {
           e.printStackTrace();
       }

       // 최신순 정렬 후 10개만
       latestNews = latestNews.stream()
                              .sorted((a, b) -> b.get("pubDate").compareTo(a.get("pubDate")))
                              .limit(15)
                              .collect(Collectors.toList());

       session.setAttribute("latestNews", latestNews);

       return "main"; // main.jsp
   }

   
}
