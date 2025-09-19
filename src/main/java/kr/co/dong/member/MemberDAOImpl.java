package kr.co.dong.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAOImpl implements MemberDAO {

	@Inject
	private SqlSession sqlSession;

	private static final String namespace = "kr.co.dong.member.MemberDAO";

	@Override
	public void insertMember(MemberDTO member) {
		sqlSession.insert(namespace + ".insertMember", member);

	}

	@Override
	public int idCheck(String id) {
		return sqlSession.selectOne(namespace + ".idCheck", id);
	}

	@Override
	public MemberDTO login(MemberDTO member) {
		return sqlSession.selectOne(namespace + ".login", member);
	}

	@Override	// 내 정보 불러오기
	public MemberDTO myDTO(String id) {
		return sqlSession.selectOne(namespace + ".myDTO", id);
	}

	@Override	// 총 회원수 
	public int memberCount() {
		return sqlSession.selectOne(namespace + ".memberCount");
	}

	@Override	// 전체회원 리스트
	public List<MemberDTO> allList() {
		return sqlSession.selectList(namespace + ".allDTO");
	}
	@Override	// 검색회원리스트
	public List<MemberDTO> searchMembers(String searchType, String searchValue) {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchValue", searchValue);
		return sqlSession.selectList(namespace + ".searchMembers", params);
	}
	@Override
	public int userupdate(MemberDTO update) {
		return sqlSession.update(namespace + ".userupdate", update);
	}

	@Override
	public int adminupdate(MemberDTO update) {
		return sqlSession.update(namespace + ".adminupdate", update);
	}

	@Override
	public int updatePassword(MemberDTO member) {
		return sqlSession.update(namespace + ".updatePassword", member);
	}

	@Override
	public MemberDTO selectone(String id) {
		return sqlSession.selectOne(namespace + ".selectone", id);
	}

	@Override
	public int deleteUser(String id) {
		  return sqlSession.update(namespace + ".deleteUser", id);
	}



}
