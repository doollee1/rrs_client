package com.rrs.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
public class MobileController {
	
	private static final Logger logger = LoggerFactory.getLogger(MobileController.class);
	
	//Login
	@RequestMapping(value = "/go_MLogin.do", method = RequestMethod.GET) 
	public String Login () throws Exception {
		//return "m_Login";
		return "Login";
	}
	

}
