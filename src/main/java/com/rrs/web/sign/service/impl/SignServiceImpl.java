package com.rrs.web.sign.service.impl;

import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.rrs.web.sign.service.SignService;
import com.rrs.web.sign.service.impl.SignMapper;
import com.rrs.web.sign.service.impl.SignServiceImpl;
import com.rrs.web.sign.service.vo.SignVO;

@Service("signService")
public class SignServiceImpl implements SignService {
	@Resource(name = "signMapper")
	private SignMapper signMapper;
	
	public int deviceInfoIns(Map<String, Object> map) throws Exception {
		return signMapper.deviceInfoIns( map );
	}
	
	public SignVO signIn(SignVO vo) throws Exception {
		return this.signMapper.signIn(vo);
	}
	
	public int signUp(SignVO vo) throws Exception {
		return this.signMapper.signUp(vo);
	}
	
	public int idChk(String id) throws Exception {
		return this.signMapper.idChk(id);
	}
	
	public int memberChk(SignVO vo) throws Exception {
		return this.signMapper.memberChk(vo);
	}
	
	public String findId(SignVO vo) throws Exception {
		return this.signMapper.findId(vo);
	}
	public String findPw(SignVO vo) throws Exception {
		return this.signMapper.findPw(vo);
	}
	public void resetPw(SignVO vo) throws Exception {
		this.signMapper.resetPw(vo);
	}
	public void changePw(SignVO vo) throws Exception {
		this.signMapper.changePw(vo);
	}
}
