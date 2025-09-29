package kr.co.dong.member;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.co.dong.sms.SmsDTO;

public interface MemberDAO {
    void insertMember(MemberDTO member);
    int idCheck(String id);
    int phoneCheck(String phone);
    int emailCheck(String email);
    MemberDTO login(MemberDTO member); // 추가
	MemberDTO myDTO(String id); // 정보 불러오기
	int memberCount();			// 회원수
	int searchMembersCount(Map<String,Object> params);	//페이징용 검색 카운트
	List<MemberDTO> allList(Map<String,Object> params);	//모든회원
//	List<MemberDTO> searchMembers(String searchType, String searchValue);	//예전 검색회원
	List<MemberDTO> searchMembers(Map<String, Object> params);	// 검색회원

    int userupdate(MemberDTO update);
    int adminupdate(MemberDTO update);
    int updatePassword(MemberDTO member);
    MemberDTO selectone(String id);
    int deleteUser(String id);
    int deleteadmin(String id);
    int activeUser(String id);
    
 // userId 기준으로 사용자 정보를 조회
    // (전화번호, 알림 설정 상태 등 가져오기 위해 사용)
    SmsDTO findUserById(@Param("id") String userId);
}
