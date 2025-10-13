package kr.co.dong.deal;

import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class DealSummaryService {

    @Inject
    private DealSummaryDAO dao;

    public boolean saveIfNotExists(DealSummaryDTO dto) {
        if (dto == null) return false;

        // 1. URL 중복 체크
        if (dto.getUrl() != null && dao.existsByUrl(dto.getUrl())) {
            System.out.println("⏩ 이미 존재(URL): " + dto.getTitle());
            return false;
        }

        // 2. 제목 전처리 및 토큰화 (cleanedTitle은 여기서 선언되어 사용 가능)
        String cleanedTitle = TitleSimilarityUtil.preprocessTitle(dto.getTitle());
        List<String> allTokens = cleanedTitle.isBlank() ?
                Collections.emptyList() :
                Arrays.asList(cleanedTitle.split("\\s+"));

        // 한 글자 토큰 제거, 상위 3개만 사용
        List<String> tokens = allTokens.stream()
                .filter(t -> t != null && t.length() > 1)
                .limit(3)
                .collect(Collectors.toList());

        // 3. 토큰이 없으면 후보군 검색 불필요 — 바로 저장
        if (tokens.isEmpty()) {
            dao.insertDeal(dto);
            System.out.println("✅ 저장 성공(토큰 없음): " + dto.getTitle());
            return true;
        }

        // 4. 후보군 조회 (Map 파라미터)
        Map<String, Object> params = new HashMap<>();
        params.put("tokens", tokens);
        List<DealSummaryDTO> candidates = dao.findDealsByTokens(params);

        // 5. 후보군에서 코사인 유사도 검사 (TitleSimilarityUtil, 기준 0.9)
        for (DealSummaryDTO existing : candidates) {
            if (TitleSimilarityUtil.isSameProduct(dto.getTitle(), existing.getTitle())) {
                System.out.println("⏩ 이미 존재(제목 유사): " + dto.getTitle());
                return false; // 중복이면 저장하지 않음
            }
        }

        // 6. 최종 저장
        dao.insertDeal(dto);
        System.out.println("✅ 저장 성공: " + dto.getTitle());
        return true;
    }

    public List<DealSummaryDTO> getDealsByKeyword(String keyword) {
        return dao.findDealsByKeyword("%" + keyword + "%");
    }
    
    public int deleteOldDeals() {
        return dao.deleteOlderThan7Days();
    }
}
