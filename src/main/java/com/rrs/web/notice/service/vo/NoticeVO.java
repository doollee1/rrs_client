package com.rrs.web.notice.service.vo;

public class NoticeVO {
	
	private int notice_seq;			//순번
	private String title;			//제목
	private String content;			//내용
	private String reg_sts;			//상태 (1대기,2게시,3숨김)
	private String reg_dt;			//등록일자
	private String st_dt;			//시작일자
	private String ed_dt;			//종료일자
	
	public int getNotice_seq() {
		return notice_seq;
	}
	public void setNotice_seq(int notice_seq) {
		this.notice_seq = notice_seq;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getReg_sts() {
		return reg_sts;
	}
	public void setReg_sts(String reg_sts) {
		this.reg_sts = reg_sts;
	}
	public String getReg_dt() {
		return reg_dt;
	}
	public void setReg_dt(String reg_dt) {
		this.reg_dt = reg_dt;
	}
	public String getSt_dt() {
		return st_dt;
	}
	public void setSt_dt(String st_dt) {
		this.st_dt = st_dt;
	}
	public String getEd_dt() {
		return ed_dt;
	}
	public void setEd_dt(String ed_dt) {
		this.ed_dt = ed_dt;
	}
	
}
