package com.rrs.comm.intercepter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

public class AuthenticInterceptor extends WebContentInterceptor {
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
    HttpSession session = request.getSession();
    String loginYn = (String)session.getAttribute("loginYn");
    if ("Y".equals(loginYn))
      return true; 
    ModelAndView modelAndView = new ModelAndView("redirect:/go_Login.do");
    throw new ModelAndViewDefiningException(modelAndView);
  }
}
