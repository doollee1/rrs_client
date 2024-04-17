<%--
	File Name : findId.jsp
	Description : 비밀번호 찾기 페이지
	Creation : 2023.11.21 이민구
	Update
	2023.11.21 이민구 - 최초생성
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

$(window).ready( function() {
	setTitle("비밀번호찾기");
});

$(document).on("keyup", "input[noSpecial]", function() {$(this).val( $(this).val().replace(/[^ㄱ-힣a-zA-Z0-9]/gi,"") );});
$(document).on("keyup", "input[onlyNum]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

function validChk_email(val){
	var pattern = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	return (val != '' && val != 'undefined' && pattern.test(val));
}

<%//비밀번호 찾기%>
function findPw(){
	
	var user_id = $("#user_id").val();
	var tel_no = $("#tel_no").val();
	var email = $("#email").val();
	
	if(user_id == null || user_id == ''){
		 $("#user_id").focus();
		 alert("아이디를 입력해주세요.");
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
	if(!validChk_email(email)) {
		alert("이메일 형식이 올바르지 않습니다.");
		return;
	}
	<%//일반적인 전화번호에 하이픈 삽입 : 010xxxxyyyy > 010-xxxx-yyyy%>
	if(tel_no.length == 11) {
		//tel_no = tel_no.replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`);
	}
	
	$.ajax({
		type: "POST",
		url : "/findPw.do",
		data: 
			{ "user_id":user_id
			, "tel_no":tel_no
			, "email":email
			},
		dataType:"json",
		success:function(data){
			if(data == "NONE"){
				alert("존재하지 않는 사용자입니다.");
			} else {
				alert("초기화 된 비밀번호가 "+ user_id + " 회원님의 이메일 : "+ email + " 로 전송되었습니다. \n 초기화된 비밀번호로 다시 접속해주세요.");
				location.href = "/signIn.do";
			}
		}
	});
}
</script>

<!-- BEGIN register -->
<div class="register register-with-news-feed find">
	<!-- BEGIN register-container -->
	<div class="register-container">

		<!-- BEGIN register-content -->
		<div class="register-content">
			<form >
				<div class="text"><i class="fa-solid fa-check"></i> 등록된 회원정보로 비밀번호를 찾아 드립니다.</div>
				<div class="mb-3">
					<label class="mb-2">아이디 </label>
					<input type="text" class="form-control fs-13px" placeholder="아이디" id="user_id" noSpecial/>
				</div>						
				<div class="mb-3"> 
					<label class="mb-2">전화번호</label>
					<input type="text" class="form-control fs-13px" placeholder="전화번호" id="tel_no" onlyNum/>
				</div>
				<div class="mb-3"> 
					<label class="mb-2">이메일 </label>
					<input type="email" class="form-control fs-13px" placeholder="이메일" id="email"/>
				</div> 
				<div>초기화된 비밀번호를 회원가입시 입력한 이메일로 보내 드립니다. 초기화된 비밀번호를 받으시고 변경해서 사용하세요.</div>
				
			</form>
			
		</div>
		<!-- END register-content -->

	</div>
	<!-- END register-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="#" class="btn btn-success btn-lg" onclick="findPw();">완   료</a>
	</div>
	<!-- END #footer -->
	
</div>
<!-- END #register -->