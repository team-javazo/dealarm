package kr.co.dong.member;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl implements MemberService {

    @Inject
    private MemberDAO memberDAO;

    @Override
    public void register(MemberDTO member) {
        memberDAO.insertMember(member);
    }

    @Override
    public boolean isIdAvailable(String id) {
        return memberDAO.idCheck(id) == 0;
    }

	@Override
	public MemberDTO login(MemberDTO member) {
		// TODO Auto-generated method stub
		return memberDAO.login(member);
	}

	@Override
	public MemberDTO myDTO(String id) {
		return memberDAO.myDTO(id);
	}

	@Override
	public int memberCount() {
		return memberDAO.memberCount();
	}

	@Override
	public List<MemberDTO> allList() {
		return memberDAO.allList();
	}
	
//	@Override	// 예전 검색회원리스트
//	public List<MemberDTO> searchMembers(String searchType, String searchValue) {
//		return memberDAO.searchMembers(searchType, searchValue);
//	}
	
	@Override	// 신규 검색회원 리스트
	public List<MemberDTO> searchMembers(Map<String, String> params) {
		return memberDAO.searchMembers(params);
	}
	@Override
	public boolean checkPassword(String id, String password) {
		MemberDTO user = memberDAO.myDTO(id);
		if(user != null && password.equals(user.getPassword())) {
		    System.out.println("비밀번호 일치 DAO");
			return true;
		}
		return false;
	}
	public int userupdate(MemberDTO update) {
		// TODO Auto-generated method stub
		return memberDAO.userupdate(update);
	}

	@Override
	public int adminupdate(MemberDTO update) {
		// TODO Auto-generated method stub
		return memberDAO.adminupdate(update);
	}

	@Override
	public MemberDTO selectone(String id) {
		// TODO Auto-generated method stub
		return memberDAO.selectone(id);
	}

	@Override
	public int updatePassword(MemberDTO member) {
		// TODO Auto-generated method stub
		return memberDAO.updatePassword(member);
	}

	@Override
	public int deleteUser(String id) {
		// TODO Auto-generated method stub
		return memberDAO.deleteUser(id);
	}



}