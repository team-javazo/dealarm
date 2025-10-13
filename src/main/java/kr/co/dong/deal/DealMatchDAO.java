package kr.co.dong.deal;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface DealMatchDAO {
    List<DealMatchDTO> dealMatch(@Param("uid") String uid,
            @Param("offset") int offset,
            @Param("limit") int limit);
    
    int deleteDeal(@Param("matchId") Integer matchId, @Param("userId") String userId);	

	List<DealMatchDTO> newDeal(Map<String, Object> params);
	
	
	
	
}