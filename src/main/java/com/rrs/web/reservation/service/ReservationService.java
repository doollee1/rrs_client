package com.rrs.web.reservation.service;

import java.util.*;

public interface ReservationService {
	int imageSave(Map<String, Object> param) throws Exception;

	Map<String, Object> imageLoad(Map<String, Object> param) throws Exception;
}
