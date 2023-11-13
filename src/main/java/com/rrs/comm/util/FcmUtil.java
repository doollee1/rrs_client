package com.rrs.comm.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.api.Context;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.AndroidConfig;
import com.google.firebase.messaging.AndroidNotification;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.rrs.web.DlController;

public class FcmUtil {
	private static final Logger logger = LoggerFactory.getLogger(FcmUtil.class);
	
	public String send_FCM(String fcmPath, String fcmFile, String tokenId, String title, String content) {
		String errorCode = "call Error" ;
		try {
			String filePath  = fcmPath; 
			String fileName  = fcmFile;
			//FileInputStream refreshToken = new FileInputStream(filePath + File.separator + fileName);
			InputStream refreshToken = getClass().getResourceAsStream("/" + filePath + fileName);
			
			FirebaseOptions options = new FirebaseOptions.Builder()
					.setCredentials(GoogleCredentials.fromStream(refreshToken))
					.setDatabaseUrl("https://fcm.googleapis.com/fcm/send")
					.build();

			//FirebaseApp 처음 호출시에만 initializing
			if(FirebaseApp.getApps().isEmpty()) {
				FirebaseApp.initializeApp(options);
			}

			//String registrationToken = 안드로이드 토큰 입력
			String registratoinToken = tokenId;

			//message
			Message msg = Message.builder()
					.setAndroidConfig(AndroidConfig.builder()
							.setTtl(3600 * 1000)
							.setPriority(AndroidConfig.Priority.NORMAL)
							.setNotification(AndroidNotification.builder()
									.setTitle(title)
									.setBody(content)
									.setIcon("stock_ticker_update")
									.setColor("#f45342")
									.build())
							.build())
					.setToken(registratoinToken)
					.build();
			
			//메시지를 FirebaseMessaging에 보내기
			String resp = FirebaseMessaging.getInstance().send(msg);

			//결과
			logger.debug("Firebase message sent: {}", resp.toString());

			errorCode = "";
			
		} catch(FirebaseMessagingException e) {
			logger.error("Error sending firebase notification: {}", e.getErrorCode(), e);
			errorCode = "FirebaseMessagingException" ;
		} catch(Exception e) {
			logger.error("Error sending firebase notification: {}", e.getMessage(), e);
		}
		
		return errorCode ;
	}
	
}
