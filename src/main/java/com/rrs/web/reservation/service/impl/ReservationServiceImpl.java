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

	// 멤버 숙방비 계산
	public Map<String, Object> memRoomChargeCalc(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.memRoomChargeCalc(paramMap);
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

	// 멤버 예약등록 step1
	public int reservationStep1_m(Map<String, Object> paramMap) throws Exception {
		return 0;
	}

	public Map<String, Object> imageLoad(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.imageLoad(paramMap);
	}
}
