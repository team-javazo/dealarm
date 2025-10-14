package kr.co.dong.click;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 클릭 추적 서비스 구현체
 */
@Service("trackService") // Controller에서 사용할 이름 지정
public class ClickServiceImpl implements ClickService {

	// DAO를 주입받아 사용
	@Autowired
	private ClickDAO clickDAO;

	/**
	 * user_id와 deal_id를 기준으로 count를 증가시키거나 새로 삽입하는 UPSERT 로직을 수행합니다.
	 */
	@Override
	public boolean click(String userId, long dealId, String keyword) {
		// DTO 객체 생성
		ClickDTO dto = new ClickDTO(userId, dealId, keyword);

		// DAO를 통해 UPSERT 실행
		try {
			int result = clickDAO.upsertClickHistory(dto);
			System.out.println("[Click Service] UPSERT 결과: " + (result > 0 ? "성공" : "실패"));
			return result > 0;
		} catch (Exception e) {
			System.err.println("[Click Service] 클릭 이력 처리 중 오류 발생: " + e.getMessage());
			// 실제 환경에서는 로그 기록 및 예외 처리 필요
			return false;
		}
	}
}
