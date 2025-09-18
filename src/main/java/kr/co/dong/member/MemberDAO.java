package kr.co.dong.member;

public interface MemberDAO {
    void insertMember(MemberDTO member);
    int idCheck(String id);
    MemberDTO login(MemberDTO member); // 추가
    int userupdate(MemberDTO update);
    int adminupdate(MemberDTO update);
    int updatePassword(MemberDTO member);
    MemberDTO selectone(String id);
    int deleteUser(String id);
}
