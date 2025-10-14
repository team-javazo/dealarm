package kr.co.dong.member;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl implements MemberService {
	
	// 비밀번호 암호화 객체
    BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

	@Inject
	private MemberDAO memberDAO;

	// 중복 체크 - 아이디
	@Override
	public boolean isIdAvailable(String id) {
		return memberDAO.idCheck(id) == 0;
	}

	// 중복 체크 - 휴대폰 번호
	@Override
	public boolean isPhoneAvailable(String phone) {
		return memberDAO.phoneCheck(phone) == 0;
	}

	// 중복 체크 - 이메일
	@Override
	public boolean isEmailAvailable(String email) {
		return memberDAO.emailCheck(email) == 0;
	}

	@Override
	public void register(MemberDTO member) {
		memberDAO.insertMember(member);
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
	public MemberDTO myDTONaver(String phone) {
		// TODO Auto-generated method stub
		return memberDAO.myDTONaver(phone);
	}

	@Override
	public int memberCount() {
		return memberDAO.memberCount();
	}
	
	@Override
	public List<MemberDTO> allList(Map<String,Object> params) {
		return memberDAO.allList(params);
	}

//	@Override	// 예전 검색회원리스트
//	public List<MemberDTO> searchMembers(String searchType, String searchValue) {
//		return memberDAO.searchMembers(searchType, searchValue);
//	}

	@Override	// 페이징용 검색 카운트
	public int searchMembersCount(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberDAO.searchMembersCount(params);
	}
	
	@Override	// 신규 검색회원 리스트
	public List<MemberDTO> searchMembers(Map<String, Object> params) {
		return memberDAO.searchMembers(params);
	}

	@Override
	public boolean checkPassword(String id, String password) {
		String userPassword = password; //user가 입력한 비밀번호
		
		MemberDTO user = memberDAO.myDTO(id);
		if (user != null && encoder.matches(userPassword, user.getPassword())) {
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
		System.out.println("비밀번호 넘어옴");
		return memberDAO.updatePassword(member);
	}

	@Override
	public int deleteUser(String id) {
		// TODO Auto-generated method stub
		return memberDAO.deleteUser(id);
	}

	@Override
	public int deleteadmin(String id) {
		// TODO Auto-generated method stub
		return memberDAO.deleteadmin(id);
	}

	@Override
	public int activeUser(String id) {
		// TODO Auto-generated method stub
		return memberDAO.activeUser(id);
	}




}