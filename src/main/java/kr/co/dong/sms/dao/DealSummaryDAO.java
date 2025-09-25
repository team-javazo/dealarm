package kr.co.dong.sms.dao;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.dong.sms.dto.DealSummaryDTO;

@Mapper
@Repository
public interface DealSummaryDAO {
    List<DealSummaryDTO> findUnnotifiedDeals();
    void markAsNotified(@Param("userId") String userId);
}
