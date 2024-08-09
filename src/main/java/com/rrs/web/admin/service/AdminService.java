/**
 * 
 */
package com.rrs.web.admin.service;

import java.util.List;
import java.util.Map;

/**
 * 관리자 서비스 선언부
 * 
 * @author DOOLLEE2
 *
 */
public interface AdminService {

	/**
	 * 관리자 예약목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> adminReservationList(Map<String, Object> param) throws Exception;
	
	/**
	 * 관리자 예약상태변경 상세보기
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> adminProdDetail(Map<String, Object> param) throws Exception;
	
	/**
	 * 관리자 예약상태변경 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> prcStsUpdate(Map<String, Object> list) throws Exception;

	/**
	 * 관리자 이미지업로드 목록 조회
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> adminImageUploadList(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 관리자 다중 이미지 등록
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> adminImageReservation(List<Map<String, Object>> param) throws Exception;
	
	/**
	 * 관리자 상태변경목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> adminProdReservation(Map<String, Object> param) throws Exception;
	
}
