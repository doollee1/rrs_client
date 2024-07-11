package com.rrs.web.comm.service;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

public interface CommonService {
	
	
	/**
	 * 공통코드 목록조회
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> commCodeList(Map<String, Object> paramMap) throws Exception;

	
	/**
	 * 텔리그램 전송
	 * 
	 * @param msg
	 * @return
	 */
	String telegramMsgSend(String msg);

	
	/**
	 * 이미지 업로드
	 * 
	 * @param image
	 * @return
	 */
	Map<String, Object> imageUpload(MultipartFile image);
	
	
	/**
	 * 클라이언트IP 확인
	 * 
	 * @param request
	 * @return
	 */
	String getClientIP(HttpServletRequest request);
		
}
