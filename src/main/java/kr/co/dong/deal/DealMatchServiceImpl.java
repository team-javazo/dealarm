package kr.co.dong.deal;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DealMatchServiceImpl implements DealMatchService {
    @Autowired
    private DealMatchDAO dealMatchDAO;
    
    private static final String BASE_DIR;
    
    private static final String WEB_ACCESS_PATH = "/dealarm/images/";
    
    static {
    	BASE_DIR = System.getProperty("user.home") + 
    			File.separator + "dealarm-data" +
    			File.separator + "images";
    	File dir = new File(BASE_DIR);
    	if(!dir.exists()) {
    		dir.mkdirs();
    	}
    }

	@Override
	public List<DealMatchDTO> dealMatch(String id, int offset, int limit) {
		List<DealMatchDTO> dealList = dealMatchDAO.dealMatch(id, offset, limit);
		processImageUrls(dealList);
		return dealList;
	}


	@Override
	public int deleteDeal(int matchId, String userId) {
		// TODO Auto-generated method stub
		return dealMatchDAO.deleteDeal(matchId, userId);
	}
	
	@Override
	public List<DealMatchDTO> newDeal(Map<String, Object> params) {
		List<DealMatchDTO> dealList = dealMatchDAO.newDeal(params);
		return dealList;
	}

	private void processImageUrls(List<DealMatchDTO> dealList) {
		// TODO Auto-generated method stub
		
	}
	

}