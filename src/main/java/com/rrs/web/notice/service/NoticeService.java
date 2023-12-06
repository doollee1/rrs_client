package com.rrs.web.notice.service;

import java.util.List;
import java.util.Map;

import com.rrs.web.notice.service.vo.NoticeVO;


public interface NoticeService {
	int noticeListCnt() throws Exception;
	List<Map<String, Object>> noticeList(Map<String, Object> map) throws Exception;
	NoticeVO noticeView(String notice_seq) throws Exception;
}
