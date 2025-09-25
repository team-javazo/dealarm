package kr.co.dong.sms.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.dong.sms.dto.UserDTO;

@Mapper
@Repository
public interface UserDAO {
    UserDTO findUserById(@Param("id") String userId);
}
