package com.rrs.web.comm.controller;

import java.util.*;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rrs.web.comm.service.MailSendService;

@Controller
public class MailController {
	@Resource(name = "mailSendService")
	private MailSendService mailSendService;

	/**
	 * Send mail
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/comm/sendMail.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> SendMail(@RequestParam Map<String, Object> map) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("result", mailSendService.sendMail(map) );
		return rMap;
	}
}
