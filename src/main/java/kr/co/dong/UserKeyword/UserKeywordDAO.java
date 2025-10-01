package kr.co.dong.UserKeyword;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.co.dong.sms.SmsDTO;

public interface UserKeywordDAO {
    void insert(UserKeywordDTO dto); // 키워드 등록	
    List<UserKeywordDTO> findByUserId(String userId); //특정 사용자의 키워드 조회
    void delete(String id);	// 키워드 삭제
    boolean isKeywordExist(UserKeywordDTO dto); // 중복 방지 체크
//    List<String> findAllUserIds(); // 전체 사용자 ID 조회
    
    
    /**
     * 상품명(title) → 사용자 매칭 DAO
	 * impl이 없는 이유는 MyBatis의 mapper가 실제 실행 부분을 대신하기 때문
	 * 
     * 특정 상품명(title)과 매칭되는 키워드를 등록한 사용자 ID 목록을 조회
     *
     * @param title  상품명 (예: "맥북", "아이폰")
     * @return       해당 키워드를 등록한 userId 리스트
     *
     * 설명:
     *  - 새로운 상품이 크롤링되어 들어왔을 때
     *  - 상품명(title)과 유저가 등록한 키워드를 비교하여
     *  - 알림을 받아야 할 대상 사용자(userId)들을 추출하는 용도로 사용
     */
    List<SmsDTO> findMatchingUsers(String title);
}