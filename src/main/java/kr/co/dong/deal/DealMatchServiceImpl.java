package kr.co.dong.deal;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DealMatchServiceImpl implements DealMatchService {
    @Autowired
    private DealMatchDAO dealMatchDAO;

	@Override
	public List<DealMatchDTO> dealMatch(String id, int offset, int limit) {
		return dealMatchDAO.dealMatch(id, offset, limit);
	}

	@Override
	public void deleteMatch(int matchId, String userId) {
		dealMatchDAO.deleteMatch(matchId, userId);
	}

	@Override
	public void deleteMultiMatch(List<Integer> matchIds, String userId) {
		for(Integer matchID : matchIds) {
			dealMatchDAO.deleteMatch(matchID, userId);
		}
	}
	

}