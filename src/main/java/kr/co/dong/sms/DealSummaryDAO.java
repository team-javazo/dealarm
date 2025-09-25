package kr.co.dong.sms;
import java.util.List;

public interface DealSummaryDAO {
    List<DealSummaryDTO> findUnnotifiedDeals();
    void markAsNotified(String userId);
}
