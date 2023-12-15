package com.rrs.web.reservation.service.impl;

import java.util.*;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.rrs.web.reservation.service.ReservationService;

@Service("reservationService")
public class ReservationServiceImpl implements ReservationService {
	@Resource(name = "reservationMapper")
	private ReservationMapper reservationMapper;

	public int imageSave(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.imageSave(paramMap);
	}

	// 예약 리스트
	public List<Map<String, Object>> reservationList(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.reservationList(paramMap);
	}

	// 멤버 숙박비 계산
	public Map<String, Object> memRoomChargeCalc(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.memRoomChargeCalc(paramMap);
	}

	// 예약등록 상품 조회(멤버숙박)
	public Map<String, Object> getRoomProdInfo(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.getRoomProdInfo(paramMap);
	}

	// 미팅센딩 상품 조회(멤버숙박)
	public Map<String, Object> getCarProdInfo(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.getCarProdInfo(paramMap);
	}

	// 미팅센딩 계산
	public Map<String, Object> sendingCalc(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.sendingCalc(paramMap);
	}

	// 야간할증비 계산
	public Map<String, Object> surchageCalc(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.surchageCalc(paramMap);
	}

	// roomup 계산
	public Map<String, Object> roomupCalc(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.roomupCalc(paramMap);
	}

	// lateCheckOut 계산
	public Map<String, Object> lateCheckOutCalc(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.lateCheckOutCalc(paramMap);
	}

	// 예약첨부파일(항공권) 등록
	public int insertTbReqAddFile(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.insertTbReqAddFile(paramMap);
	}

	// 멤버 예약등록 step1
	public int reservationStep1_m(Map<String, Object> paramMap) throws Exception {
		long totalAmt        = 0;  // 총액
		long roomCharge      = 0;  // 숙박비
		long sendingAmt      = 0;  // 미팅센딩비
		long surchageAmt     = 0;  // 야간할증비
		long roomupAmt       = 0;  // room업그레이드 가격
		long lateCheckOutAmt = 0;  // lateCheckOut 가격
		int insertGbn = 0;

		paramMap.put("hdng_gbn", "28"); //숙박(멤버)
		// 예약등록 상품 조회(멤버숙박)
		Map<String, Object> prodMap = reservationMapper.getRoomProdInfo(paramMap);
		if(prodMap == null || prodMap.size() == 0) {
			return insertGbn;
		}
		// 숙박비
		roomCharge = (long)Double.parseDouble(String.valueOf(prodMap.get("MEM_ROOM_CHARGE")));

		paramMap.put("res_bas_yy"    , prodMap.get("BAS_YY"    ));
		paramMap.put("res_bas_yy_seq", prodMap.get("BAS_YY_SEQ"));
		paramMap.put("res_prod_seq"  , prodMap.get("PROD_SEQ"  ));
		// 예약 테이블 등록
		insertGbn = reservationMapper.insertTbReqBookingM(paramMap);

		if(insertGbn == 0) return insertGbn;

		// 미팅센딩 상품 조회
		String pickGbn   = (String)paramMap.get("pick_gbn");  // 미팅센딩 구분값 (01 미신청)
		// 미싱청 아닐때만
		if(!"01".equals(pickGbn)) {
			Map<String, Object> pickupMap = reservationMapper.getCarProdInfo(paramMap);
			if(pickupMap != null) {
				// 미팅센딩 total 가격
				sendingAmt = (long)Double.parseDouble(String.valueOf(pickupMap.get("SENDING_AMT")));

				// 야간할증비행기 횟수
				int surchargeCnt = Integer.parseInt(String.valueOf(pickupMap.get("SURCHARGE_CNT")));
				if(surchargeCnt > 0) {
					Map<String, Object> surchargeMap = reservationMapper.surchageCalc(paramMap);
					if(surchargeMap != null) {
						// 야간할증비 가격
						surchageAmt = (long)Double.parseDouble(String.valueOf(surchargeMap.get("SURCHARGE")));
					}
				}

				// 미팅센딩 테이블 등록
				paramMap.put("car_num"     , pickupMap.get("CAR_NUM" ));
				paramMap.put("use_amt"     , pickupMap.get("COM_AMT" ));
				paramMap.put("car_prod_seq", pickupMap.get("PROD_SEQ"));

				insertGbn = reservationMapper.insertTbReqPickup(paramMap);
				if(insertGbn == 0) return insertGbn;
			}
		}

		// room up 인원 있을때만
		if(!"0".equals((String)paramMap.get("add_r_s_per")) || !"0".equals((String)paramMap.get("add_r_p_per"))) {
			Map<String, Object> roomupCalc =  reservationMapper.roomupCalc(paramMap);
			roomupAmt = (long)Double.parseDouble(String.valueOf(roomupCalc.get("ROOMUP_AMT")));
		}

		// lateCheckout
		if(!"3".equals((String)paramMap.get("late_check_out"))) {
			Map<String, Object> lateCheckOutCalc =  reservationMapper.lateCheckOutCalc(paramMap);
			if(lateCheckOutCalc != null) {
				lateCheckOutAmt = (long)Double.parseDouble(String.valueOf(lateCheckOutCalc.get("LATECHECKOUT_AMT")));
			}
		}

		// 총비용
		totalAmt = roomCharge + sendingAmt + surchageAmt + roomupAmt + lateCheckOutAmt;
		paramMap.put("tot_amt", totalAmt);

		// 비용테이블 등록
		insertGbn = reservationMapper.insertTbReqFee(paramMap);

		return insertGbn;
	}

	public Map<String, Object> imageLoad(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.imageLoad(paramMap);
	}
}
