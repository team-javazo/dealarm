package kr.co.dong;

import java.io.PrintWriter;
import java.util.List;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.co.dong.inquiry.CommentService;
import kr.co.dong.inquiry.InquiryService;

/**
 * InquiryController
 * - 문의 게시판 컨트롤러 (댓글형)
 * - 관리자 글은 자동으로 writer='관리자(이름)' 처리
 * - 일반회원은 삭제 불가 / 조회수 실시간 반영
 */
@Controller
@RequestMapping("/inquiry")
public class InquiryController {

    @Inject private InquiryService service;
    @Inject private CommentService commentService;

    /** 📋 목록 */
    @GetMapping("/list")
    public String list(@RequestParam(value = "category", required = false) String category,
                       @RequestParam(value = "keyword", required = false) String keyword,
                       Model model, HttpSession session) {

        List<InquiryDTO> list = service.list();
        model.addAttribute("list", list);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("currentLoginId", resolveLoginWriter(session));
        model.addAttribute("isAdmin", isAdmin(session));
        model.addAttribute("categories", new String[]{"일반문의","버그제보","계정문의","기타"});

        return "inquiry/list";
    }

    /** 📄 상세 (조회수 실시간 반영) */
    @GetMapping("/detail")
    public String detail(@RequestParam("id") int id,
                         HttpSession session, Model model,
                         HttpServletResponse response) throws Exception {

        InquiryDTO dto = service.detail(id);
        if (dto == null) {
            sendAlert(response, "존재하지 않는 글입니다.", "/inquiry/list");
            return null;
        }

        String loginId = resolveLoginWriter(session);
        boolean admin = isAdmin(session);
        boolean owner = loginId != null && dto.getWriter() != null && dto.getWriter().contains(loginId);

        if (dto.isSecret() && !(admin || owner)) {
            sendAlert(response, "비밀글은 작성자 또는 관리자만 열람할 수 있습니다.", "history.back()");
            return null;
        }

        // ✅ 조회수 업데이트 후 다시 조회해서 즉시 반영
        service.updateHit(id);
        dto = service.detail(id);

        model.addAttribute("inquiry", dto);
        model.addAttribute("commentList", commentService.list(id));
        model.addAttribute("isAdmin", admin);
        model.addAttribute("currentLoginId", loginId);
        session.setAttribute("inquiryWriter", dto.getWriter());

        return "inquiry/detail";
    }

    /** ✏️ 글쓰기 폼 */
    @GetMapping("/write")
    public String writeForm(HttpSession session, HttpServletResponse response, Model model) throws Exception {
        String writer = resolveLoginWriter(session);
        if (writer == null) {
            sendAlert(response, "로그인 후 글을 작성할 수 있습니다.", "history.back()");
            return null;
        }
        model.addAttribute("currentWriter", writer);
        model.addAttribute("isAdmin", isAdmin(session));
        return "inquiry/write";
    }

    /** 📝 글쓰기 등록 */
    @PostMapping("/write")
    public String writeSubmit(@ModelAttribute InquiryDTO dto,
                              HttpSession session,
                              HttpServletResponse response) throws Exception {

        String writer = resolveLoginWriter(session);
        boolean admin = isAdmin(session);

        if (writer == null) {
            sendAlert(response, "로그인 후 글을 작성할 수 있습니다.", "history.back()");
            return null;
        }

        // ✅ 관리자일 경우 writer 자동 “관리자(이름)” 처리
        if (admin) {
            String adminName = resolveLoginWriter(session);
            dto.setWriter("관리자(" + (adminName != null ? adminName : "시스템") + ")");
        } else if (isBlank(dto.getWriter())) {
            dto.setWriter(writer);
        }

        service.insert(dto);
        return "redirect:/inquiry/list";
    }

    /** 🧩 수정 폼 */
    @GetMapping("/edit")
    public String editForm(@RequestParam("id") int id,
                           HttpSession session, HttpServletResponse response, Model model) throws Exception {
        InquiryDTO dto = service.detail(id);
        if (dto == null) {
            sendAlert(response, "존재하지 않는 글입니다.", "/inquiry/list");
            return null;
        }

        String loginId = resolveLoginWriter(session);
        boolean admin = isAdmin(session);
        boolean owner = loginId != null && dto.getWriter() != null && dto.getWriter().contains(loginId);

        if (!(admin || owner)) {
            sendAlert(response, "수정 권한이 없습니다.", "history.back()");
            return null;
        }

        model.addAttribute("dto", dto);
        model.addAttribute("isAdmin", admin);
        model.addAttribute("isOwner", owner);
        return "inquiry/edit";
    }

    /** 🧱 수정 제출 */
    @PostMapping("/edit")
    public void editSubmit(@ModelAttribute InquiryDTO dto,
                           HttpSession session,
                           HttpServletRequest request,
                           HttpServletResponse response) throws Exception {
        String loginId = resolveLoginWriter(session);
        boolean admin = isAdmin(session);
        boolean owner = loginId != null && dto.getWriter() != null && dto.getWriter().contains(loginId);

        if (!(admin || owner)) {
            sendAlert(response, "수정 권한이 없습니다.", "history.back()");
            return;
        }

        if (admin) {
            String adminName = resolveLoginWriter(session);
            dto.setWriter("관리자(" + (adminName != null ? adminName : "시스템") + ")");
        }

        service.update(dto);
        sendAlertWithContextPath(response, request, "수정되었습니다.", "/inquiry/detail?id=" + dto.getId());
    }

    /** 🗑️ 삭제 (관리자만 가능) */
    @GetMapping("/delete")
    public void delete(@RequestParam("id") int id,
                       HttpSession session,
                       HttpServletRequest request,
                       HttpServletResponse response) throws Exception {

        InquiryDTO dto = service.detail(id);
        if (dto == null) {
            sendAlert(response, "존재하지 않는 글입니다.", "/inquiry/list");
            return;
        }

        boolean admin = isAdmin(session);

        // ✅ 일반회원 삭제 불가
        if (!admin) {
            sendAlert(response, "삭제는 관리자만 가능합니다.", "history.back()");
            return;
        }

        service.delete(id);
        sendAlertWithContextPath(response, request, "삭제되었습니다.", "/inquiry/list");
    }

    /** 관리자 모드 ON/OFF */
    @GetMapping("/dev/admin/on")
    public void devAdminOn(HttpSession session, HttpServletResponse response) throws Exception {
        session.setAttribute("isAdmin", true);
        sendAlert(response, "관리자 모드 ON", "/inquiry/list");
    }

    @GetMapping("/dev/admin/off")
    public void devAdminOff(HttpSession session, HttpServletResponse response) throws Exception {
        session.removeAttribute("isAdmin");
        sendAlert(response, "관리자 모드 OFF", "/inquiry/list");
    }

    /* ===================== 공통 유틸 ===================== */

    private String resolveLoginWriter(HttpSession session) {
        try {
            Object userObj = session.getAttribute("loginUser");
            if (userObj instanceof kr.co.dong.member.MemberDTO) {
                kr.co.dong.member.MemberDTO m = (kr.co.dong.member.MemberDTO) userObj;
                if (m.getName() != null && !m.getName().trim().isEmpty()) return m.getName();
                if (m.getId() != null && !m.getId().trim().isEmpty()) return m.getId();
            }

            final String[] keys = {"name","username","id","loginId","userId"};
            for (String key : keys) {
                Object val = session.getAttribute(key);
                if (val != null && !val.toString().trim().isEmpty()) return val.toString();
            }
            return null;
        } catch (Exception e) {
            System.out.println("[resolveLoginWriter] 오류: " + e.getMessage());
            return null;
        }
    }

    private boolean isAdmin(HttpSession session) {
        try {
            Object roleObj = session.getAttribute("role");
            String role = (roleObj == null) ? "" : roleObj.toString().toLowerCase();
            boolean byRole = role.contains("admin");
            boolean byToggle = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
            return byRole || byToggle;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }

    private void sendAlert(HttpServletResponse response, String msg, String action) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        if (action.startsWith("/"))
            out.println("<script>alert('" + msg + "'); location.href='" + action + "';</script>");
        else
            out.println("<script>alert('" + msg + "'); " + action + ";</script>");
        out.flush();
        out.close();
    }

    private void sendAlertWithContextPath(HttpServletResponse response, HttpServletRequest request,
                                          String msg, String path) throws Exception {
        String contextPath = request.getContextPath();
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>alert('" + msg + "'); location.href='" + contextPath + path + "';</script>");
        out.flush();
        out.close();
    }
}
