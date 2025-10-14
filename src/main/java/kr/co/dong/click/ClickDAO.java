package kr.co.dong.click;

import java.util.List;
import java.util.Map;

/**
 * 클릭 이력 데이터 접근 객체 인터페이스 (DAO)
 */
public interface ClickDAO {

	/**
	 * user_id와 deal_id를 기준으로 클릭 횟수를 업데이트하거나 새로운 레코드를 삽입합니다 (UPSERT).
	 * 
	 * @param dto user_id, deal_id, keyword를 포함하는 DTO
	 * @return DB에 영향을 준 행의 수
	 */
	int upsertClickHistory(ClickDTO dto);
	
	// 키워드 별 클릭 통계 조회
	List<Map<String, Object>> getUserClick(String userId);
}
