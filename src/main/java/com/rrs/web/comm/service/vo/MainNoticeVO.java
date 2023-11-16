package com.rrs.web.comm.service.vo;

import com.rrs.web.comm.service.vo.MainNoticeVO;

public class MainNoticeVO {
  private int wr_id;
  
  private String wr_subject;
  
  private String wr_date;
  
  private String wr_contact;
  
  public int getWr_id() {
    return this.wr_id;
  }
  
  public void setWr_id(int wr_id) {
    this.wr_id = wr_id;
  }
  
  public String getWr_subject() {
    return this.wr_subject;
  }
  
  public void setWr_subject(String wr_subject) {
    this.wr_subject = wr_subject;
  }
  
  public String getWr_date() {
    return this.wr_date;
  }
  
  public void setWr_date(String wr_date) {
    this.wr_date = wr_date;
  }
  
  public String getWr_contact() {
    return this.wr_contact;
  }
  
  public void setWr_contact(String wr_contact) {
    this.wr_contact = wr_contact;
  }
}
