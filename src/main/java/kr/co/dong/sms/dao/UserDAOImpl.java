package kr.co.dong.sms.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.dong.sms.dto.UserDTO;

@Repository
public class UserDAOImpl implements UserDAO {

    private final SqlSessionTemplate sqlSession;

    @Autowired
    public UserDAOImpl(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public UserDTO findUserById(String userId) {
        return sqlSession.selectOne(
            "kr.co.dong.sms.dao.UserDAO.findUserById",
            userId
        );
    }
}
