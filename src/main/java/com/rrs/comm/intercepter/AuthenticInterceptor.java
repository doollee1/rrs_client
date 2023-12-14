package com.rrs.comm.intercepter;

import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.rrs.web.sign.service.vo.SignVO;

public class AuthenticInterceptor extends HandlerInterceptorAdapter {
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		boolean result = true;
		HttpSession session = request.getSession();
		SignVO login = (SignVO)session.getAttribute("login");
		String requestURI = request.getRequestURI(); // 요청 URI
		List<String> excludeList = Arrays.asList("/main.do"  // 메인 페이지
												, "/productInfo.do" // 상품소개
												, "/signIn.do"      // 로그인
												, "/signOut.do"     // 로그아웃
												, "/findId.do"      // 아이디찾기
												, "/signUpIdChk.do" // 중복체크
												, "/findPw.do"      // 비밀번호 찾기
												, "/signUp.do"      // 회원가입
												);
		if (excludeList.indexOf(requestURI) < 0) {
			if(login == null) {
				if (request.getHeader("HEADER") != null) {
					// Ajax일 경우
					response.sendError(999);
					result = false;
				} else {
					response.sendRedirect("/main.do");
					result = false;
				}
			}
		}
		return result;
	}
}
