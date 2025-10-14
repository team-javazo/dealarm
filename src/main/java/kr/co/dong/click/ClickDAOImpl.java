package kr.co.dong.click;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * 클릭 이력 DAO 구현체 SqlSessionTemplate을 사용하여 MyBatis SQL을 실행합니다.
 */
@Repository("clickDAO")
public class ClickDAOImpl implements ClickDAO {

	// SqlSessionTemplate 주입
	// MyBatis 설정이 완료되어 있어야 사용 가능합니다.
	@Autowired
	private SqlSession sqlSession;

	// 매퍼 XML의 namespace를 정의합니다.
	private static final String NAMESPACE = "kr.co.dong.click.ClickMapper";

	/**
	 * user_id와 deal_id를 기준으로 클릭 횟수를 업데이트하거나 새로운 레코드를 삽입합니다 (UPSERT).
	 */
	@Override
	public int upsertClickHistory(ClickDTO dto) {
		// 매퍼 XML의 NAMESPACE와 SQL ID를 조합하여 호출
		return sqlSession.insert(NAMESPACE + ".upsertClickHistory", dto);
	}

	@Override
	public List<Map<String, Object>> getUserClick(String userId) {
		// TODO Auto-generated method stub
		return sqlSession.selectList(NAMESPACE + ".getUserClick", userId);
	}
}
