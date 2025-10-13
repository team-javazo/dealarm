package kr.co.dong.deal;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	public int deleteDeal(int matchId, String userId) {
		// TODO Auto-generated method stub
		return dealMatchDAO.deleteDeal(matchId, userId);
	}
	
	@Override
	public List<DealMatchDTO> newDeal(Map<String, Object> params) {
		return dealMatchDAO.newDeal(params);
	}





	

}