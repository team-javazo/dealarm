package kr.co.dong;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalControllerAdvice {
	
	@ModelAttribute("serverTime")
	public String serverTime(Locale locale) {
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getTimeInstance(DateFormat.LONG, locale);
		
		return dateFormat.format(date);
		
	}

}
