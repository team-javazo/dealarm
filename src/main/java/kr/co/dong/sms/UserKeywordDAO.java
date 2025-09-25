package kr.co.dong.sms;
import java.util.List;

public interface UserKeywordDAO {
    List<String> findMatchingUsers(String title);
}
