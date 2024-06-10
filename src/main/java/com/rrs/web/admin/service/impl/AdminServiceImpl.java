/**
 * 
 */
package com.rrs.web.admin.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.rrs.web.admin.service.AdminService;
import com.rrs.web.comm.service.CommonService;
import com.rrs.web.reservation.service.impl.ReservationMapper;

/**
 * 관리자 서비스 구현부
 * 
 * @author DOOLLEE2
 *
 */
@Service("adminService")
public class AdminServiceImpl implements AdminService {

	private static final Logger logger = LoggerFactory.getLogger(AdminServiceImpl.class);
	
	@Resource(name = "adminMapper")
	private AdminMapper adminMapper;   //관리자 Mapper
	
	@Resource(name = "reservationMapper")
	private ReservationMapper reservationMapper;  //예약 Mapper
	
	@Resource(name = "commonService")
	CommonService commonService;	   //공통 서비스	
	/**
	 * 관리자 예약목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> adminReservationList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		
		logger.info("========== 관리자 예약목록 조회 서비스 ==========");
		
		//최초 조회일자가 없을시
		if(param.isEmpty()) {
			
			String endDt   = new SimpleDateFormat("yyyyMMdd").format(new Date());
			String startDt = endDt.substring(0, 6) + "01";
					
			logger.info("===== startDt : "+startDt);
			logger.info("===== endDt   : "+endDt);
						
			
			//조회 파라미터 세팅
			param.put("start_dt", startDt);
			param.put("end_dt", endDt);
			
		}
						
		return adminMapper.adminReservationList(param);
	}


	/**
	 * 관리자 이미지업로드 목록 조회
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> adminImageUploadList(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		
		logger.info("========== 관리자 이미지업로드 목록 조회 서비스 ==========");
		
		return adminMapper.adminImageUploadList(paramMap);
	}


	/**
	 * 관리자 다중 이미지등록 
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> adminImageReservation(List<Map<String, Object>> list) throws Exception {
		// TODO Auto-generated method stub
		logger.info("========== 관리자 다중 이미지등록 서비스 ==========");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		for(Map<String, Object> paramMap : list) {
			
			// 이미지 업로드
			Map<String, Object>imageMap = commonService.imageUpload((MultipartFile)paramMap.get("file"));
			paramMap.putAll(imageMap);
			
			
			// 이미지테이블 등록 결과
			int resultImgReg = reservationMapper.insertTbReqAddFile(paramMap);
			logger.info("===== 이미지테이블 등록결과 : "+resultImgReg);
			
			if(resultImgReg < 1) {
				
				resultMap.put("result", "FAIL");
				return resultMap;
			}
			
			
			//예약상세  업데이트(첨부파일일련번호, 동반자한글명, 동반자영문명, 동반자전화번호)
			int resultBookingDUpd = adminMapper.updateBookingD(paramMap);
			logger.info("===== 예약상세 업데이트결과 : "+resultBookingDUpd);
			
			if(resultBookingDUpd < 1) {
				
				resultMap.put("result", "FAIL");
				return resultMap;
			}
			
		}
		
		//성공
		resultMap.put("result", "SUCCESS");
		return resultMap;
	}

}
