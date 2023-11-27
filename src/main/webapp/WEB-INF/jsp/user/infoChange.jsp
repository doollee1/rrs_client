<%--
	File Name : infoChange.jsp (PalmResort > html > set_personal.html)
	Description : 회원가입 페이지
	Creation : 이민구
	Update
	2023.11.24 이민구 - 최초생성
	----------남은일----------
	----------남은일----------
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script src="resrc/rsa/rsa.js"	></script>
<script src="resrc/rsa/jsbn.js"	></script>
<script src="resrc/rsa/prng4.js"></script>
<script src="resrc/rsa/rng.js"	></script>

<c:set value="${sessionScope.login}" var="login" />

<script>
$(window).ready( function() {
	setTitle("개인정보변경");
	setEvent();
});

$(document).on("keyup", "input[noSpecial]", function() {$(this).val( $(this).val().replace(/[^ㄱ-힣a-zA-Z0-9]/gi,"") );});
$(document).on("keyup", "input[onlyNum]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
$(document).on("keyup", "input[onlyKor]", function() {$(this).val( $(this).val().replace(/[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g,"") );});
$(document).on("keyup", "input[onlyEng]", function() {$(this).val( $(this).val().replace(/[^A-Za-z]/ig,"") );});

function validChk_email(val){
	var pattern = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	return (val != '' && val != 'undefined' && pattern.test(val));
}

function validChk_passwd(val){
	var pattern = /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,100}$/;
	return (val != '' && val != 'undefined' && pattern.test(val));
}

var today = new Date();
var year = today.getFullYear();
var month = ('0' + (today.getMonth() + 1)).slice(-2);
var day = ('0' + today.getDate()).slice(-2);
var now = year + '-' + month  + '-' + day; <%//오늘날짜 YYYY-MM-DD%>
var pwChkYN = false; <%//비밀번호 유효성 확인%>

<%//페이지 이벤트 설정 %>
function setEvent(){
	<%//비밀번호 중복확인%>
	pwChk();
}

<%//변경 버튼 이벤트%>
function infoChange(){
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
	
	$("#upd_dtm").val(now);
	
	var rsa = new RSAKey();
	rsa.setPublic($('#RSAModulus').val(),$('#RSAExponent').val());
	
	var user_id		= $("#user_id").val();						<%//사용자id%>
	var han_name	= $("#han_name").val();						<%//한글이름%>
	var passwd		= rsa.encrypt($("#passwd").val());			<%//비밀번호%>
	var passwdChk	= rsa.encrypt($("#passwdChk").val());		<%//비밀번호중복확인%>
	var passwdOri	= rsa.encrypt($("#passwdOri").val());		<%//기존비밀번호%>
	var ret_yn		= $("#ret_yn").val();						<%//탈퇴여부%>
	var upd_dtm		= $("#upd_dtm").val();						<%//수정일시%>
	var email		= $("#email").val();						<%//이메일 %>
	
	if(email == null || email == ''){
		$("#email").focus();
		alert("이메일을 입력해주세요.");
		return;
	}
	if($('#passwd').val() == null || $('#passwd').val() == ''){
		$("#passwd").focus();
		alert("비밀번호를 입력해주세요.");
		return;
	}
	if(!validChk_passwd($('#passwd').val())){
		alert("비밀번호는 8자리 이상 영문과 숫자를 포함해야 합니다.");
		return;
	}
	if(!pwChkYN){
		alert("입력하신 비밀번호와 비밀번호 확인 값이 일치하지 않습니다.");
		return;
	}
	if(!validChk_email(email)) {
		alert("이메일 형식이 올바르지 않습니다.");
		return;
	}
	
	$.ajax({
			type:"POST",
			url:"/infoChange.do",
			data:{"user_id":user_id
				, "han_name" : han_name
				, "email" : email
				, "passwd" : passwd
				, "upd_dtm" : upd_dtm
				, "passwdOri" : passwdOri
			},
			
			dataType:"json",
			success:function(data){
				if(data == "Y"){
					alert("개인정보 변경이 완료되었습니다.");
					location.href = "/main.do";
				} else {
					alert("기존 비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
				}
			},
			error:function(data){
				console.log("통신중 오류가 발생하였습니다.");
			}
		});
	
}

function pwChk(){
	$('#passwd, #passwdChk').on('change', function(){
		var passwd = $('#passwd').val();
		var passwdChk = $('#passwdChk').val();
		if(passwd.length > 8) {
			$('#passwdChkText').text("비밀번호는 8자리 이상 영문과 숫자를 포함해야 합니다.");
			pwChkYN = false;
		}
		
		if(passwdChk == "") {
			return;
		}
		
		if(passwd == passwdChk) {
			$('#passwdChkText').text("비밀번호가 일치합니다.");
			pwChkYN = true;
		} else {
			$('#passwdChkText').text("비밀번호가 일치하지 않습니다.");
			pwChkYN = false;
		}
	});
}
</script>
	 
<!-- BEGIN register -->
<div class="register register-with-news-feed set">
	<!-- BEGIN register-container -->
	<div class="register-container">

		<!-- BEGIN register-content -->
		<div class="register-content">
			<form action="index.html" method="GET" class="fs-13px">
				<div class="mb-3">
					<label class="mb-2">이름</label>
					<input type="text" class="form-control fs-13px" placeholder="이름" readonly value="${sessionScope.han_name }" id="han_name">
				</div>
				<div class="mb-3">
					<label class="mb-2">이메일 </label>
					<input type="email" class="form-control fs-13px" placeholder="이메일" value="${sessionScope.email }" id="email"/>
				</div>
				<div class="mb-3">
					<label class="mb-2">기존 비밀번호 </label>
					<input type="password" class="form-control fs-13px" placeholder="기존 비밀번호" id="passwdOri"/>
				</div>
				<div class="mb-3">
					<label class="mb-2">신규 비밀번호 </label>
					<input type="password" class="form-control fs-13px" placeholder="신규 비밀번호" id="passwd" />
				</div>
				<div class="mb-2">
					<label class="mb-2">비밀번호 확인</label>
					<input type="password" class="form-control fs-13px" placeholder="비밀번호 확인" id="passwdChk" />
				</div>
				<div class="small" id="passwdChkText">
					비밀번호는 8자리 이상 영문과 숫자를 포함해야 합니다.
				</div>
				<input type="hidden" id="user_id" name="user_id" value="${sessionScope.user_id }"/>
				<input type="hidden" id="RSAModulus" name="RSAModulus" value="${RSAModulus }"/>
				<input type="hidden" id="RSAExponent" name="RSAExponent" value="${RSAExponent}"/>
			</form>
			
		</div>
		<!-- END register-content -->

	</div>
	<!-- END register-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="#" class="btn btn-success btn-lg" onclick="infoChange();">변  경</a>
	</div>
	<!-- END #footer -->
</div>
<!-- END #register -->