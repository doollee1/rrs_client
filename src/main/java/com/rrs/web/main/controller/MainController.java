package com.rrs.web.main.controller;

import com.rrs.web.login.service.LoginService;
import com.rrs.web.main.controller.MainController;
import com.rrs.web.main.service.MainService;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class MainController {
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);

	@Resource(name = "mainService")
	MainService mainService;

	@Resource(name = "loginService")
	LoginService loginService;

	@RequestMapping(value = {"/main.do"}, method = {RequestMethod.GET})
	public String main() throws Exception {
		return "main.index";
	}
	
	@RequestMapping(value = {"/main1.do"}, method = {RequestMethod.GET})
	public String main1() throws Exception {
		return "main1.index";
	}
	
	@RequestMapping(value = {"/resortInfo.do"}, method = {RequestMethod.GET})
	public String resortInfo() throws Exception {
		return "resort/resortInfo.view1";
	}
}
