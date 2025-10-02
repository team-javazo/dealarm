package kr.co.dong;

import java.util.HashMap;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

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
		return result; // ✅ JSON 형태로 반환됨
	}

	// 게시판 유저별 키워드 랭킹 조회
	@GetMapping("/ranking/default")
	@ResponseBody
	public Map<String, Object> getDefaultKeywordRanking(HttpSession session) {
		Map<String, Object> result = new HashMap<>();
		try {
			String userId = (String) session.getAttribute("userId");
			if (userId == null || userId.isEmpty()) {
				userId = null; // 로그인하지 않으면 userId는 null로 처리
			}

			// 기본값 조회: 성별 = all, 나이 범위 = 10~60
			List<UserKeywordDTO> keywordRankings = userKeywordService.getKeywordRankingByFilters("all", 10, 60, userId);
			result.put("keywordRankings", keywordRankings);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("error", "서버 처리 중 오류가 발생했습니다.");
			System.out.println("Default keyword ranking error: " + e.getMessage());
		}
		return result;
	}

	// 카테고리별 키워드 랭킹 조회
	@GetMapping("/ranking")
	@ResponseBody
	public Map<String, Object> getKeywordRankingByGenderAndAge(@RequestParam String gender,
	                                                            @RequestParam int startAge,
	                                                            @RequestParam int endAge,
	                                                            HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        // 성별 변환 처리: 'm' -> 'male', 'f' -> 'female', 'all'은 성별 필터링을 하지 않음
	        if ("m".equals(gender)) {
	            gender = "male";
	        } else if ("f".equals(gender)) {
	            gender = "female";
	        } else if ("all".equals(gender)) {
	            gender = "all";  // 'all'일 때는 성별 조건을 아예 생략
	        }

	        // 세션에서 userId 추출 (로그인 여부 상관없이)
	        String userId = (String) session.getAttribute("userId");
	        if (userId == null || userId.isEmpty()) {
	            userId = null;  // userId가 없으면 null로 처리
	        }

	        // 필터링된 키워드 랭킹 조회
	        List<UserKeywordDTO> keywordRankings = userKeywordService.getKeywordRankingByFilters(gender, startAge, endAge, userId);
	        result.put("keywordRankings", keywordRankings);
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("error", "서버 처리 중 오류가 발생했습니다.");
	        System.out.println("Keyword ranking error: " + e.getMessage());
	    }
	    return result;
	}

}