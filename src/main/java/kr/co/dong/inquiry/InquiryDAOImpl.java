package kr.co.dong.inquiry;

import java.util.List;
import javax.inject.Inject;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class InquiryDAOImpl implements InquiryDAO {

    @Inject
    private SqlSession sqlSession;

    private static final String namespace = "kr.co.dong.inquiry.InquiryDAO";

    @Override
    public List<InquiryDTO> list() {
        return sqlSession.selectList(namespace + ".list");
    }

    @Override
    public InquiryDTO detail(int id) {
        return sqlSession.selectOne(namespace + ".detail", id);
    }

    @Override
    public void insert(InquiryDTO dto) {
        sqlSession.insert(namespace + ".insert", dto);
    }

    @Override
    public void update(InquiryDTO dto) {
        sqlSession.update(namespace + ".update", dto);
    }

    @Override
    public void updateHit(int id) {
        sqlSession.update(namespace + ".updateHit", id);
    }

    @Override
    public void insertAnswer(InquiryDTO dto) {
        sqlSession.update(namespace + ".insertAnswer", dto);
    }

    @Override
    public void updateStatus(InquiryDTO dto) {
        sqlSession.update(namespace + ".updateStatus", dto);
    }

    @Override
    public void delete(int id) {
        sqlSession.delete(namespace + ".delete", id);
    }
}
