package kr.co.dong.inquiry;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/inquiry")
public class InquiryController {

    @Autowired
    private InquiryService inquiryService;

    // 📋 문의 목록 (페이징 + 검색)
    @GetMapping("/list")
    public String list(@RequestParam(value = "page", defaultValue = "1") int page,
                       @RequestParam(value = "keyword", required = false) String keyword,
                       Model model) {
        List<InquiryDTO> inquiries = inquiryService.list(page, keyword);
        int totalPages = inquiryService.getTotalPages(keyword);

        model.addAttribute("inquiryList", inquiries);
        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("keyword", keyword);

        return "inquiry/list"; // /WEB-INF/views/inquiry/list.jsp
    }

    // ✏️ 등록 폼
    @GetMapping("/write")
    public String writeForm(HttpSession session, Model model) {
        String loginName = (String) session.getAttribute("name");
        model.addAttribute("writer", loginName != null ? loginName : "익명");
        model.addAttribute("categories", List.of("일반문의", "결제문의", "계정문의", "기타"));
        return "inquiry/write"; // /WEB-INF/views/inquiry/write.jsp
    }

    // ✏️ 등록 처리 (파일 업로드 포함)
    @PostMapping("/write")
    public String write(InquiryDTO dto,
                        @RequestParam(value = "uploadFile", required = false) MultipartFile file,
                        HttpSession session) throws IOException {
        String loginName = (String) session.getAttribute("name");
        dto.setWriter(loginName != null ? loginName : "익명");

        // 파일 업로드 처리
        if (file != null && !file.isEmpty()) {
            String uploadDir = "C:/upload/";
            File dest = new File(uploadDir, file.getOriginalFilename());
            file.transferTo(dest);

            dto.setFilename(file.getOriginalFilename());
            dto.setFilepath(dest.getAbsolutePath());
        }

        inquiryService.insert(dto);

        // 📢 알림 서비스 연동 가능 (추후 구현)
        return "redirect:/inquiry/list";
    }

    // 🔍 상세보기
    @GetMapping("/detail")
    public String detail(@RequestParam("id") int id, HttpSession session, Model model) {
        InquiryDTO dto = inquiryService.detail(id);
        String loginName = (String) session.getAttribute("name");
        String role = (String) session.getAttribute("role");

        // 비밀글 체크
        if (dto.isSecret() && (loginName == null || (!loginName.equals(dto.getWriter()) && !"admin".equals(role)))) {
            model.addAttribute("error", "비밀글은 작성자와 관리자만 볼 수 있습니다.");
            return "redirect:/inquiry/list";
        }

        model.addAttribute("dto", dto);
        return "inquiry/detail";
    }

    // ✏️ 수정 폼
    @GetMapping("/update")
    public String updateForm(@RequestParam("id") int id, HttpSession session, Model model) {
        String loginName = (String) session.getAttribute("name");
        String role = (String) session.getAttribute("role");

        InquiryDTO dto = inquiryService.detail(id);

        if (loginName == null || (!loginName.equals(dto.getWriter()) && !"admin".equals(role))) {
            return "redirect:/inquiry/detail?id=" + id;
        }

        model.addAttribute("dto", dto);
        model.addAttribute("categories", List.of("일반문의", "결제문의", "계정문의", "기타"));
        return "inquiry/update";
    }

    // ✏️ 수정 처리
    @PostMapping("/update")
    public String update(InquiryDTO dto,
                         @RequestParam(value = "uploadFile", required = false) MultipartFile file,
                         HttpSession session) throws IOException {
        String loginName = (String) session.getAttribute("name");
        String role = (String) session.getAttribute("role");

        InquiryDTO origin = inquiryService.detail(dto.getId());
        if (loginName == null || (!loginName.equals(origin.getWriter()) && !"admin".equals(role))) {
            return "redirect:/inquiry/detail?id=" + dto.getId();
        }

        if (file != null && !file.isEmpty()) {
            String uploadDir = "C:/upload/";
            File dest = new File(uploadDir, file.getOriginalFilename());
            file.transferTo(dest);

            dto.setFilename(file.getOriginalFilename());
            dto.setFilepath(dest.getAbsolutePath());
        }

        inquiryService.update(dto);
        return "redirect:/inquiry/detail?id=" + dto.getId();
    }

    // ❌ 삭제
    @PostMapping("/delete")
    public String delete(@RequestParam("id") int id, HttpSession session) {
        String loginName = (String) session.getAttribute("name");
        String role = (String) session.getAttribute("role");

        InquiryDTO dto = inquiryService.detail(id);
        if (loginName == null || (!loginName.equals(dto.getWriter()) && !"admin".equals(role))) {
            return "redirect:/inquiry/detail?id=" + id;
        }

        inquiryService.delete(id);
        return "redirect:/inquiry/list";
    }

    // 📨 답변 등록 (관리자만)
    @PostMapping("/answer")
    public String insertAnswer(@RequestParam("id") int id,
                               @RequestParam("answer") String answer,
                               HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            return "redirect:/inquiry/detail?id=" + id;
        }

        inquiryService.insertAnswer(id, answer);

        // 📢 알림 서비스 연동 가능
        return "redirect:/inquiry/detail?id=" + id;
    }

    // 🔄 상태 변경 (관리자만)
    @PostMapping("/status")
    public String updateStatus(@RequestParam("id") int id,
                               @RequestParam("status") String status,
                               HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            return "redirect:/inquiry/detail?id=" + id;
        }

        inquiryService.updateStatus(id, status);
        return "redirect:/inquiry/detail?id=" + id;
    }

    // 🙋‍♂️ 마이페이지 - 내가 쓴 문의
    @GetMapping("/myInquiries")
    public String myInquiries(HttpSession session, Model model) {
        String loginName = (String) session.getAttribute("name");
        List<InquiryDTO> myList = inquiryService.listByWriter(loginName);
        model.addAttribute("inquiryList", myList);
        return "inquiry/myList";
    }

    // 📊 통계 (관리자 전용)
    @GetMapping("/stats")
    public String stats(HttpSession session, Model model) {
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            return "redirect:/inquiry/list";
        }

        Map<String, Integer> stats = inquiryService.getStats();
        model.addAttribute("stats", stats);
        return "inquiry/stats";
    }
}
