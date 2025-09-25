package kr.co.dong.sms.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.co.dong.sms.service.SmsDBService;
import kr.co.dong.sms.service.SmsDBServiceImpl;

@RestController
public class SmsController {

    private final SmsDBService smsDBService;

    public SmsController(SmsDBService smsDBService) {
        this.smsDBService = smsDBService;
    }

    // 강제로 트리거 (예: 수동 실행)
    @GetMapping("/send-db-sms")
    public Map<String, String> sendDbSms() {
        smsDBService.processDeals();
        return Map.of("status", "processed");
    }
}
