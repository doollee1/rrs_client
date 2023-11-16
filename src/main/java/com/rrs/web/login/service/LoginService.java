package com.rrs.web.login.service;

import java.util.Map;

import com.rrs.web.login.service.vo.LoginVO;

public interface LoginService {
	
    LoginVO login(LoginVO paramLoginVO) throws Exception;
        
    int deviceInfoIns(Map<String, Object> paramMap) throws Exception;
}
