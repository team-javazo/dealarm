package kr.co.dong.sms;

import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
public class SmsDBController {

    private final SmsDBService smsDBService;

    public SmsDBController(SmsDBService smsDBService) {
        this.smsDBService = smsDBService;
    }

    // 강제로 트리거 (예: 수동 실행)
    @GetMapping("/send-db-sms")
    public Map<String, String> sendDbSms() {
        smsDBService.processDeals();
        return Map.of("status", "processed");
    }
}
