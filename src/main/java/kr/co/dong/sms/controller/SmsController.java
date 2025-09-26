package kr.co.dong.sms.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.co.dong.sms.service.SmsDBService;

@RestController
public class SmsController {

    private final SmsDBService smsDBService;

    // 생성자 주입 (Spring이 SmsDBServiceImpl 빈을 자동으로 넣어줌)
    public SmsController(SmsDBService smsDBService) {
        this.smsDBService = smsDBService;
    }

//    // 강제로 트리거 (예: 수동 실행)
//    @GetMapping("/send-db-sms")
//    public Map<String, String> sendDbSms() {
//        smsDBService.processDeals();
//        return Map.of("status", "processed");
//    }
    /*
     * 수동 실행
     * http://localhost:8080/send-db-sms 접속
     * 브라우저에 json 결과 뜨면 실행된거임
     */
}
