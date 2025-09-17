package kr.co.dong.member;

import java.util.List;

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
		// TODO Auto-generated method stub
		return sqlSession.selectOne(namespace + ".idCheck", id);
	}

	@Override
	public MemberDTO login(MemberDTO member) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne(namespace + ".login", member);
	}

	@Override	// 내 정보 불러오기
	public MemberDTO myDTO(String id) {
		return sqlSession.selectOne(namespace + ".myDTO", id);
	}

	@Override	// 전체회원 리스트
	public List<MemberDTO> allList() {
		return sqlSession.selectList(namespace + ".allDTO");
	}

}
