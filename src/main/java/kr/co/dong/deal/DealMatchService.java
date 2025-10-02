package kr.co.dong.deal;

import java.util.List;

public interface DealMatchService {
	List<DealMatchDTO> dealMatch(String id, int offset, int limit);
	void deleteMatch(int matchId, String userId);
	void deleteMultiMatch(List<Integer> matchIds, String userId);
	
	
	

}