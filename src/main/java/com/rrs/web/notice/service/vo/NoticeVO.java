package com.rrs.web.notice.service.vo;

public class NoticeVO {
	
	private int notice_no;			//순번
	private String title;			//제목
	private String notice_tp;		//게시판종류 01 : System, 02 : General
	private String contents;		//내용
	private int cnt;				//조회수
	private String fromDate;		//시작일자
	private String toDate;			//종료일자
	private String file_uid;		//파일ID
	private String file_nm;		    //파일명
	private String status;			//게시상태 : 'A' 하드코딩
	private String reg_dt;			//등록일자
	private String reg_id;			//등록자
	private String upt_dt;			//수정일자
	private String upt_id;			//수정자
	
	public int getNotice_no() {
		return notice_no;
	}
	public void setNotice_no(int notice_seq) {
		this.notice_no = notice_seq;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getNotice_tp() {
		return notice_tp;
	}
	public void setNotice_tp(String notice_tp) {
		this.notice_tp = notice_tp;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getFromDate() {
		return fromDate;
	}
	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}
	public String getToDate() {
		return toDate;
	}
	public void setToDate(String toDate) {
		this.toDate = toDate;
	}
	public String getFile_uid() {
		return file_uid;
	}
	public void setFile_uid(String file_uid) {
		this.file_uid = file_uid;
	}		
	public String getFile_nm() {
		return file_nm;
	}
	public void setFile_nm(String file_nm) {
		this.file_nm = file_nm;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getReg_dt() {
		return reg_dt;
	}
	public void setReg_dt(String reg_dt) {
		this.reg_dt = reg_dt;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public String getUpt_dt() {
		return upt_dt;
	}
	public void setUpt_dt(String upt_dt) {
		this.upt_dt = upt_dt;
	}
	public String getUpt_id() {
		return upt_id;
	}
	public void setUpt_id(String upt_id) {
		this.upt_id = upt_id;
	}
	
}
