package kr.co.dong.deal;

import java.util.List;

public interface DealMatchDAO {
	List<DealMatchDTO> dealMatch(String userId);
	int deleteMatch(int matchId, String userId);

	
	
}
