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
      // 중복 체크
      String errorMessage = null;
      boolean isDuplicate = false;

      // 아이디 중복 체크
      if (!memberService.isIdAvailable(member.getId())) {
         errorMessage = "아이디가 이미 존재합니다.";
         member.setId(null); // 중복된 아이디는 null로 설정
         isDuplicate = true;
      }
      // 휴대폰 번호 중복 체크
      else if (!memberService.isPhoneAvailable(member.getPhone())) {
         errorMessage = "휴대폰 번호가 이미 존재합니다.";
         member.setPhone(null); // 중복된 휴대폰 번호는 null로 설정
         isDuplicate = true;
      }
      // 이메일 중복 체크
      else if (!memberService.isEmailAvailable(member.getEmail())) {
         errorMessage = "이메일이 이미 존재합니다.";
         member.setEmail(null); // 중복된 이메일은 null로 설정
         isDuplicate = true;
      }

      // 중복된 항목이 있을 경우, 입력 폼에 다시 보여주기 위해 `model`에 에러 메시지를 담음
      if (isDuplicate) {
         model.addAttribute("errorMessage", errorMessage);
         model.addAttribute("member", member); // 중복 항목을 제외한 값들을 유지
         return "member/join"; // 다시 회원가입 폼으로 돌아가게 함
      }

      // 중복되지 않으면, 회원가입 처리
      memberService.register(member);
      return "redirect:/member/login"; // 회원가입 후 로그인 페이지로 리다이렉트
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

           // 최신순 정렬 후 X개만
           latestNews = latestNews.stream()
                                  .sorted((a,b) -> b.get("pubDate").compareTo(a.get("pubDate")))
                                  .limit(100)
                                  .collect(Collectors.toList());

           session.setAttribute("latestNews", latestNews);

           return "redirect:/main"; // 메인 페이지
       } else {
           model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
           return "member/login";
       }
   }


   // 로그아웃 처리
   @GetMapping("/logout")
   public String logout(HttpSession session) {
      session.invalidate(); // 세션 초기화
      return "redirect:/main"; // 홈으로 이동
   }

   // 회원가입 중복 검사 후, 알림 띄우기
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


//   마이페이지 띄우기
   @RequestMapping("/mypage")
   public String mypage(HttpSession session, Model model) {
      String id = (String) session.getAttribute("id"); // 로그인세션에서 id 추출
      MemberDTO user = memberService.myDTO(id); // 내 정보객체 생성
      model.addAttribute("user", user); // user를 view로 보냄
      return "member/mypage";
   }

//   마이페이지 수정모달 비밀번호 체크 
   @PostMapping("/mypage_pass")
   public String checkPass(@RequestParam String id, @RequestParam String password, Model model) {
      MemberDTO user = memberService.myDTO(id);
      System.out.println("비번체크comtroller");
      if (!memberService.checkPassword(id, password)) {
         model.addAttribute("passFail", true);
         System.out.println("비번실패");
         model.addAttribute("user", user);
         return "member/mypage";
      }
      model.addAttribute("user", user);
      System.out.println("비번체크성공");

      return "member/userupdate";
   }

   // 관리자 회원관리 전체 리스트
   @RequestMapping("/members")
   public String members(@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
                    Model model){
      
      int limit = 15;   // 페이지당 목록 수
      int offset = (currentPage -1) * limit;
      
      // 검색조건 Map int형 따로 분리 object에서 안들어감
      Map<String,Object> params = new HashMap<>();
      params.put("limit", Integer.valueOf(limit));
      params.put("offset", Integer.valueOf(offset));
      
      
      int totalCount = memberService.memberCount(); // 총 회원 수
      List<MemberDTO> list = memberService.allList(params); // 전체회원 목록
      int searchMembersCount = memberService.searchMembersCount(params); // 검색 회원 수
      
      int totalPages = totalCount / limit;   // 정수 나눗셈 = 자동 소수점 버림
       if(totalCount % limit != 0) {         // 나머지가 있으면 한 페이지 추가
           totalPages += 1;
       }
       
      if(currentPage > totalPages) currentPage = totalPages;
      if(currentPage < 1) currentPage = 1; 
      

      model.addAttribute("list", list);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("searchCount", totalCount);   // 검색카운트
      model.addAttribute("currentPage", currentPage);
      model.addAttribute("totalPages", totalPages);
      model.addAttribute("limit", limit);
      
      return "admin/members";
   }

   // 관리자 회원검색 리스트
   @RequestMapping("/members_search")
   public String searchMembers(@RequestParam Map<String, Object> params, // 모든 파라미터를 한
                        @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
                        Model model) {
      
      //2. 검색 필터조건 Map 에 넣어 서비스로 보내기
      int limit = 15;   // 페이지당 목록 수
      int offset = (currentPage -1) * limit; 
      
      // 검색조건 Map int형 따로 분리 object에서 안들어감
      params.put("limit", Integer.valueOf(limit));
      params.put("offset", Integer.valueOf(offset));
      
      
//      List<MemberDTO> list= memberService.searchMembers(searchType, searchValue); // 이전꺼
      List<MemberDTO> list= memberService.searchMembers(params);   //검색 회원 목록

      int totalCount = memberService.memberCount();   // 총 회원수
      int searchMembersCount = memberService.searchMembersCount(params); // 검색 회원 수
      int totalPage = (int) Math.ceil((double) searchMembersCount / limit);   // 총페이지수 계산

      model.addAttribute("list", list);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("searchCount", searchMembersCount);
      model.addAttribute("params", params);
      model.addAttribute("currentPage", currentPage);
      model.addAttribute("totalPage", totalPage);

      return "admin/members";

   }

   // 회원정보 수정 페이지 내용 삽입
   @PostMapping("/userupdate")
   public String userupdate(MemberDTO member, Model model) {
      memberService.userupdate(member); // 수정 처리
      model.addAttribute("user", memberService.selectone(member.getId()));
      return "member/mypage";
   }

   // 관리자 회원정보 수정 페이지 내용 삽입
   @PostMapping(value = "/adminupdate")
   public String adminupdate(@RequestParam("id") String id, Model model) {
       MemberDTO list = memberService.selectone(id);
        model.addAttribute("user", list);  
        return "admin/adminupdate";  
   }

   // 회원 정보 수정
//   @PostMapping(value = "/userupdate_ok")
//   public String userupdate(@ModelAttribute MemberDTO update) {
//      memberService.userupdate(update);
//        return "redirect:/";  
//   }
   
   // 관리자 회원 정보 수정
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

   // 회원 탈퇴 요청
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
   
   //회원 계정 활성화
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
   
   // 관리자 회원상세조회 체이지
   @GetMapping("/detail")
   public String detail(@RequestParam("id") String id, Model model) {
      MemberDTO user = memberService.selectone(id);
      model.addAttribute("user", user);
      return "admin/detail";
      
   }
   

}