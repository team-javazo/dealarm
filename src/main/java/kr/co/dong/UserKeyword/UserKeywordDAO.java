package kr.co.dong.UserKeyword;

import java.util.List;

public interface UserKeywordDAO {
    void insert(UserKeywordDTO dto); // 키워드 등록	
    List<UserKeywordDTO> findByUserId(String userId); //특정 사용자의 키워드 조회
    void delete(String id);	// 키워드 삭제
    boolean isKeywordExist(UserKeywordDTO dto); // 중복 방지 체크
//    List<String> findAllUserIds(); // 전체 사용자 ID 조회
}