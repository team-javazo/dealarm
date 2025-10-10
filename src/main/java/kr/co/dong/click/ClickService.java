package kr.co.dong.click;

import kr.co.dong.sms.SmsDTO;
import org.springframework.transaction.annotation.Transactional;

public interface ClickService {

    String createOrGetTrackingUrl(SmsDTO dto);

    /**
     * 고유 ID에 해당하는 링크의 클릭 수를 1 증가시키고,
     * 클릭 히스토리를 기록한 후, 실제 상품 URL을 반환합니다.
     */
    // 💡 이 부분이 구현체와 일치하도록 수정되어야 합니다.
    String increaseClickCountAndGetUrl(String uniqueId) throws Exception; 
}