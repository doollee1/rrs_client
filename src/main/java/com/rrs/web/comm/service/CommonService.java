package com.rrs.web.comm.service;

import java.util.*;

import org.springframework.web.multipart.MultipartFile;

public interface CommonService {
	List<Map<String, Object>> commCodeList(Map<String, Object> paramMap) throws Exception;

	void telegramMsgSend(String msg);

	Map<String, Object> imageUpload(MultipartFile image);
}
