package kr.co.dong.inquiry;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CommentDAOImpl implements CommentDAO {

    @Autowired private SqlSessionTemplate sql;

    public List<CommentDTO> list(long inquiryId) {
        return sql.selectList("CommentMapper.list", inquiryId);
    }
    public void add(CommentDTO d) { sql.insert("CommentMapper.add", d); }
    public void deleteById(long id) { sql.delete("CommentMapper.deleteById", id); }
    public void deleteByOwner(long id, String writer) {
        CommentDTO d = new CommentDTO(); d.setId(id); d.setWriter(writer);
        sql.delete("CommentMapper.deleteByOwner", d);
    }
}
