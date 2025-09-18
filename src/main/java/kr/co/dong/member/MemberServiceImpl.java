package kr.co.dong.member;

import java.util.List;

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
	public List<MemberDTO> allList() {
		return memberDAO.allList();
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
}