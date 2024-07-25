package com.rrs.comm.intercepter;

import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.core.HttpHeaders;

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
		logger.info("===== requestURI : "+requestURI);
		
		
		
		//웹취약점 점검처리
		List<String> webSpiderList = Arrays.asList("/main.do", "/findId.do", "/findPw.do", "/noticeList.do", "/policy.do",  "/productInfo.do"
						,"/qnaList.do", "/reservationList.do", "/reservationReq.do", "/resortInfo.do", "/setting.do", "/signIn.do", "/signOut.do", "/signUp.do");
		
		if(webSpiderList.indexOf(requestURI) >=0) {
			
			//Content-Security-Policy 헤더 추가 (경고 : Content Security Policy(CSP) Header Not Set	
			//response.setHeader("Content-Security-Policy", "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self'; font-src 'self'; object-src 'none'" );
			//response.setHeader("Content-Security-Policy", "form-action 'self'");
									
			//X-Frame-Options 추가(경고 : Missing Anti-clickjacking Header)
			response.setHeader("X-Frame-Options", "SAMEORIGIN");
			
			//Cookie 속성(Secure; SameSite=lax) 설정 (경고 : Cookie without SameSite Attribute)
			addSameSite(response,  "lax");
			
			//X-Content-Type-Options 헤더 추가(경고 : X-Content-Type-Options Header Missing)
			response.setHeader("X-Content-Type-Options", "nosniff");
		}
		
				
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
												, "/infoChange.do" // 내정보변경
												, "/initRsaAjax.do" // RSA초기화
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
	
	
	/**
	 * 웹취약점 점검처리(Cookie without SameSite Attribute)
	 * 
	 * @param response
	 * @param sameSite
	 */
	private void addSameSite(HttpServletResponse response, String sameSite) {
    	
        Collection<String> headers = response.getHeaders(HttpHeaders.SET_COOKIE);
        boolean firstHeader = true;
        for (String header : headers) { // there can be multiple Set-Cookie attributes
            if (firstHeader) {
                response.setHeader(HttpHeaders.SET_COOKIE, String.format("%s; Secure; %s", header, "SameSite=" + sameSite));
                firstHeader = false;
                continue;
            }
            response.addHeader(HttpHeaders.SET_COOKIE, String.format("%s; Secure; %s", header, "SameSite=" + sameSite));
        }
	}
	
}	
