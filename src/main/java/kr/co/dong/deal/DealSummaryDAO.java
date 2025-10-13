package kr.co.dong.deal;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.dong.sms.SmsDTO;
@Mapper
public interface DealSummaryDAO {
	void insertDeal(DealSummaryDTO dto);
    boolean existsByUrl(String url);
    List<DealSummaryDTO> findDealsByTokens(Map<String, Object> params);
    List<DealSummaryDTO> findDealsByKeyword(String keyword);
    List<SmsDTO> findAllDeals();
    int deleteOlderThan7Days();
}
