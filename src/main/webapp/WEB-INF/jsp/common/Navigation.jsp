<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>

<div class="header-wrap">
  <div class="wrap-inner">
    <div class="header">
      <h1 class="logo"><a href="/mainPage.do" id="headerLinkTag"><img src="resrc/image/logo.png" alt=""></a></h1>
      <div class="m-btn">
        <button type="buttton" class="m-menu"><span></span><span></span><span></span></button>
      </div>
    </div>
    <div class="gnbmenu">
      <div class="mask"></div>
      <div class="gnb">
        <button type="button" class="close"><span></span><span></span><span></span></button>
        <ul class="menu">
 
           <c:if test="${sessionScope.login != null}">
           	<li class="loginUserForm"><a href="/logout.do" id="tab_login_toggle"><span>LogOut</span></a></li>
            <li class="loginUserForm"><a href="javascript:void(0);" ><span>Member</span></a>
          	  <ul>

                <c:if test="${sessionScope.usrlvl == 0 }">
	                <li><a href="/Member_sel.do"><span>회원관리</span></a></li>
	                <li><a href="/Comm_code.do" ><span>코드관리</span></a></li>
	                <li><a id="holi_main_menu"  ><span>휴가관리</span></a></li>
<!-- 	                <li><a href="/Doollee_prod_main.do"><span>장비관리</span></a></li> -->
<!-- 	                <li><a href="/Doollee_repair_main.do"><span>장비수리관리</span></a></li> -->
<!-- 	                <li><a href="/Doollee_trans_main.do"><span>장비인수인계</span></a></li> -->
<!-- 	                <li><a href="/Business_outline_tailesTest.do"><span>Business[개요]-TEST</span></a></li> -->
	            </c:if>
                <c:if test="${sessionScope.usrlvl <= 2 }">
                	<li><a href="/Member_user.do"><span>회원정보수정</span></a></li>
                	<c:if test="${sessionScope.pw_chk eq '1'}">
	                	<li><a id="prod_main_menu"><span>장비관리</span></a></li>
                	</c:if>
                </c:if>
              </ul>
            </li>
          	
          </c:if>
 
          <li><a href="javascript:void(0);"><span> Company</span></a>
            <ul>
              <li><a href="/Company.do"><span>회사소개</span></a></li>
              <li><a href="/Recruit.do"><span>인재채용</span></a></li>
              <li><a href="/noticeList.do"><span>공지사항</span></a></li>
            </ul>
          </li>
          <li><a href="javascript:void(0);"><span>Business</span></a>
            <ul>
              <li><a href="/Business_outline.do"><span>개요</span></a></li>
              <li><a href="/Business_consulting.do"><span>컨설팅</span></a></li>
              <li><a href="/Business_service.do"><span>서비스</span></a></li>
              <li><a href="/Business_solution.do"><span>솔루션</span></a></li>
            </ul>
          </li>
          <li><a href="javascript:void(0);"><span>Project</span></a>
            <ul>
              <li><a href="Project_actual.do"><span>프로젝트 실적</span></a></li>
            </ul>
          </li>
          <li><a href="javascript:void(0);"><span>Contact</span></a>
            <ul>
              <li><a href="/Contact_insert.do"><span>문의사항</span></a></li>
              <li><a href="/Contact_select.do"><span>문의사항내용</span></a></li>
            </ul>
          </li>
        </ul>
        
      </div>
    </div>
    
  </div>
  
  <div class="gnbmenu-layer">
    <div class="wrapper" id="layerWrapper" 
        style=" <c:if test='${sessionScope.login != null}'> padding-left:420px </c:if>
                <c:if test='${sessionScope.login == null}'> padding-left:580px </c:if>
              ">
    </div>
    
  </div>
</div>

<script>
	$(function() {
	    $(window).on("scroll", function() {
	        if($(window).scrollTop() > 50) {
	            $(".header-wrap").addClass("fixed");
	        } else {
	            //remove the background property so it comes transparent again (defined in your css)
	           $(".header-wrap").removeClass("fixed");
	        }
	    });
	});
	
    $(document).on("click", "#holi_main_menu", function() {
        var appPageGbn = window.innerWidth <= 500 ? "_app" : "";
        $(this).attr("href", "/Doollee_holi_main"+ appPageGbn +".do");
    });
	
    $(document).on("click", "#prod_main_menu", function() {
        var appPageGbn = window.innerWidth <= 500 ? "_app" : "";
        $(this).attr("href", "/Doollee_prod_main"+ appPageGbn +".do");
    });

    //비로그인 상태에서 왼쪽상단 둘리정보통신 마크 5초이상 터치 유지시 로그인 화면 이동
    // *** 앱(안드로이드)에서 로그인/로그아웃 후 메인화면을 포함 다른 화면에 다시 진입시 한번이라도 로그인 했으면 로그아웃 후에도 계속 세션이 다시 복구?되는 현상발생
    //   - 앱웹간의 세션관리, 연동시에 화면이동시 앱에서도 세션데이터를 따로 가지고 있다가 다시 넣는?, 일치화시키는? 경우일걸로 추정.
    //   - 원래 로그아웃시 앱에도 로그아웃 상태를 알려야하지만 거기까지는 안했었던 것으로 기억.
    //   - 단순하게 처리하기 위해 로그인화면 진입시 세션스토리지에 구분값 -1, 로그인완료 후 구분값 1을 생성 후 같이 체크하도록 추가
    //   - 스토리지값은 외부 변경도 가능하므로 문제가 있을 수 있으나 기존 내용을 보면 로그인 체크가 필요한 경우 java상에서 처리해서 로그인 화면으로 보내버리는 것으로 확인함.
    //   - 따라서 조작가능하더라도 직접적인 문제는 없을 듯함.  일단 이상태로 유지   ------ 20230905
	if( ${sessionScope.login == null} || sessionStorage.getItem("loginScriptCk") == -1 ) {
        $(".loginUserForm").remove();
        $("#layerWrapper" ).css("padding-left","580px");
        
        var touchTmCode = 0  ;
        var intervalVal = "" ;
        function fn_touchStart() {
            intervalVal = setInterval( function() {
                touchTmCode++;
                if( touchTmCode > 5 ) {
                    clearInterval( intervalVal );
                    touchTmCode = 0  ;
                    intervalVal = "" ;
                    //location.href = "/go_Login.do";
                    location.href = "/logout.do";
                }
            }, 1000 );
        }
        function fn_touchEnd() {
            if( !intervalVal ) {
                clearInterval( intervalVal );
                touchTmCode = 0  ;
                intervalVal = "" ;
            }
        }
        //$(document).on("mousedown" , "#headerLinkTag", fn_touchStart );
        //$(document).on("mouseup"   , fn_touchEnd );
        $(document).on("touchstart", "#headerLinkTag", fn_touchStart );
        $(document).on("touchend"  , fn_touchEnd );
    }
    
</script>
