package kr.co.dong.inquiry;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

/**
 * CommentServiceImpl
 * - CommentService 구현체
 * - CommentDAO를 통해 DB와 연동
 * - Controller와 Mapper 중간 계층 역할
 */
@Service
public class CommentServiceImpl implements CommentService {

    @Inject
    private CommentDAO dao;

    /** 특정 문의글의 댓글 목록 */
    @Override
    public List<CommentDTO> list(int inquiryId) {
        return dao.list(inquiryId);
    }

    /** 댓글 추가 */
    @Override
    public void add(CommentDTO dto) {
        dao.insert(dto);
    }

    /** 댓글 삭제 (관리자 전용) */
    @Override
    public void deleteById(int id) {
        dao.delete(id);
    }

    /** 댓글 삭제 (작성자 본인만 가능) */
    @Override
    public void deleteByOwner(int id, String writer) {
        dao.deleteByOwner(id, writer);
    }
}
