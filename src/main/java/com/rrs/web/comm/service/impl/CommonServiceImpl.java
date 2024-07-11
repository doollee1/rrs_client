package com.rrs.web.comm.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.rrs.comm.util.EgovDateUtil;
import com.rrs.web.comm.service.CommonService;

@Service("commonService")
public class CommonServiceImpl implements CommonService {
	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;
	
	@Autowired
	private Properties properties;

	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);
	
	public List<Map<String, Object>> commCodeList(Map<String, Object> paramMap) throws Exception {
		return commonMapper.commCodeList(paramMap);
	}

	
	/**
	 * 텔리그램 전송
	 */
	public String  telegramMsgSend(String msg) {

		logger.info("=========== 텔리그램 전송 ===========");
		
		BufferedReader in = null;
		try {
			List<Map<String, Object>> chatIdList = commonMapper.getChatIdList();
			if(chatIdList != null && (chatIdList.size() > 0)) {
				
				//String token = properties.getProperty("TELEGRAM.TOKEN");
				String message = "";
				if(msg != null && !"".equals(msg)) {
					message = URLEncoder.encode(msg, "UTF-8");
				}
				
								
				//텔리그램 전송
				for(Map<String, Object> map : chatIdList) {
					
					logger.info("map : "+map.toString());
					
					String token  = map.get("TELEGRAM_TOKEN").toString().trim();
					String chatId = map.get("CHAT_ID").toString();
					
					//채팅방 확인
					URL url = new URL("https://api.telegram.org/bot" + token + "/getUpdates"); // 호출할 url
					HttpURLConnection con = (HttpURLConnection)url.openConnection();
					con.setRequestMethod("GET");
					in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
					
					String contents="";
					String input;
					while((input = in.readLine()) != null) {
						contents += input;
					}
							
					
					JSONParser jsonParser = new JSONParser();
					JSONObject jsonObj = (JSONObject) jsonParser.parse(contents);
					logger.info("채팅방 결과 : "+jsonObj.toJSONString());
					
					boolean okJson = (boolean) jsonObj.get("ok");
					logger.info("ok : "+okJson);
					
					//응답결과 false
					//if(!okJson) {
						//return "N";
					//}
					
					JSONArray jsonArray = (JSONArray) jsonObj.get("result");
					int size = jsonArray.size();
					logger.info("채팅방 갯수 : "+size);
					
					
					//채팅방이 없을 경우
					//if(size < 1) {
						//return "N";
					//}
					
					//텔리그램 전송
					url = new URL("https://api.telegram.org/bot" + token + "/sendmessage?chat_id=" + chatId + "&text=" + message); // 호출할 url
					con = (HttpURLConnection)url.openConnection();
					con.setRequestMethod("GET");
					in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(in != null) try { in.close(); } catch(Exception e) { e.printStackTrace(); }
		}
		
		return "Y";
	}

	
	/**
	 * 항공권이미지 업로드
	 */
	public Map<String, Object> imageUpload(MultipartFile image) {
		Map<String, Object> rMap = new HashMap<String, Object>();
				
		try {
			//로컬여부 확인
			InetAddress addr = InetAddress.getLocalHost();
			String strIp = addr.getHostAddress();
			logger.info("===== IP : "+strIp);
			String isLocalYn = strIp.startsWith("192") ? "Y" : "N";
			
			
			String path  = properties.getProperty("UPLOAD.PATH"    );  //업로드 기존 path
			
			//로컬일 경우 경로, 년, 월 구분자'/'을 "\\"로 변환
			path = "Y".equals(isLocalYn) ? "C:\\opt\\tomcat\\webapps\\upload\\" : path;
			
			String path2 = properties.getProperty("UPLOAD.NAS_PATH");  //업로드 기존 path(NAS)
			rMap.put("add_file_path", path2);
									
			String toDay   = EgovDateUtil.getToday();
			String strYyyy = toDay.substring(0, 4) + File.separator;    // 기존"/"
			String strMm   = toDay.substring(4, 6) + File.separator;    // 기존 "/"
						
			
			rMap.put("add_file_path2", strYyyy + strMm);
			rMap.put("add_file_real_nm", image.getOriginalFilename());
			
			path = path + strYyyy;								
			logger.info("===== 파일 현재년 Path : "+path);			
			logger.info("===== 파일 현재년 Path 유무 : "+new File(path).exists());
			
			
			//폴더가 없을경우 폴더 생성
			if(!new File(path).exists()) {
				new File(path).mkdir(); // 년폴더								
			}
			
			
			path = path + strMm;
			logger.info("===== 파일 현재월 Path : "+path);
			logger.info("===== 파일 현재월 Path 유무 : "+new File(path).exists());
			
			
			if(!new File(path).exists()) {
				new File(path).mkdir(); // 월폴더
			}
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS"); //SSS가 밀리세컨드 표시
			Calendar calendar = Calendar.getInstance();
			String fileNm   = dateFormat.format(calendar.getTime()).toString() + "." + image.getOriginalFilename().substring(image.getOriginalFilename().lastIndexOf(".") + 1);
			rMap.put("add_file_nm", fileNm);
									
			String filePath = path + fileNm;
			logger.info("====== filePath : "+filePath);
			
			//파일 전송
			File realFile = new File(filePath);
			image.transferTo(realFile);
			
			//파일 권한설정
			realFile.setExecutable(true, false);
			realFile.setWritable  (true, false);
			realFile.setReadable  (true, false);
			
		} catch(Exception e) {
			e.printStackTrace();
			return rMap;
		}
		return rMap;
	}
	
	
	/**
	 * 클라이언트IP 확인
	 * 
	 * @param request
	 * @return
	 */
	public String getClientIP(HttpServletRequest request) {
		
		logger.info("===== 클라이언트IP 확인 =====");
		
	    String ip = request.getHeader("X-Forwarded-For");
	    logger.info("> X-FORWARDED-FOR : " + ip);

	    if (ip == null) {
	        ip = request.getHeader("Proxy-Client-IP");
	        logger.info("> Proxy-Client-IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
	        logger.info(">  WL-Proxy-Client-IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_CLIENT_IP");
	        logger.info("> HTTP_CLIENT_IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	        logger.info("> HTTP_X_FORWARDED_FOR : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getRemoteAddr();
	        logger.info("> getRemoteAddr : "+ip);
	    }
	    logger.info("> Result : IP Address : "+ip);

	    return ip;
	}
}
