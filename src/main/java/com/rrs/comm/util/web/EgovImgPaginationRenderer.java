package com.rrs.comm.util.web;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;
import javax.servlet.ServletContext;
import org.springframework.web.context.ServletContextAware;

import com.rrs.comm.util.web.EgovImgPaginationRenderer;

public class EgovImgPaginationRenderer extends AbstractPaginationRenderer implements ServletContextAware {
  private ServletContext servletContext;
  
  public void initVariables() {
    this.firstPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\"><image src='" + this.servletContext.getContextPath() + "/images/egovframework/cmmn/btn_page_pre10.gif' border=0/></a>&#160;";
    this.previousPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\"><image src='" + this.servletContext.getContextPath() + "/images/egovframework/cmmn/btn_page_pre1.gif' border=0/></a>&#160;";
    this.currentPageLabel = "<strong>{0}</strong>&#160;";
    this.otherPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\">{2}</a>&#160;";
    this.nextPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\"><image src='" + this.servletContext.getContextPath() + "/images/egovframework/cmmn/btn_page_next1.gif' border=0/></a>&#160;";
    this.lastPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\"><image src='" + this.servletContext.getContextPath() + "/images/egovframework/cmmn/btn_page_next10.gif' border=0/></a>&#160;";
  }
  
  public void setServletContext(ServletContext servletContext) {
    this.servletContext = servletContext;
    initVariables();
  }
}
