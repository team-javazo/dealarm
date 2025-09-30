package kr.co.dong.deal;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.dong.sms.SmsDTO;

import javax.inject.Inject;

@Repository
public class DealSummaryDAOImpl implements DealSummaryDAO {
    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "kr.co.dong.deal.DealSummaryDAO";

    @Override
    public void insertDeal(DealSummaryDTO dto) {
        sqlSession.insert(NAMESPACE + ".insertDeal", dto);
    }

    @Override
    public boolean existsByUrl(String url) {
        return sqlSession.selectOne(NAMESPACE + ".existsByUrl", url);
    }

    @Override
    public List<DealSummaryDTO> findDealsByKeyword(String keyword) {
        return sqlSession.selectList(NAMESPACE + ".findDealsByKeyword", keyword);
    }

    @Override
    public List<SmsDTO> findAllDeals() {
        return sqlSession.selectList(NAMESPACE + ".findAllDeals");
    }
}
