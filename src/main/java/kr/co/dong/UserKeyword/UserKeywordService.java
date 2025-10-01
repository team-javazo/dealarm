package kr.co.dong.UserKeyword;

import java.util.List;

public interface UserKeywordService {
    void addKeyword(UserKeywordDTO dto);
    void removeKeyword(String id);
    List<UserKeywordDTO> getKeywords(String userId);
    List<UserKeywordDTO> memberKeyword(String memberId);
//    List<String> getAllUserIds();
    public List<UserKeywordDTO> getKeywordRankingByFilters(String gender, Integer startAge, Integer endAge, String userId);
}
	
