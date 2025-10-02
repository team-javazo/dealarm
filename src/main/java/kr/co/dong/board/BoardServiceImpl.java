package kr.co.dong.board;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardDAO boardDAO;

    @Override
    public List<BoardDTO> listAll(Map<String, Object> params) {
        return boardDAO.listAll(params);
    }

    @Override
    public int insert(BoardDTO dto) {
        return boardDAO.insert(dto);
    }

    @Override
    public BoardDTO detail(int id) {
        return boardDAO.detail(id);
    }

    @Override
    public int update(BoardDTO dto) {
        return boardDAO.update(dto);
    }

    @Override
    public int delete(int id) {
        return boardDAO.delete(id);
    }

    @Override
    public void increaseHit(int id) {
        boardDAO.increaseHit(id);
    }

    @Override
    public int countAll() {
        return boardDAO.countAll();
    }

    @Override
    public List<BoardDTO> search(Map<String, Object> params) {
        return boardDAO.search(params);
    }

    @Override
    public int countSearch(String keyword) {
        return boardDAO.countSearch(keyword);
    }
}
