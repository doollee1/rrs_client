package com.rrs.web.comm.service;

import java.util.*;

import org.apache.commons.mail.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("mailSendService")
public class MailSendService {
	
	@Autowired
	private Properties properties;

	/**
	 * Send Mail
	 * @param map
	 * @return boolean
	 * @exception Exception
	 */
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

	
}
