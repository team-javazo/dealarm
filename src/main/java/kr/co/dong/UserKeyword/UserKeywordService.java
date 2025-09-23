package kr.co.dong.UserKeyword;

import java.util.List;

public interface UserKeywordService {
    void addKeyword(UserKeywordDTO dto);
    List<UserKeywordDTO> getKeywords(String userId);
    void removeKeyword(String id);
}
