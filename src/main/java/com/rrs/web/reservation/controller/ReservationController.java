package com.rrs.web.reservation.controller;

import com.google.gson.Gson;
import com.rrs.comm.util.EgovDateUtil;
import com.rrs.web.comm.service.CommonService;
import com.rrs.web.reservation.service.ReservationService;

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

	// 예약취소
	@RequestMapping(value = "/reservationCancel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reservationCancel(@RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		// 상태값 체크 01 예약요청-일반 / 02 예약요청-멤버 / 03 예약가능 / 04 예약신청 / 05 입금대기 / 06 예약확정 / 07 환불요청 / 08 환불완료 / 09 예약취소
		String prcSts  = reservationService.getPrcSts(param);
		String pPrcSts = (String)param.get("prc_sts");
		// 예약요청, 예약신청, 입금대기
		if(prcSts != null && !"".equals(prcSts) && prcSts.equals(pPrcSts)) {
			if("01".equals(prcSts) || "02".equals(prcSts) || "04".equals(prcSts) || "05".equals(prcSts) || "06".equals(prcSts)) {
				HttpSession session = req.getSession();
				param.put("user_id" , session.getAttribute("user_id"));
				// 예약확정일때는 환불요청
				if("06".equals(prcSts)) {
					// 환불가능 여부
					Map<String, Object> refundMap = reservationService.getReFundInfo(param);
					if(refundMap == null) {
						return rMap; 
					}
					String refundYn  = (String)refundMap.get("REFUND_YN" );  // 환불여부
					String refundDay = (String)refundMap.get("REFUND_DAY");  // 환불가능일
					if(!"Y".equals(refundYn)) {
						rMap.put("msg", "환불은 체크인일자로부터 " + refundDay + "일 이내 가능합니다.");
						return rMap; 
					}
				}

				// 회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시 
				String memGbn  = (String)session.getAttribute("mem_gbn");
				String memGbn2 = "01".equals(memGbn) ? "멤버" : "일반";
				int result = reservationService.reservationCancel(param);
				if(result >= 1) {
					String msg = memGbn2 + " 예약이 취소 되었습니다.";
					if("06".equals(prcSts)) {
						msg = memGbn2 + " 환불요청이 등록 되었습니다.";
					}
					commonService.telegramMsgSend(msg);
					rMap.put("result", "SUCCESS");
				}
			}
		}

		return rMap;
	}

	// 업데이트 체크
	@RequestMapping(value = "/getPrcSts.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPrcSts(@RequestParam Map<String, Object> param) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		// 상태값 체크 01 예약요청-일반 / 02 예약요청-멤버 / 03 예약가능 / 04 예약신청 / 05 입금대기 / 06 예약확정 / 07 예약취소
		String prcSts = reservationService.getPrcSts(param);

		rMap.put("result"  , "SUCCESS");
		rMap.put("prc_sts" , prcSts   );

		return rMap;
	}

	// 예약요청 수정(일반, 멤버)
	@RequestMapping(value = "/reservationUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reservationUpdate(@RequestPart Map<String, Object> param, @RequestPart(required = false) MultipartFile file, HttpServletRequest req) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		HttpSession session = req.getSession();
		// 상태값 체크 01 예약요청-일반 / 02 예약요청-멤버 / 03 예약가능 / 04 예약신청 / 05 입금대기 / 06 예약확정 / 07 예약취소
		String prcSts = reservationService.getPrcSts(param);
		// 회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시 
		String memGbn = (String)session.getAttribute("mem_gbn");

		// 멤버, 일반 예약요청일때만 수정가능 
		if( ( "01".equals(memGbn) && "02".equals(prcSts) ) // 멤버 예약요청 
				|| ( "02".equals(memGbn) && "01".equals(prcSts) ) // 일반 예약요청
				|| ( "02".equals(memGbn) && "04".equals(prcSts) ) // 일반 예약신청
		) {
			// 예약 등록 수정
			param.put("user_id" , session.getAttribute("user_id" ));
			param.put("mem_gbn" , memGbn                          );

			int result = 0;
			String msg = "";
			if( ( "01".equals(memGbn) && "02".equals(prcSts) ) || ( "02".equals(memGbn) && "04".equals(prcSts) ) ) {
				result = reservationService.reservationUpdate_m(param);
				if("01".equals(memGbn) && "02".equals(prcSts)) {
					msg = "멤버 예약이 수정 되었습니다.";
				} else {
					msg = "일반 예약신청이 수정 되었습니다.";
				}
			} else {
				result = reservationService.reservationUpdate(param);
				msg = "일반 예약이 수정 되었습니다.";
			}

			if(result >= 1) {
				commonService.telegramMsgSend(msg);
				rMap.put("result", "SUCCESS");
			}
		}

		return rMap;
	}

	// 예약현황
	@RequestMapping(value = "/reservationList.do", method = RequestMethod.GET)
	public String reservationList(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		HttpSession session = req.getSession();

		param.put("user_id" , session.getAttribute("user_id" ));

		// 예약 리스트
		List<Map<String, Object>> reservationList = reservationService.reservationList(param);
		model.addAttribute("reservationList", reservationList);
		return "reservation/reservationList.view";
	}

	// 예약현황 상세
	@RequestMapping(value = "/reservationDetail.do", method = RequestMethod.POST)
	public String reservationDetail(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		HttpSession session = req.getSession();

		param.put("user_id" , session.getAttribute("user_id" ));

		// 예약 상세
		Map<String, Object> reservationDetail = reservationService.reservationDetail(param);
		
		param.put("HEAD_CD" , "500210"); // 미팅샌딩
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

		Gson gson =  new Gson();
		String strReservationDetail = gson.toJson(reservationDetail);

		String memGbn = (String)reservationDetail.get("MEM_GBN"); // 회원구분
		String prcSts = (String)reservationDetail.get("PRC_STS"); // 예약상태

		model.addAttribute("reservationDetail"   , reservationDetail   );
		model.addAttribute("strReservationDetail", strReservationDetail);
		model.addAttribute("pickupSvcList"       , pickupSvcList       );
		model.addAttribute("lateOutYnList"       , lateOutYnList       );
		model.addAttribute("roomTypeList"        , roomTypeList        );
		model.addAttribute("fligthInList"        , fligthInList        );
		model.addAttribute("fligthOutList"       , fligthOutList       );

		if("01".equals(memGbn)) { // 멤버
			if("02".equals(prcSts)) {  // 예약요청
				return "reservation/reservationReqDetail_m.view";
			} else {
				return "reservation/reservationReqDetail_m2.view";
			}
		} else {  // 일반
			List<Map<String, Object>> packageList = reservationService.packageList();
			model.addAttribute("packageList", packageList);
			if("01".equals(prcSts)) {  // 예약요청
				return "reservation/reservationReqDetail.view";
			} else if("03".equals(prcSts)) { // 일반 예약가능
				return "reservation/reservationReqDetail2.view";
			} else if("04".equals(prcSts)) { // 일반 예약신청
				return "reservation/reservationReqDetail3.view";
			} else {  // 그외(입금대기, 예약확정, 예약취소, 환불요청)
				return "reservation/reservationReqDetail4.view";
			}
		}
	}

	// 예약요청(일반, 멤버)
	@RequestMapping(value = "/reservationReq.do", method = RequestMethod.GET)
	public String reservationReq(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		HttpSession session = req.getSession();
		// 회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시 
		String memGbn = (String)session.getAttribute("mem_gbn");

		param.put("HEAD_CD" , "500070");  // 객실타입
		List<Map<String, Object>> roomTypeList = commonService.commCodeList(param);
		model.addAttribute("roomTypeList" , roomTypeList );

		if("01".equals(memGbn)) {  // 멤버
			param.put("HEAD_CD" , "500210"); // 미팅샌딩
			List<Map<String, Object>> pickupSvcList = commonService.commCodeList(param);

			param.put("HEAD_CD" , "500060"); // late체크아웃
			List<Map<String, Object>> lateOutYnList = commonService.commCodeList(param);

			param.put("HEAD_CD" , "500180"      );  // 출발항공편
			param.put("ORDER_BY", "REF_CHR3 ASC");
			List<Map<String, Object>> fligthInList = commonService.commCodeList(param);

			param.put("HEAD_CD" , "500190"      );  // 도착항공편
			List<Map<String, Object>> fligthOutList = commonService.commCodeList(param);

			model.addAttribute("pickupSvcList", pickupSvcList);
			model.addAttribute("lateOutYnList", lateOutYnList);
			model.addAttribute("fligthInList" , fligthInList );
			model.addAttribute("fligthOutList", fligthOutList);

			return "reservation/reservationReq_m.view";
		}
		// 일반 패키지 리스트
		List<Map<String, Object>> packageList = reservationService.packageList();
		model.addAttribute("packageList", packageList);

		return "reservation/reservationReq.view";
	}

	// 일반 예약요청
	@RequestMapping(value = "/reservationInsert1.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reservationInsert1(@RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		HttpSession session = req.getSession();

		param.put("today"   , EgovDateUtil.getToday()         ); // 금일
		param.put("user_id" , session.getAttribute("user_id" ));
		param.put("han_name", session.getAttribute("han_name"));
		param.put("eng_name", session.getAttribute("eng_name"));
		param.put("tel_no"  , session.getAttribute("tel_no"  ));
		param.put("mem_gbn" , session.getAttribute("mem_gbn" ));
		param.put("prc_sts" , "01"                            ); // 예약요청-일반

		// 일반 예약등록
		int result = reservationService.reservationInsert1(param);
		if(result >= 1) {
			String msg = "일반 예약요청이 등록 되었습니다.";
			commonService.telegramMsgSend(msg);
			rMap.put("result", "SUCCESS");
		} else {
			rMap.put("result", "FAIL");
		}
		return rMap;
	}

	// 멤버 예약요청, 일반 예약신청
	@RequestMapping(value = "/reservationInsert.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reservationInsert(@RequestPart Map<String, Object> param, @RequestPart MultipartFile file, HttpServletRequest req) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		HttpSession session = req.getSession();
		// 회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시 
		String memGbn  = (String)session.getAttribute("mem_gbn");
		String msg     = "";

		param.put("user_id" , session.getAttribute("user_id" ));
		param.put("han_name", session.getAttribute("han_name"));
		param.put("eng_name", session.getAttribute("eng_name"));
		param.put("tel_no"  , session.getAttribute("tel_no"  ));
		param.put("mem_gbn" , memGbn                          );
		if("01".equals(memGbn)) {
			param.put("today"   , EgovDateUtil.getToday()         ); // 금일
			param.put("prc_sts" , "02"                            ); // 예약요청-멤버
			msg = "멤버 예약요청이 등록 되었습니다.";
		} else {
			param.put("prc_sts" , "04"                            ); // 예약신청(일반)
			msg = "일반 예약신청이 등록 되었습니다.";
		}
		param.put("file"    , file                            );

		// 멤버일때 예약요청, 일반일때 예약신청
		int result = reservationService.reservationInsert(param);
		if(result >= 1) {
			commonService.telegramMsgSend(msg);
			rMap.put("result", "SUCCESS");
		}

		return rMap;
	}

	// 가계산
	@RequestMapping(value = "/reservationCal.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reservationCal(@RequestParam Map<String, Object> param, HttpServletRequest req) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		HttpSession session = req.getSession();

		long totalAmt        = 0;  // total 가격
		int surchargeCnt     = 0;  // 야간할증횟수
		long roomCharge      = 0;  // 멤버 숙박비
		long packageAmt      = 0;  // 패키지가격
		long sendingAmt      = 0;  // 미팅샌딩가격
		long surchageAmt     = 0;  // 야간할증가격
		long roomupAmt       = 0;  // room추가 가격
		long lateCheckOutAmt = 0;  // lateCheckOut 가격

		// 회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시 
		String memGbn  = (String)session.getAttribute("mem_gbn");

		if("01".equals(memGbn)) {  // 가계산시 멤버는 숙박
			param.put("hdng_gbn", "28"); // 조건 멤버(숙박)
			Map<String, Object> memRoomChargeMap =  reservationService.memRoomChargeCalc(param);
			if(memRoomChargeMap != null) {
				roomCharge = (long)Double.parseDouble(String.valueOf(memRoomChargeMap.get("MEM_ROOM_CHARGE")));
			}
		} else {  // 일반은 패키지
			Map<String, Object> packageMap =  reservationService.packageCharge(param);
			if(packageMap != null) {
				packageAmt = (long)Double.parseDouble(String.valueOf(packageMap.get("PACKAGE_AMT")));
			}
		}

		String pickGbn   = (String)param.get("pick_gbn");  // 미팅샌딩 구분값 (01 미신청)
		// 미싱청 아닐때만
		if(!"01".equals(pickGbn)) {
			Map<String, Object> sendingMap =  reservationService.getCarProdInfo(param);  // 미팅샌딩 정보
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

		totalAmt = roomCharge + packageAmt + sendingAmt + surchageAmt + roomupAmt + lateCheckOutAmt;

		rMap.put("roomCharge", roomCharge);
		rMap.put("packageAmt", packageAmt);
		rMap.put("sendingAmt", sendingAmt);
		rMap.put("surchageAmt", surchageAmt);
		rMap.put("roomupAmt", roomupAmt);
		rMap.put("lateCheckOutAmt", lateCheckOutAmt);

		rMap.put("totalAmt", totalAmt );
		rMap.put("result"  , "SUCCESS");
		return rMap;
	}
}
