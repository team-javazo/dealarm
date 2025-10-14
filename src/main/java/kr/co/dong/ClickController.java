package kr.co.dong;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.dong.click.ClickService;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;
import java.util.Map;

/**
 * 클릭 추적 및 리다이렉트 요청을 처리하는 컨트롤러 URL: /dong/track
 */
@Controller
@RequestMapping("/")
public class ClickController {

	// Service를 주입받아 사용 (이름: "trackService"로 지정했음)
	@Autowired
	private ClickService trackService;

	/**
	 * 클릭 추적 요청을 처리하고, 디코딩된 URL로 리다이렉트합니다.
	 * 
	 * @param encodedUrl Base64 인코딩된 원본 URL
	 * @param userId     사용자 ID
	 * @param dealId     딜 ID
	 * @param keyword    키워드
	 * @return 리다이렉트 경로
	 */
	@GetMapping("/track")
	public String trackClick(@RequestParam("url") String encodedUrl, @RequestParam("user_id") long userId,
			@RequestParam("deal_id") long dealId, @RequestParam("keyword") String keyword) {
		String decodedUrl = null;

		try {
			// 1. URL-Safe Base64 디코딩
			// Base64.getUrlDecoder().decode()에서 잘못된 Base64 문자열의 경우 IllegalArgumentException
			// 발생
			byte[] decodedBytes = Base64.getUrlDecoder().decode(encodedUrl);
			decodedUrl = new String(decodedBytes, StandardCharsets.UTF_8);

			// 2. 서비스 로직 호출 (클릭 이력 저장/업데이트)
			boolean success = trackService.click(userId, dealId, keyword);

			System.out.println("--- Controller Log ---");
			System.out.println("디코딩된 URL: " + decodedUrl);
			System.out.println("클릭 추적 처리 결과: " + (success ? "성공" : "실패"));

		} catch (IllegalArgumentException e) {
			// Base64 디코딩 오류 처리
			System.err.println("요청 매개변수 오류 발생 (Base64 디코딩 오류): " + e.getMessage());
			return "redirect:/error/invalidRequest";
		} catch (Exception e) {
			// Spring의 @RequestParam 바인딩 오류(NumberFormatException 등) 및 서비스 내부 오류 처리
			System.err.println("클릭 추적 처리 중 내부 오류 발생: " + e.getMessage());
			return "redirect:/error/internal";
		}

		// 3. 디코딩된 원본 URL로 리다이렉트
		if (decodedUrl == null || decodedUrl.isEmpty()) {
			System.err.println("디코딩된 URL이 비어 리다이렉트할 수 없습니다.");
			return "redirect:/error/missingUrl";
		}

		return "redirect:" + decodedUrl;
	}
	
	/**
     * ✅ 그래프 데이터 반환 (Ajax용)
     */
    @GetMapping("/mypage/click-stats")
    @ResponseBody
    public List<Map<String, Object>> getClickStats(@RequestParam("userId") String userId) {
        List<Map<String, Object>> result = trackService.getUserClick(userId);
        System.out.println("📊 [ClickStats] userId=" + userId + " 결과 행수: " + result.size());
        return result;
    }

}
