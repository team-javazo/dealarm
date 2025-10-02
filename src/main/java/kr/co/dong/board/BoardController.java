package kr.co.dong.board;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    private BoardService boardService;

    // 📌 목록 (검색 + 페이징)
    @GetMapping("/list")
    public String list(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "q", required = false) String q,
            Model model) {

    	int pageSize = 10;
    	int offset = (page - 1) * pageSize;

    	Map<String, Object> params = new HashMap<>();
    	params.put("start", offset);   // ✅ DAO 쪽 키 이름과 맞춤
    	params.put("size", pageSize);  // ✅ DAO 쪽 키 이름과 맞춤

        List<BoardDTO> list;
        int totalCount;

        if (q != null && !q.trim().isEmpty()) {
            params.put("q", q);
            list = boardService.search(params);
            totalCount = boardService.countSearch(q);
        } else {
            list = boardService.listAll(params);
            totalCount = boardService.countAll();
        }

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        model.addAttribute("boardList", list);
        model.addAttribute("q", q);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);

        return "board/list"; // → /WEB-INF/views/board/list.jsp
    }

    // 📌 글쓰기 화면
    @GetMapping("/write")
    public String writeForm() {
        return "board/write";
    }

    // 📌 글쓰기 처리
    @PostMapping("/write")
    public String write(BoardDTO dto) {
        boardService.insert(dto);
        return "redirect:/board/list";
    }

    // 📌 상세보기
    @GetMapping("/detail")
    public String detail(@RequestParam("id") int id, Model model) {
        boardService.increaseHit(id);
        BoardDTO dto = boardService.detail(id);
        model.addAttribute("board", dto);
        return "board/detail";
    }

    // 📌 수정 화면
    @GetMapping("/edit")
    public String editForm(@RequestParam("id") int id, Model model) {
        BoardDTO dto = boardService.detail(id);
        model.addAttribute("board", dto);
        return "board/edit";
    }

    // 📌 수정 처리
    @PostMapping("/edit")
    public String edit(BoardDTO dto) {
        boardService.update(dto);
        return "redirect:/board/detail?id=" + dto.getId();
    }

    // 📌 삭제 처리
    @GetMapping("/delete")
    public String delete(@RequestParam("id") int id) {
        boardService.delete(id);
        return "redirect:/board/list";
    }
}
