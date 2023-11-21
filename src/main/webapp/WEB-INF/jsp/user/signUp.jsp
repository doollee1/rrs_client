<%--
	File Name : signUp.jsp (PalmResort > html > register.html)
	Description : 회원가입 페이지
	Creation : 이민구
	Update
	2023.11.15 이민구 - 최초생성
	
	----------남은일----------
	비밀번호 암호화
	인풋 이벤트 추가
		> 아이디 값 변화시 아이디 중복체크 확인 값 idChkYN false 변경
		> 한글이름 입력창 한글만 입력하도록
		> 영문이름 입력창 영문만 입력하도록
		> 전화번호 입력창 숫자만 입력하도록 + 값 전달 시 '-' 는 로직으로 추가해서 전달하도록
		> 비밀번호 확인창 비밀번호 입력창과 값 비교 후 값에따라 '비밀번호는 8자리 이상 영문과 숫자를 포함해야 합니다.' 텍스트 변경되도록
	----------남은일----------
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script>
$(window).ready( function() {
	setTitle("회원가입");
	setEvent();
});

var today = new Date();
var year = today.getFullYear();
var month = ('0' + (today.getMonth() + 1)).slice(-2);
var day = ('0' + today.getDate()).slice(-2);
var now = year + '-' + month  + '-' + day; <%//오늘날짜 YYYY-MM-DD%>
var idChkYN = false; <%//아이디 중복확인 여부%>

<%//페이지 이벤트 설정 %>
function setEvent(){
	
}

<%// 회원가입 버튼 이벤트%>
function signUpChk(){
	<%/*
	
	tb_member	회원테이블
	
	USER_ID		사용자ID
	MEM_GBN		회원구분
	HAN_NAME	한글이름
	ENG_NAME	영문이름
	TEL_NO		전화번호
	EMAIL		이메일
	PASSWD		비밀번호
	RET_YN		탈퇴여부
	REG_DTM		등록일시
	UPD_DTM		수정일시
	
	*/%>
	
	$("#reg_dtm").val(now);
	$("#upd_dtm").val(now);
	
	var user_id		= $("#user_id").val();		<%//사용자id%>
	var mem_gbn		= $("#mem_gbn").val();		<%//회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시%>
	var han_name	= $("#han_name").val();		<%//한글이름%>
	var eng_name	= $("#eng_name").val();		<%//영문이름%>
	var tel_no		= $("#tel_no").val();		<%//전화번호%>
	var email		= $("#email").val();		<%//이메일%>
	var passwd		= $("#passwd").val();		<%//비밀번호%>
	var ret_yn		= $("#ret_yn").val();		<%//탈퇴여부%>
	var reg_dtm		= $("#reg_dtm").val();		<%//등록일시%>
	var upd_dtm		= $("#upd_dtm").val();		<%//수정일시%>
	
	
	if(han_name == null || han_name == ''){
		$("#han_name").focus();
		alert("이름을 입력해주세요.");
		return;
	}
	if(eng_name == null || eng_name == ''){
		$("#eng_name").focus();
		alert("영문이름을 입력해주세요.");
		return;
	}
	if(tel_no == null || tel_no == ''){
		$("#tel_no").focus();
		alert("전화번호를 입력해주세요.");
		return;
	}
				if(email == null || email == ''){
		$("#email").focus();
		alert("이메일을 입력해주세요.");
		return;
	}
	if(user_id == null || user_id == ''){
		$("#user_id").focus();
		alert("아이디를 입력해주세요.");
		return;
	}
	if(passwd == null || passwd == ''){
		$("#passwd").focus();
		alert("비밀번호를 입력해주세요.");
		return;
	}
	if(!idChkYN){
		alert("아이디 중복확인을 완료해주세요.");
		return;
	}
	
	$.ajax({
			type:"POST",
			url:"/signUp.do",
			data:{"user_id":user_id
				, "mem_gbn" : mem_gbn
				, "han_name" : han_name
				, "eng_name" : eng_name
				, "tel_no" : tel_no
				, "email" : email
				, "passwd" : passwd
				, "ret_yn" : ret_yn
				, "reg_dtm" : reg_dtm
				, "upd_dtm" : upd_dtm
			},
			
			dataType:"json",
			success:function(data){
				if(data == "Y"){
					alert("회원가입이 완료되었습니다.");
					location.href="/signIn.do";
				} else if(data == "M"){
					alert("회원가입 및 멤버확인이 완료되었습니다.")
					location.href="/signIn.do";
				} else {
					alert("회원가입에 실패했습니다. 다시 시도해주세요.");
				}
			},
			error:function(data){
				console.log("통신중 오류가 발생하였습니다.");
			}
		});
	
}

<%//ID 중복확인%>
function idChk(){
	
	var idChk = $('#user_id').val();
	idChkYN = false;
	
	if(idChk == null || idChk == ''){
		$("#user_id").focus();
		alert("아이디를 입력해주세요.");
		return;
	}
	
	$.ajax({
		type:"POST",
		url:"/signUpIdChk.do",
		data:{"user_id":idChk},
		dataType:"json",
		success:function(data){
			alert(data);
			if(data == "Y") {
				alert("이미 등록된 회원입니다.");
				idChkYN = false;
			} else {
				alert("회원가입이 가능한 ID입니다.");
				idChkYN = true;
			}
		},
		error:function(data){
			console.log("통신중 오류가 발생하였습니다.");
		}
	});
}

<%//비밀번호 중복확인%>
function pwChk(){
	
}

</script>
	 
<!-- BEGIN register -->
<div class="register register-with-news-feed">
	<!-- BEGIN register-container -->
	<div class="register-container">

		<!-- BEGIN register-content -->
		<div class="register-content">
<!-- 			<form action="index.html" method="GET" class="fs-13px"> -->
				<div class="mb-3">
					<label class="mb-2">이름 </label>
					<input type="text" class="form-control fs-13px" placeholder="이름" id="han_name" name="han_name"/>
				</div>
				<div class="mb-3">
					<label class="mb-2">영문이름</label>
					<input type="text" class="form-control fs-13px" placeholder="영문이름" id="eng_name" name="eng_name"/>
				</div>
				<div class="mb-3">
					<label class="mb-2">전화번호</label>
					<input type="text" class="form-control fs-13px" placeholder="전화번호" id="tel_no" name="tel_no"/>
				</div>
				<div class="mb-3">
					<label class="mb-2">이메일 </label>
					<input type="text" class="form-control fs-13px" placeholder="이메일" id="email" name="email"/>
				</div>
				<div class="mb-3">
					<label class="mb-2">아이디 </label>
					<input type="text" class="form-control fs-13px" placeholder="아이디" id="user_id" name="user_id"/>
					<button type="button" class="btn btn-pink d-block w-100 mt-2" onclick="idChk()">아이디중복확인</button>
				</div>
				<div class="mb-3">
					<label class="mb-2">비밀번호 </label>
					<input type="password" class="form-control fs-13px" placeholder="비밀번호" id="passwd" name="passwd"/>
				</div>
				<div class="mb-2">
					<label class="mb-2">비밀번호 확인</label>
					<input type="password" class="form-control fs-13px" placeholder="비밀번호 확인" id="passwdChk" name="passwdChk"/>
				</div>
				<div class="small">
					비밀번호는 8자리 이상 영문과 숫자를 포함해야 합니다.
				</div>
				<input type="hidden" id="mem_gbn" name="mem_gbn" class="form-control" placeholder="회원구분"><BR></BR>
				<input type="hidden" id="ret_yn" name="ret_yn" class="form-control" placeholder="탈퇴여부"><BR></BR>
				<input type="hidden" id="reg_dtm" name="reg_dtm" class="form-control" placeholder="등록일시"><BR></BR>
				<input type="hidden" id="upd_dtm" name="upd_dtm" class="form-control" placeholder="수정일시"><BR></BR>
<!-- 			</form> -->
			
		</div>
		<!-- END register-content -->

	</div>
	<!-- END register-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="#" class="btn btn-success btn-lg d-block" onclick="signUpChk()">회원가입</a>
	</div>
	<!-- END #footer -->
	
</div>
<!-- END #register -->