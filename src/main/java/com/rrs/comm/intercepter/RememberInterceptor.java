/**
 * 
 */
package com.rrs.comm.intercepter;

import javax.inject.Inject;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.ObjectUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

import com.rrs.web.sign.service.SignService;
import com.rrs.web.sign.service.vo.SignVO;

/**
 * 자동로그인 인터셋터
 * 
 * @author kwook
 *
 */
public class RememberInterceptor extends HandlerInterceptorAdapter {
	
	private static final Logger logger = LoggerFactory.getLogger(RememberInterceptor.class);
	
	@Inject
	SignService signService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		// TODO Auto-generated method stub
		logger.info("======== 자동로그인 인터셋터 preHandler ========");
		
		HttpSession httpSession = request.getSession();
		
		Cookie[] cookies = request.getCookies(); //client에서 쿠키를 받아옴
		logger.info("===== cookie 객수 :" +cookies.length);
		
		Cookie loginCookie = null;
				
		if(cookies!=null){
		    for(int i=0;i<cookies.length;i++){
		    	
		    	String cookieName = cookies[i].getName();
	            String cookieValue = cookies[i].getValue();
	            
	            logger.info("===== cookie 명 :" +cookieName);
	            logger.info("===== cookie 값 :" +cookieValue);
	            
		        if(cookieName.equals("RRSCLIENTSESSION")){
		        	loginCookie = cookies[i];
		        }
		    }
		}
		
        //Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
        logger.info("===== loginCookie : "+loginCookie);
        
        //loginCookie가 null 이 아닐시
		if(!ObjectUtils.isEmpty(loginCookie)) {
			
			SignVO signVo = signService.checkUserWithSessionKey(loginCookie.getValue());
			logger.info("===== signVo : "+signVo);
			
			if(!ObjectUtils.isEmpty(signVo)) {
				httpSession.setAttribute("login", signVo);
			}
			
		}
		
		return true;
	}
	
	

}
