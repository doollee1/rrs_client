package com.rrs.web.reservation.controller;

import com.rrs.comm.util.EgovDateUtil;
import com.rrs.web.comm.service.CommonService;
import com.rrs.web.reservation.service.ReservationService;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

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

@Controller("reservationController")
public class ReservationController {
	private static final Logger logger = LoggerFactory.getLogger(ReservationController.class);

	@Resource(name = "reservationService")
	ReservationService reservationService;

	@Resource(name = "commonService")
	CommonService commonService;

	@RequestMapping(value = "/reservationList.do", method = RequestMethod.GET)
	public String reservationList(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		HttpSession session = req.getSession();

		param.put("user_id" , session.getAttribute("user_id" ));

		// 예약 리스트
		List<Map<String, Object>> reservationList = reservationService.reservationList(param);
		model.addAttribute("reservationList", reservationList);
		return "reservation/reservationList.view";
	}

	@RequestMapping(value = "/reservationReq.do", method = RequestMethod.GET)
	public String reservationReq(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		param.put("HEAD_CD" , "500050"); // 미팅센딩
		List<Map<String, Object>> pickupSvcList = commonService.commCodeList(param);

		param.put("HEAD_CD" , "500060"); // late체크아웃
		List<Map<String, Object>> lateOutYnList = commonService.commCodeList(param);

		param.put("HEAD_CD" , "500070");  // 객실타입
		List<Map<String, Object>> roomTypeList = commonService.commCodeList(param);

		param.put("HEAD_CD" , "500180"      );  // 출발항공편
		param.put("ORDER_BY", "REF_CHR3 ASC");
		List<Map<String, Object>> fligthInList = commonService.commCodeList(param);

		param.put("HEAD_CD" , "500190"      );  // 도착항공편
		List<Map<String, Object>> fligthOutList = commonService.commCodeList(param);

		model.addAttribute("pickupSvcList", pickupSvcList);
		model.addAttribute("lateOutYnList", lateOutYnList);
		model.addAttribute("roomTypeList" , roomTypeList );
		model.addAttribute("fligthInList" , fligthInList );
		model.addAttribute("fligthOutList", fligthOutList);

		return "reservation/reservationReq_m.view";
	}

	@RequestMapping(value = "/reservationStep1_m.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reservationStep1_m(@RequestPart Map<String, Object> param, @RequestPart MultipartFile file, HttpServletRequest req) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		HttpSession session = req.getSession();

		param.put("today"   , EgovDateUtil.getToday()         ); // 금일
		param.put("user_id" , session.getAttribute("user_id" ));
		param.put("han_name", session.getAttribute("han_name"));
		param.put("eng_name", session.getAttribute("eng_name"));
		param.put("tel_no"  , session.getAttribute("tel_no"  ));
		param.put("mem_gbn" , session.getAttribute("mem_gbn" ));
		param.put("prc_sts" , "02"                            ); // 예약요청-멤버

		// 멤버 예약등록 step1
		int result = reservationService.reservationStep1_m(param);
		if(result >= 1) {
			// 이미지 업로드
			Map<String, Object> imageMap = commonService.imageUpload(file);
			if(imageMap != null) {
				param.putAll(imageMap);
				// 예약첨부파일(항공권) 등록
				reservationService.insertTbReqAddFile(param);
			}
			String msg = "멤버 예약이 등록되었습니다.";
			commonService.telegramMsgSend(msg);
			rMap.put("result", "SUCCESS");
		} else {
			rMap.put("result", "FAIL");
		}
		return rMap;
	}

	@RequestMapping(value = "/reservationCal_m.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reservationCal_m(@RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();

		long totalAmt        = 0;  // total 가격
		int surchargeCnt     = 0;  // 야간할증횟수
		long roomCharge      = 0;  // 멤버 숙박비
		long sendingAmt      = 0;  // 미팅센딩가격
		long surchageAmt     = 0;  // 야간할증가격
		long roomupAmt       = 0;  // room업그레이드 가격
		long lateCheckOutAmt = 0;  // lateCheckOut 가격

		param.put("hdng_gbn", "28"); // 조건 멤버(숙박)
		Map<String, Object> memRoomChargeMap =  reservationService.getRoomProdInfo(param);
		if(memRoomChargeMap != null) {
			roomCharge = (long)Double.parseDouble(String.valueOf(memRoomChargeMap.get("MEM_ROOM_CHARGE")));
		}

		String pickGbn   = (String)param.get("pick_gbn");  // 미팅센딩 구분값 (01 미신청)
		// 미싱청 아닐때만
		if(!"01".equals(pickGbn)) {
			Map<String, Object> sendingMap =  reservationService.getCarProdInfo(param);  // 미팅센딩 정보
			if(sendingMap != null) {
				sendingAmt = (long)Double.parseDouble(String.valueOf(sendingMap.get("SENDING_AMT")));
				surchargeCnt = Integer.parseInt(String.valueOf(sendingMap.get("SURCHARGE_CNT")));
				if(surchargeCnt > 0) {
					Map<String, Object> surchargeMap = reservationService.surchageCalc(param);
					if(surchargeMap != null) {
						surchageAmt = (long)Double.parseDouble(String.valueOf(surchargeMap.get("SURCHARGE")));
					}
				}
			}
		}

		// room up 인원 있을때만
		if(!"0".equals((String)param.get("add_r_s_per")) || !"0".equals((String)param.get("add_r_p_per"))) {
			Map<String, Object> roomupCalc =  reservationService.roomupCalc(param);
			roomupAmt = (long)Double.parseDouble(String.valueOf(roomupCalc.get("ROOMUP_AMT")));
		}

		// lateCheckout
		if(!"3".equals((String)param.get("late_check_out"))) {
			Map<String, Object> lateCheckOutCalc =  reservationService.lateCheckOutCalc(param);
			if(lateCheckOutCalc != null) {
				lateCheckOutAmt = (long)Double.parseDouble(String.valueOf(lateCheckOutCalc.get("LATECHECKOUT_AMT")));
			}
		}

		totalAmt = roomCharge + sendingAmt + surchageAmt + roomupAmt + lateCheckOutAmt;

		rMap.put("roomCharge", roomCharge);
		rMap.put("sendingAmt", sendingAmt);
		rMap.put("surchageAmt", surchageAmt);
		rMap.put("roomupAmt", roomupAmt);
		rMap.put("lateCheckOutAmt", lateCheckOutAmt);

		rMap.put("totalAmt", totalAmt );
		rMap.put("result"  , "SUCCESS");
		return rMap;
	}

	@RequestMapping(value = "/testImage3.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> testImage3(@RequestPart Map<String, Object> param, @RequestPart MultipartFile file) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		String savePath = "/opt/apache-tomcat-8.5.32/webapps/upload/";

		String toDay   = EgovDateUtil.getToday();
		String strYyyy = toDay.substring(0, 4) + "/";
		String strMm   = toDay.substring(4, 6) + "/";
		savePath = savePath + strYyyy;
		if(!new File(savePath).exists()) {
			try {
				new File(savePath).mkdir();
				savePath = savePath + strMm;
				if(!new File(savePath).exists()) {
					new File(savePath).mkdir();
				}
			} catch(Exception ex) {
				ex.printStackTrace();
			}
		}
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS"); //SSS가 밀리세컨드 표시
		Calendar calendar = Calendar.getInstance();
		String filePath = savePath + dateFormat.format(calendar.getTime()).toString() + "." + file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".") + 1);
		//file.getOriginalFilename();
		File realFile = new File(filePath);
		file.transferTo(realFile);
		realFile.setExecutable(true);
		realFile.setWritable  (true);
		realFile.setReadable  (true);
		rMap.put("result", "SUCCESS");
		return rMap;
	}

	@RequestMapping(value = "/testImage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> testImage(@RequestPart Map<String, Object> param, @RequestPart MultipartFile file) throws Exception {
		logger.info("/testImage.do");
		Map<String, Object> rMap = new HashMap<String, Object>();
		System.out.println(param.toString());
		if(!file.isEmpty()) {
			System.out.println("file size : " + file.getSize());
			System.out.println("file name : " + file.getName());
			System.out.println("file OriginalFilename : " + file.getOriginalFilename());

			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("fileNm"  , file.getOriginalFilename());
			paramMap.put("image"   , file.getBytes()           );
			paramMap.put("filePath", ""                        );

			reservationService.imageSave(paramMap);
		} else {
			System.out.println("File is Empty!!!!!!");
		}
		rMap.put("result", "SUCCESS");
		return rMap;
	}

	@RequestMapping(value = "/testImage2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> testImage2(@RequestParam Map<String, Object> param) throws Exception {
		logger.info("/testImage2.do");
		Map<String, Object> rMap = new HashMap<String, Object>();
		System.out.println(param.toString());
		rMap = reservationService.imageLoad(param);
		String fileNm  = (String)rMap.get("ADD_FILE_NM");
		String fileExt =  fileNm.substring(fileNm.lastIndexOf(".") + 1);
		String addPath = "data:image/" + ((fileExt == null || "".equals(fileExt)) ? "png" : fileExt) + ";base64,";
		rMap.put("ADD_PATH", addPath);
		rMap.put("result", "SUCCESS");
		return rMap;
	}
}
