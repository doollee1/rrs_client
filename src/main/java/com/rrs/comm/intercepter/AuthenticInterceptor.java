package com.rrs.comm.intercepter;

import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
	
}
