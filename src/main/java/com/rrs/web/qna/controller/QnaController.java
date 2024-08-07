package com.rrs.web.qna.controller;

import com.rrs.web.comm.service.CommonService;
import com.rrs.web.qna.service.QnaService;
import com.rrs.web.qna.service.vo.QnaVO;

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
 * 파일이름 : qnaController.java
 * 파일설명 : 문의사항 컨트롤러
 * ***************************************************************************
 * 함수명				함수설명						방식	URL
 * ---------------------------------------------------------------------------
 * qnaListPage()		문의사항 목록 페이지 진입		GET		/qnaList.do
 * myQnaListPage()		내 문의사항 목록 페이지 진입	GET		/myQnaList.do 
 * qnaListNextPage()	문의사항 다음 페이지 로딩		POST	/qnaListNextPage.do
 * qnaView()			문의사항 상세보기 페이지 진입	GET		/qnaView.do
 * qnaWritePage()		문의사항 입력 페이지 진입		GET		/qnaWrite.do
 * qnaWrite()			문의사항 입력 처리				POST	/qnaWrite.do
 * qnaModifyPage()		문의사항 수정 페이지 진입		GET		/qnaModify.do
 * qnaModify()			문의사항 수정 처리				POST	/qnaModify.do
 * qnaDelete()			문의사항 삭제 처리				GET		/qnaDelete.do
 * ***************************************************************************
 */
@Controller
public class QnaController {
	
	private static final Logger logger = LoggerFactory.getLogger(QnaController.class);
	
	@Resource(name = "qnaService")
	QnaService qnaService;
	
	@Resource(name = "commonService")
	CommonService commonService;
	
	@RequestMapping({"/qnaList.do"})
	@ResponseBody
	public ModelAndView qnaList(@RequestParam Map<String, Object> map, Model model) throws Exception {
		logger.info("qnaList");
		
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
		
		list = this.qnaService.qnaList(map);
		listCnt = this.qnaService.qnaListCnt();
		
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
		mav.setViewName("qna/qnaList.view");
		
		return mav;
	}
	
	@RequestMapping(value={"/myQnaList.do"}, method={RequestMethod.POST})
	@ResponseBody
	public List<Map<String, Object>> myQnaList(@RequestParam Map<String, Object> map, Model model) throws Exception {
		logger.info("myQnaList");
		
		List<Map<String, Object>> list = null;
		
		list = this.qnaService.myQnaList(map);
//		listCnt = this.qnaService.myQnaListCnt((String) map.get("user_id"));
		
		logger.info("list ::::: " + list);
		logger.info("list.isEmpty ::::: " + list.isEmpty());
		
		return list;
	}
	
	@RequestMapping(value={"/qnaListNextPage.do"}, method={RequestMethod.POST})
	@ResponseBody
	public List<Map<String, Object>> qnaListNextPage(@RequestParam Map<String, Object> map, Model model) throws Exception {
		logger.info("QnaList");
		
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
		
		list = this.qnaService.qnaList(map);
		
		return list;
	}
	
	@RequestMapping(value = {"/qnaView.do"}, method = RequestMethod.GET)
	public ModelAndView qnaView(@RequestParam  Map<String, Object> map, Model model) throws Exception {
		logger.info("qnaDetail");
		
		ModelAndView mav = new ModelAndView();
		List<Map<String, Object>> list = null;
		
		list = this.qnaService.qnaView((String)map.get("qna_seq"));
		mav.addObject("list", list);
		mav.setViewName("qna/qnaView.view");
		
		return mav;
	}
	
	@RequestMapping(value = {"/qnaWrite.do"}, method = RequestMethod.GET)
	public String qnaWritePage(@RequestParam  Map<String, Object> map, Model model) throws Exception {
		logger.info("qnaWritePage");
		return "qna/qnaWrite.view";
	}
	
	@RequestMapping(value = {"/qnaWrite.do"}, method = RequestMethod.POST)
	@ResponseBody
	public String qnaWrite(@RequestParam  Map<String, Object> map, Model model) throws Exception {
		logger.info("qnaWritePage");
		String result = "";
		
		QnaVO vo = new QnaVO();
		vo.setTitle((String) map.get("title"));
		vo.setContent((String) map.get("content"));
		vo.setReg_id((String) map.get("user_id"));
		vo.setSecret_yn((String) map.get("secret_yn"));
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("[문의사항 등록 알림]").append(System.getProperty("line.separator"))
		.append("[등록자] : ").append((String) map.get("user_id")).append(System.getProperty("line.separator"))
		.append("[제목] : ").append((String) map.get("title")).append(System.getProperty("line.separator"))
		.append("등록된 문의사항을 확인해주세요.");
		
		try {
			this.qnaService.qnaWrite(vo);
			result = "Y";
			
			
			logger.debug(":::::텔레그램 메세지 전송 시도:::::");
			logger.debug("msg :: " + sb.toString());
			
			String telgramResult = this.commonService.telegramMsgSend(sb.toString());
			logger.debug("텔리그램결과 : "+telgramResult);;
			
			if("Y".equals(telgramResult)) {
				logger.debug(":::::텔레그램 메세지 전송 완료:::::");				
			} else {
				logger.debug(":::::텔레그램 메세지 전송 실패:::::");				
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			result = "N";
		}
		
		return result;
	}
	
	@RequestMapping(value = {"/qnaModify.do"}, method = RequestMethod.GET)
	public ModelAndView qnaModifyPage(@RequestParam  Map<String, Object> map, Model model) throws Exception {
		logger.info("qnaModifyPage");
		
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("qna_seq",   map.get("qna_seq"));
		mav.addObject("title",     map.get("title"));
		mav.addObject("content",   map.get("content"));
		mav.addObject("secret_yn", map.get("secret_yn"));
		
		mav.setViewName("qna/qnaModify.view");
		
		return mav;
	}
	
	@RequestMapping(value = {"/qnaModify.do"}, method = RequestMethod.POST)
	@ResponseBody
	public String qnaModify(@RequestParam  Map<String, Object> map, Model model) throws Exception {
		logger.info("qnaModify");
		
		String result = "";
		QnaVO vo = new QnaVO();
		vo.setQna_seq(Integer.parseInt((String) map.get("qna_seq")));
		vo.setTitle((String) map.get("title"));
		vo.setContent((String) map.get("content"));
		vo.setReg_sts((String) map.get("reg_sts"));
		vo.setUpd_id((String) map.get("user_id"));
		vo.setSecret_yn((String) map.get("secret_yn"));
		
		try {
			this.qnaService.qnaModify(vo);
			result = "Y";
		} catch (Exception e) {
			// TODO: handle exception
			result = "N";
		}
		
		return result;
	}
	
	@RequestMapping(value = {"/qnaDelete.do"}, method = RequestMethod.GET)
	@ResponseBody
	public String qnaDelete(@RequestParam  Map<String, Object> map, Model model) throws Exception {
		logger.info("qnaDelete");
		String result = "";
		QnaVO vo = new QnaVO();
		
		vo.setQna_seq(Integer.parseInt((String) map.get("qna_seq")));
		
		try {
			this.qnaService.qnaDelete(vo);
			result="Y";
		} catch (Exception e) {
			// TODO: handle exception
			result="N";
		}
		
		return result;
	}
}
