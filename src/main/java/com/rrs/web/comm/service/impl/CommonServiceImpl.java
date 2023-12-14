package com.rrs.web.comm.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.annotation.Resource;

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

	public List<Map<String, Object>> commCodeList(Map<String, Object> paramMap) throws Exception {
		return commonMapper.commCodeList(paramMap);
	}

	public void telegramMsgSend(String msg) {
		BufferedReader in = null;
		try {
			List<String> chatIdList = commonMapper.getChatIdList();
			if(chatIdList != null && (chatIdList.size() > 0)) {
				String token = properties.getProperty("TELEGRAM.TOKEN");
				String message = "";
				if(msg != null && !"".equals(msg)) {
					message = URLEncoder.encode(msg, "UTF-8");
				}
				for(String chatId : chatIdList) {
					URL url = new URL("https://api.telegram.org/bot" + token + "/sendmessage?chat_id=" + chatId + "&text=" + message); // 호출할 url
					HttpURLConnection con = (HttpURLConnection)url.openConnection();
					con.setRequestMethod("GET");
					in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(in != null) try { in.close(); } catch(Exception e) { e.printStackTrace(); }
		}
	}

	public Map<String, Object> imageUpload(MultipartFile image) {
		Map<String, Object> rMap = new HashMap<String, Object>();
		try {
			String path = properties.getProperty("UPLOAD.PATH");  //업로드 기존 path
			rMap.put("add_file_path", path);
			String toDay   = EgovDateUtil.getToday();
			String strYyyy = toDay.substring(0, 4) + "/";
			String strMm   = toDay.substring(4, 6) + "/";
			rMap.put("add_file_path2", strYyyy + strMm);
			rMap.put("add_file_real_nm", image.getOriginalFilename());
			path = path + strYyyy;
			if(!new File(path).exists()) {
				new File(path).mkdir(); // 년폴더
				if(!new File(path + strMm).exists()) {
					new File(path + strMm).mkdir(); // 월폴더
				}
			}
			path = path + strMm;
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS"); //SSS가 밀리세컨드 표시
			Calendar calendar = Calendar.getInstance();
			String fileNm   = dateFormat.format(calendar.getTime()).toString() + "." + image.getOriginalFilename().substring(image.getOriginalFilename().lastIndexOf(".") + 1);
			rMap.put("add_file_nm", fileNm);
			String filePath = path + fileNm;
			File realFile = new File(filePath);
			image.transferTo(realFile);
			realFile.setExecutable(true);
			realFile.setWritable  (true);
			realFile.setReadable  (true);
		} catch(Exception e) {
			e.printStackTrace();
			return null;
		}
		return rMap;
	}
}
