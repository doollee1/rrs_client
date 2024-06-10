package com.rrs.web.sign.service.impl;

import java.security.SecureRandom;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.rrs.web.sign.service.SignService;
import com.rrs.web.sign.service.impl.SignMapper;
import com.rrs.web.sign.service.impl.SignServiceImpl;
import com.rrs.web.sign.service.vo.SignVO;

@Service("signService")
public class SignServiceImpl implements SignService {
	
	private static final Logger logger = LoggerFactory.getLogger(SignServiceImpl.class);
			
	@Resource(name = "signMapper")
	private SignMapper signMapper;
	
	public int deviceInfoIns(Map<String, Object> map) throws Exception {
		return signMapper.deviceInfoIns( map );
	}
	// 로그인
	public SignVO signIn(SignVO vo) throws Exception {
		return this.signMapper.signIn(vo);
	}
	// 회원가입
	public int signUp(SignVO vo) throws Exception {
		return this.signMapper.signUp(vo);
	}
	// 아이디 중복체크 - 회원가입
	public int idChk(String id) throws Exception {
		return this.signMapper.idChk(id);
	}
	// 멤버 확인 - 회원가입
	public int memberChk(SignVO vo) throws Exception {
		return this.signMapper.memberChk(vo);
	}
	// 아이디 찾기
	public String findId(SignVO vo) throws Exception {
		return this.signMapper.findId(vo);
	}
	// 비밀번호 찾기
	public String findPw(SignVO vo) throws Exception {
		return this.signMapper.findPw(vo);
	}
	// 비밀번호 초기화
	public void resetPw(SignVO vo) throws Exception {
		this.signMapper.resetPw(vo);
	}
	// 아이디, 비밀번호 체크
	public int userChk(SignVO vo) throws Exception {
		return this.signMapper.userChk(vo);
	}
	// 개인정보변경
	public void changeInfo(SignVO vo) throws Exception {
		this.signMapper.changeInfo(vo);
	}
	/** 랜덤 비밀번호 생성
	 * @param (int) size : 자리수
	 * @return
	 */
	public String getRandomPassword(int size) {
		char[] charSet = new char[] {
			'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
			'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
			'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
			'!', '@', '#', '$', '%', '^', '&' 
		};
		StringBuffer sb = new StringBuffer();
		SecureRandom sr = new SecureRandom();
		sr.setSeed(new Date().getTime());
		int idx = 0;
		int len = charSet.length;
		for (int i=0; i<size; i++) {
			idx = sr.nextInt(len);
			sb.append(charSet[idx]);
		}
		return sb.toString();
	}
	
	public int userOut(String id) throws Exception {
		return this.signMapper.userOut(id);
	}
	
	
	/**
	 * 로그인 유지
	 */
	@Override
	public int keepLogin(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		logger.info("======== 로그인유지 서비스 ========");
		
		return this.signMapper.keepLogin(paramMap);
	}
	
	
	/**
	 * 세션키 검증
	 */
	@Override
	public SignVO checkUserWithSessionKey(String sessionId) throws Exception {
		// TODO Auto-generated method stub
		logger.info("======== 세션키검증 서비스 ========");
		
		return this.signMapper.checkUserWithSessionKey(sessionId);
	}
	
	/**
	 * 관리자 여부 확인
	 */
	@Override
	public String isAdminYn(String userId) throws Exception {
		// TODO Auto-generated method stub
		logger.info("======== 관리자여부확인 서비스 ========");
		
		return this.signMapper.isAdminYn(userId);
	}
	
}
