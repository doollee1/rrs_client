// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   LoginMapper.java

package com.rrs.web.sign.service.impl;

import java.util.Map;

import com.rrs.web.sign.service.vo.SignVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("signMapper")
public interface SignMapper {
	int deviceInfoIns(Map<String, Object> paramMap) throws Exception;
	SignVO signIn(SignVO paramSignVo) throws Exception;
	int signUp(SignVO paramSignVo) throws Exception;
	SignVO userChk(String id) throws Exception;
	int idChk(String id) throws Exception;
	int memberChk(SignVO paramSignVo) throws Exception;
	String findId(SignVO paramSignVo) throws Exception;
	String findPw(SignVO paramSignVo) throws Exception;
	void resetPw(SignVO paramSignVo) throws Exception;
	void changePw(SignVO paramSignVo) throws Exception;
}
