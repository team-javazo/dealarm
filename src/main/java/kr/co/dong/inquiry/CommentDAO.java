package kr.co.dong.inquiry;
import java.util.List;

public interface CommentDAO {
    List<CommentDTO> list(long inquiryId);
    void add(CommentDTO dto);
    void deleteById(long id);
    void deleteByOwner(long id, String writer);
}
