package kr.co.dong;

import java.util.List;

import javax.inject.Inject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.co.dong.UserKeyword.UserKeywordDTO;
import kr.co.dong.UserKeyword.UserKeywordService;

@Controller
@RequestMapping("/keywords")
public class UserKeywordController {

    @Inject
    private UserKeywordService userKeywordService;

    // 키워드 추가
    @PostMapping("/add")
    public String addKeyword(@RequestParam("userId") String userId,
                             @RequestParam("keyword") String keyword) {
        UserKeywordDTO dto = new UserKeywordDTO();
        dto.setUserId(userId);
        dto.setKeyword(keyword);
        userKeywordService.addKeyword(dto);
        return "redirect:/keywords/list/" + userId;  // 키워드 목록으로 리다이렉트
    }
    
    // 키워드 목록
    @RequestMapping("/list/{userId}")
    public String listKeywords(@PathVariable("userId") String userId, Model model) {
        List<UserKeywordDTO> keywords = userKeywordService.getKeywords(userId);
        model.addAttribute("keywords", keywords);
        return "home"; 
    }
    
    // 키워드 삭제
    @PostMapping("/delete/{id}")
    public String deleteKeyword(@PathVariable("id") String num) {
        userKeywordService.removeKeyword(num);  // 키워드 삭제 서비스 호출
        return "redirect:/keywords/list/{userId}";  // 키워드 목록으로 리다이렉트
    }
}
