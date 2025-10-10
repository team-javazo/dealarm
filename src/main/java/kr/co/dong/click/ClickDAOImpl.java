package kr.co.dong.click;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository // DAO 구현체에 @Repository 어노테이션을 붙입니다.
public class ClickDAOImpl implements ClickDAO { // 인터페이스를 implements 합니다.

    private final SqlSessionTemplate sqlSession;
    
    // XML Mapper의 네임스페이스를 상수로 정의
    private static final String NAMESPACE = "kr.co.dong.click.ClickDAO";

    @Autowired
    public ClickDAOImpl(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public ClickDTO findByDealIdAndUserId(int dealId, String userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("dealId", dealId);
        params.put("userId", userId);
        // 인터페이스의 메서드를 구현합니다.
        return sqlSession.selectOne(NAMESPACE + ".findByDealIdAndUserId", params);
    }

    @Override
    public ClickDTO findByUniqueId(String uniqueId) {
        // 인터페이스의 메서드를 구현합니다.
        return sqlSession.selectOne(NAMESPACE + ".findByUniqueId", uniqueId);
    }

    @Override
    public int insertLink(ClickDTO dto) {
        // 인터페이스의 메서드를 구현합니다.
        return sqlSession.insert(NAMESPACE + ".insertLink", dto);
    }

    @Override
    public int increaseClickCount(String uniqueId) {
        // 인터페이스의 메서드를 구현합니다.
        return sqlSession.update(NAMESPACE + ".increaseClickCount", uniqueId);
    }

    @Override
    public int insertClickHistory(ClickDTO dto) {
        // 인터페이스의 메서드를 구현합니다.
        return sqlSession.insert(NAMESPACE + ".insertClickHistory", dto);
    }
}