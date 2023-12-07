package com.rrs.web.qna.service.vo;

public class QnaVO {
	
	private int qna_seq;		//순번
	private int up_seq;			//부모순번
	private String reg_dt;		//등록일자
	private String title;		//제목
	private String content;		//내용
	private String reg_sts;		//상태 (1접수, 2완료)
	private String reg_dtm;		//등록일시
	private String reg_id;		//등록자ID
	private String upd_dtm;		//수정일시
	private String upd_id;		//수정자ID
	
	public int getQna_seq() {
		return qna_seq;
	}
	public void setQna_seq(int qna_seq) {
		this.qna_seq = qna_seq;
	}
	public int getUp_seq() {
		return up_seq;
	}
	public void setUp_seq(int up_seq) {
		this.up_seq = up_seq;
	}
	public String getReg_dt() {
		return reg_dt;
	}
	public void setReg_dt(String reg_dt) {
		this.reg_dt = reg_dt;
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
	public String getReg_dtm() {
		return reg_dtm;
	}
	public void setReg_dtm(String reg_dtm) {
		this.reg_dtm = reg_dtm;
	}
	public String getReg_id() {
		return reg_id;
	}
	public void setReg_id(String reg_id) {
		this.reg_id = reg_id;
	}
	public String getUpd_dtm() {
		return upd_dtm;
	}
	public void setUpd_dtm(String upd_dtm) {
		this.upd_dtm = upd_dtm;
	}
	public String getUpd_id() {
		return upd_id;
	}
	public void setUpd_id(String upd_id) {
		this.upd_id = upd_id;
	}
	
}
