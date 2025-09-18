package kr.co.dong.member;

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
		return null;
	}
}