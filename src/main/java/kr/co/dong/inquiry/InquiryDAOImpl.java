package kr.co.dong.inquiry;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class InquiryDAOImpl implements InquiryDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String namespace = "kr.co.dong.inquiry.InquiryDAO";

    @Override
    public void insert(InquiryDTO dto) {
        sqlSession.insert(namespace + ".insert", dto);
    }

    @Override
    public List<InquiryDTO> list() {
        return sqlSession.selectList(namespace + ".list");
    }

    @Override
    public InquiryDTO detail(int id) {
        return sqlSession.selectOne(namespace + ".detail", id);
    }

    @Override
    public void updateHit(int id) {
        sqlSession.update(namespace + ".updateHit", id);
    }

    @Override
    public void update(InquiryDTO dto) {
        sqlSession.update(namespace + ".update", dto);
    }

    @Override
    public void delete(int id) {
        sqlSession.delete(namespace + ".delete", id);
    }

    @Override
    public void updateStatus(int id, String status) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("status", status);
        sqlSession.update(namespace + ".updateStatus", map);
    }

    @Override
    public void insertAnswer(int id, String answer) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("answer", answer);
        sqlSession.update(namespace + ".insertAnswer", map);
    }

    @Override
    public List<InquiryDTO> search(String keyword) {
        return sqlSession.selectList(namespace + ".search", keyword);
    }

    @Override
    public List<InquiryDTO> listByCategory(String category) {
        return sqlSession.selectList(namespace + ".listByCategory", category);
    }

    // ✅ 페이징 + 검색
    @Override
    public List<InquiryDTO> listWithPaging(int offset, int pageSize, String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("pageSize", pageSize);
        params.put("keyword", keyword);
        return sqlSession.selectList(namespace + ".listWithPaging", params);
    }

    @Override
    public int count(String keyword) {
        return sqlSession.selectOne(namespace + ".count", keyword);
    }

    @Override
    public List<InquiryDTO> listByWriter(String writer) {
        return sqlSession.selectList(namespace + ".listByWriter", writer);
    }

    @Override
    public Map<String, Integer> getStats() {
        return sqlSession.selectOne(namespace + ".getStats");
    }
}
