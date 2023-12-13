package com.rrs.web.reservation.service;

import java.util.*;

public interface ReservationService {
	int imageSave(Map<String, Object> param) throws Exception;

	Map<String, Object> memRoomChargeCalc(Map<String, Object> param) throws Exception;

	Map<String, Object> sendingCalc(Map<String, Object> param) throws Exception;

	Map<String, Object> surchageCalc(Map<String, Object> param) throws Exception;

	Map<String, Object> roomupCalc(Map<String, Object> param) throws Exception;

	Map<String, Object> lateCheckOutCalc(Map<String, Object> param) throws Exception;

	int reservationStep1_m(Map<String, Object> param) throws Exception;

	Map<String, Object> imageLoad(Map<String, Object> param) throws Exception;
}
