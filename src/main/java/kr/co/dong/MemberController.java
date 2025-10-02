package kr.co.dong;

import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.dong.member.MemberDTO;
import kr.co.dong.member.MemberService;
import kr.co.dong.news.NaverNewsdto;
import kr.co.dong.news.NaverNewsService;
import kr.co.dong.UserKeyword.UserKeywordDTO;
import kr.co.dong.UserKeyword.UserKeywordService;

@Controller
@RequestMapping("/member")
public class MemberController {

   @Inject
   private MemberService memberService;
   @Inject
   private NaverNewsService naverNewsService;
   @Inject
   private UserKeywordService userKeywordService;

   // 키워드 페이지 이동
   @GetMapping("/keyword")
   public String keyword() {
      return "member/keyword";
   }

   // 회원가입 폼 이동
   @GetMapping("/join")
   public String joinForm() {
      return "member/join"; // /WEB-INF/views/member/join.jsp
   }

   // 회원가입 처리
   @RequestMapping(value = "/join", method = RequestMethod.POST)
   public String join(MemberDTO member, Model model) {
      String errorMessage = null;
      boolean isDuplicate = false;

      // 아이디 중복 체크
      if (!memberService.isIdAvailable(member.getId())) {
         errorMessage = "아이디가 이미 존재합니다.";
         member.setId(null);
         isDuplicate = true;
      }
      // 휴대폰 번호 중복 체크
      else if (!memberService.isPhoneAvailable(member.getPhone())) {
         errorMessage = "휴대폰 번호가 이미 존재합니다.";
         member.setPhone(null);
         isDuplicate = true;
      }
      // 이메일 중복 체크
      else if (!memberService.isEmailAvailable(member.getEmail())) {
         errorMessage = "이메일이 이미 존재합니다.";
         member.setEmail(null);
         isDuplicate = true;
      }

      if (isDuplicate) {
         model.addAttribute("errorMessage", errorMessage);
         model.addAttribute("member", member);
         return "member/join";
      }

      memberService.register(member);
      return "redirect:/member/login";
   }

   // 로그인 폼 이동
   @GetMapping("/login")
   public String loginForm() {
      return "member/login"; // /WEB-INF/views/member/login.jsp
   }

   // 로그인 처리 (🔑 병합된 부분: loginUser 세션 저장 강화)
   @PostMapping("/login")
   public String login(MemberDTO member, HttpSession session, Model model) {

       MemberDTO loginUser = memberService.login(member);

       if (loginUser != null) {
           // 세션 저장 (Inquiry 작성자 자동 기입용)
           session.setAttribute("loginUser", loginUser); 
           session.setAttribute("id", loginUser.getId());
           session.setAttribute("role", loginUser.getRole());
           session.setAttribute("name", loginUser.getName());

           // 키워드 뉴스 최신 10개 가져오기
           List<UserKeywordDTO> keywordDTOs = userKeywordService.getKeywords(loginUser.getId());
           Set<String> addedLinks = new HashSet<>();
           List<Map<String, String>> latestNews = new ArrayList<>();

           try {
               for (UserKeywordDTO dto : keywordDTOs) {
                   NaverNewsdto newsResponse = naverNewsService.searchNews(dto.getKeyword());
                   for (NaverNewsdto.NewsItem item : newsResponse.getItems()) {
                       if (addedLinks.contains(item.getLink())) continue;
                       addedLinks.add(item.getLink());

                       Map<String, String> newsMap = new HashMap<>();
                       newsMap.put("title", item.getTitle());
                       newsMap.put("pubDate", item.getPubDate());
                       newsMap.put("keyword", dto.getKeyword());
                       newsMap.put("link", item.getLink());

                       latestNews.add(newsMap);
                   }
               }
           } catch (Exception e) {
               e.printStackTrace();
           }

           latestNews = latestNews.stream()
                                  .sorted((a,b) -> b.get("pubDate").compareTo(a.get("pubDate")))
                                  .limit(100)
                                  .collect(Collectors.toList());

           session.setAttribute("latestNews", latestNews);

           return "main"; // 메인 페이지
       } else {
           model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
           return "member/login";
       }
   }

   // 로그아웃 처리
   @GetMapping("/logout")
   public String logout(HttpSession session) {
      session.invalidate();
      return "redirect:/main";
   }

   // 회원가입 중복 검사
   @PostMapping("/checkDuplicate")
   @ResponseBody
   public String checkDuplicate(@RequestParam("id") String id, @RequestParam("phone") String phone,
         @RequestParam("email") String email) {
      StringBuilder json = new StringBuilder();
      json.append("{");

      if (!memberService.isIdAvailable(id)) {
         json.append("\"success\":false,");
         json.append("\"message\":\"아이디가 이미 존재합니다.\"");
      } else if (!memberService.isPhoneAvailable(phone)) {
         json.append("\"success\":false,");
         json.append("\"message\":\"휴대폰 번호가 이미 존재합니다.\"");
      } else if (!memberService.isEmailAvailable(email)) {
         json.append("\"success\":false,");
         json.append("\"message\":\"이메일이 이미 존재합니다.\"");
      } else {
         json.append("\"success\":true,");
         json.append("\"message\":\"사용 가능한 값입니다.\"");
      }

      json.append("}");
      return json.toString();
   }

   // 마이페이지
   @RequestMapping("/mypage")
   public String mypage(HttpSession session, Model model) {
      String id = (String) session.getAttribute("id");
      MemberDTO user = memberService.myDTO(id);
      model.addAttribute("user", user);
      return "member/mypage";
   }

   // 비번체크 → 수정모달
   @PostMapping("/mypage_pass")
   public String checkPass(@RequestParam String id, @RequestParam String password, Model model) {
      MemberDTO user = memberService.myDTO(id);
      if (!memberService.checkPassword(id, password)) {
         model.addAttribute("passFail", true);
         model.addAttribute("user", user);
         return "member/mypage";
      }
      model.addAttribute("user", user);
      return "member/userupdate";
   }

   // 회원/관리자 전체 리스트
   @RequestMapping("/members")
   public String members(@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
                    Model model){
      int limit = 15;
      int offset = (currentPage -1) * limit;

      Map<String,Object> params = new HashMap<>();
      params.put("limit", Integer.valueOf(limit));
      params.put("offset", Integer.valueOf(offset));

      int totalCount = memberService.memberCount();
      List<MemberDTO> list = memberService.allList(params);
      int searchMembersCount = memberService.searchMembersCount(params);

      int totalPages = totalCount / limit;
       if(totalCount % limit != 0) {
           totalPages += 1;
       }
      if(currentPage > totalPages) currentPage = totalPages;
      if(currentPage < 1) currentPage = 1;

      model.addAttribute("list", list);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("searchCount", totalCount);
      model.addAttribute("currentPage", currentPage);
      model.addAttribute("totalPages", totalPages);
      model.addAttribute("limit", limit);

      return "admin/members";
   }

   // 회원검색
   @RequestMapping("/members_search")
   public String searchMembers(@RequestParam Map<String, Object> params,
                        @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
                        Model model) {
      int limit = 15;
      int offset = (currentPage -1) * limit;
      params.put("limit", Integer.valueOf(limit));
      params.put("offset", Integer.valueOf(offset));

      List<MemberDTO> list= memberService.searchMembers(params);
      int totalCount = memberService.memberCount();
      int searchMembersCount = memberService.searchMembersCount(params);
      int totalPage = (int) Math.ceil((double) searchMembersCount / limit);

      model.addAttribute("list", list);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("searchCount", searchMembersCount);
      model.addAttribute("params", params);
      model.addAttribute("currentPage", currentPage);
      model.addAttribute("totalPage", totalPage);

      return "admin/members";
   }

   // 회원정보 수정
   @PostMapping("/userupdate")
   public String userupdate(MemberDTO member, Model model) {
      memberService.userupdate(member);
      model.addAttribute("user", memberService.selectone(member.getId()));
      return "member/mypage";
   }

   // 관리자 회원정보 수정
   @PostMapping(value = "/adminupdate")
   public String adminupdate(@RequestParam("id") String id, Model model) {
       MemberDTO list = memberService.selectone(id);
        model.addAttribute("user", list);
        return "admin/adminupdate";
   }

   @PostMapping(value = "/adminupdate_ok")
   public String adminupdate(@ModelAttribute MemberDTO update) {
      memberService.adminupdate(update);
        return "redirect:/member/members";
   }

   // 관리자 삭제
   @PostMapping(value = "/deleteadmin")
   public String deleteadmin(@RequestParam("id") String id) {
      memberService.deleteadmin(id);
      return "redirect:/member/members";
   }

   // 비밀번호 변경
   @PostMapping("/change-password")
   @ResponseBody
   public String changePassword(@RequestParam("id") String id, @RequestParam("currentPw") String currentPw,
         @RequestParam("newPw") String newPw) {
      StringBuilder json = new StringBuilder();
      json.append("{");

      MemberDTO member = memberService.selectone(id);
      if (member == null) {
         json.append("\"success\":false,");
         json.append("\"message\":\"사용자를 찾을 수 없습니다.\"");
         json.append("}");
         return json.toString();
      }

      if (!member.getPassword().equals(currentPw)) {
         json.append("\"success\":false,");
         json.append("\"message\":\"현재 비밀번호가 올바르지 않습니다.\"");
         json.append("}");
         return json.toString();
      }

      member.setPassword(newPw);
      int result = memberService.updatePassword(member);

      json.append("\"success\":").append(result > 0);
      if (result <= 0) {
         json.append(",\"message\":\"비밀번호 변경 실패\"");
      } else {
         json.append(",\"message\":\"비밀번호가 성공적으로 변경되었습니다.\"");
      }
      json.append("}");
      return json.toString();
   }

   // 회원 탈퇴
   @PostMapping(value = "/delete", produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String deleteUser(@RequestParam("id") String id, @RequestParam("password") String password) {
      StringBuilder json = new StringBuilder();
      json.append("{");

      MemberDTO member = memberService.selectone(id);
      if (member == null) {
         json.append("\"success\":false,");
         json.append("\"message\":\"사용자를 찾을 수 없습니다.\"");
         json.append("}");
         return json.toString();
      }

      if (!member.getPassword().equals(password)) {
         json.append("\"success\":false,");
         json.append("\"message\":\"비밀번호가 일치하지 않습니다.\"");
         json.append("}");
         return json.toString();
      }

      int result = memberService.deleteUser(id);

      json.append("\"success\":").append(result > 0);
      if (result <= 0) {
         json.append(",\"message\":\"회원 탈퇴 처리에 실패했습니다.\"");
      } else {
         json.append(",\"message\":\"회원 탈퇴가 완료되었습니다.\"");
      }
      json.append("}");
      return json.toString();
   }

   // 회원 계정 활성화
   @PostMapping(value="/active", produces="application/json;charset=UTF-8")
   @ResponseBody
   public String active(@RequestParam("id") String id,
                            @RequestParam("password") String password) {
       StringBuilder json = new StringBuilder();
       json.append("{");

       MemberDTO member = memberService.selectone(id);
       if (member == null) {
           json.append("\"success\":false,");
           json.append("\"message\":\"사용자를 찾을 수 없습니다.\"");
           json.append("}");
           return json.toString();
       }

       if (!member.getPassword().equals(password)) {
           json.append("\"success\":false,");
           json.append("\"message\":\"비밀번호가 일치하지 않습니다.\"");
           json.append("}");
           return json.toString();
       }

       int result = memberService.activeUser(id);

       json.append("\"success\":").append(result > 0);
       if (result <= 0) {
           json.append(",\"message\":\"계정 활성화에 실패했습니다.\"");
       } else {
           json.append(",\"message\":\"계정 활성화가 완료되었습니다. 재로그인 해주세요\"");
       }
       json.append("}");
       return json.toString();
   }

   // 관리자 회원상세조회
   @GetMapping("/detail")
   public String detail(@RequestParam("id") String id, Model model) {
      MemberDTO user = memberService.selectone(id);
      model.addAttribute("user", user);
      return "admin/detail";
   }

}
