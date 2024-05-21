package com.rrs.web.reservation.service.impl;

import java.util.*;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.rrs.web.comm.service.CommonService;
import com.rrs.web.reservation.service.ReservationService;

@Service("reservationService")
public class ReservationServiceImpl implements ReservationService {
	@Resource(name = "reservationMapper")
	private ReservationMapper reservationMapper;

	@Resource(name = "commonService")
	CommonService commonService;

	// 패키지 리스트
	public List<Map<String, Object>> packageList() throws Exception {
		return reservationMapper.packageList();
	}

	// 예약 리스트
	public List<Map<String, Object>> reservationList(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.reservationList(paramMap);
	}

	// 멤버 숙박비 계산
	public Map<String, Object> memRoomChargeCalc(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.memRoomChargeCalc(paramMap);
	}

	// 패키지 가겨 계산
	public Map<String, Object> packageCharge(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.packageCharge(paramMap);
	}

	// 예약등록 상품 조회(멤버숙박)
	public Map<String, Object> getRoomProdInfo(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.getRoomProdInfo(paramMap);
	}

	// 일반 패키지 상품 조회
	public Map<String, Object> getPackageInfo(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.getPackageInfo(paramMap);
	}

	// 미팅샌딩 상품 조회(멤버숙박)
	public Map<String, Object> getCarProdInfo(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.getCarProdInfo(paramMap);
	}

	// 미팅샌딩 계산
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

	// 멤버 예약요청, 일반 예약신청
	public int reservationInsert(Map<String, Object> paramMap) throws Exception {
		long totalAmt        = 0;  // 총액
		long roomCharge      = 0;  // 숙박비
		long packageAmt      = 0;  // 패키지가격
		long sendingAmt      = 0;  // 미팅샌딩비
		long surchageAmt     = 0;  // 야간할증비
		long roomupAmt       = 0;  // room업그레이드 가격
		long lateCheckOutAmt = 0;  // lateCheckOut 가격
		int insertGbn = 0;

		// 회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시 
		String memGbn  = (String)paramMap.get("mem_gbn");

		if("01".equals(memGbn)) {
			paramMap.put("hdng_gbn", "28"); //숙박(멤버)
			// 예약등록 상품 조회(멤버숙박)
			Map<String, Object> prodMap = reservationMapper.getRoomProdInfo(paramMap);
			if(prodMap == null || prodMap.size() == 0) {
				return insertGbn;
			}
			// 숙박비
			Map<String, Object> memRoomChargeMap =  reservationMapper.memRoomChargeCalc(paramMap);
			if(memRoomChargeMap != null) {
				roomCharge = (long)Double.parseDouble(String.valueOf(memRoomChargeMap.get("MEM_ROOM_CHARGE")));
			}

			paramMap.put("res_bas_yy"    , prodMap.get("BAS_YY"    ));
			paramMap.put("res_bas_yy_seq", prodMap.get("BAS_YY_SEQ"));
			paramMap.put("res_prod_seq"  , prodMap.get("PROD_SEQ"  ));

			// 예약 테이블 등록
			insertGbn = reservationMapper.insertTbReqBookingM(paramMap);
			if(insertGbn == 0) return insertGbn;
		} else {
			// 패키지 상품 정보 조회
			Map<String, Object> packageMap = reservationMapper.getPackageInfo(paramMap);
			if(packageMap == null || packageMap.size() == 0) {
				return insertGbn;
			}
			Map<String, Object> packageChageMap =  reservationMapper.packageCharge(paramMap);
			if(packageChageMap != null) {
				packageAmt = (long)Double.parseDouble(String.valueOf(packageChageMap.get("PACKAGE_AMT")));
			}

			// 예약 테이블 수정
			paramMap.put("res_bas_yy"    , packageMap.get("BAS_YY"    ));
			paramMap.put("res_bas_yy_seq", packageMap.get("BAS_YY_SEQ"));
			paramMap.put("res_prod_seq"  , packageMap.get("PROD_SEQ"  ));

			insertGbn = reservationMapper.updateTbReqBookingM(paramMap);
			if(insertGbn == 0) return insertGbn;
		}

		// 미팅샌딩 상품 조회
		String pickGbn   = (String)paramMap.get("pick_gbn");  // 미팅샌딩 구분값 (01 미신청)
		// 미신청 아닐때만
		if(!"01".equals(pickGbn)) {
			Map<String, Object> pickupMap = reservationMapper.getCarProdInfo(paramMap);
			if(pickupMap != null) {
				// 미팅샌딩 total 가격
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

				// 미팅샌딩 테이블 등록
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
		totalAmt = roomCharge + packageAmt + sendingAmt + surchageAmt + roomupAmt + lateCheckOutAmt;
		paramMap.put("tot_amt", totalAmt);

		// 비용테이블 등록
		insertGbn = reservationMapper.insertTbReqFee(paramMap);
		if(insertGbn == 0) return insertGbn;

		// 이미지 업로드
		Map<String, Object>imageMap = commonService.imageUpload((MultipartFile)paramMap.get("file"));
		paramMap.putAll(imageMap);

		// 이미지테이블 등록
		insertGbn = reservationMapper.insertTbReqAddFile(paramMap);

		return insertGbn;
	}

	// 일반 예약요청
	public int reservationInsert1(Map<String, Object> paramMap) throws Exception {
		int insertGbn = 0;

		// 패키지 상품 정보 조회
		Map<String, Object> packageMap = reservationMapper.getPackageInfo(paramMap);
		if(packageMap == null || packageMap.size() == 0) {
			return insertGbn;
		}

		paramMap.put("res_bas_yy"    , packageMap.get("BAS_YY"    ));
		paramMap.put("res_bas_yy_seq", packageMap.get("BAS_YY_SEQ"));
		paramMap.put("res_prod_seq"  , packageMap.get("PROD_SEQ"  ));

		// 예약 테이블 등록
		insertGbn = reservationMapper.insertTbReqBookingM(paramMap);
		
		if(insertGbn == 0) return insertGbn;

		return insertGbn;
	}

	// 멤버 예약요청 수정, 일반 예약신청 수정
	public int reservationUpdate_m(Map<String, Object> paramMap) throws Exception {
		long totalAmt        = 0;  // 총액
		long roomCharge      = 0;  // 숙박비
		long packageAmt      = 0;  // 패키지
		long sendingAmt      = 0;  // 미팅샌딩비
		long surchageAmt     = 0;  // 야간할증비
		long roomupAmt       = 0;  // room업그레이드 가격
		long lateCheckOutAmt = 0;  // lateCheckOut 가격
		int updateGbn = 0;

		// 회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시 
		String memGbn  = (String)paramMap.get("mem_gbn");
		if("01".equals(memGbn)) {  // 멤버
			paramMap.put("hdng_gbn"   , "28"               ); //숙박(멤버)
			// 예약등록 상품 조회(멤버숙박)
			Map<String, Object> prodMap = reservationMapper.getRoomProdInfo(paramMap);
			if(prodMap == null || prodMap.size() == 0) {
				return updateGbn;
			}
			// 숙박비
			Map<String, Object> memRoomChargeMap =  reservationMapper.memRoomChargeCalc(paramMap);
			if(memRoomChargeMap != null) {
				roomCharge = (long)Double.parseDouble(String.valueOf(memRoomChargeMap.get("MEM_ROOM_CHARGE")));
			}
			
			paramMap.put("res_bas_yy"    , prodMap.get("BAS_YY"    ));
			paramMap.put("res_bas_yy_seq", prodMap.get("BAS_YY_SEQ"));
			paramMap.put("res_prod_seq"  , prodMap.get("PROD_SEQ"  ));
			// 예약 테이블 수정
		} else { // 일반
			// 패키지 상품 정보 조회
			Map<String, Object> packageMap = reservationMapper.getPackageInfo(paramMap);
			if(packageMap == null || packageMap.size() == 0) {
				return updateGbn;
			}
			Map<String, Object> packageChageMap =  reservationMapper.packageCharge(paramMap);
			if(packageChageMap != null) {
				packageAmt = (long)Double.parseDouble(String.valueOf(packageChageMap.get("PACKAGE_AMT")));
			}

			paramMap.put("res_bas_yy"    , packageMap.get("BAS_YY"    ));
			paramMap.put("res_bas_yy_seq", packageMap.get("BAS_YY_SEQ"));
			paramMap.put("res_prod_seq"  , packageMap.get("PROD_SEQ"  ));
		}

		updateGbn = reservationMapper.updateTbReqBookingM(paramMap);

		if(updateGbn == 0) return updateGbn;

		// 미팅샌딩 상품 조회
		String pickGbn    = (String)paramMap.get("pick_gbn"    );  // 미팅샌딩 구분값 (01 미신청)

		// 이전 미팅샌딩 데이터 존재시 삭제
		reservationMapper.deleteTbReqPickup(paramMap);

		// 미팅샌딩 미신청 아닐 때
		if(!"01".equals(pickGbn)) {
			Map<String, Object> pickupMap = reservationMapper.getCarProdInfo(paramMap);
			if(pickupMap != null) {
				// 미팅샌딩 total 가격
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

				// 미팅샌딩 테이블 등록
				paramMap.put("car_num"     , pickupMap.get("CAR_NUM" ));
				paramMap.put("use_amt"     , pickupMap.get("COM_AMT" ));
				paramMap.put("car_prod_seq", pickupMap.get("PROD_SEQ"));

				updateGbn = reservationMapper.insertTbReqPickup(paramMap);
				if(updateGbn == 0) return updateGbn;
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
		totalAmt = roomCharge + packageAmt + sendingAmt + surchageAmt + roomupAmt + lateCheckOutAmt;
		paramMap.put("tot_amt", totalAmt);

		// 비용테이블 업데이트
		updateGbn = reservationMapper.updateTbReqFee(paramMap);
		if(updateGbn == 0) return updateGbn;

		// 이미지 업로드
		MultipartFile file = (MultipartFile)paramMap.get("file");
		if(file != null) {
			Map<String, Object>imageMap = commonService.imageUpload((MultipartFile)paramMap.get("file"));
			paramMap.putAll(imageMap);
			// 이미지테이블 등록
			updateGbn = reservationMapper.insertTbReqAddFile(paramMap);
			if(updateGbn == 0) return updateGbn;
		}

		return updateGbn;
	}

	// 일반 예약수정
	public int reservationUpdate(Map<String, Object> paramMap) throws Exception {
		int updateGbn = 0;

		// 패키지 상품 정보 조회
		Map<String, Object> packageMap = reservationMapper.getPackageInfo(paramMap);
		if(packageMap == null || packageMap.size() == 0) {
			return updateGbn;
		}

		paramMap.put("res_bas_yy"    , packageMap.get("BAS_YY"    ));
		paramMap.put("res_bas_yy_seq", packageMap.get("BAS_YY_SEQ"));
		paramMap.put("res_prod_seq"  , packageMap.get("PROD_SEQ"  ));

		// 예약 테이블 수정
		updateGbn = reservationMapper.updateTbReqBookingM(paramMap);

		if(updateGbn == 0) return updateGbn;

		return updateGbn;
	}

	// 멤버 예약 취소
	public int reservationCancel(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.reservationCancel(paramMap);
	}

	// 예약상세
	public Map<String, Object> reservationDetail(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.reservationDetail(paramMap);
	}

	// 예약상태 확인
	public String getPrcSts(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.getPrcSts(paramMap);
	}

	// 환불가능여부
	public Map<String, Object> getReFundInfo(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.getReFundInfo(paramMap);
	}
	
	// 동반자등록
	public int reservationPartnarInsert(List<Map<String, Object>> paramMap) throws Exception {
		return reservationMapper.reservationPartnarInsert(paramMap);
	}
	
	// 예약등록체크
	public Map<String, Object> reservationChk(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.reservationChk(paramMap);
	}
	
	// 동반자 예약 리스트
	public List<Map<String, Object>> reservationPartnarList(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.reservationPartnarList(paramMap);
	}
}
