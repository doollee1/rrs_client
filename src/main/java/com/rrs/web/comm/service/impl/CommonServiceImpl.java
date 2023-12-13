package com.rrs.web.comm.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;
import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
