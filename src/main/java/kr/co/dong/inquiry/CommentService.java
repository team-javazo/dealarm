package kr.co.dong.inquiry;

import java.util.List;

public interface CommentService {
    List<CommentDTO> list(int inquiryId);
    void add(CommentDTO dto);
    void deleteById(int id);
    void deleteByOwner(int id, String writer);
}
