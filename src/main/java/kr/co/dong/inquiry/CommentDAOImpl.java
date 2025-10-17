package kr.co.dong.inquiry;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

/**
 * CommentDAOImpl
 * - CommentDAO 구현체 (MyBatis SqlSession 직접 사용)
 * - CommentMapper.xml 과 연결
 */
@Repository
public class CommentDAOImpl implements CommentDAO {

    private static final String NAMESPACE = "kr.co.dong.inquiry.CommentDAO";

    @Inject
    private SqlSession sqlSession;

    /** 🔹 특정 문의글의 댓글 목록 불러오기 */
    @Override
    public List<CommentDTO> list(int inquiryId) {
        return sqlSession.selectList(NAMESPACE + ".list", inquiryId);
    }

    /** 🔹 댓글 추가 */
    @Override
    public void insert(CommentDTO dto) {
        sqlSession.insert(NAMESPACE + ".insert", dto);
    }

    /** 🔹 댓글 삭제 (관리자 전용) */
    @Override
    public void delete(int id) {
        sqlSession.delete(NAMESPACE + ".delete", id);
    }

    /** 🔹 댓글 삭제 (작성자 본인만) */
    @Override
    public void deleteByOwner(int id, String writer) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("writer", writer);
        sqlSession.delete(NAMESPACE + ".deleteByOwner", map);
    }
}
