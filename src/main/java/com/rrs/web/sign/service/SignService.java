package com.rrs.web.sign.service;

import java.util.Map;

import com.rrs.web.sign.service.vo.SignVO;

public interface SignService {
	
	int deviceInfoIns(Map<String, Object> paramMap) throws Exception;
	SignVO signIn(SignVO paramSignVo) throws Exception;	
	int signUp(SignVO paramSignVo) throws Exception;
	int idChk(String id) throws Exception;
	int memberChk(SignVO paramSignVo) throws Exception;
	String findId(SignVO vo) throws Exception;
	String findPw(SignVO vo) throws Exception;
	void resetPw(SignVO vo) throws Exception;
	int userChk(SignVO vo) throws Exception;
	void changeInfo(SignVO vo) throws Exception;
	public String getRamdomPassword(int size) throws Exception;
}
