package kr.co.dong.sms.dao;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.dong.sms.dto.DealSummaryDTO;

@Mapper
@Repository
public interface DealSummaryDAO {
	// 알림이 아직 발송되지 않은 Deal 목록 조회
    List<DealSummaryDTO> findUnnotifiedDeals();
    // 특정 사용자의 Deal 알림 상태를 "발송 완료"로 표시
    // 현재 구조에서 Python이 deal_match 테이블에 insert 하므로 불필요하므로 주석처리
    void markAsNotified(@Param("userId") String userId);
}
