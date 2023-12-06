package com.rrs.web.notice.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.rrs.web.notice.service.NoticeService;
import com.rrs.web.notice.service.vo.NoticeVO;

@Service("noticeService")
public class NoticeServiceImpl implements NoticeService {
	@Resource(name = "noticeMapper")
	private NoticeMapper noticeMapper;
	
	public int noticeListCnt() throws Exception {
		return noticeMapper.noticeListCnt();
	}
	public List<Map<String, Object>> noticeList(Map<String, Object> map) throws Exception {
		return noticeMapper.noticeList(map);
	}
	public NoticeVO noticeView(String notice_seq) throws Exception {
		return noticeMapper.noticeView(notice_seq);
	}
}
