package com.rrs.web.reservation.controller;

import com.rrs.comm.util.EgovDateUtil;
import com.rrs.web.reservation.service.ReservationService;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller("reservationController")
public class ReservationController {
	private static final Logger logger = LoggerFactory.getLogger(ReservationController.class);

	@Resource(name = "reservationService")
	ReservationService reservationService;

	@RequestMapping(value = "/reservationReq.do", method = RequestMethod.GET)
	public String reservationReq(HttpServletRequest req) throws Exception {
		return "reservation/reservationReq_m.view";
	}
	
	@RequestMapping(value = "/testImage3.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> testImage3(@RequestPart Map<String, Object> param, @RequestPart MultipartFile file) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		String savePath = "/opt/apache-tomcat-8.5.32/webapps/upload/";

		String toDay   = EgovDateUtil.getToday();
		String strYyyy = toDay.substring(0, 4) + "/";
		String strMm   = toDay.substring(4, 6) + "/";
		savePath = savePath + strYyyy + strMm;
		if(!new File(savePath).exists()) {
			try {
				new File(savePath).mkdir();
			} catch(Exception ex) {
				ex.printStackTrace();
			}
		}
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS"); //SSS가 밀리세컨드 표시
		Calendar calendar = Calendar.getInstance();
		String filePath = savePath + dateFormat.format(calendar.getTime()).toString();
		//file.getOriginalFilename();
		File realFile = new File(filePath);
		file.transferTo(realFile);
		realFile.setExecutable(true);
		realFile.setWritable  (true);
		realFile.setReadable  (true);
		rMap.put("result", "SUCCESS");
		return rMap;
	}

	@RequestMapping(value = "/testImage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> testImage(@RequestPart Map<String, Object> param, @RequestPart MultipartFile file) throws Exception {
		logger.info("/testImage.do");
		Map<String, Object> rMap = new HashMap<String, Object>();
		System.out.println(param.toString());
		if(!file.isEmpty()) {
			System.out.println("file size : " + file.getSize());
			System.out.println("file name : " + file.getName());
			System.out.println("file OriginalFilename : " + file.getOriginalFilename());

			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("fileNm"  , file.getOriginalFilename());
			paramMap.put("image"   , file.getBytes()           );
			paramMap.put("filePath", ""                        );

			reservationService.imageSave(paramMap);
		} else {
			System.out.println("File is Empty!!!!!!");
		}
		rMap.put("result", "SUCCESS");
		return rMap;
	}

	@RequestMapping(value = "/testImage2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> testImage2(@RequestParam Map<String, Object> param) throws Exception {
		logger.info("/testImage2.do");
		Map<String, Object> rMap = new HashMap<String, Object>();
		System.out.println(param.toString());
		rMap = reservationService.imageLoad(param);
		String fileNm  = (String)rMap.get("ADD_FILE_NM");
		String fileExt =  fileNm.substring(fileNm.lastIndexOf(".") + 1);
		String addPath = "data:image/" + ((fileExt == null || "".equals(fileExt)) ? "png" : fileExt) + ";base64,";
		rMap.put("ADD_PATH", addPath);
		rMap.put("result", "SUCCESS");
		return rMap;
	}
}
