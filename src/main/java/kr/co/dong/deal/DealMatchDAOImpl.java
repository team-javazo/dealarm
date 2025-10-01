package kr.co.dong.deal;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DealMatchDAOImpl implements DealMatchDAO {
	
	private static final String namespace = "kr.co.dong.deal.DealMatchDAO.";
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<DealMatchDTO> dealMatch(String userId) {
		return sqlSession.selectList(namespace + "dealMatch", userId);
	}

	@Override
	public int deleteMatch(int matchId, String userId) {
		return sqlSession.delete(namespace + "deleteMatch", new java.util.HashMap<String, Object>(){{
		put("matchId", matchId);
		put("userId", userId);
		}});
	}

	

}
