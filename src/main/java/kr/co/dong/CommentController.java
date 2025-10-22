package kr.co.dong;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.PrintWriter;

import kr.co.dong.inquiry.CommentDTO;
import kr.co.dong.inquiry.CommentService;
import kr.co.dong.member.MemberDTO;

/**
 * CommentController (최신 완성형)
 * - 관리자와 작성자만 댓글 작성/삭제 가능
 * - 관리자가 댓글을 달면 writer="관리자" 로 표시
 * - 관리자 댓글은 role='admin' 으로 저장되어 JSP에서 별도 표시됨
 */
@Controller
@RequestMapping("/comment")
public class CommentController {

    @Inject
    private CommentService service;

    /** 🟢 댓글 등록 */
    @PostMapping("/insert")
    public String insert(@ModelAttribute CommentDTO dto,
                         HttpSession session,
                         HttpServletResponse response) throws Exception {

        // 로그인 유저 확인
        String loginId = getLoginId(session);
        String role = (String) session.getAttribute("role");
        boolean isAdmin = role != null && role.toLowerCase().contains("admin");

        if (loginId == null) {
            sendAlert(response, "로그인 후 댓글을 작성할 수 있습니다.", "history.back()");
            return null;
        }

        // 작성자 or 관리자 권한 확인
        String inquiryWriter = (String) session.getAttribute("inquiryWriter");
        boolean isOwner = inquiryWriter != null && loginId.equals(inquiryWriter);

        if (!(isAdmin || isOwner)) {
            sendAlert(response, "댓글 작성 권한이 없습니다.", "history.back()");
            return null;
        }

        // ✅ 관리자일 경우 작성자 이름을 '관리자'로 고정
        if (isAdmin) {
            dto.setWriter("관리자");
            dto.setRole("admin");
        } else {
            dto.setWriter(loginId);
            dto.setRole("user");
        }

        service.add(dto);
        return "redirect:/inquiry/detail?id=" + dto.getInquiryId();
    }

    /** 🔴 댓글 삭제 (작성자 or 관리자) */
    @GetMapping("/delete")
    public String delete(@RequestParam("id") int id,
                         @RequestParam("inquiryId") int inquiryId,
                         HttpSession session,
                         HttpServletResponse response) throws Exception {

        String loginId = getLoginId(session);
        String role = (String) session.getAttribute("role");
        boolean isAdmin = role != null && role.toLowerCase().contains("admin");

        if (loginId == null) {
            sendAlert(response, "로그인 후 삭제할 수 있습니다.", "history.back()");
            return null;
        }

        if (isAdmin) {
            service.deleteById(id);
        } else {
            service.deleteByOwner(id, loginId);
        }

        return "redirect:/inquiry/detail?id=" + inquiryId;
    }

    /** 🧩 로그인 사용자 ID 추출 */
    private String getLoginId(HttpSession session) {
        Object idObj = session.getAttribute("id");
        if (idObj != null) return idObj.toString();

        Object userObj = session.getAttribute("loginUser");
        if (userObj instanceof MemberDTO) {
            MemberDTO m = (MemberDTO) userObj;
            if (m.getId() != null && !m.getId().trim().isEmpty()) return m.getId();
            if (m.getName() != null && !m.getName().trim().isEmpty()) return m.getName();
        }

        String[] keys = {"loginId", "userId", "userid", "username", "name"};
        for (String key : keys) {
            Object v = session.getAttribute(key);
            if (v != null && !v.toString().trim().isEmpty()) return v.toString();
        }

        return null;
    }

    /** 🧱 공통 alert */
    private void sendAlert(HttpServletResponse response, String msg, String action) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        if (action.startsWith("/")) {
            out.println("<script>alert('" + msg + "'); location.href='" + action + "';</script>");
        } else {
            out.println("<script>alert('" + msg + "'); " + action + ";</script>");
        }
        out.flush();
    }
}
