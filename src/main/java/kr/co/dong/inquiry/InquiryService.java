package kr.co.dong.inquiry;

import java.util.List;
import java.util.Map;

public interface InquiryService {
    void insert(InquiryDTO dto);
    List<InquiryDTO> list();  // 기본 목록
    InquiryDTO detail(int id);
    void updateHit(int id);
    void update(InquiryDTO dto);
    void delete(int id);
    void updateStatus(int id, String status);
    void insertAnswer(int id, String answer);

    // ✅ 추가 기능
    List<InquiryDTO> search(String keyword);
    List<InquiryDTO> listByCategory(String category);

    // ✅ 페이징 + 검색
    List<InquiryDTO> list(int page, String keyword);
    int getTotalPages(String keyword);

    // ✅ 마이페이지 & 통계
    List<InquiryDTO> listByWriter(String writer);
    Map<String, Integer> getStats();
}
