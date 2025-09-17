package kr.co.dong.member;

import java.util.List;

public interface MemberDAO {
    void insertMember(MemberDTO member);
    int idCheck(String id);
    MemberDTO login(MemberDTO member); // 추가
	MemberDTO myDTO(String id); // 정보 불러오기
	List<MemberDTO> allList();	//모든회원


}
