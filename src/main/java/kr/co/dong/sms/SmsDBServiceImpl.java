package kr.co.dong.sms;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.dong.UserKeyword.UserKeywordDAO;
import kr.co.dong.member.MemberDAO;
import kr.co.dong.deal.DealSummaryDAO;
import kr.co.dong.sms.SmsDTO;

import java.util.List;
import java.util.Map;

@Service
public class SmsDBServiceImpl implements SmsDBService {

	private static final Logger log = LoggerFactory.getLogger(SmsDBServiceImpl.class);
	
    @Autowired
    private final SmsApiService smsApiService;
    private final UserKeywordDAO userKeywordMapper;
    private final MemberDAO memberMapper;
    private final DealSummaryDAO dealSummaryMapper;

    public SmsDBServiceImpl(SmsApiService smsApiService,
                            UserKeywordDAO userKeywordMapper,
                            MemberDAO memberMapper,
                            DealSummaryDAO dealSummaryMapper) {
        this.smsApiService = smsApiService;
        this.userKeywordMapper = userKeywordMapper;
        this.memberMapper = memberMapper;
        this.dealSummaryMapper = dealSummaryMapper;
    }

    @Override
    public void processDeals() {
        // deal_summary 테이블에서 전체 거래 가져오기
        List<SmsDTO> deals = dealSummaryMapper.findAllDeals();
        log.info("📦 불러온 deal 개수 = " + deals.size());

        for (SmsDTO deal : deals) {
        	log.info("👉 처리 중 dealId=" + deal.getDealId() + ", title=" + deal.getTitle());

            // 🔎 키워드 매칭 결과 → userId + keyword 함께 가져오기
            List<SmsDTO> matchedUsers = userKeywordMapper.findMatchingUsers(deal.getTitle());
            log.info("🔎 매칭된 유저 수 = " + matchedUsers.size());

            if (matchedUsers == null || matchedUsers.isEmpty()) {
                continue;
            }

            for (SmsDTO matched : matchedUsers) {
                String userId = matched.getUserId();
                String keyword = matched.getKeyword();

                SmsDTO user = memberMapper.findUserById(userId);
                if (user == null || user.getPhone() == null) {
                	log.warn("⚠️ 유저 " + userId + " 의 전화번호 없음 → 스킵");
                    continue;
                }

                // keyword 추가된 dto 생성
                SmsDTO dto = new SmsDTO(
                    userId,
                    user.getPhone(),
                    deal.getTitle(),
                    deal.getUrl(),
                    deal.getDealId()
                );
                dto.setKeyword(keyword); // ✅ 키워드 포함

                Map<String, Object> result = smsApiService.sendSms(dto);
                log.info("📨 전송 결과: user=" + userId + ", keyword=" + keyword + " => " + result);
            }
        }
    }
}
