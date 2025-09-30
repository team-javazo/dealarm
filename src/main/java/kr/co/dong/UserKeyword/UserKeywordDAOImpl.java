package kr.co.dong.UserKeyword;

import java.util.List;

import javax.inject.Inject;
import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.dong.sms.SmsDTO;

@Repository
public class UserKeywordDAOImpl implements UserKeywordDAO {

    @Inject
    private SqlSession sqlSession;

    private static final String namespace = "kr.co.dong.mappers.UserKeywordMapper";

    @Override
    public void insert(UserKeywordDTO dto) {
        sqlSession.insert(namespace + ".insert", dto);
    }

//    @Override
//	public List<String> findAllUserIds() {
//		return sqlSession.selectList(namespace + ".findAllUserIds");
//	}
    
    @Override
    public List<UserKeywordDTO> findByUserId(String userId) {
        return sqlSession.selectList(namespace + ".findByUserId", userId);
    }

    @Override
    public void delete(String id) {
        sqlSession.delete(namespace + ".delete", id);
    }

    @Override
    public boolean isKeywordExist(UserKeywordDTO dto) {
        Integer count = sqlSession.selectOne(namespace + ".countKeyword", dto);
        return count != null && count > 0;
    }

    @Autowired
    public UserKeywordDAOImpl(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public List<SmsDTO> findMatchingUsers(String title) {
        return sqlSession.selectList(namespace + ".findMatchingUsers", title);
    }
}