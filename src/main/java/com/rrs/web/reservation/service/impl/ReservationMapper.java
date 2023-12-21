package com.rrs.web.reservation.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;
import java.util.Map;

@Mapper("reservationMapper")
public interface ReservationMapper {
	// 멤버 숙박비 계산
	List<Map<String, Object>> reservationList(Map<String, Object> paramMap) throws Exception;

	// 멤버 숙박비 계산
	Map<String, Object> memRoomChargeCalc(Map<String, Object> paramMap) throws Exception;

	// 미팅센딩비 계산
	Map<String, Object> sendingCalc(Map<String, Object> paramMap) throws Exception;

	// 야간할증비 계산
	Map<String, Object> surchageCalc(Map<String, Object> paramMap) throws Exception;

	// roomup 계산
	Map<String, Object> roomupCalc(Map<String, Object> paramMap) throws Exception;

	// lateCheckOut 계산
	Map<String, Object> lateCheckOutCalc(Map<String, Object> paramMap) throws Exception;

	// 예약등록 상품 조회(멤버숙박)
	Map<String, Object> getRoomProdInfo(Map<String, Object> paramMap) throws Exception;

	// 예약등록 픽업 상품 조회
	Map<String, Object> getCarProdInfo(Map<String, Object> paramMap) throws Exception;

	// 예약 취소
	int reservationCancel(Map<String, Object> paramMap) throws Exception;

	// 예약테이블 등록
	int insertTbReqBookingM(Map<String, Object> paramMap) throws Exception;

	// 예약테이블 수정
	int updateTbReqBookingM(Map<String, Object> paramMap) throws Exception;

	// 미팅센딩 테이블 등록
	int insertTbReqPickup(Map<String, Object> paramMap) throws Exception;

	// 미팅샌딩테이블 삭제
	int deleteTbReqPickup(Map<String, Object> paramMap) throws Exception;

	// 비용 테이블 등록
	int insertTbReqFee(Map<String, Object> paramMap) throws Exception;

	// 비용 테이블 수정
	int updateTbReqFee(Map<String, Object> paramMap) throws Exception;

	// 예약첨부파일(항공권) 등록
	int insertTbReqAddFile(Map<String, Object> paramMap) throws Exception;

	// 예약상세
	Map<String, Object> reservationDetail(Map<String, Object> paramMap) throws Exception;

	// 예약상태 확인
	String getPrcSts(Map<String, Object> paramMap) throws Exception;
}
