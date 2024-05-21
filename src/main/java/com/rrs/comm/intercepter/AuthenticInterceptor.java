package com.rrs.comm.intercepter;

import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.ObjectUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.rrs.web.sign.service.vo.SignVO;


/**
 * 인증 인터셉터 
 * 
 * @author kwook
 *
 */
public class AuthenticInterceptor extends HandlerInterceptorAdapter {
	
	private static final Logger logger = LoggerFactory.getLogger(AuthenticInterceptor.class);
			
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		logger.info("======== 인증 인터셋터 preHandle ========");
		
		boolean result = true;
		HttpSession session = request.getSession();
		SignVO login = (SignVO)session.getAttribute("login");
		String requestURI = request.getRequestURI(); // 요청 URI
		List<String> excludeList = Arrays.asList("/main.do"  // 메인 페이지
												, "/noticeList.do" // 공지사항
												, "/noticeView.do" // 공지사항 상세
												, "/resortInfo.do"	// 리조트&골프장 소개
												, "/signIn.do"      // 로그인
												, "/signOut.do"     // 로그아웃
												, "/findId.do"      // 아이디찾기
												, "/signUpIdChk.do" // 중복체크
												, "/findPw.do"      // 비밀번호 찾기
												, "/signUp.do"      // 회원가입
												, "/policy.do"     // 개인정보정책 
												);
		if (excludeList.indexOf(requestURI) < 0) {
			if(login == null) {
				if (request.getHeader("HEADER") != null) {
					// Ajax일 경우
					response.sendError(999);
					result = false;
				} else {
					response.setContentType("text/html; charset=UTF-8");
		            PrintWriter out = response.getWriter();
		            out.println("<script>alert('로그인을 해 주세요.'); location.href='/main.do';</script>");
		            out.flush();
		            result = false;
				}
			}
		}
		return result;
	}

	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		
		logger.info("======== 인증 인터셋터 postHandle ========");
		
		String requestURI = request.getRequestURI(); // 요청 URI
		logger.info("===== requestURI : "+requestURI);
		
		//로그인시 처리
		if("/signIn.do".equals(requestURI) && "POST".equals(request.getMethod())) {
			
			HttpSession httpSession = request.getSession();
			//ModelMap modelMap = modelAndView.getModelMap();
			//Object signVo = modelMap.get("login");
	        SignVO signVo = (SignVO)httpSession.getAttribute("login");		
			
	        logger.info("===== signVo : "+signVo);
	        
			//signVO가 null이 아닐시
	        if(!ObjectUtils.isEmpty(signVo)) {
	        	
	        	logger.info("===== new Login Process");
	        	httpSession.setAttribute("login", signVo);
	             
	        	logger.info("===== useCookie : "+request.getParameter("useCookie"));
	        	if(request.getParameter("useCookie")!=null) {
	             	
	        		logger.info("====== remember me....");
	        		
	        		//쿠키생성
	        		String sessionId = httpSession.getId();
	             	Cookie loginCookie = new Cookie("loginCookie", sessionId);
	             	logger.info("===== sessionId : "+sessionId);
	             	
	             	loginCookie.setPath("/");
	             	loginCookie.setMaxAge(60*60*24*1);   //자동로그인 1일
	             	
	             	//전송
	             	response.addCookie(loginCookie);
	             }
	        	
	        	//루트로 이동
	        	//response.sendRedirect("/");        	
	        }
	        
		}
		
		
	}
	
	
	
}
