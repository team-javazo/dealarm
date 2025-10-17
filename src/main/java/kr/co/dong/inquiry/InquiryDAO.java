package kr.co.dong.inquiry;

import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface InquiryDAO {
    void insert(InquiryDTO dto);
    List<InquiryDTO> list();
    InquiryDTO detail(@Param("id") int id);
    void updateHit(@Param("id") int id);
    void updateStatus(@Param("id") int id, @Param("status") String status);
    void insertAnswer(@Param("id") int id, @Param("answer") String answer);
}
