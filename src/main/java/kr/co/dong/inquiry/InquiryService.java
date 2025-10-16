package kr.co.dong.inquiry;

import java.util.List;

public interface InquiryService {
    void insert(InquiryDTO dto);
    List<InquiryDTO> list();
    InquiryDTO detail(int id);
    void updateHit(int id);
    void updateStatus(int id, String status);
    void insertAnswer(int id, String answer);
}
