package com.rrs.web.main.service.impl;

import java.util.*;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.rrs.web.main.service.MainService;
import com.rrs.web.main.service.impl.MainMapper;
import com.rrs.web.main.service.impl.MainServiceImpl;

@Service("mainService")
public class MainServiceImpl implements MainService {
	@Resource(name = "mainMapper")
	private MainMapper mainMapper;
}
