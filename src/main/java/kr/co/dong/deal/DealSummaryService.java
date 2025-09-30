package kr.co.dong.deal;

import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.List;

@Service
public class DealSummaryService {

    @Inject
    private DealSummaryDAO dao;

    // DB 저장 시 중복 방지 (URL → 제목+판매처)
    public void saveIfNotExists(DealSummaryDTO dto) {
        // 1. URL 중복 체크
        if (dao.existsByUrl(dto.getUrl())) {
            System.out.println("⏩ 이미 존재(URL): " + dto.getTitle());
            return;
        }

        // 2. 기존 데이터 중 비슷한 제목 있는지 확인
        //    (키워드 검색: 제목 첫 단어 기준, 필요시 최근 N개로 최적화 가능)
        String firstWord = dto.getTitle().split(" ")[0];
        List<DealSummaryDTO> candidates = dao.findDealsByKeyword("%" + firstWord + "%");

        for (DealSummaryDTO existing : candidates) {
            boolean sameSite = dto.getSite() != null &&
                               existing.getSite() != null &&
                               dto.getSite().equalsIgnoreCase(existing.getSite());

            if (TitleSimilarityUtil.isSameProduct(dto.getTitle(), existing.getTitle(), sameSite)) {
                System.out.println("⏩ 이미 존재(제목+판매처): " + dto.getTitle());
                return;
            }
        }

        // 3. 최종 저장
        dao.insertDeal(dto);
        System.out.println("✅ 저장 성공: " + dto.getTitle());
    }

    public List<DealSummaryDTO> getDealsByKeyword(String keyword) {
        return dao.findDealsByKeyword("%" + keyword + "%");
    }
}
