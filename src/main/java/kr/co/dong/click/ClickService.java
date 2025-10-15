package kr.co.dong.click;


import java.util.List;
import java.util.Map;

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
	boolean click(String userId, long dealId, String keyword);
	
	// 개인 통계 조회
	List<Map<String, Object>> getUserClick(String UserId);
	
	// 통합 통계 조회
	List<ClickDTO> keywordStats(Map<String, Object>params); 
}