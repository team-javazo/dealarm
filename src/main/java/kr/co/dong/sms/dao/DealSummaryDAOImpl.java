package kr.co.dong.sms.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.dong.sms.dto.DealSummaryDTO;

@Repository
public class DealSummaryDAOImpl implements DealSummaryDAO {

    private final SqlSessionTemplate sqlSession;

    @Autowired
    public DealSummaryDAOImpl(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public List<DealSummaryDTO> findUnnotifiedDeals() {
        return sqlSession.selectList(
            "kr.co.dong.sms.dao.DealSummaryDAO.findUnnotifiedDeals"
        );
    }

    @Override
    public void markAsNotified(String userId) {
        // 현재 구조에서는 Python에서 deal_match 테이블에 기록하므로 사실상 필요 없음
        // 만약 deal_summary 테이블의 상태를 갱신하려면 아래 쿼리가 XML 매퍼에 있어야 함
        sqlSession.update(
            "kr.co.dong.sms.dao.DealSummaryDAO.markAsNotified",
            userId
        );
    }
}
