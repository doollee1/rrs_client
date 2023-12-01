package com.rrs.web.notice.controller;

import com.rrs.web.notice.service.NoticeService;
import com.rrs.web.notice.service.vo.NoticeVO;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author 이민구
 * 파일이름 : noticeController.java
 * 파일설명 : 공지사항 컨트롤러
 * ***************************************************************************
 * 함수명			- 함수설명						방식	URL
 * ---------------------------------------------------------------------------
 * noticeListPage()	- 공지사항 목록 페이지 진입		GET		/noticeList.do
 * ***************************************************************************
 */
@Controller
public class NoticeController {
	
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);
	
	@Resource(name = "noticeService")
	NoticeService noticeService;
	
	@RequestMapping({"/noticeList.do"})
	public String noticeList(@RequestParam Map<String, Object> map, Model model) throws Exception {
		logger.info("noticeList");
		
		List<Map<String, Object>> list = null;
		int listCnt = 0;
		int page = 0;
		int countList = 10;
		int countPage = 10;
		int totalCount = 0;
		int totalPage = 0;
		int lastPage = 0;
		String strPage = (String)map.get("page");
		Date DateNow = new Date();
		SimpleDateFormat formatNow = new SimpleDateFormat("yyyy-MM-dd");
		String now = formatNow.format(DateNow);
		
		map.put("now", now);
		
		if (!map.containsKey("page")) {
			map.put("page", Integer.valueOf(0));
			page = 1;
		} else {
			page = Integer.parseInt(strPage);
			map.put("page", Integer.valueOf(page * 10 - 10));
		}
		
		logger.info("page :::::" + page);
		
		list = this.noticeService.noticeList(map);
		listCnt = this.noticeService.noticeListCnt();
		
		totalCount = listCnt;
		totalPage = totalCount / countList;
		if (totalCount % countList > 0) { totalPage++; }
		if (totalPage < page) { page = totalPage; } 
		int startPage = (page - 1) / 10 * 10 + 1;
		int endPage = startPage + countPage - 1;
		if (endPage > totalPage) { endPage = totalPage; } 
		lastPage = (int)Math.ceil(listCnt / countList);
		
		model.addAttribute("page", Integer.valueOf(page));
		model.addAttribute("startPage", Integer.valueOf(startPage));
		model.addAttribute("endPage", Integer.valueOf(endPage));
		model.addAttribute("lastPage", Integer.valueOf(lastPage));
		model.addAttribute("list", list);
		model.addAttribute("listCnt", Integer.valueOf(listCnt));
		
		return "notice/noticeList.view";
	}
	
	@RequestMapping(value = {"/noticeView.do"}, method = RequestMethod.GET)
	public ModelAndView noticeView(@RequestParam  Map<String, Object> map, Model model) throws Exception {
		logger.info("noticeDetail");
		
		ModelAndView mav = new ModelAndView();
		
		NoticeVO vo = this.noticeService.noticeView((String)map.get("notice_seq"));
		mav.addObject("title", vo.getTitle());
		mav.addObject("content", vo.getContent());
		mav.setViewName("notice/noticeView.view");
		
		return mav;
	}
}
