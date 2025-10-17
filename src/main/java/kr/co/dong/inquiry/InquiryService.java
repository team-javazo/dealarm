package kr.co.dong.inquiry;

import java.util.List;

public interface InquiryService {
    List<InquiryDTO> list();
    InquiryDTO detail(int id);
    void insert(InquiryDTO dto);
    void update(InquiryDTO dto);
    void updateHit(int id);
    void insertAnswer(InquiryDTO dto);
    void updateStatus(InquiryDTO dto);
    void delete(int id);
}
