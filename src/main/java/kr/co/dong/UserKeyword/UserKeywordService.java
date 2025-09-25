package kr.co.dong.UserKeyword;

import java.util.List;

public interface UserKeywordService {
    void addKeyword(UserKeywordDTO dto);
    void removeKeyword(String id);
    List<UserKeywordDTO> getKeywords(String userId);
//    List<String> getAllUserIds();
}
