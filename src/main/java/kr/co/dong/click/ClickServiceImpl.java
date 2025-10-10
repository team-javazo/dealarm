package kr.co.dong.click;

import kr.co.dong.sms.SmsDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

@Service
public class ClickServiceImpl implements ClickService {

    @Autowired
    private ClickDAO clickDAO;  
    
    // 💡 수정: 외부 접속 가능한 주소와 @GetMapping("/track/{uniqueId}") 경로를 정확히 일치시킵니다.
    // TODO: 'mbc-sw.iptime.org:8080' 등을 실제 주소로 변경하세요.
    private static final String TRACKING_BASE_URL = "http://mbc-sw.iptime.org:8080/dong/track/";

    private String generateUniqueId(String userId, int dealId) {
        String combined = userId + "|" + dealId;
        return Base64.getUrlEncoder().encodeToString(combined.getBytes(StandardCharsets.UTF_8)).replaceAll("=", "");
    }

    @Override
    @Transactional
    public String createOrGetTrackingUrl(SmsDTO dto) {
        String userId = dto.getUserId();
        int dealId = dto.getDealId();
        String actualUrl = dto.getUrl();
        String keyword = dto.getKeyword();

        // 1. 기존 링크 확인 (dealId + userId)
        ClickDTO existingLink = clickDAO.findByDealIdAndUserId(dealId, userId);

        if (existingLink != null) {
            // TRACKING_BASE_URL에 이미 '/'가 있으므로, 바로 uniqueId를 붙입니다.
            return TRACKING_BASE_URL + existingLink.getUniqueId();
        }

        // 3. 새 uniqueId 생성 및 저장
        String uniqueId = generateUniqueId(userId, dealId);
        
        ClickDTO newLink = new ClickDTO(userId, dealId, actualUrl);
        newLink.setUniqueId(uniqueId);
        newLink.setCategory(keyword); 
        
        clickDAO.insertLink(newLink);
        
        // TRACKING_BASE_URL에 이미 '/'가 있으므로, 바로 uniqueId를 붙입니다.
        return TRACKING_BASE_URL + uniqueId;
    }
    // ... increaseClickCountAndGetUrl 메서드는 이전 수정 사항과 동일 ...
    @Override // 인터페이스 메서드를 구현했음을 명시
    @Transactional
    public String increaseClickCountAndGetUrl(String uniqueId) throws Exception {
        
        // 1. 클릭 수 1 증가 (DB 업데이트)
        int updatedRows = clickDAO.increaseClickCount(uniqueId);
        if (updatedRows == 0) {
            // DB 업데이트 실패 시, 링크가 DB에 없음을 의미
            throw new Exception("Link not found: " + uniqueId);
        }
        
        // 2. 업데이트된 정보를 다시 조회하여 실제 URL 및 기록에 필요한 정보 가져오기
        ClickDTO link = clickDAO.findByUniqueId(uniqueId);
        
        if (link == null) {
            throw new Exception("Link data missing after update: " + uniqueId);
        }
        
        // 3. click_history 기록 (dealId, userId, category 사용)
        ClickDTO historyDto = new ClickDTO();
        historyDto.setUserId(link.getUserId());
        historyDto.setDealId(link.getDealId());
        // 조회된 Link 객체에서 category(keyword) 정보를 가져와 사용
        historyDto.setCategory(link.getCategory() != null ? link.getCategory() : "미확인_키워드"); 
        clickDAO.insertClickHistory(historyDto);

        return link.getActualUrl(); // 4. 실제 상품 URL 반환
    }
} // <== 이 닫는 괄호는 클래스의 마지막에 위치해야 합니다.