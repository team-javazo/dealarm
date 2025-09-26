package kr.co.dong.sms.service;

import java.util.Map;
import kr.co.dong.sms.dto.SmsDTO;

//SMS 발송 서비스 인터페이스
public interface SmsApiService {
	// SMS 발송 요청을 처리하는 메소드
    // 파라미터: SmsDTO (userId, phone, title, url, dealId 포함)
    // 반환값: 실행 결과(JSON 형태 -> Map 변환)
    Map<String, Object> sendSms(SmsDTO dto);
}