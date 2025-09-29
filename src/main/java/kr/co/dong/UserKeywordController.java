package kr.co.dong;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


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
    @ResponseBody
    public Map<String, Object> addKeyword(@RequestBody UserKeywordDTO dto) {
        Map<String, Object> response = new HashMap<>();
        try {
            userKeywordService.addKeyword(dto);
            response.put("success", true);
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    // 키워드 삭제
    @PostMapping("/delete/{id}")
    @ResponseBody
    public Map<String, Object> deleteKeyword(@PathVariable int id) {
        Map<String, Object> response = new HashMap<>();
        try {
            userKeywordService.removeKeyword(String.valueOf(id));
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "삭제 실패");
        }
        return response;
    }

    // 로그인한 사용자의 키워드 목록
    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> getKeywords(@RequestParam String userId) {
        List<UserKeywordDTO> keywords = userKeywordService.getKeywords(userId);
      
        Map<String, Object> result = new HashMap<>();
        result.put("keywords", keywords);
        return result;  // ✅ JSON 형태로 반환됨
    }
    
    //관리자메뉴 회원상세 페이지 키워드 불러오기
    @GetMapping("/memberKeyword")
    @ResponseBody
    public Map<String, Object> memberKeyword(@RequestParam String memberId){
    	List<UserKeywordDTO> keywordList = userKeywordService.memberKeyword(memberId);
    	Map<String, Object> result = new HashMap<>();
    	result.put("keywordList", keywordList);
		return result;
    	
    	
    }


}