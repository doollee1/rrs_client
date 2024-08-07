package com.rrs.web.reservation.service;

import java.util.*;

public interface ReservationService {
	String getPrcSts (Map<String, Object> param) throws Exception;

	Map<String, Object> getReFundInfo(Map<String, Object> param) throws Exception;

	Map<String, Object> memRoomChargeCalc(Map<String, Object> param) throws Exception;

	Map<String, Object> getRoomProdInfo(Map<String, Object> param) throws Exception;

	Map<String, Object> getPackageInfo(Map<String, Object> param) throws Exception;

	Map<String, Object> packageCharge(Map<String, Object> param) throws Exception;

	Map<String, Object> nokidChargeCalc(Map<String, Object> param) throws Exception;
	
	Map<String, Object> getCarProdInfo(Map<String, Object> param) throws Exception;

	Map<String, Object> sendingCalc(Map<String, Object> param) throws Exception;

	Map<String, Object> surchageCalc(Map<String, Object> param) throws Exception;

	Map<String, Object> roomupCalc(Map<String, Object> param) throws Exception;
	
	Map<String, Object> lateCheckInCalc(Map<String, Object> param) throws Exception;

	Map<String, Object> lateCheckOutCalc(Map<String, Object> param) throws Exception;

	int reservationInsert1(Map<String, Object> param) throws Exception;

	int reservationInsert(Map<String, Object> param) throws Exception;

	int reservationUpdate_m(Map<String, Object> param) throws Exception;

	int reservationUpdate(Map<String, Object> param) throws Exception;

	int reservationCancel(Map<String, Object> param) throws Exception;

	int insertTbReqAddFile(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> reservationList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> packageList() throws Exception;

	Map<String, Object> reservationDetail(Map<String, Object> param) throws Exception;
	
	int reservationComInsert(List<Map<String, Object>> param) throws Exception;
	
	Map<String, Object> reservationChk(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> reservationComList(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> noRoomChk(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> packageListReset(Map<String, Object> param) throws Exception;
}
