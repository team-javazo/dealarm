package kr.co.dong.sms.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MatchingUserKeywordDAOImpl implements MatchingUserKeywordDAO {

    private final SqlSessionTemplate sqlSession;

    @Autowired
    public MatchingUserKeywordDAOImpl(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public List<String> findMatchingUsers(String title) {
        return sqlSession.selectList(
            "kr.co.dong.sms.dao.MatchingUserKeywordDAO.findMatchingUsers",
            title
        );
    }
}
