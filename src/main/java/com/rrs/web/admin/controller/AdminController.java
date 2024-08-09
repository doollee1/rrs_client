/**
 *
 */
package com.rrs.web.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.rrs.web.admin.service.AdminService;
import com.rrs.web.comm.service.CommonService;

/**
 * 관리자 Controller
 *
 * @author DOOLLEE2
 *
 */
@Controller("adminController")
public class AdminController {

	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

	@Resource(name = "adminService")
	AdminService adminService;   //관리자 서비스

	@Resource(name = "commonService")
	CommonService commonService;	   //공통 서비스

	/**
	 * 관리자 예약목록 화면으로 이동
	 *
	 * @param model
	 * @param param
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminReservationList.do", method = RequestMethod.GET)
	public String adminReservationList(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		//관리자 예약 리스트
		List<Map<String, Object>> reservationList =  adminService.adminReservationList(param);
		model.addAttribute("reservationList", reservationList);
		return "admin/adminReservationList.view";
	}

	/**
	 * 예약상태변경 상세
	 *
	 * @param model
	 * @param param
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminProdDetail.do", method = RequestMethod.GET)
	public String adminProdDetail(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		// 예약현황 상세
		List<Map<String, Object>> ProdDetail =  adminService.adminProdDetail(param);

		// 예약상태
		param.put("HEAD_CD" , "500020"      );
		List<Map<String, Object>> prcStsGbnList = commonService.commCodeList(param);

		model.addAttribute("ProdDetail", ProdDetail);
		model.addAttribute("prcStsGbnList", prcStsGbnList);

		return "admin/adminProdDetail.view";
	}

	/**
	 * 관리자 예약상태변경 저장
	 *
	 * @param list
	 * @param file
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminPrcStsUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> prcStsUpdate(@RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap = adminService.prcStsUpdate(param);
		return rMap;
	}

	/**
	 * 관리자 이미지업로드 화면으로 이동
	 *
	 * @param model
	 * @param param
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminImageUploadList.do", method = RequestMethod.GET)
	public String adminImageUploadList(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		//관리자 이미지업로드 목록조회
		List<Map<String, Object>> adminImageUploadList =  adminService.adminImageUploadList(param);
		model.addAttribute("adminImageUploadList", adminImageUploadList);
		return "admin/adminImageUploadList.view";
	}

	/**
	 * 관리자 예약현황 확인
	 *
	 * @param model
	 * @param param
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminProdReservation.do", method = RequestMethod.GET)
	public String reservationList(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		List<Map<String, Object>> prodReservationList =  adminService.adminProdReservation(param);
		model.addAttribute("prodReservationList", prodReservationList);
		return "admin/adminProdReservation.view";
	}

	/**
	 * 관리자 다중 이미지 등록 ajax
	 *
	 * @param list
	 * @param file
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminImageReservationAjax.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> adminImageReservationAjax(@RequestPart List<Map<String, Object>> list, @RequestPart List<MultipartFile> file, HttpServletRequest req) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpSession session = req.getSession();
		int i = 0;
		for(Map<String, Object> param : list) {
			param.put("user_id" , session.getAttribute("user_id" )); //세션의 사용자 ID를 파라미터로 세팅
			param.put("file"    , file.get(i));  					 //파일을 파라미터로 설정
			i++;  //파일 인덱스 증가
		}
		//관리자 다중이미지 등록
		resultMap = adminService.adminImageReservation(list);
		return resultMap;
	}

}
