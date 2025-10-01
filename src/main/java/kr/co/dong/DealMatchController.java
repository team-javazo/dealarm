package kr.co.dong;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.co.dong.deal.DealMatchDTO;
import kr.co.dong.deal.DealMatchService;
import kr.co.dong.deal.DealSummaryDTO;

@Controller
public class DealMatchController {

    @Autowired
    private DealMatchService dealMatchService;
    
    @GetMapping("/")
    public String dealMatch(HttpSession session, Model model) {
    	String userId = (String) session.getAttribute("id");
    	System.out.println(userId);
    	System.out.println("======================================================================================");
    	System.out.println("======================================================================================");
    	System.out.println("======================================================================================");
    	System.out.println("======================================================================================");
    	System.out.println("======================================================================================");
    	System.out.println("======================================================================================");
    	System.out.println("======================================================================================");
    	System.out.println("======================================================================================");
    	List<DealMatchDTO> list = dealMatchService.dealMatch(userId);
    	
    	model.addAttribute("list", list);
		return "/main";
    	
    }
    
    

}
