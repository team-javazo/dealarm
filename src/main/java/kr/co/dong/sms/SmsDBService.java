package kr.co.dong.sms;

import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
public class SmsDBService {

    private final SmsApiService smsApiService;
    private final DealSummaryDAO dealMapper;
    private final UserKeywordDAO keywordMapper;
    private final UserDAO userMapper;

    public SmsDBService(SmsApiService smsApiService,
                        DealSummaryDAO dealMapper,
                        UserKeywordDAO keywordMapper,
                        UserDAO userMapper) {
        this.smsApiService = smsApiService;
        this.dealMapper = dealMapper;
        this.keywordMapper = keywordMapper;
        this.userMapper = userMapper;
    }

    // 스케줄러에서 이 메서드를 호출하면 됨
    public void processDeals() {
        List<DealSummaryDTO> deals = dealMapper.findUnnotifiedDeals();

        for (DealSummaryDTO deal : deals) {
            // title과 매칭되는 userId 찾기
            List<String> userIds = keywordMapper.findMatchingUsers(deal.getTitle());

            for (String userId : userIds) {
                UserDTO user = userMapper.findUserById(userId);
                if (user == null) continue;
                if (user.getNotification() != 1) continue; // 알림 꺼둔 유저 제외

                // Python API에 전송할 DTO
                SmsDTO dto = new SmsDTO(
                    user.getuserId(),
                    user.getPhone(),
                    deal.getUrl(),
                    deal.getTitle()
                );

                Map<String, Object> result = smsApiService.sendSms(dto);
                System.out.println("📨 전송 결과: user=" + userId + ", deal=" + deal.getuserId() + " => " + result);
            }

            // deal 은 전송 시도 후 notified=1로 마킹
            dealMapper.markAsNotified(deal.getuserId());
        }
    }
}
