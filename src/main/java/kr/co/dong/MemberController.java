package kr.co.dong;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
//            session.setAttribute("loginUser", loginUser);
            session.setAttribute("id", loginUser.getId());
            session.setAttribute("role", loginUser.getRole());
            session.setAttribute("name", loginUser.getName());
            
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
	String id = (String) session.getAttribute("id");		//로그인세션에서 id 추출
		MemberDTO user = memberService.myDTO(id);					//내 정보객체 생성
		model.addAttribute("user", user);							//user를 view로 보냄
		return "member/mypage";
	}
//	마이페이지 수정모달 비밀번호 체크 
	@PostMapping("/mypage_pass")
	public String checkPass(@RequestParam String id, @RequestParam String password, Model model) {
		MemberDTO user = memberService.myDTO(id);
		System.out.println("비번체크comtroller");
		if(!memberService.checkPassword(id, password)){
			model.addAttribute("passFail", true);
			System.out.println("비번실패");
			model.addAttribute("user", user);
			return "member/mypage";
		}
		model.addAttribute("userId", id);
		System.out.println("비번체크성공");

		return "member/userupdate";
	}

	
	

	//	관리자 회원관리 전체 리스트
	@RequestMapping("/members")

	public String members(Model model) {
		int totalCount = memberService.memberCount(); // 총 회원 수
		model.addAttribute("totalCount", totalCount);
		List<MemberDTO> list = memberService.allList(); // 전체회원 목록
		model.addAttribute("list", list);
		model.addAttribute("searchCount", list.size());	// 검색카운트
		return "admin/members";
	}
	// 관리자 회원검색 리스트
	@RequestMapping("/members_search")
	public String searchMembers(@RequestParam String searchType, @RequestParam String searchValue, Model model) {
		int totalCount = memberService.memberCount(); // 총 회원 수
		model.addAttribute("totalCount", totalCount);
		List<MemberDTO> list= memberService.searchMembers(searchType, searchValue);
		model.addAttribute("list", list);
		model.addAttribute("searchCount", list.size());
		return "admin/members";
		
	}
	


    // 회원정보 수정 페이지 내용 삽입
	@PostMapping(value = "/userupdate")
	public String userpdate(@RequestParam("id") String id, Model model) {
	    MemberDTO list = memberService.selectone(id);
	     model.addAttribute("user", list);  
	     return "member/userupdate";  
	}
	

    // 관리자 회원정보 수정 페이지 내용 삽입
	@PostMapping(value = "/adminupdate")
	public String adminupdate(@RequestParam("id") String id, Model model) {
	    MemberDTO list = memberService.selectone(id);
	     model.addAttribute("user", list);  
	     return "adminupdate";  
	}
	
	// 회원 정보 수정
	@PostMapping(value = "/userupdate_ok")
	public String userupdate(@ModelAttribute MemberDTO update) {
		memberService.userupdate(update);
	     return "redirect:/";  
	}
	
	// 관리자 회원 정보 수정
	@PostMapping(value = "/adminupdate_ok")
	public String adminupdate(@ModelAttribute MemberDTO update) {
		memberService.adminupdate(update);
	     return "redirect:/";  
	}
	// 비밀번호 변경 
	@PostMapping("/change-password")
	@ResponseBody
	public Map<String, Object> changePassword(@RequestBody Map<String, Object> data) {
	    String id = (String) data.get("id");
	    String currentPw = (String) data.get("currentPw");
	    String newPw = (String) data.get("newPw");

	    Map<String, Object> response = new HashMap<>();

	    MemberDTO member = memberService.selectone(id);
	    if (member == null) {
	        response.put("success", false);
	        response.put("message", "사용자를 찾을 수 없습니다.");
	        return response;
	    }

	    if (!member.getPassword().equals(currentPw)) {
	        response.put("success", false);
	        response.put("message", "현재 비밀번호가 올바르지 않습니다.");
	        return response;
	    }

	    member.setPassword(newPw);
	    int result = memberService.updatePassword(member);

	    response.put("success", result > 0);
	    if (result <= 0) {
	        response.put("message", "비밀번호 변경 실패");
	    }

	    return response;
	}
	//회원 탈퇴 요청
	@PostMapping("/user/delete")
	@ResponseBody
	public Map<String, Object> deleteUser(@RequestBody Map<String, Object> data) {
	    String id = (String) data.get("id");
	    String password = (String) data.get("password");

	    Map<String, Object> response = new HashMap<>();

	    MemberDTO member = memberService.selectone(id);
	    if (member == null) {
	        response.put("success", false);
	        response.put("message", "사용자를 찾을 수 없습니다.");
	        return response;
	    }

	    if (!member.getPassword().equals(password)) {
	        response.put("success", false);
	        response.put("message", "비밀번호가 일치하지 않습니다.");
	        return response;
	    }

	    // 탈퇴 처리
	    int result = memberService.deleteUser(id);

	    response.put("success", result > 0);
	    if (result <= 0) {
	        response.put("message", "회원 탈퇴 처리에 실패했습니다.");
	    }
	    return response;
	}

}