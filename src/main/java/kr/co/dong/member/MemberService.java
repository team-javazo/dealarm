package kr.co.dong.member;

public interface MemberService {
	void register(MemberDTO member);
	 MemberDTO login(MemberDTO member);
	boolean isIdAvailable(String id);
    int userupdate(MemberDTO update);
    int adminupdate(MemberDTO update);
	MemberDTO selectone(String id);
}