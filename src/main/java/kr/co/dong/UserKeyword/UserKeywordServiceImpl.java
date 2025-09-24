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
}
