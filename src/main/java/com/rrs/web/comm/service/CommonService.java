package com.rrs.web.comm.service;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

public interface CommonService {
	
	
	/**
	 * �����ڵ� �����ȸ
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> commCodeList(Map<String, Object> paramMap) throws Exception;

	
	/**
	 * �ڸ��׷� ����
	 * 
	 * @param msg
	 * @return
	 */
	String telegramMsgSend(String msg);

	
	/**
	 * �̹��� ���ε�
	 * 
	 * @param image
	 * @return
	 */
	Map<String, Object> imageUpload(MultipartFile image);
	
	
	/**
	 * Ŭ���̾�ƮIP Ȯ��
	 * 
	 * @param request
	 * @return
	 */
	String getClientIP(HttpServletRequest request);
		
}
