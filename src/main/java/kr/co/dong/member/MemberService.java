package kr.co.dong.member;

import java.util.List;

public interface MemberService {
	void register(MemberDTO member);
	MemberDTO login(MemberDTO member);
	boolean isIdAvailable(String id);
	MemberDTO myDTO(String id);	//내정보
	int memberCount();			//회원수
	List<MemberDTO> allList();	//모든회원
	List<MemberDTO> searchMembers(String searchType, String searchValue);	// 검색회원
	boolean checkPassword(String id, String password);
    int userupdate(MemberDTO update);
    int adminupdate(MemberDTO update);
	MemberDTO selectone(String id);
	int updatePassword(MemberDTO member);
	int deleteUser(String id);

}