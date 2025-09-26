package kr.co.dong.sms.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.dong.sms.dto.UserDTO;

@Mapper
@Repository
public interface UserDAO {
	// userId 기준으로 사용자 정보를 조회
    // (전화번호, 알림 설정 상태 등 가져오기 위해 사용)
    UserDTO findUserById(@Param("id") String userId);
}
