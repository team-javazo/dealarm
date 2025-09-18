package kr.co.dong.member;

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

	@Override
	public int userupdate(MemberDTO update) {
		// TODO Auto-generated method stub
		return sqlSession.update(namespace + ".userupdate", update);
	}

	@Override
	public int adminupdate(MemberDTO update) {
		// TODO Auto-generated method stub
		return sqlSession.update(namespace + ".adminupdate", update);
	}

}
