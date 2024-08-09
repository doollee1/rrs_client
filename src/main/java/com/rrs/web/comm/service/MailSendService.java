package com.rrs.web.comm.service;

import java.util.*;

import org.apache.commons.mail.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("mailSendService")
public class MailSendService {
	
	private static final Logger logger = LoggerFactory.getLogger(MailSendService.class);
			
	@Autowired
	private Properties properties;

	/**
	 * Send Mail
	 * @param map
	 * @return boolean
	 * @exception Exception
	 */
	/*
	public boolean sendMail(Map<String, Object> param) throws Exception {
		try {
			Email email = new SimpleEmail();
			email.setHostName(properties.getProperty("EMAIL.HOST"));
			email.setSmtpPort(Integer.parseInt(properties.getProperty("EMAIL.PORT")));
			email.setSslSmtpPort(properties.getProperty("EMAIL.PORT"));
			email.setAuthenticator(new DefaultAuthenticator(properties.getProperty("EMAIL.FROM"), properties.getProperty("EMAIL.PASSWORD")));
			email.setSSLOnConnect(true);
			email.setFrom(properties.getProperty("EMAIL.FROM"));
			email.setSubject("TestMail");
			email.setMsg("This is a test mail ...");
			email.addTo("dev@doollee.com");
			email.send();
		} catch (EmailException  ex) {
			System.err.println("System Exception ::::: " + ex.getMessage());
			return false;
		}
		return true;
	}
	*/
	/**
	 * 이메일 발송 - 이민구
	 * @param map
	 * 		"to"		: 수신자
	 * 		"title" 	: 이메일 제목
	 * 		"content"	: 이메일 내용
	 * @return boolean
	 * @exception Exception
	 */
	public boolean sendMail(Map<String, Object> param) throws Exception {
		try {
			Email email = new SimpleEmail();
			email.setCharset("euc-kr");// 한글 인코딩
			email.setHostName(properties.getProperty("EMAIL.HOST"));
			email.setSmtpPort(Integer.parseInt(properties.getProperty("EMAIL.PORT")));
			email.setSslSmtpPort(properties.getProperty("EMAIL.PORT"));
			email.setAuthenticator(new DefaultAuthenticator(properties.getProperty("EMAIL.FROM"), properties.getProperty("EMAIL.PASSWORD")));
			email.setSSLOnConnect(true);
			email.setFrom(properties.getProperty("EMAIL.FROM"));
			email.setSubject((String) param.get("title"));
			email.setMsg((String) param.get("content"));
			email.addTo((String) param.get("to"));
			email.send();
		} catch (EmailException  ex) {
			
			logger.info("EmailException ::::: " + ex.getMessage());
			ex.printStackTrace();
			
			return false;
		}
		return true;
	}

	
}
