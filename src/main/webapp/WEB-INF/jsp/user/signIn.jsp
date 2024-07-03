<%--
	File Name : signIn.jsp
	Description : 로그인 페이지
	Creation : 2023.11.15 이민구
	Update
	2023.11.15 이민구 - 최초생성
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script src="resrc/rsa/rsa.js"	></script>
<script src="resrc/rsa/jsbn.js"	></script>
<script src="resrc/rsa/prng4.js"></script>
<script src="resrc/rsa/rng.js"	></script>

<script>

$(window).ready( function() {
	setTitle("로그인");
	setEvent();
});

<%//페이지 이벤트 설정 %>
function setEvent(){
	
	<%-- 패스워드  이벤트--%>
	$("#user_id").on("keyup", function(key) {
		
		if(key.keyCode == 13) {  //엔테키           			     
			$("#password").focus();
		}		
	});
}

<%// 로그인 이벤트%>
function signIn(){
	
	console.log("======== 로그인 진행 ========");
	
	var rsa = new RSAKey();
	rsa.setPublic($('#RSAModulus').val(),$('#RSAExponent').val());
	
	var user_id = $("#user_id").val();
	var passwd = rsa.encrypt($("#password").val());
	var useCookie = $("input[name=useCookie]:checked").val();
	
	console.log("=== user_id : "+user_id);
	console.log("=== passwd : "+passwd);
	console.log("=== useCookie : "+useCookie);
	
	
	if(user_id == null || user_id == ''){
		 $("#user_id").focus();
		 alert("ID를 입력해주세요.");
		 return;
	}
	
	if(passwd == null || passwd == ''){
		$("#password").focus();
		alert("비밀번호를 입력해주세요.");
		return;
	}
	
	$.ajax({
		type: "POST",
		url : "/signIn.do",
		data: 
			{ "user_id":user_id
			, "passwd":passwd
			, "useCookie":useCookie 
			},
		dataType:"json",
		success:function(data){
			if(data == "Y"){
				location.href = "/main.do";
			} else if(data == "A"){
				location.href = "/adminReservationList.do";   //관리자 예약목록 페이지로 이동  
			} else if(data == "R"){
				alert("비밀번호가 초기 상태입니다.\n비밀번호 변경 후 이용해주세요.");
				location.href="/infoChange.do";
			} else if(data == "F"){
				alert("이용할 수 없는 게정입니다. 관리자에게 문의해주세요.");
			} else if(data == "N"){
				alert("ID 또는 비밀번호가 틀렸습니다.");
			} else if(data == "Q"){
				alert("에이전시 회원은 관리자에서만 가능합니다.");
			} else if(data == "E"){
				alert("세션이 종료되어 메인화면으로 이동합니다.");
				location.href = "/main.do";
			} else {
				alert("존재하지 않는 회원입니다. 회원가입 후 이용해주세요.");
			}
		}
	});
}
</script>

<style>
@media (min-width: 767.98px) {
	.login.login-with-news-feed {display:flex;}
	.login-container {min-width: 500px;}
	.login-background {border:double 4px; flex:1;}
}
</style>

<!-- BEGIN login -->
<div class="login login-with-news-feed">
	<div class="login-background"></div>
	<!-- BEGIN login-container -->
	<div class="login-container">
		<!-- BEGIN login-header -->
		<div class="login-header mb-30px">
			<div class="brand">
				<div class="d-flex">
					<span class="logo"><i class="far fa-face-grin-beam"></i></span>
					<b>Palm</b> Resort
				</div>
				<small>Welcome to Le Grandeur Palm Resort</small>
			</div>
			<div class="icon">
				<i class="fa fa-sign-in-alt"></i>
			</div>
		</div>
		<!-- END login-header -->
		<!-- BEGIN login-content -->
		<div class="login-content">
			<div class="form-floating mb-15px">
				<input type="text" class="form-control h-45px fs-13px" placeholder="아이디" id="user_id"/>
				<label for="user_id" class="d-flex align-items-center fs-13px text-gray-600">아이디</label>
			</div>
			<div class="form-floating mb-30px">
				<input type="password" class="form-control h-45px fs-13px" placeholder="비밀번호" id="password" onKeyPress="if(event.keyCode == 13) javascript:signIn();"/>
				<label for="password" class="d-flex align-items-center fs-13px text-gray-600">비밀번호</label>
			</div>
			<input type="hidden" id="RSAModulus" name="RSAModulus" value="${RSAModulus }"/>
			<input type="hidden" id="RSAExponent" name="RSAExponent" value="${RSAExponent}"/>
			<label>
                  <input type="checkbox" name="useCookie"> 자동로그인
            </label>
			<div class="mb-15px">
				<button type="button" class="btn btn-theme h-45px w-100 btn-lg fs-14px" onclick="signIn()">로그인</button>				
			</div>
			<div class="mb-40px pb-40px text-dark btn-links">
				<a href="/findId.do">아이디찾기</a>
				<a href="/findPw.do">비밀번호찾기</a>
				<a href="/signUp.do" class="text-theme btn-join">회원가입</a>
			</div>
		</div>
		<!-- END login-content -->
	</div>
	<!-- END login-container -->
	
</div>
<!-- END login -->
