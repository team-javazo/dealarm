package kr.co.dong.inquiry;

import java.util.List;

public interface CommentDAO {
    List<CommentDTO> list(int inquiryId);
    void insert(CommentDTO dto);           // ✅ add → insert 변경
    void delete(int id);                   // ✅ deleteById → delete 변경
    void deleteByOwner(int id, String writer);
}
