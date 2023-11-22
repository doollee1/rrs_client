<%--
	File Name : signIn.jsp
	Description : 로그인 페이지
	Creation : 2023.11.15 이민구
	Update
	2023.11.15 이민구 - 최초생성
	----------남은일----------
	비밀번호 암호화
	로그인 이벤트 분기 페이지 URL 재점검
	인풋 이벤트 추가
	----------남은일----------
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

$(window).ready( function() {
	setTitle("로그인");
	setEvent();
});

<%//페이지 이벤트 설정 %>
function setEvent(){
	
}

<%// 로그인 이벤트%>
function signIn(){
	
	var user_id = $("#user_id").val();
	var passwd = $("#password").val();
	
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
			},
		dataType:"json",
		success:function(data){
			if(data == "Y"){
				location.href = "/mainPage.do";
			} else if(data == "D"){
				alert("비밀번호가 초기 상태입니다.\n비밀번호 변경을 위해	회원수정 화면으로 이동합니다.");
				location.href="/Member_user.do";
			} else if(data == "F"){
				alert("이용할 수 없는 게정입니다. 관리자에게 문의해주세요.");
			} else if(data == "N"){
				alert("ID 또는 비밀번호가 틀렸습니다.");
			} else {
				alert("존재하지 않는 회원입니다. 회원가입 후 이용해주세요.");
			}
		},
		error:function(data){
			console.log("통신중 오류가 발생하였습니다.");
		}
	});
}

function signUp() {
	location.href = "/signUp.do";
}
</script>

<!-- BEGIN login -->
<div class="login login-with-news-feed">

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
				<input type="text" class="form-control h-45px fs-13px" placeholder="아이디" id="user_id" />
				<label for="user_id" class="d-flex align-items-center fs-13px text-gray-600">아이디</label>
			</div>
			<div class="form-floating mb-30px">
				<input type="password" class="form-control h-45px fs-13px" placeholder="비밀번호" id="password" />
				<label for="password" class="d-flex align-items-center fs-13px text-gray-600">비밀번호</label>
			</div>
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
