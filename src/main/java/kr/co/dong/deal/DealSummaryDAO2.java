package kr.co.dong.deal;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface DealSummaryDAO2 {
    void insertDeal(DealSummaryDTO2 dto);

    boolean existsByUrl(String url); // 중복 방지
    
    List<DealSummaryDTO2> findDealsByKeyword(@Param("keyword") String keyword);
}
