package kr.co.dong.member;

import java.util.List;
import java.util.Map;

public interface MemberService {
	void register(MemberDTO member);
	MemberDTO login(MemberDTO member);
	boolean isIdAvailable(String id);
	boolean isPhoneAvailable(String phone);
	boolean isEmailAvailable(String email);
	MemberDTO myDTO(String id);	//내정보
	MemberDTO myDTONaver(String phone);	//네이버를 위한 내정보
	
	int memberCount();			// 총 회원수
	List<MemberDTO> allList(Map<String,Object> params);	//모든회원

	int searchMembersCount(Map<String,Object> params);	//페이징용 검색 카운트
	List<MemberDTO> searchMembers(Map<String, Object> params);	// 검색회원
	
//	List<MemberDTO> searchMembers(String searchType, String searchValue);	// 예전 검색회원
	boolean checkPassword(String id, String password);
    int userupdate(MemberDTO update);
    int adminupdate(MemberDTO update);
	MemberDTO selectone(String id);
	int updatePassword(MemberDTO member);
	int deleteUser(String id);
    int deleteadmin(String id);
    int activeUser(String id);
}