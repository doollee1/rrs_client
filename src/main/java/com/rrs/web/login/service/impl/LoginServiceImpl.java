package com.rrs.web.login.service.impl;

import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.rrs.web.login.service.LoginService;
import com.rrs.web.login.service.impl.LoginMapper;
import com.rrs.web.login.service.impl.LoginServiceImpl;
import com.rrs.web.login.service.vo.LoginVO;

@Service("loginService")
public class LoginServiceImpl implements LoginService {
  @Resource(name = "loginMapper")
  private LoginMapper loginMapper;
  
  public LoginVO login(LoginVO vo) throws Exception {
    return this.loginMapper.login(vo);
  }

  public int deviceInfoIns(Map<String, Object> map) throws Exception {
    return loginMapper.deviceInfoIns( map );
  }
}
