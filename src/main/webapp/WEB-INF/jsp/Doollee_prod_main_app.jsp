<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>

<link href="resrc/css/common_admin.css" rel="stylesheet">

<link href="resrc/vendor/bootstrap/css/datepicker3.css" rel="stylesheet">    <!-- date picker 관련 import -->
<script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.js"></script>    <!-- date picker 관련 import -->
<script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.kr.js"></script> <!-- date picker 관련 import -->
<script src="https://kit.fontawesome.com/77ad8525ff.js" crossorigin="anonymous"></script> <!-- fontawesome (icon관련) -->

<style>
.select_date_input {width: 100%;height: 32px;border: 1px solid #acacac;border-radius: 2px;padding: 10px;font-size: 11px;}
.select_form_btn   {width: 98%;border-radius: 5px;height: 37px !important;background: royalblue;color: white;font-weight: bolder;}
.left_button       {border-radius: 5px 0px 0px 5px}
.right_button      {border-radius: 0px 5px 5px 0px}
#subArea > #regArea{position:fixed;top:110%;transition:all 0.5s;display:block;border-radius:10px 10px 0 0;height:100%}
#subArea > #regArea > #body_area {height:calc(100vh - 15px);}
#subArea > #regArea > #body_area > div {height:100% !important;}

.windowScroll {overflow-y:auto;height:100%}

/*------------------------------------------------------------------*/
.test-form > .test-circle {
    position: fixed;
    top: 150%;
    left: 50%;
    width: 20vw;
    height: 20vw;
    transform: translate(-50%, -50%);
    background: repeating-radial-gradient(orangered, darkorange, white 75px);
    z-index: 100;
    border-radius: 249px;
    box-shadow: 0px 0px 150px 75px orange;
    transition: all 20s;
}
.test-form > .test-back {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 200vh;
    opacity: 0.8;
    background: linear-gradient(180deg, black, black, transparent, floralwhite, lightskyblue);
    z-index: 99;
    transition: all 20s;
}
.test-form.on > .test-circle { top: 50%;    }
.test-form.on > .test-back   { top: -100vh; }
.test-back    > .fa-star     { color: floralwhite; position: fixed; z-index: 100; opacity: 1; transition: all 20s; }
.test-form.on   .fa-star     { opacity: 0 } 
</style>

<!--container-->
<div class="container" style="padding-top:75px">
    <form name="holiInfoForm" id="holiInfoForm" method="post">
        <!-- data-st1 -->
        <div class="data-st4" style="margin-left:5px">
            <table style="overflow: auto;">
                <tr>
                    <th>제품구분</th>
                    <td colspan="2">
                        <label class="selectbox-form">
                            <input type="text" id="prod_gbn" value="전체" code="" readOnly>
                            <div>
        	           	        <ul class="scrollCat-selbox">
        	           	            <li value="">전체</li>
                                    <c:forEach var="prod_gbn_list" items="${prod_gbn_list}" varStatus="i">
                                        <li value="${prod_gbn_list.simp_c}">${prod_gbn_list.simp_cnm}</li>
                                    </c:forEach>
        	           	        </ul>
        	           	    </div>
        	           	</label>
                    </td>
                </tr>
                <tr>
                    <th>장비상태</th>
                    <td colspan="2">
                        <label class="selectbox-form">
                            <input type="text" id="prod_sts" value="전체" code="" readOnly>
                            <div class="multi-select-div">
        	           	        <ul class="scrollCat-selbox">
        	           	            <li class="all-select" value=""><input type="checkbox"><label>전체</label></li>
                                    <c:forEach var="prod_sts_list" items="${prod_sts_list}" varStatus="i">
                                        <li value="${prod_sts_list.simp_c}">
        	           	                    <input type="checkbox"><label>${prod_sts_list.simp_cnm}</label>
                                        </li>
                                    </c:forEach>
        	           	        </ul>
        	           	    </div>
        	           	</label>
                    </td>
                </tr>
            </table>
        </div>
        <div  style="margin-top: 5px"></div>
        <div class="data-top">
            <div style="text-align:center;width:100%">
                <input class="btn-type3 type3 min-size3 select_form_btn" type="button" value="신규등록" onclick="regInfo();" style="background:linear-gradient(45deg, aquamarine, royalblue)">
            </div>
        </div>
    </form>
    <div id="listArea"></div>
    
    <!-- 20145 20564 ------------------- -->
    <div class="test-form" style="display:none">
        <div class="test-circle"></div>
        <div class="test-back">
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
            <i class="fa-solid fa-star fa-rotate-90 fa-2xs"></i>
        </div>
    </div>
    <!-- ------------------- -->
    
</div>  
<!--/container-->
  
<script> 
    /////////////////////////////
    $(document).on("click", ".test-form", function() {
        if( $(this).hasClass("on") ) {
            randomPos();
            $(this).removeClass("on");
        } else $(this).addClass("on");
    });
    $(document).on("click", ".test-circle", function() {
        $(this).parents(".test-form").hide();
    });
    var testCkChk = 0;
    $("body").on("click", function() {
        if( testCkChk > 2 ) setTimeout( function() { testCkChk=0; }, 1000 );
        testCkChk++;
        if(testCkChk == 10) {
            randomPos();
            $(".test-form").show();
        }
    });
    function randomPos() {
        $(".test-back > .fa-star").each( function() {
            $(this).css("left", Math.round(Math.random() * 1000) %  window.innerWidth     + "px");
            $(this).css("top" , Math.round(Math.random() * 1000) % (window.innerHeight/2) + "px");
        });
    }
    /////////////////////////////

    var pop_gbn = ""; //팝업실행 구분

    //common.css의 logo이미지 filter 제거 (이미지가 하얗게 나와서 안보임)
    $(".header-wrap .wrap-inner img").css("filter", "none");    
    
	//조회조건 하단 버튼 화면크기에 꽉차게
    $(window).resize( function() { contolBtnSize(); });
	
	//조회조건 하단 버튼 크기조정
    function contolBtnSize() {
        var obj = $("#holiRegForm .data-top");
        var cnt = obj.find(".btn-type3").not(".hide").length;
        
        obj.find(".btn-type3").removeClass("left_button").removeClass("right_button");
        if( cnt==1 ) return;
        obj.find(".btn-type3:first").addClass("left_button" );
        obj.find(".btn-type3:last" ).addClass("right_button");
        
        obj.find(".btn-type3").css("width",obj.innerWidth()/cnt-2*(cnt-1));
    }
    
    //조회조건 변경시 조회내용 재조회
    $(document).on("change", "#holiInfoForm INPUT", function() {
        if( !v_startYn ) return;
        selectList();
    });
    
    $("#body_area").scroll( function() {
        //스크롤시 selectbox layer 위치 조정
        var scrollT = $(this).scrollTop();
        var obj     = $("#holiInfoForm .selectbox-form > div");
        obj.each( function() { $(this).css("margin-top", (-1 * scrollT + 2) + "px"); });
    }).addClass("windowScroll");
    
    //조회
    function selectList(){
        $.ajax({
            type:"POST",
            url:"selectProdInfoApp.do",
            data:{ prod_no   : "",
                   prod_gbn  : $("#holiInfoForm #prod_gbn").val(),
                   prod_sts  : $("#holiInfoForm #prod_sts").val()
                 },
            contentType : "application/x-www-form-urlencoded; charset=UTF-8",
            success: function(data) {
                if( data.indexOf("loginChk()") == -1 ) {
                    $("#listArea").html(data);
                } else location.replace("go_Login.do");
            },
            error  : function(data) { console.log("조회중 오류가 발생하였습니다."); }
        });
    }
    
    //휴가신청
    function regInfo(){
        $.ajax({
            url         : "prodInfoReg.do",
            data        : null,
            contentType : "application/x-www-form-urlencoded; charset=UTF-8",
            type        : "POST",
            success     : function(result) {
                if( result.indexOf("loginChk()") == -1 ) {
                    $("#regArea").html(result).show();
                    $("#regArea").css("top", "0");
                    
                    setTimeout( function() { $("body").css("overflow-y", "hidden"); }, 10 );
                    
                } else location.replace("go_Login.do");
            },
            error       : function(e) {
                alert(e.responseText);
            }
        });
    }
    
    //휴가신청정보 상세조회
    function updateView( inProdNo ) {
        $.ajax({
       	    url         : "prodInfoUpd.do",
       	    data        : { prod_no: inProdNo },
       	    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
    	    type        : "POST",
    	    success     : function(result) {
                if( result.indexOf("loginChk()") == -1 ) {
                    $("#regArea").html(result).show();
                    $("#regArea").css("top", "0");
                    
                    setTimeout( function() { $("body").css("overflow-y", "hidden"); }, 10 );
                    
                } else location.replace("go_Login.do");
    	    },
    	    error : function(e) {
    		    alert(e.responseText);
            }
        });
    }

    //화면 초기시작시 실행 (화면 로딩 후)
    var v_startYn = false;
    $(document).ready( function() {
    	selectList();
        contolBtnSize(); //버튼크기조정
        
        v_startYn = true;
        $("#navi_area > .header-wrap").css("z-index", "1"); //구 IOS 팝업실행시 헤더 안보이게 처리 (body_area보다 상위에 올라가지 않게 처리)
    });
  
</script>

<div id="subArea">
    <div id="regArea" class="modal"></div>
</div>

<script>includeHTML();</script>
