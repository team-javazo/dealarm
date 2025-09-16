package kr.co.dong.member;

public interface MemberService {
	void register(MemberDTO member);
	 MemberDTO login(MemberDTO member);
	boolean isIdAvailable(String id);
}