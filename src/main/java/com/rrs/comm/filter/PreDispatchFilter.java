package com.rrs.comm.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.filter.GenericFilterBean;



/**
 * 디스패처 필터
 * 
 * @author DOOLLEE2
 *
 */
public class PreDispatchFilter extends GenericFilterBean {

	private static final Logger logger = LoggerFactory.getLogger(PreDispatchFilter.class);
	
	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		//logger.info("====== PreDispatchFilter ======");		
		
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		
		String requestUri = request.getRequestURI().toLowerCase().trim();		
		//logger.info("====== doFilter.requestUri : "+requestUri );
		
		if(requestUri.endsWith(".txt") || requestUri.endsWith(".xml")) {	
			//Cookie 속성(Secure; SameSite=lax) 설정 (경고 : Cookie without SameSite Attribute)
			return;
		}
		
		
		
		if(requestUri.endsWith(".css") || requestUri.endsWith(".jpg") 
				|| requestUri.endsWith(".png")	|| requestUri.endsWith(".gif") || requestUri.endsWith(".js") ) {
			
			//X-Content-Type-Options 헤더 추가(경고 : X-Content-Type-Options Header Missing)
			response.setHeader("X-Content-Type-Options", "nosniff"); 
		}				
		
		chain.doFilter(req, res);
	}
		
}
