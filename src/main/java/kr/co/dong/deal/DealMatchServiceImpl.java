package kr.co.dong.deal;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DealMatchServiceImpl implements DealMatchService {
    @Autowired
    private DealMatchDAO dealMatchDAO;

	@Override
	public List<DealMatchDTO> dealMatch(String userId) {
		// TODO Auto-generated method stub
		return dealMatchDAO.dealMatch(userId);
	}

	@Override
	public void deleteMatch(int matchId, String userId) {
		// TODO Auto-generated method stub
		dealMatchDAO.deleteMatch(matchId, userId);
	}

	@Override
	public void deleteMultiMatch(List<Integer> matchIds, String userId) {
		// TODO Auto-generated method stub
		for(Integer matchID : matchIds) {
			dealMatchDAO.deleteMatch(matchID, userId);
		}
	}
	

}
