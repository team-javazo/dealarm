package kr.co.dong;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
@Controller
public class ErrorController {

    @RequestMapping("/errorRedirect")
    public String redirectToMain() {
       return "error/405"; // 메인 페이지로 튕기기
    }
}


