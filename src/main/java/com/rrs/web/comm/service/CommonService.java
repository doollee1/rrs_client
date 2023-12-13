package com.rrs.web.comm.service;

import java.util.*;

public interface CommonService {
	List<Map<String, Object>> commCodeList(Map<String, Object> paramMap) throws Exception;

	void telegramMsgSend(String msg);
}
