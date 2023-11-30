package com.rrs.web.reservation.controller;

import com.rrs.web.reservation.service.ReservationService;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.net.SocketException;
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
	public Map<String, Object> testImage3(@RequestPart MultipartFile file) throws Exception {
		Map<String, Object> rMap = new HashMap<String, Object>();
		String savePath = "/opt/tomcat/webapps/upload/";
		if(!new File(savePath).exists()) {
			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ XXXXXXXX");
			try {
				System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22222222 XXXXXXXX");
				new File(savePath).mkdir();
			} catch(Exception ex) {
				ex.printStackTrace();
			}
		}
		String filePath = savePath + file.getOriginalFilename();
		file.transferTo(new File(filePath));
		
		
		
		
		
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
