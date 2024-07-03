<%--
	File Name : signUp.jsp (PalmResort > html > register.html)
	Description : 회원가입 페이지
	Creation : 이민구
	Update
	2023.11.15 이민구 - 최초생성
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script src="resrc/rsa/rsa.js"	></script>
<script src="resrc/rsa/jsbn.js"	></script>
<script src="resrc/rsa/prng4.js"></script>
<script src="resrc/rsa/rng.js"	></script>

<script>
$(window).ready( function() {
	setTitle("회원가입");
	setEvent();
});

// $(document).on("keyup", "input[telNo]", function() {$(this).val( $(this).val().replace(/[^0-9-]/gi,"") );});
$(document).on("keyup", "input[noSpecial]", function() {$(this).val( $(this).val().replace(/[^ㄱ-힣a-zA-Z0-9]/gi,"") );});
$(document).on("keyup", "input[onlyNum]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
$(document).on("keyup", "input[onlyKor]", function() {$(this).val( $(this).val().replace(/[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g,"") );});
$(document).on("keyup", "input[onlyEng]", function() {$(this).val( $(this).val().replace(/[^A-Z,a-z, ]/ig,"") );});

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
var idChkYN = false; <%//아이디 중복확인 여부%>
var pwChkYN = false; <%//비밀번호 유효성 확인%>

<%//페이지 이벤트 설정 %>
function setEvent(){
	<%//아이디가 변하면 중복체크도 다시하도록 값 초기화%>
	$('#user_id').on("change", function(){
		idChkYN = false;
	});
	
	<%//비밀번호 중복확인%>
	pwChk();
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
	
	var rsa = new RSAKey();
	rsa.setPublic($('#RSAModulus').val(),$('#RSAExponent').val());
	
	var user_id		= $("#user_id").val();		<%//사용자id%>
	var mem_gbn		= $("#mem_gbn").val();		<%//회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시%>
	var han_name	= $("#han_name").val();		<%//한글이름%>
	var eng_name	= $("#eng_name").val();		<%//영문이름%>
	var tel_no		= $("#tel_no").val();		<%//전화번호%>
	var email		= $("#email").val();		<%//이메일%>
	var passwd		= rsa.encrypt($("#passwd").val());		<%//비밀번호%>
	var ret_yn		= $("#ret_yn").val();		<%//탈퇴여부%>
	var reg_dtm		= $("#reg_dtm").val();		<%//등록일시%>
	var upd_dtm		= $("#upd_dtm").val();		<%//수정일시%>
	var privacy_ch  = $("input:checkbox[id='privacy']").is(":checked"); <%//개인정보동의여부%>
	
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
	if(!idChkYN){
		alert("아이디 중복확인을 완료해주세요.");
		return;
	}
	if(!validChk_email(email)) {
		alert("이메일 형식이 올바르지 않습니다.");
		return;
	}
	if(!privacy_ch){
		alert("개인정보동의여부에 체크해주세요.");
		return;
	}
	/* 
	if(tel_no.length == 11) {
		tel_no = tel_no.replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`);
	}
	 */
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
				, "ret_yn" : ret_yn	//탈퇴여부
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
<div class="register register-with-news-feed">
	<div class="register-background"></div>
	<!-- BEGIN register-container -->
	<div class="register-container">
		<!-- BEGIN register-content -->
		<div class="register-content">
<!-- 			<form action="index.html" method="GET" class="fs-13px"> -->
				<div class="mb-3">
					<label class="mb-2">이름 </label>
					<input type="text" class="form-control fs-13px" placeholder="이름" id="han_name" name="han_name" onlyKor/>
				</div>
				<div class="mb-3">
					<label class="mb-2">영문이름</label>
					<input type="text" class="form-control fs-13px" placeholder="영문이름" id="eng_name" name="eng_name" onlyEng/>
				</div>
				<div class="mb-3">
					<label class="mb-2">전화번호(숫자만기입)</label>
					<input type="tel" class="form-control fs-13px" placeholder="전화번호" id="tel_no" name="tel_no" onlyNum/>
				</div>
				<div class="mb-3">
					<label class="mb-2">이메일 </label>
					<input type="email" class="form-control fs-13px" placeholder="이메일" id="email" name="email"/>
				</div>
				<div class="mb-3">
					<label class="mb-2">아이디 </label>
					<input type="text" class="form-control fs-13px" placeholder="아이디" id="user_id" name="user_id" noSpecial/>
					<button type="button" class="btn btn-pink w-100 mt-2" onclick="idChk()">아이디중복확인</button>
				</div>
				<div class="mb-3">
					<label class="mb-2">비밀번호 </label>
					<input type="password" class="form-control fs-13px" placeholder="비밀번호" id="passwd" name="passwd"/>
				</div>
				<div class="mb-2">
					<label class="mb-2">비밀번호 확인</label>
					<input type="password" class="form-control fs-13px" placeholder="비밀번호 확인" id="passwdChk" name="passwdChk"/>
				</div>
				<div class="small" id="passwdChkText">
					비밀번호는 8자리 이상 영문과 숫자를 포함해야 합니다.
				</div>
				<div class="mb-3 ">
					<lable class="mb-2" style="font-size:17px">개인정보동의여부</lable>
					<input type="checkbox" id="privacy" name="privacy" value="privacyYN">
					<a href="/policy.do" style="text-decoration-line:underline;float:right">상세보기</a>
				</div>
				<input type="hidden" id="mem_gbn" name="mem_gbn" class="form-control" placeholder="회원구분">
				<input type="hidden" id="ret_yn" name="ret_yn" class="form-control" placeholder="탈퇴여부">
				<input type="hidden" id="reg_dtm" name="reg_dtm" class="form-control" placeholder="등록일시">
				<input type="hidden" id="upd_dtm" name="upd_dtm" class="form-control" placeholder="수정일시">
				<input type="hidden" id="RSAModulus" name="RSAModulus" value="${RSAModulus }"/>
				<input type="hidden" id="RSAExponent" name="RSAExponent" value="${RSAExponent}"/>
<!-- 			</form> -->
		</div>
		<!-- END register-content -->

	</div>
	<!-- END register-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="#" class="btn btn-success btn-lg" onclick="signUpChk()">회원가입</a>
	</div>
	<!-- END #footer -->
	
</div>
<!-- END #register -->