package com.rrs.web.main.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.rrs.web.main.service.MainService;

@Service("mainService")
public class MainServiceImpl implements MainService {
	@Resource(name = "mainMapper")
	private MainMapper mainMapper;
}
