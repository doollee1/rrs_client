<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">
<head>
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="description" content="">
   <meta name="author" content="">
   <title>(주)둘리정보통신</title>
   <!-- Bootstrap CSS -->
   <link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
   <!-- Custom styles for this template -->
   <!-- <link href="css/modern-business.css" rel="stylesheet"> -->
   <!--css-->
   <link href="resrc/css/common.css" rel="stylesheet">
   <link href="resrc/css/Login.css" rel="stylesheet">
   <!--script-->
   <script src="resrc/vendor/jquery/jquery.js"></script>
   <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
   <script src="resrc/js/includeHTML.js"></script>  
   <script>
   $(window).ready( function() {
       if( localStorage.getItem("idValue") ) {
    	   $("#in_id"    ).val(localStorage.getItem("idValue"));
    	   $("#ip_idSave").prop("checked", true );
       }
   });
   $(document).on("click", "#sp_idSave", function() { $("#ip_idSave").prop("checked", !$("#ip_idSave").prop("checked")); });

   sessionStorage.setItem("loginScriptCk", -1);
   
   function loginChk(){
		 
		 var in_id = $("#in_id").val();
         var in_pw = $("#in_pw").val();
         
         if(in_id == null || in_id == ''){
        	 $("#in_id").focus();
        	 alert("ID를 입력해주세요.");
        	 return;
         }
		 
         if(in_pw == null || in_pw == ''){
        	 $("#in_pw").focus();
        	 alert("비밀번호를 입력해주세요.");
        	 return;
         }
         
         $.ajax({
			type: "POST",
			url : "login.do",
			data: { "in_id":in_id, "in_pw":in_pw },
			dataType:"json",
			success:function(data){
				if(data == 'Y'){
               	    sessionStorage.setItem("loginScriptCk", 1);
               	    
			        if( isMobile() == "Local" ) {
    		            localStorage.removeItem("idValue") ;
			    	    if( $("#ip_idSave").prop("checked") ) localStorage.setItem("idValue", in_id );
		        	    location.href = "/mainPage.do";
			    	} else {
			    	    var inData = JSON.parse(JSON.stringify(window["deviceInfo"]));
			    	    inData.mb_id = in_id ;
			    	    $.ajax({
			    		    type: "POST",
			    		    url: "deviceInfoIns.do",
			    		    data: inData,
			    		    dataType: "json",
			    		    success: function(data){
					          if( data == 'Y' ) {
						            localStorage.removeItem("idValue") ;
		    		            	if( $("#ip_idSave").prop("checked") ) { localStorage.setItem("idValue", in_id ); }
		    				        location.href="/mainPage.do";
			    		        } else alert("TOKEN 저장 중 오류가 발생했습니다.");
			    		    },
			    			error:function(data){
			    				alert("server 통신 에러");
			    			}
			    		});
			    	}
			    
				}else if(data == 'F'){
					alert("비밀번호가 초기 상태입니다.\n비밀번호 변경을 위해  회원수정 화면으로 이동합니다.");
					location.href="/Member_user.do";
				}else if(data == 'R'){
					alert("퇴사자 입니다. 로그인 하실 수 없습니다.");
				}else{
					alert("ID 또는 비밀번호가 틀렸습니다.");
				}
			},
			error:function(data){
				console.log("통신중 오류가 발생하였습니다.");
			}
		});
         
		 //form.submit();
	 }
 </script>
 
</head>
<body>
  <!--navigation-->
  <jsp:include page="common/Navigation.jsp" />
  <!--header-->
  <!-- <header><img src="image/sub_visual_01.png" style="padding-top:8px;padding-bottom:15px;"></header> -->
  <!--container-->
  <div class="container sticky-footer login">
    <div class="card align-middle">
      <div class="card-title" style="margin-top:30px;">
        <h2 class="card-title text-center"><img src="resrc/image/logo_white.png" style="width:50%;"></h2>
      </div>
      <div class="card-body">
          <form class="form-signin" id="login_form" method="POST" action="login.do">
              <label for="inputEmail" class="sr-only">Enter ID</label>
              <input type="text" id="in_id" name="in_id" class="form-control" placeholder="아이디" required autofocus><BR>
              <label for="inputPassword" class="sr-only">Enter Password</label>
              <input type="password" id="in_pw" name="in_pw" class="form-control" placeholder="비밀번호" required><br>
          </form>
          <button id="btn-Yes" class="btn btn-dark btn-block" onclick="loginChk()" >로그인</button>
          <div style="margin:15px;width:90px;height:15px;position:absolute;left:70%;transform:translate(-30%, 0);">
              <input id="ip_idSave" type="checkbox" style="position: relative; top:2px">
              <span  id="sp_idSave" style="margin-left:5px;color:white;"> 아이디 저장</span>
          </div>
      </div>
    </div>
  </div>
  <!--/container-->
  <jsp:include page="common/Footer.jsp" />
  <script>includeHTML();</script>
</body>
</html>