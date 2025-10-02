package kr.co.dong.board;

import java.util.List;
import java.util.Map;

public interface BoardService {
    // 📌 게시글 목록 (페이징)
    List<BoardDTO> listAll(Map<String, Object> params);

    // 📌 게시글 등록
    int insert(BoardDTO dto);

    // 📌 게시글 상세보기
    BoardDTO detail(int id);

    // 📌 게시글 수정
    int update(BoardDTO dto);

    // 📌 게시글 삭제
    int delete(int id);

    // 📌 조회수 증가
    void increaseHit(int id);

    // 📌 전체 게시글 수
    int countAll();

    // 📌 검색 (제목/작성자/내용)
    List<BoardDTO> search(Map<String, Object> params);

    // 📌 검색 결과 수
    int countSearch(String keyword);
}
