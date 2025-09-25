package kr.co.dong.sms.dao;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface UserKeywordDAO {
    List<String> findMatchingUsers(@Param("title") String title);
}
