package com.rrs.comm.service.impl;

import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.rrs.comm.service.LoginService;
import com.rrs.comm.service.impl.LoginMapper;
import com.rrs.comm.service.impl.LoginServiceImpl;
import com.rrs.comm.service.vo.LoginVO;

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
