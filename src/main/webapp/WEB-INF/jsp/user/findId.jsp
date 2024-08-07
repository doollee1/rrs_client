﻿<%--
	File Name : findId.jsp
	Description : 아이디 찾기 페이지
	Creation : 2023.11.21 이민구
	Update
	2023.11.21 이민구 - 최초생성
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

$(window).ready( function() {
	setTitle("아이디찾기");
	setEvent();
});

$(document).on("keyup", "input[noSpecial]", function() {$(this).val( $(this).val().replace(/[^ㄱ-힣a-zA-Z0-9]/gi,"") );});
$(document).on("keyup", "input[onlyNum]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
$(document).on("keyup", "input[onlyKor]", function() {$(this).val( $(this).val().replace(/[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g,"") );});

function validChk_email(val){
	var pattern = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	return (val != '' && val != 'undefined' && pattern.test(val));
}

<%//페이지 이벤트 설정 %>
function setEvent(){
	
}

<%//아이디 찾기%>
function findId(){
	
	var han_name = $("#han_name").val();
	var tel_no = $("#tel_no").val();
	var email = $("#email").val();
	
	if(han_name == null || han_name == ''){
		 $("#han_name").focus();
		 alert("이름을 입력해주세요.");
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
	<%//일반적인 전화번호에 하이픈 삽입 : 010xxxxyyyy > 010-xxxx-yyyy%>
	if(tel_no.length == 11) {
		//tel_no = tel_no.replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`);
	}
	
	$.ajax({
		type: "POST",
		url : "/findId.do",
		data: 
			{ "han_name":han_name
			, "tel_no":tel_no
			, "email":email
			},
		dataType:"json",
		success:function(data){
			if(data == "NONE"){
				alert("존재하지 않는 정보입니다.");
			} else if(data == "N") {
				alert("메일발송이 실패하였습니다.");				
			} else if(data == "Y"){
				alert("등록된 회원님의 이메일주소(" + email + ")로 아이디가 발송되었습니다.");
				location.href = "/signIn.do";
			}
		}
	});
}
</script>

<!-- BEGIN register -->
<div class="register register-with-news-feed find">
	<div class="register-background"></div>
	<!-- BEGIN register-container --> 
	<div class="register-container"> 
		<!-- BEGIN register-content -->
		<div class="register-content">
			
				<div class="text"><i class="fa-solid fa-check"></i> 등록된 회원정보로 아이디를 찾아 드립니다.</div>
				<div class="mb-3">
					<label class="mb-2">이름 </label>
					<input type="text" class="form-control fs-13px" placeholder="이름" id="han_name" onlyKor/>
				</div>						
				<div class="mb-3">
					<label class="mb-2">전화번호</label>
					<input type="text" class="form-control fs-13px" placeholder="전화번호" id="tel_no" onlyNum/>
				</div>
				<div class="mb-3">
					<label class="mb-2">이메일 </label>
					<input type="email" class="form-control fs-13px" placeholder="이메일" id="email"/>
				</div>
				<div>아이디를 회원가입시 입력한 이메일로 보내 드립니다.</div>
			
		</div>
		<!-- END register-content -->

	</div>
	<!-- END register-container -->	
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="#" class="btn btn-success btn-lg" onclick="findId();">완료</a>
	</div>
	<!-- END #footer -->
</div>
<!-- END #register -->