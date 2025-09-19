package kr.co.dong.member;

import java.util.List;
import java.util.Map;

public interface MemberDAO {
    void insertMember(MemberDTO member);
    int idCheck(String id);
    MemberDTO login(MemberDTO member); // 추가
	MemberDTO myDTO(String id); // 정보 불러오기
	int memberCount();			// 회원수
	List<MemberDTO> allList();	//모든회원
//	List<MemberDTO> searchMembers(String searchType, String searchValue);	//예전 검색회원
	List<MemberDTO> searchMembers(Map<String, String> params);	// 검색회원

    int userupdate(MemberDTO update);
    int adminupdate(MemberDTO update);
    int updatePassword(MemberDTO member);
    MemberDTO selectone(String id);
    int deleteUser(String id);
}
