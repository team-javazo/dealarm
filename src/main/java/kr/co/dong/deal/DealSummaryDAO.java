package kr.co.dong.deal;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.dong.sms.SmsDTO;

public interface DealSummaryDAO {
    void insertDeal(DealSummaryDTO dto);

    boolean existsByUrl(String url); // 중복 방지
    
    List<DealSummaryDTO> findDealsByKeyword(@Param("keyword") String keyword);
    
    List<SmsDTO> findAllDeals();
}
