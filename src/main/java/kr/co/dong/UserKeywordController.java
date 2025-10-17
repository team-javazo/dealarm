package kr.co.dong;

import java.util.ArrayList;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.HashSet; // Set 사용을 위해 import 추가
import javax.inject.Inject;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import kr.co.dong.UserKeyword.UserKeywordDTO;
import kr.co.dong.UserKeyword.UserKeywordService;
import kr.co.dong.util.GoogleApiUtil;

@Controller
@RequestMapping("/keywords")
public class UserKeywordController {

	@Inject
	private UserKeywordService userKeywordService;

	// GoogleApiUtil 주입
	@Inject
	private GoogleApiUtil GoogleApiUtil;

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
		return result;
	}

	// 게시판 유저별 키워드 랭킹 조회 (기존 로직)
	@GetMapping("/ranking/default")
	@ResponseBody
	public Map<String, Object> getDefaultKeywordRanking(HttpSession session) {
		Map<String, Object> result = new HashMap<>();
		try {
			String userId = (String) session.getAttribute("userId");
			if (userId == null || userId.isEmpty()) {
				userId = null;
			}

			// 기본값 조회: 성별 = all, 나이 범위 = 10~60
			List<UserKeywordDTO> keywordRankings = userKeywordService.getKeywordRankingByFilters("all", 0, 60, userId);
			result.put("keywordRankings", keywordRankings);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("error", "서버 처리 중 오류가 발생했습니다.");
			System.out.println("Default keyword ranking error: " + e.getMessage());
		}
		return result;
	}

	// 카테고리별 키워드 랭킹 조회 (기존 로직)
	@GetMapping("/ranking")
	@ResponseBody
	public Map<String, Object> getKeywordRankingByGenderAndAge(@RequestParam String gender, @RequestParam int startAge,
			@RequestParam int endAge, HttpSession session) {
		Map<String, Object> result = new HashMap<>();
		try {
			// 성별 변환 처리: 'm' -> 'male', 'f' -> 'female', 'all'은 성별 필터링을 하지 않음
			if ("m".equals(gender)) {
				gender = "male";
			} else if ("f".equals(gender)) {
				gender = "female";
			} else if ("all".equals(gender)) {
				gender = "all";
			}

			// 세션에서 userId 추출 (로그인 여부 상관없이)
			String userId = (String) session.getAttribute("userId");
			if (userId == null || userId.isEmpty()) {
				userId = null;
			}

			// 필터링된 키워드 랭킹 조회
			List<UserKeywordDTO> keywordRankings = userKeywordService.getKeywordRankingByFilters(gender, startAge,
					endAge, userId);
			result.put("keywordRankings", keywordRankings);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("error", "서버 처리 중 오류가 발생했습니다.");
			System.out.println("Keyword ranking error: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 🔑 My 키워드 기반 추천 키워드 조회 (새로 추가) 로그인 유저의 저장된 키워드 중 3개를 무작위로 선택하여 API를 호출하고 결과를
	 * 반환합니다.
	 */
	@GetMapping("/related/user")
	@ResponseBody
	public Map<String, Object> getRelatedKeywordsFromUserKeywords(HttpSession session) {
		Map<String, Object> result = new HashMap<>();
		// JSP에서 사용하는 세션 ID 속성 'id'를 사용합니다.
		String userId = (String) session.getAttribute("id");

		if (userId == null || userId.isEmpty()) {
			result.put("success", false);
			result.put("error", "로그인이 필요합니다.");
			return result;
		}

		try {
			List<UserKeywordDTO> userKeywords = userKeywordService.getKeywords(userId);

			if (userKeywords == null || userKeywords.isEmpty()) {
				result.put("success", true);
				result.put("relatedKeywords", new ArrayList<String>());
				result.put("searchKeywords", new ArrayList<String>());
				result.put("message", "등록된 키워드가 없습니다. 키워드를 등록해주세요.");
				return result;
			}

			// 1. 키워드 목록에서 무작위로 최대 3개 선택
			List<String> selectedKeywords = new ArrayList<>();
			List<UserKeywordDTO> mutableList = new ArrayList<>(userKeywords);
			Collections.shuffle(mutableList);

			int count = Math.min(3, userKeywords.size());
			for (int i = 0; i < count; i++) {
				selectedKeywords.add(mutableList.get(i).getKeyword());
			}

			// 2. 선택된 각 키워드에 대해 API 호출 후 결과를 통합 (중복 제거)
			Set<String> combinedRelatedKeywords = new HashSet<>();
			for (String keyword : selectedKeywords) {
				List<String> apiResults = GoogleApiUtil.getRelatedKeywords(keyword);
				// API 호출 오류 메시지는 최종 결과에서 제외
				if (apiResults.size() == 1 && apiResults.get(0).contains("오류")) {
					continue;
				}
				combinedRelatedKeywords.addAll(apiResults);
			}

			// 3. Set을 List로 변환하고 최종적으로 최대 4개만 추출
			List<String> finalRelatedKeywords = new ArrayList<>(combinedRelatedKeywords);

			if (finalRelatedKeywords.size() > 4) {
				finalRelatedKeywords = finalRelatedKeywords.subList(0, 4);
			}

			// 4. 응답 구성
			result.put("success", true);
			result.put("searchKeywords", selectedKeywords); // 검색에 사용된 키워드
			result.put("relatedKeywords", finalRelatedKeywords); // 최종 추천 키워드

		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("error", "My 키워드 연관 검색어 조회 중 오류가 발생했습니다.");
		}
		return result;
	}

	// 🆕 연관 검색어 검색 엔드포인트
	@GetMapping("/related")
	@ResponseBody
	public Map<String, Object> getRelatedKeywords(@RequestParam String keyword) {
		Map<String, Object> result = new HashMap<>();
		try {
			List<String> relatedKeywords = GoogleApiUtil.getRelatedKeywords(keyword);

			result.put("success", true);
			result.put("relatedKeywords", relatedKeywords); // JS가 기대하는 이름
		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("error", "연관 검색어 조회 중 서버 오류가 발생했습니다.");
		}
		return result;
	}

	// 관리자메뉴 회원상세 페이지 키워드 불러오기
	@GetMapping("/memberKeyword")
	@ResponseBody
	public Map<String, Object> memberKeyword(@RequestParam String memberId) {
		List<UserKeywordDTO> keywordList = userKeywordService.memberKeyword(memberId);
		Map<String, Object> result = new HashMap<>();
		result.put("keywordList", keywordList);
		return result;
	}
}