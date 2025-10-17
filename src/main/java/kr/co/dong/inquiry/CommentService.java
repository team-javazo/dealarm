package kr.co.dong.inquiry;
import java.util.List;

public interface CommentService {
    List<CommentDTO> list(long inquiryId);
    void addAdminComment(long inquiryId, String writer, String content);
    void addUserComment(long inquiryId, String writer, String content);
    void deleteById(long id);
    void deleteByOwner(long id, String writer);
}
