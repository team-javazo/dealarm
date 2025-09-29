package kr.co.dong;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.dong.deal.DealSummaryDTO2;
import kr.co.dong.deal.DealSummaryService;

@Controller
@RequestMapping("/deals")
public class DealSummaryController {
    @Inject
    private DealSummaryService service;

    @GetMapping("/search")
    @ResponseBody // JSON 응답이 필요 없다면 이거 빼도 돼요
    public String search(@RequestParam String keyword) {
        List<DealSummaryDTO2> results = service.getDealsByKeyword(keyword);

        System.out.println("===== 검색 키워드: " + keyword + " =====");
        if (results.isEmpty()) {
            System.out.println("❌ 검색 결과 없음");
        } else {
            results.forEach(deal -> System.out.println("검색 결과: " + deal));
        }
        System.out.println("============================");

        // 웹 응답은 단순 메시지
        return "검색 완료. 콘솔을 확인하세요.";
    }
    
    @GetMapping("/byKeyword")
    @ResponseBody
    public Map<String, Object> getDealsByKeyword(@RequestParam String keyword) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<DealSummaryDTO2> deals = service.getDealsByKeyword(keyword);

            // ✅ 서버 콘솔에 출력
            System.out.println("===== 검색 키워드: " + keyword + " =====");
            if (deals.isEmpty()) {
                System.out.println("❌ 검색 결과 없음");
            } else {
                deals.forEach(d -> System.out.println("검색 결과: " + d));
            }
            System.out.println("============================");

            result.put("success", true);
            result.put("deals", deals);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}
