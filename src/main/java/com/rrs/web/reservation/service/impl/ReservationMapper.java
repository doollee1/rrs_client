package com.rrs.web.reservation.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

import com.rrs.web.comm.service.vo.MainContactVO;
import com.rrs.web.comm.service.vo.MainNoticeVO;
import com.rrs.web.comm.service.vo.ProjectVO;
import com.rrs.web.login.service.vo.LoginVO;

@Mapper("reservationMapper")
public interface ReservationMapper {
	int imageSave(Map<String, Object> paramMap) throws Exception;

	Map<String, Object> imageLoad(Map<String, Object> paramMap) throws Exception;
}
