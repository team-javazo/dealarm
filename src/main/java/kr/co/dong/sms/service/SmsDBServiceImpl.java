package kr.co.dong.sms.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

import kr.co.dong.UserKeyword.UserKeywordDAO;
import kr.co.dong.sms.dao.DealSummaryDAO;
import kr.co.dong.sms.dao.UserDAO;
import kr.co.dong.sms.dao.UserKeywordsmsDAO;
import kr.co.dong.sms.dto.DealSummaryDTO;
import kr.co.dong.sms.dto.SmsDTO;
import kr.co.dong.sms.dto.UserDTO;

@Service
public class SmsDBServiceImpl implements SmsDBService {

	@Autowired
    private final SmsApiService smsApiService;
    private final DealSummaryDAO dealMapper;
    private final UserKeywordsmsDAO keywordMapper;
    private final UserDAO userMapper;

    public SmsDBServiceImpl(SmsApiService smsApiService,
                            DealSummaryDAO dealMapper,
                            UserKeywordsmsDAO keywordMapper,
                            UserDAO userMapper) {
        this.smsApiService = smsApiService;
        this.dealMapper = dealMapper;
        this.keywordMapper = keywordMapper;
        this.userMapper = userMapper;
    }

    @Override
    public void processDeals() {
        List<DealSummaryDTO> deals = dealMapper.findUnnotifiedDeals();
        if (deals == null || deals.isEmpty()) {
            return;
        }

        for (DealSummaryDTO deal : deals) {
            // 1) 제목 기반으로 키워드 매칭되는 유저 찾기
            List<String> matchedUserIds = keywordMapper.findMatchingUsers(deal.getTitle());
            if (matchedUserIds == null || matchedUserIds.isEmpty()) {
                continue;
            }

            for (String userId : matchedUserIds) {
                UserDTO user = userMapper.findUserById(userId);
                if (user == null || user.getPhone() == null) {
                    continue;
                }

                SmsDTO dto = new SmsDTO(
                    userId,
                    user.getPhone(),
                    deal.getTitle(),
                    deal.getUrl()
                );

                Map<String, Object> result = smsApiService.sendSms(dto);
                System.out.println("📨 전송 결과: user=" + userId + ", dealUser=" + deal.getUserId() + " => " + result);
            }

            // 2) 해당 userId의 deal들을 notified=1로 마킹 (userId 기준)
            if (deal.getUserId() != null) {
                dealMapper.markAsNotified(deal.getUserId());
            }
        }
    }
}
