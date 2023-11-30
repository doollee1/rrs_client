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

	public Map<String, Object> imageLoad(Map<String, Object> paramMap) throws Exception {
		return reservationMapper.imageLoad(paramMap);
	}
}
