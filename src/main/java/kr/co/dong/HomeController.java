package kr.co.dong;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		logger.info("정신차려 이친구야~~~~`");
		logger.info("import->git->clone URI->주소지정");
		logger.info("니가넣어");
		
		return "home";
	}
	@GetMapping(value = "/Update")
	public String Update() {
		return "Update";
		
	}
	@PostMapping(value = "/Update")
	public String selectonePost(@RequestParam("id") String id, Model model) {
	     DTO list = service.selectone(id);
	     model.addAttribute("user", list);  
	     return "Update";  
	}
	
	@PostMapping(value = "/userupdate")
	public String userdelete(@ModelAttribute DTO update) {
		 service.update(update);
	     return "redirect:/Update";  
	}
	
	@PostMapping(value = "/adminupdate")
	public String admindelete(@ModelAttribute DTO update) {
		 service.update(update);
	     return "redirect:/Update";  
	}
	
	@PostMapping("/user/delete")
	public String delete(@RequestParam("id") String id) {
		 service.delete(id);
	     return "redirect:/Update";  
	}
	
	
}
