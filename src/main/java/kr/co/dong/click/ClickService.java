package kr.co.dong.click;

import kr.co.dong.sms.SmsDTO;
import org.springframework.transaction.annotation.Transactional;

/**
 * 클릭 추적 관련 서비스 인터페이스
 */
public interface ClickService {
	/**
	 * 클릭 이력을 추적하고 DB에 저장/업데이트합니다.
	 * 
	 * @param userId  사용자 ID
	 * @param dealId  딜 ID
	 * @param keyword 키워드
	 * @return 처리 성공 여부
	 */
	boolean click(long userId, long dealId, String keyword);
}