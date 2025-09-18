package kr.co.dong.member;

import java.util.List;

public interface MemberService {
	void register(MemberDTO member);
	 MemberDTO login(MemberDTO member);
	boolean isIdAvailable(String id);
	
	MemberDTO myDTO(String id);	//내정보
	List<MemberDTO> allList();	//모든회원
	boolean checkPassword(String id, String password);
	
}