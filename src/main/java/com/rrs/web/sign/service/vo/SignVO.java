package com.rrs.web.sign.service.vo;

import com.rrs.web.sign.service.vo.SignVO;

public class SignVO {
	
	private String user_id;			//사용자id
	private String mem_gbn;			//회원구분
	private String han_name;		//한글이름
	private String eng_name;		//영문이름
	private String tel_no;			//전화번호
	private String email;			//이메일
	private String passwd;			//비밀번호
	private String ret_yn;			//탈퇴여부
	private String sessionId;		//세션ID
	private String sessionLimit;	//세션limit
	private String useCookie;		//쿠키사용여부
	private String reg_dtm;			//등록일시
	private String upd_dtm;			//수정일시
	
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getMem_gbn() {
		return mem_gbn;
	}
	public void setMem_gbn(String mem_gbn) {
		this.mem_gbn = mem_gbn;
	}
	public String getHan_name() {
		return han_name;
	}
	public void setHan_name(String han_name) {
		this.han_name = han_name;
	}
	public String getEng_name() {
		return eng_name;
	}
	public void setEng_name(String eng_name) {
		this.eng_name = eng_name;
	}
	public String getTel_no() {
		return tel_no;
	}
	public void setTel_no(String tel_no) {
		this.tel_no = tel_no;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public String getRet_yn() {
		return ret_yn;
	}
	public void setRet_yn(String ret_yn) {
		this.ret_yn = ret_yn;
	}
	public String getReg_dtm() {
		return reg_dtm;
	}
	public void setReg_dtm(String reg_dtm) {
		this.reg_dtm = reg_dtm;
	}
	public String getUpd_dtm() {
		return upd_dtm;
	}
	public void setUpd_dtm(String upd_dtm) {
		this.upd_dtm = upd_dtm;
	}
	public String getSessionId() {
		return sessionId;
	}
	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}
	public String getSessionLimit() {
		return sessionLimit;
	}
	public void setSessionLimit(String sessionLimit) {
		this.sessionLimit = sessionLimit;
	}
	public String getUseCookie() {
		return useCookie;
	}
	public void setUseCookie(String useCookie) {
		this.useCookie = useCookie;
	}
	@Override
	public String toString() {
		return "SignVO [user_id=" + user_id + ", mem_gbn=" + mem_gbn + ", han_name=" + han_name + ", eng_name="
				+ eng_name + ", tel_no=" + tel_no + ", email=" + email + ", passwd=" + passwd + ", ret_yn=" + ret_yn
				+ ", sessionId=" + sessionId + ", sessionLimit=" + sessionLimit + ", useCookie=" + useCookie
				+ ", reg_dtm=" + reg_dtm + ", upd_dtm=" + upd_dtm + "]";
	}
		
}
