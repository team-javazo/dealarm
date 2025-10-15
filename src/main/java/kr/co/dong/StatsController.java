package kr.co.dong;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.dong.click.ClickDTO;
import kr.co.dong.click.ClickService;

@Controller
public class StatsController {
	
	@Autowired
	private ClickService clickService;
	
	// 통계페이지 이동
	@GetMapping("/stats")
	public String stats() {
		return "admin/stats"; 
	}
	
	// 통계 데이터 반환
	@GetMapping("statsData")
	@ResponseBody
	public Map<String, Object> statsData(){
		Map<String, Object> params = new HashMap<>();
		params.put("startDate", "2025-10-01");
		params.put("endDate", "2025-10-15");
		
		List<ClickDTO> list = clickService.keywordStats(params);
		
		
		Map<String, Object> result = new HashMap<>();
		result.put("data", list);
		return result;
		
	}
	
	

}
