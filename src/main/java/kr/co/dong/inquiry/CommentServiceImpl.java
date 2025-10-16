package kr.co.dong.inquiry;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommentServiceImpl implements CommentService {

    @Autowired private CommentDAO dao;

    public List<CommentDTO> list(long inquiryId) { return dao.list(inquiryId); }

    public void addAdminComment(long inquiryId, String writer, String content) {
        CommentDTO d = new CommentDTO();
        d.setInquiryId(inquiryId); d.setWriter(writer); d.setContent(content); d.setRole("ADMIN");
        dao.add(d);
    }

    public void addUserComment(long inquiryId, String writer, String content) {
        CommentDTO d = new CommentDTO();
        d.setInquiryId(inquiryId); d.setWriter(writer); d.setContent(content); d.setRole("USER");
        dao.add(d);
    }

    public void deleteById(long id) { dao.deleteById(id); }
    public void deleteByOwner(long id, String writer) { dao.deleteByOwner(id, writer); }
}
