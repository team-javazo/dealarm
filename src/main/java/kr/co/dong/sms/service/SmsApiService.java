package kr.co.dong.sms.service;

import java.util.Map;
import kr.co.dong.sms.dto.SmsDTO;

public interface SmsApiService {
    Map<String, Object> sendSms(SmsDTO dto);
}