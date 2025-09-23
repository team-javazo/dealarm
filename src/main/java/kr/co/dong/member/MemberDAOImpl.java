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

	// 중복 체크 - 휴대폰 번호
    @Override
    public int phoneCheck(String phone) {
        return sqlSession.selectOne(namespace + ".phoneCheck", phone);
    }

    // 중복 체크 - 이메일
    @Override
    public int emailCheck(String email) {
        return sqlSession.selectOne(namespace + ".emailCheck", email);
    }
	// 중복 체크 - 아이디
    @Override
    public int idCheck(String id) {
    	return sqlSession.selectOne(namespace + ".idCheck", id);
    }
	
	@Override
	public void insertMember(MemberDTO member) {
		sqlSession.insert(namespace + ".insertMember", member);

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
	public List<MemberDTO> allList(Map<String,Object> params) {
		return sqlSession.selectList(namespace + ".allDTO", params);
	}

	@Override	// 페이징용 검색 카운트
	public int searchMembersCount(Map<String, Object> params) {
		return sqlSession.selectOne(namespace + ".searchMembersCount",params);
	}

	@Override	// 검색회원리스트
//	public List<MemberDTO> searchMembers(String searchType, String searchValue) {	//예전꺼
	public List<MemberDTO> searchMembers(Map<String, Object> params) {
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
	    System.out.println("비밀번호 넘어옴");
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

	@Override
	public int deleteadmin(String id) {
		// TODO Auto-generated method stub
		return sqlSession.update(namespace + ".deleteadmin", id);
	}

	@Override
	public int activeUser(String id) {
		// TODO Auto-generated method stub
	  return sqlSession.update(namespace + ".activeUser", id);
	}








}
