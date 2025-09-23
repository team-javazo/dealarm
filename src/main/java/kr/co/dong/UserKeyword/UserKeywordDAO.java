package kr.co.dong.UserKeyword;

import java.util.List;

public interface UserKeywordDAO {
	void insert(UserKeywordDTO dto);

	List<UserKeywordDTO> findByUserId(String userId);

	void delete(String id);
}
