package kr.co.dong.click;

import java.util.List; // ClickDTO 대신 List를 반환할 수도 있으므로 필요하면 추가
import java.util.Map;

// DAO 인터페이스에는 @Repository 어노테이션을 붙이지 않습니다.
public interface ClickDAO {

    /**
     * 특정 거래 ID와 사용자 ID로 클릭 정보를 조회합니다.
     * @param dealId 거래 ID
     * @param userId 사용자 ID
     * @return ClickDTO 객체 또는 null
     */
    ClickDTO findByDealIdAndUserId(int dealId, String userId);

    /**
     * 고유 ID(uniqueId)로 클릭 정보를 조회합니다.
     * @param uniqueId 고유 ID
     * @return ClickDTO 객체 또는 null
     */
    ClickDTO findByUniqueId(String uniqueId);

    /**
     * 새로운 링크 정보를 DB에 삽입합니다.
     * @param dto 삽입할 ClickDTO
     * @return 삽입된 레코드 수 (성공 시 1)
     */
    int insertLink(ClickDTO dto);

    /**
     * 특정 고유 ID의 클릭 횟수를 1 증가시킵니다.
     * @param uniqueId 클릭 횟수를 증가시킬 고유 ID
     * @return 업데이트된 레코드 수 (성공 시 1)
     */
    int increaseClickCount(String uniqueId);

    /**
     * 클릭 이력을 DB에 삽입합니다.
     * @param dto 클릭 이력 정보가 담긴 ClickDTO
     * @return 삽입된 레코드 수 (성공 시 1)
     */
    int insertClickHistory(ClickDTO dto);
}