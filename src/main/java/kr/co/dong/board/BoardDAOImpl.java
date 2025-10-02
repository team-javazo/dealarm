package kr.co.dong.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDAOImpl implements BoardDAO {

    private final DataSource dataSource;

    @Autowired
    public BoardDAOImpl(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    // 📌 게시글 목록 (페이징)
    @Override
    public List<BoardDTO> listAll(Map<String, Object> params) {
        List<BoardDTO> list = new ArrayList<>();
        final String sql =
            "SELECT id, title, writer, content, regdate, hit, notice " +
            "FROM board ORDER BY id DESC LIMIT ?, ?";

        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, (int) params.get("start"));
            pstmt.setInt(2, (int) params.get("size"));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    BoardDTO dto = new BoardDTO();
                    dto.setId(rs.getInt("id"));
                    dto.setTitle(rs.getString("title"));
                    dto.setWriter(rs.getString("writer"));
                    dto.setContent(rs.getString("content"));
                    dto.setRegdate(rs.getTimestamp("regdate"));
                    dto.setHit(rs.getInt("hit"));
                    dto.setNotice(rs.getInt("notice") == 1);
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 📌 전체 게시글 수
    @Override
    public int countAll() {
        int count = 0;
        final String sql = "SELECT COUNT(*) FROM board";
        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
        ) {
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // 📌 게시글 등록
    @Override
    public int insert(BoardDTO dto) {
        int result = 0;
        final String sql =
            "INSERT INTO board (title, writer, content, regdate, hit, notice) " +
            "VALUES (?, ?, ?, NOW(), 0, ?)";

        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getWriter());
            pstmt.setString(3, dto.getContent());
            pstmt.setInt(4, dto.isNotice() ? 1 : 0);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // 📌 상세보기
    @Override
    public BoardDTO detail(int id) {
        BoardDTO dto = null;
        final String sql =
            "SELECT id, title, writer, content, regdate, hit, notice " +
            "FROM board WHERE id = ?";

        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new BoardDTO();
                    dto.setId(rs.getInt("id"));
                    dto.setTitle(rs.getString("title"));
                    dto.setWriter(rs.getString("writer"));
                    dto.setContent(rs.getString("content"));
                    dto.setRegdate(rs.getTimestamp("regdate"));
                    dto.setHit(rs.getInt("hit"));
                    dto.setNotice(rs.getInt("notice") == 1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }

    // 📌 수정
    @Override
    public int update(BoardDTO dto) {
        int result = 0;
        final String sql =
            "UPDATE board SET title = ?, content = ?, notice = ? WHERE id = ?";

        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setInt(3, dto.isNotice() ? 1 : 0);
            pstmt.setInt(4, dto.getId());
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // 📌 삭제
    @Override
    public int delete(int id) {
        int result = 0;
        final String sql = "DELETE FROM board WHERE id = ?";

        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, id);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // 📌 조회수 증가
    @Override
    public void increaseHit(int id) {
        final String sql = "UPDATE board SET hit = hit + 1 WHERE id = ?";
        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 📌 검색 (제목+작성자+내용)
    @Override
    public List<BoardDTO> search(Map<String, Object> params) {
        List<BoardDTO> list = new ArrayList<>();
        final String sql =
            "SELECT id, title, writer, content, regdate, hit, notice " +
            "FROM board " +
            "WHERE title LIKE ? OR writer LIKE ? OR content LIKE ? " +
            "ORDER BY id DESC LIMIT ?, ?";

        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            String keyword = "%" + params.get("keyword") + "%";
            pstmt.setString(1, keyword);
            pstmt.setString(2, keyword);
            pstmt.setString(3, keyword);
            pstmt.setInt(4, (int) params.get("start"));
            pstmt.setInt(5, (int) params.get("size"));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    BoardDTO dto = new BoardDTO();
                    dto.setId(rs.getInt("id"));
                    dto.setTitle(rs.getString("title"));
                    dto.setWriter(rs.getString("writer"));
                    dto.setContent(rs.getString("content"));
                    dto.setRegdate(rs.getTimestamp("regdate"));
                    dto.setHit(rs.getInt("hit"));
                    dto.setNotice(rs.getInt("notice") == 1);
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 📌 검색 결과 개수
    @Override
    public int countSearch(String keyword) {
        int count = 0;
        final String sql =
            "SELECT COUNT(*) FROM board " +
            "WHERE title LIKE ? OR writer LIKE ? OR content LIKE ?";

        try (
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            String like = "%" + keyword + "%";
            pstmt.setString(1, like);
            pstmt.setString(2, like);
            pstmt.setString(3, like);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}
