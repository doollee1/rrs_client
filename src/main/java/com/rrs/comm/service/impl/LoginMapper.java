// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   LoginMapper.java

package com.rrs.comm.service.impl;

import java.util.Map;

import com.rrs.comm.service.vo.LoginVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("loginMapper")
public interface LoginMapper {
  
  LoginVO login(LoginVO paramLoginVO) throws Exception;
  
  int deviceInfoIns(Map<String, Object> paramMap) throws Exception;
}
