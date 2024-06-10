/**
 * 
 */
package com.rrs.web.admin.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 관리자 Mapper
 * 
 * @author DOOLLEE2
 *
 */
@Mapper("adminMapper")
public interface AdminMapper {

	//관리자 예약목록 조회
	List<Map<String, Object>> adminReservationList(Map<String, Object> paramMap) throws Exception;
	
	
	//관리자 이미지업로드 목록 조회
	List<Map<String, Object>> adminImageUploadList(Map<String, Object> paramMap) throws Exception;
	
	
	//예약상세 업데이트
	int updateBookingD(Map<String, Object> paramMap) throws Exception;
	
}
