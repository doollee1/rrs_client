// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   LoginMapper.java

package com.rrs.web.notice.service.impl;

import java.util.List;
import java.util.Map;

import com.rrs.web.notice.service.vo.NoticeVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("noticeMapper")
public interface NoticeMapper {
	int noticeListCnt() throws Exception;
	List<Map<String, Object>> noticeList(Map<String, Object> map) throws Exception;
	NoticeVO noticeView(String notice_seq) throws Exception;
}
