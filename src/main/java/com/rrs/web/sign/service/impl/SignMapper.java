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
	int idChk(String id) throws Exception;
	int memberChk(SignVO paramSignVo) throws Exception;
	String findId(SignVO paramSignVo) throws Exception;
	String findPw(SignVO paramSignVo) throws Exception;
	void resetPw(SignVO paramSignVo) throws Exception;
	int userChk(SignVO paramSignVo) throws Exception;
	void changeInfo(SignVO paramSignVo) throws Exception;
	int userOut(String id) throws Exception;
	
	// 로그인 유지 처리
	int keepLogin(Map<String, Object> paramMap) throws Exception;
	
	//세션키 검증
	SignVO checkUserWithSessionKey(String sessionId) throws Exception;
	
	//관리자 여부 확인
	String isAdminYn(String userId) throws Exception;
}
