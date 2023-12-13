package com.rrs.web.reservation.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.Map;

@Mapper("reservationMapper")
public interface ReservationMapper {
	int imageSave(Map<String, Object> paramMap) throws Exception;

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

	Map<String, Object> imageLoad(Map<String, Object> paramMap) throws Exception;
}
