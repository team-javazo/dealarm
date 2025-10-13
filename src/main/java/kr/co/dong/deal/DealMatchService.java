package kr.co.dong.deal;

import java.util.List;
import java.util.Map;

public interface DealMatchService {
	List<DealMatchDTO> dealMatch(String id, int offset, int limit);
	int deleteDeal(int matchId, String userId);
	List<DealMatchDTO> newDeal(Map<String, Object> params);
}