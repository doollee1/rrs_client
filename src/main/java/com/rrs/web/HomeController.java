package com.rrs.web;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.rrs.web.HomeController;

@Controller
public class HomeController {
  private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
  
  @RequestMapping({"/main.do"})
  public String main(Locale locale, Model model) {
    logger.info("Welcome home! The client locale is {}@@@.", locale);
    Date date = new Date();
    DateFormat dateFormat = DateFormat.getDateTimeInstance(1, 1, locale);
    String formattedDate = dateFormat.format(date);
    model.addAttribute("serverTime", formattedDate);
    return "main";
  }
}
