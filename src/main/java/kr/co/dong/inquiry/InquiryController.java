package kr.co.dong.inquiry;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.co.dong.member.MemberDTO; // 로그인 세션 객체

@Controller
@RequestMapping("/inquiry")
public class InquiryController {

    @Inject
    private InquiryService service;

    /* ==============================
       📜 목록
       - 로그인 정보와 관리자 여부 전달 (JSP 권한 표시용)
    ============================== */
    @GetMapping("/list")
    public String list(HttpSession session, Model model) {
        model.addAttribute("list", service.list());

        // ✅ 로그인 사용자 정보 JSP에 전달
        String loginId = resolveLoginWriter(session);
        model.addAttribute("currentLoginId", loginId);

        // ✅ 관리자 여부 JSP에서 활용 가능하게 전달
        boolean admin = isAdmin(session);
        model.addAttribute("isAdmin", admin);

        return "inquiry/list";
    }

    /* ==============================
       📄 상세 (쿼리 & 패스 공통)
       - 비밀글 접근권한: 관리자 or 작성자만 가능
    ============================== */
    @GetMapping("/detail")
    public String detailByQuery(@RequestParam("id") int id, HttpSession session, Model model) {
        return handleDetail(id, session, model);
    }

    @GetMapping("/detail/{id}")
    public String detailByPath(@PathVariable("id") int id, HttpSession session, Model model) {
        return handleDetail(id, session, model);
    }

    /* ==============================
       ✍️ 글쓰기 폼 (작성자 자동기입)
    ============================== */
    @GetMapping("/write")
    public String writeForm(HttpSession session, Model model) {
        String writer = resolveLoginWriter(session);
        model.addAttribute("currentWriter", writer == null ? "" : writer);
        return "inquiry/write";
    }

    /* ==============================
       💾 글쓰기 저장 (POST)
    ============================== */
    @PostMapping("/write")
    public String writeSubmit(@ModelAttribute InquiryDTO dto, HttpSession session) {
        if (isEmpty(dto.getWriter())) {
            String writer = resolveLoginWriter(session);
            if (!isEmpty(writer)) dto.setWriter(writer);
        }
        service.insert(dto);
        return "redirect:/inquiry/list";
    }

    /* ==============================
       🧩 (호환용) /insert 저장
    ============================== */
    @PostMapping("/insert")
    public String insert(@ModelAttribute InquiryDTO dto, HttpSession session) {
        if (isEmpty(dto.getWriter())) {
            String writer = resolveLoginWriter(session);
            if (!isEmpty(writer)) dto.setWriter(writer);
        }
        service.insert(dto);
        return "redirect:/inquiry/list";
    }

    /* ==============================
       🗣️ 관리자 답변 등록
    ============================== */
    @PostMapping("/answer")
    public String answer(@RequestParam("id") int id,
                         @RequestParam("answer") String answer,
                         HttpSession session, Model model) {
        if (!isAdmin(session)) {
            model.addAttribute("msg", "관리자만 답변을 등록할 수 있습니다.");
            return "error/403";
        }
        service.insertAnswer(id, answer);
        service.updateStatus(id, "답변완료");
        return "redirect:/inquiry/detail?id=" + id;
    }

    /* ==============================
       ⚙️ 관리자 모드 토글 (개발용)
    ============================== */
    @GetMapping("/dev/admin/on")
    public String devAdminOn(HttpSession session) {
        session.setAttribute("isAdmin", true);
        session.setAttribute("role", "admin");
        return "redirect:/inquiry/list";
    }

    @GetMapping("/dev/admin/off")
    public String devAdminOff(HttpSession session) {
        session.setAttribute("isAdmin", false);
        return "redirect:/inquiry/list";
    }

    /* ==============================
       🔍 상세 공통 처리
       - 비밀글 접근: 관리자 or 작성자만 허용
       - 그 외: 403 반환
    ============================== */
    private String handleDetail(int id, HttpSession session, Model model) {
        InquiryDTO dto = service.detail(id);
        if (dto == null) {
            model.addAttribute("msg", "존재하지 않는 글입니다.");
            return "error/404";
        }

        String loginId = resolveLoginWriter(session);  // 로그인한 유저의 ID
        boolean admin = isAdmin(session);
        boolean owner = !isEmpty(loginId) && loginId.equals(dto.getWriter());

        // ✅ 비밀글 접근 제한
        if (dto.isSecret() && !(admin || owner)) {
            model.addAttribute("msg", "비밀글은 작성자 또는 관리자만 열람할 수 있습니다.");
            return "error/403";
        }

        // 조회수 증가 및 데이터 전달
        service.updateHit(id);
        model.addAttribute("inquiry", dto);
        model.addAttribute("isAdmin", admin);
        model.addAttribute("isOwner", owner);
        return "inquiry/detail";
    }

    /* ==============================
       🧠 관리자 판별
       - role 속성 또는 dev 토글값 기준
    ============================== */
    private boolean isAdmin(HttpSession session) {
        Object roleObj = session.getAttribute("role");
        String role = roleObj == null ? "" : roleObj.toString();

        boolean byRole = "admin".equalsIgnoreCase(role)
                      || "role_admin".equalsIgnoreCase(role)
                      || role.toUpperCase().contains("ADMIN");

        boolean byToggle = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
        return byRole || byToggle;
    }

    /* ==============================
       👤 로그인 사용자 식별자 추출
       - loginUser(MemberDTO) → 세션 키 순서로 탐색
    ============================== */
    private String resolveLoginWriter(HttpSession session) {
        // 1️⃣ MemberDTO 세션 객체에서 가져오기
        Object userObj = session.getAttribute("loginUser");
        if (userObj != null) {
            if (userObj instanceof MemberDTO) {
                MemberDTO m = (MemberDTO) userObj;
                if (!isEmpty(m.getId())) return m.getId();
                if (!isEmpty(m.getName())) return m.getName();
            }
            // 2️⃣ 리플렉션으로 대체 필드 추적
            String viaReflect = tryMethods(userObj,
                    "getId", "getUserId", "getUserid",
                    "getUsername", "getName", "getEmail");
            if (!isEmpty(viaReflect)) return viaReflect;
        }

        // 3️⃣ 세션 키값에서 직접 추출
        String[] keys = { "loginId", "userId", "userid", "username", "name", "email" };
        for (String k : keys) {
            Object v = session.getAttribute(k);
            if (v != null && !isEmpty(v.toString())) return v.toString();
        }

        return null;
    }

    private String tryMethods(Object target, String... methodNames) {
        for (String m : methodNames) {
            try {
                java.lang.reflect.Method md = target.getClass().getMethod(m);
                Object val = md.invoke(target);
                if (val != null) {
                    String s = val.toString().trim();
                    if (!s.isEmpty()) return s;
                }
            } catch (Exception ignore) { }
        }
        return null;
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
