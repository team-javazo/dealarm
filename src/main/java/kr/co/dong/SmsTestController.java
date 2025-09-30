package kr.co.dong;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.dong.sms.SmsManualService;

@Controller
@RequestMapping("/sms")
public class SmsTestController {

    private final SmsManualService smsManualService;

    public SmsTestController(SmsManualService smsManualService) {
        this.smsManualService = smsManualService;
    }

    // 수동 발송 화면
    @GetMapping("/manualForm")
    public String manualForm() {
    	System.out.println("maualForm 실행됨");
        return "sms/manualForm"; // JSP or Thymeleaf 파일
    }

    // 수동 발송 실행
    @PostMapping("/manualSend")
    public String manualSend(
            @RequestParam String userId,
            @RequestParam String phone,
            @RequestParam String title,
            @RequestParam int dealId,
            @RequestParam(required = false) String url,
            Model model) {

        Map<String, Object> result = smsManualService.sendManualSms(userId, phone, title, url, dealId);
        model.addAttribute("result", result);
        return "sms/manualResult"; // 결과 페이지
    }
}
