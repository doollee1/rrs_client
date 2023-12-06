package com.rrs.web.notice.controller;

import com.rrs.web.notice.service.NoticeService;
import com.rrs.web.notice.service.vo.NoticeVO;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
	@ResponseBody
	public ModelAndView noticeList(@RequestParam Map<String, Object> map, Model model) throws Exception {
		logger.info("noticeList");
		
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, Object>> list = null;
		int listCnt = 0;
		int page = 0;
		int countList = 10;
		int countPage = 10;
		int totalCount = 0;
		int totalPage = 0;
		int lastPage = 0;
		String strPage = (String)map.get("page");
		
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
		
		mav.addObject("page", Integer.valueOf(page));
		mav.addObject("startPage", Integer.valueOf(startPage));
		mav.addObject("endPage", Integer.valueOf(endPage));
		mav.addObject("lastPage", Integer.valueOf(lastPage));
		mav.addObject("list", list);
		mav.addObject("listCnt", Integer.valueOf(listCnt));
		mav.setViewName("notice/noticeList.view");
		
		return mav;
	}
	
	@RequestMapping(value={"/noticeListNextPage.do"}, method={RequestMethod.POST})
	@ResponseBody
	public List<Map<String, Object>> noticeListNextPage(@RequestParam Map<String, Object> map, Model model) throws Exception {
		logger.info("noticeList");
		
		List<Map<String, Object>> list = null;
		int page = 0;
		String strPage = (String)map.get("page");
		
		if (!map.containsKey("page")) {
			map.put("page", Integer.valueOf(0));
			page = 1;
		} else {
			page = Integer.parseInt(strPage);
			map.put("page", Integer.valueOf(page * 10 - 10));
		}
		
		list = this.noticeService.noticeList(map);
		
		return list;
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
