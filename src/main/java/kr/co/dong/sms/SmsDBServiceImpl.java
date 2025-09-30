package kr.co.dong.sms;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.dong.UserKeyword.UserKeywordDAO;
import kr.co.dong.member.MemberDAO;
// ⬇️ MemberDTO 대신 SmsDTO 사용
import kr.co.dong.sms.SmsDTO;

import java.util.List;
import java.util.Map;

@Service
public class SmsDBServiceImpl implements SmsDBService {

    @Autowired
    private final SmsApiService smsApiService;
    private final UserKeywordDAO userKeywordMapper;
    private final MemberDAO memberMapper;

    public SmsDBServiceImpl(SmsApiService smsApiService,
                            UserKeywordDAO userKeywordMapper,
                            MemberDAO memberMapper) {
        this.smsApiService = smsApiService;
        this.userKeywordMapper = userKeywordMapper;
        this.memberMapper = memberMapper;
    }

    @Override
    public void processDeals() {
    	List<SmsDTO> deals = 
    	
        // 1) 키워드 기반으로 매칭되는 유저 찾기 (함수명/변수명은 기존 유지)
        List<String> matchedUserIds = userKeywordMapper.findMatchingUsers(deal.getTitle());
        if (matchedUserIds == null || matchedUserIds.isEmpty()) {
            return;
        }

        for (String userId : matchedUserIds) {
            // ⬇️ DAO 반환 타입도 SmsDTO
            SmsDTO user = memberMapper.findUserById(userId);
            if (user == null || user.getPhone() == null) {
                continue;
            }

            // ⬇️ dealId가 int 이므로 null 불가 → 기본값 사용(0) 또는 실제 dealId 넣기
            SmsDTO dto = new SmsDTO(
                userId,
                user.getPhone(),
                "발송 제목 예시",
                "발송 URL 예시",
                0
            );

            Map<String, Object> result = smsApiService.sendSms(dto);
            System.out.println("📨 전송 결과: user=" + userId + " => " + result);
        }
    }
}
