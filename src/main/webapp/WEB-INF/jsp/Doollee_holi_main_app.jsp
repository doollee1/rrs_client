<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>

<link href="resrc/css/common_admin.css" rel="stylesheet">

<link href="resrc/vendor/bootstrap/css/datepicker3.css" rel="stylesheet">    <!-- date picker 관련 import -->
<script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.js"></script>    <!-- date picker 관련 import -->
<script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.kr.js"></script> <!-- date picker 관련 import -->

<style>
.select_date_input {width: 100%;height: 32px;border: 1px solid #acacac;border-radius: 2px;padding: 10px;font-size: 11px;}
.select_form_btn   {width: 98%;border-radius: 5px;height: 37px !important;background: royalblue;color: white;font-weight: bolder;}
.left_button       {border-radius: 5px 0px 0px 5px}
.right_button      {border-radius: 0px 5px 5px 0px}
#subArea > #regArea{position:fixed;top:110%;transition:all 0.5s;display:block;border-radius:10px 10px 0 0;height:100%}
#subArea > #regArea > #body_area {height:calc(100% - 15px);}
#subArea > #regArea > #body_area > div {height:100% !important;}

.windowScroll {overflow-y:auto;height:100%}
</style>

<!--container-->
<div class="container" style="padding-top:75px">
    <form name="holiInfoForm" id="holiInfoForm" method="post">
        <!-- data-st1 -->
        <div class="data-st4" style="margin-left:5px">
            <table style="overflow: auto;">
                <tr>
                    <th style="width: 30%">기준일자</th>
                    <td>
                        <input id="holi_date" class="date select_date_input" readOnly>
                    </td>
                    <td>
                        <label class="selectbox-form">
                            <input type="text" id="holi_date_gbn" value="7일전" code="1WEEK" readOnly>
                            <div>
        	           	        <ul class="scrollCat-selbox">
                                    <li value="0DAY"  >하루</li>
                                    <li value="1WEEK" class="selected">7일전</li>
                                    <li value="1MONTH">1개월전</li>
                                    <li value="3MONTH">3개월전</li>
        	           	        </ul>
        	           	    </div>
        	           	</label>
                    </td>
                </tr>
                <tr>
                    <th>휴가구분</th>
                    <td colspan="2">
                        <label class="selectbox-form">
                            <input type="text" id="holi_gbn_search" value="전체" code="" readOnly>
                            <div>
        	           	        <ul class="scrollCat-selbox">
        	           	            <li value="">전체</li>
                                    <c:forEach var="holi_gbn_list" items="${holi_gbn_list}" varStatus="i">
                                        <li value="${holi_gbn_list.simp_c}">${holi_gbn_list.simp_cnm}</li>
                                    </c:forEach>
        	           	        </ul>
        	           	    </div>
        	           	</label>
                    </td>
                </tr>
                <tr>
                    <th>신청구분</th>
                    <td colspan="2">
                        <label class="selectbox-form">
                            <input type="text" id="holi_sts_search" value="전체" code="" readOnly>
                            <div>
        	           	        <ul class="scrollCat-selbox">
        	           	            <li value="">전체</li>
                                    <c:forEach var="holi_sts_list" items="${holi_sts_list}" varStatus="i">
                                        <li value="${holi_sts_list.simp_c}">${holi_sts_list.simp_cnm}</li>
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
                <input class="btn-type3 type3 min-size3 select_form_btn" type="button" value="휴가신청" onclick="regInfo();" style="background:linear-gradient(45deg, aquamarine, royalblue)">
            </div>
        </div>
    </form>
    <div id="listArea"></div>
</div>  
<!--/container-->
  
<script> 
    var pop_gbn = ""; //팝업실행 구분

    //common.css의 logo이미지 filter 제거 (이미지가 하얗게 나와서 안보임)
    $(".header-wrap .wrap-inner img").css("filter", "none");    
    
    //달력 날짜선택 추가
    $('#holi_date').datepicker({ format: "yyyy-mm-dd", language: "kr", autoclose : true });
    
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
    $(document).on("change", "#holiInfoForm SELECT, #holiInfoForm INPUT", function() {
        if( !v_startYn ) return;
        if( $(this).hasClass("date") ) {
        	if( !$(this).val() ) $('#holi_date').datepicker("setDate", $(this).attr("focusInitVal") );
            if( $(this).val()==$(this).attr("focusInitVal") ) return;
        }
        selectListSearch();
    });
    $(document).on("focus", "#holiInfoForm .date", function() {
        $(this).attr("focusInitVal", $(this).val());
    });
    
    $("#body_area").scroll( function() {
        //스크롤시 selectbox layer 위치 조정
        var scrollT = $(this).scrollTop();
        var obj     = $("#holiInfoForm .selectbox-form > div");
        obj.each( function() { $(this).css("margin-top", (-1 * scrollT + 2) + "px"); });
    }).addClass("windowScroll");
    
    //조회
    function selectListSearch(){
        $.ajax({
            type:"POST",
            url:"selectHoliInfoApp.do",
            data:{
                request_dt : $("#holi_date").val().replace(/-/g, ''),
                holi_tp    : $("#holi_gbn_search").val(),
                appr_gbn   : $("#holi_sts_search").val(),
                dayNum     : $("#holi_date_gbn"  ).val().replace(/[^0-9]/g, '') * -1,
                dayType    : $("#holi_date_gbn"  ).val().replace(/[0-9]/g , '')
            },
            contentType : "application/x-www-form-urlencoded; charset=UTF-8",
            success:function(data){
                $("#listArea").html(data);
            },
            error:function(data){
            	console.log(data);
                console.log("조회중 오류가 발생하였습니다.");
            }
        });
    }
    
    //휴가신청
    function regInfo(){
        $.ajax({
            url : "holiInfoRegApp.do",
            data : null,
            contentType : "application/x-www-form-urlencoded; charset=UTF-8",
            type : "POST",
            success : function(result) {
                if( result.indexOf("loginChk()") == -1 ) {
                    $("#regArea").html(result).show();
                    $("#regArea").css("top", "15px");
                    if( window["deviceInfo"]["device_model"].indexOf("iPhone 6 ") > -1 ) {
                        $("#regArea").css("top", "0px" ); //구버전 IOS에서만
                    }
                    
                    setTimeout( function() { $(".windowScroll").css("overflow-y", "hidden"); }, 10 );
                    
                } else location.replace("go_Login.do");
            }, 
            error : function(e) {
                alert(e.responseText);
            }
        });
    }
    
    //휴가신청정보 상세조회
    function updateView(holiSeq){
        $.ajax({
            url : "holiInfoRegApp.do",
            data : {"holi_seq": holiSeq },
            contentType : "application/x-www-form-urlencoded; charset=UTF-8",
            type : "POST",
            success : function(result) {
                if( result.indexOf("loginChk()") == -1 ) {
                    $("#regArea").html(result).show();
                    $("#regArea").css("top", "15px");
                    if( window["deviceInfo"]["device_model"].indexOf("iPhone 6 ") > -1 ) {
                        $("#regArea").css("top", "0px" ); //구버전 IOS에서만
                    }
                    
                    setTimeout( function() { $(".windowScroll").css("overflow-y", "hidden"); }, 10 );
                    
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
        //기준일자 초기값 오늘날짜로
        var thsDate    = new Date();
            thsDate    = new Array( thsDate.getFullYear(), thsDate.getMonth() + 1, thsDate.getDate() );
            thsDate[1] = (thsDate[1] + "").padStart(2, '0');
            thsDate[2] = (thsDate[2] + "").padStart(2, '0');
        $('#holi_date').datepicker("setDate", thsDate.join("-") );
        
        selectListSearch();
        contolBtnSize(); //버튼크기조정
        
        v_startYn = true;
        
        $("#navi_area > .header-wrap").css("z-index", "0"); //구 IOS 팝업실행시 헤더 안보이게 처리 (body_area보다 상위에 올라가지 않게 처리)
    });
  
</script>

<div id="subArea">
    <div id="regArea" class="modal"></div>
</div>

<script>includeHTML();</script>
