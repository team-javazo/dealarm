package kr.co.dong.UserKeyword;

import java.util.List;

import javax.inject.Inject;
import org.springframework.stereotype.Service;

@Service
public class UserKeywordServiceImpl implements UserKeywordService {

	@Inject
	private UserKeywordDAO userKeywordDAO;

	@Override
	public List<UserKeywordDTO> getKeywords(String userId) {
		return userKeywordDAO.findByUserId(userId);
	}

	@Override
	public List<UserKeywordDTO> getKeywordRankingByFilters(String gender, Integer startAge, Integer endAge, String userId) {
	    return userKeywordDAO.findKeywordRankingByGenderAndAge(gender, startAge, endAge, userId);
	}
//    @Override
//	public List<String> getAllUserIds() {
//		return userKeywordDAO.findAllUserIds();
//	}

	@Override
	public void removeKeyword(String id) {
		userKeywordDAO.delete(id);
	}

	@Override
	public void addKeyword(UserKeywordDTO dto) {
		if (userKeywordDAO.isKeywordExist(dto)) {
			throw new IllegalArgumentException("이미 등록된 키워드입니다.");
		}
		userKeywordDAO.insert(dto);
	}

	@Override
	public List<UserKeywordDTO> memberKeyword(String memberId) {
		// TODO Auto-generated method stub
		return userKeywordDAO.findByUserId(memberId);
	}
}
