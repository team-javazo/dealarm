package kr.co.dong;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import kr.co.dong.click.ClickService;

@Controller
public class ClickController {
	@Autowired
	private ClickService clickService; // ⚠️ ClickService 주입

	/**
	 * 추적 URL 엔드포인트: 클릭 기록 후 실제 URL로 리다이렉트
	 */
	@GetMapping("/track/{uniqueId}")
	public String trackAndRedirect(@PathVariable String uniqueId) {
		try {
			// 1. 클릭 수 기록 및 실제 URL 조회
			String actualUrl = clickService.increaseClickCountAndGetUrl(uniqueId);

			// 2. 실제 상품 페이지로 리다이렉트 (HTTP 302 응답)
			return "redirect:" + actualUrl;

		} catch (Exception e) {
			System.err.println("❌ 추적 링크 처리 중 오류: ID=" + uniqueId + ", Message=" + e.getMessage());
			// 오류 발생 시, 미리 정의된 오류 페이지로 이동
			return "redirect:/error/invalid-link";
		}
	}
}
