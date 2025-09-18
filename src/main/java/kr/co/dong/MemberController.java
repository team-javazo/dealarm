package kr.co.dong;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import kr.co.dong.member.MemberDTO;
import kr.co.dong.member.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Inject
    private MemberService memberService;

    // 회원가입 폼 이동
    @GetMapping("/join")
    public String joinForm() {
        return "member/join"; // /WEB-INF/views/member/join.jsp
    }

    // 회원가입 처리
    @PostMapping("/join")
    public String join(MemberDTO member) {
        memberService.register(member);
        return "redirect:/"; // 가입 후 홈으로 이동
    }

    // 로그인 폼 이동
    @GetMapping("/login")
    public String loginForm() {
        return "member/login"; // /WEB-INF/views/member/login.jsp
    }

    // 로그인 처리
    @PostMapping("/login")
    public String login(MemberDTO member, HttpSession session, Model model) {
        MemberDTO loginUser = memberService.login(member);

        if (loginUser != null) {
            session.setAttribute("loginUser", loginUser);
            return "redirect:/"; // 로그인 성공 → 홈으로
        } else {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "member/login"; // 실패 → 다시 로그인 페이지
        }
    }

    // 로그아웃 처리
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 초기화
        return "redirect:/"; // 홈으로 이동
    }
//	마이페이지 띄우기
	@RequestMapping("/mypage")
	public String mypage(HttpSession session, Model model) {
//		String id = (String) session.getAttribute("loginUser");		//로그인세션에서 id 추출
		String id = "hubizuk";										//test ID
		MemberDTO user = memberService.myDTO(id);					//내 정보객체 생성
		model.addAttribute("user", user);							//user를 view로 보냄
		return "member/mypage";
	}
//	마이페이지 수정모달 비밀번호 체크 
	@PostMapping("/mypage_pass")
	public String checkPass(@RequestParam String id, @RequestParam String password, Model model) {
		MemberDTO user = memberService.myDTO(id);
		System.out.println("패스체크까지 오나??");
		if(!memberService.checkPassword(id, password)){
			model.addAttribute("passFail", true);
			System.out.println("비번실패");
			model.addAttribute("user", user);
			return "member/mypage";
		}
		model.addAttribute("userId", id);
		System.out.println("비번체크성공");

		return "member/mypage";
	}
	
	
	
	//	관리자 회원관리 페이지
	@RequestMapping("/members")
	public String members(Model model) {
		// 전체회원 목록
		List<MemberDTO> list = memberService.allList();
		model.addAttribute("list", list);
		return "admin/members";
	}

	
	
	
	
    
}