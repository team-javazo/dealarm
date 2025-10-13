package kr.co.dong.deal;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DealMatchDAOImpl implements DealMatchDAO {
	
	private static final String namespace = "kr.co.dong.deal.DealMatchDAO";
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<DealMatchDTO> dealMatch(String uid, int offset, int limit) {
		Map<String, Object> params = new HashMap<>();
		params.put("uid", uid);
		params.put("offset",  offset);
		params.put("limit", limit);			
		return sqlSession.selectList(namespace +  ".dealMatch", params);
	}


	@Override
	public int deleteDeal(Integer matchId, String userId) {
		Map<String, Object> params = new HashMap<>();
		params.put("matchId", matchId);
		params.put("userId", userId);
		return sqlSession.update(namespace + ".deleteDeal", params);

	}


	@Override
	public List<DealMatchDAO> newDeal(Map<String, Object> params) {
		return sqlSession.selectList(namespace + ".newDeal");
	}


	

}