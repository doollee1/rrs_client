<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>(주)둘리정보통신</title>
    <!-- Bootstrap core CSS -->
    <link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <!-- <link href="css/modern-business.css" rel="stylesheet"> -->
    <!--css-->
    <link href="resrc/css/common_admin.css" rel="stylesheet">
    <link href="resrc/vendor/bootstrap/css/datepicker3.css" rel="stylesheet">    <!-- date picker 관련 import -->
    <!--script-->
    <script src="resrc/vendor/jquery/jquery.js"></script>
    <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.js"></script>    <!-- date picker 관련 import -->
    <script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.kr.js"></script> <!-- date picker 관련 import -->
    <script src="resrc/js/includeHTML.js"></script>  
    <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>

<style>
    body {min-width:500px}
    #holiInfoForm .data-top > .right > input[type=button] {width: 100px}
    .select_date_input {width: 100px;height: 40px;border: 1px solid #acacac;border-radius: 4px;padding: 10px;margin-top: 1px}
    .data-pop-reg select {min-width:100px; max-width:200px; width:100%;}
    #holi_date_gbn {min-width:97px; width:97px}
    .datepicker {width:350px;height:250px}
    #regButton {border-radius:5px;background:royalblue;
                color:white;font-weight:bold;
                padding:0px 20px;margin-left:10px;
                width:90px;height:35px;line-height:40px;
                text-align:center;box-shadow:2px 2px 1px 0px darkblue
               }
    @media screen and (max-width: 768px) {
        .select_date_input, #regButton {height: 32px;font-size: 11px;line-height: 32px}
        #regButton { width: 80px }
    }
    /*팝업(신청/승인/반려)에서 사용 css 추가*/
    .select_form_btn {width: 98%;border-radius: 5px;height: 37px !important;background: royalblue;color: white;font-weight: bolder;}
    #subArea > #regArea{position:fixed;top:110%;transition:all 0.5s;display:block;border-radius:10px 10px 0 0;height:100%}
    #regArea > #body_area {max-width:500px;margin:auto;}
    #regArea > #body_area > .modal-content {margin-top:calc(50vh - 55%);}
    #regArea .data-st4 {max-height:420px;}
    
    .windowScroll {overflow-y:auto;height:100%}                
</style>

<body>
    <script>    
        var v_startYn = false;
        $(window).ready( function() {
            //달력 날짜선택 추가
            $('#holi_date').datepicker({ format: "yyyy-mm-dd", language: "kr", autoclose : true });

            //기준일자 초기값 오늘날짜로
            var thsDate    = new Date();
                thsDate    = new Array( thsDate.getFullYear(), thsDate.getMonth() + 1, thsDate.getDate() );
                thsDate[1] = (thsDate[1] + "").padStart(2, '0');
                thsDate[2] = (thsDate[2] + "").padStart(2, '0');
            $('#holi_date').datepicker("setDate", thsDate.join("-") );

            $(".container").scroll( function() {
                //스크롤시 selectbox layer 위치 조정
                var scrollT = $(this).scrollTop();
                var obj     = $("#holiInfoForm .selectbox-form > div");
                obj.each( function() { $(this).css("margin-top", (-1 * scrollT + 2) + "px"); });
            }).addClass("windowScroll");
            
            //조회
            selectListSearch();
            
            v_startYn = true;
        });
        
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
        
        //휴가신청버튼 클릭
        $(document).on("click", "#regButton", function() {
            $.ajax({
                url : "holiInfoRegApp.do",
                data : null,
                contentType : "application/x-www-form-urlencoded; charset=UTF-8",
                type : "POST",
                success : function(result) {
                    if( result.indexOf("loginChk()") == -1 ) {
                        $("#regArea").html(result).show();
                        $("#regArea").css("top", "0");
                        
                        setTimeout( function() { $(".windowScroll").css("overflow-y", "hidden"); }, 10 );
                        
                    } else location.replace("go_Login.do");
                }, 
                error : function(e) {
                    alert(e.responseText);
                }
            });
        });
        
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
                        $("#regArea").css("top", "0");

                        setTimeout( function() { $(".windowScroll").css("overflow-y", "hidden"); }, 10 );
                        
                    } else location.replace("go_Login.do");
                },
                error : function(e) {
                    alert(e.responseText);
                } 
            });
        }

        //조회
        function selectListSearch(){
            $.ajax({
                type:"POST",
                url:"selectHoliInfo.do",
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
    </script>

    <!--navigation-->
    <jsp:include page="common/Navigation.jsp" />
  	
    <!--container-->
    <div class="container">
        <div class="left">
            <p class="tit-type4">휴가 관리 </p>
        </div> 
        <form name="holiInfoForm" id="holiInfoForm" action="" method="post" >
            <!-- data-st1 -->
            <div class="data-pop-reg data-st2">
                <table>
                    <colgroup >
                        <col style="width:20%" />
                        <col style="width:30%" />
                        <col style="width:20%" />
                        <col style="width:auto" />
                    </colgroup >
                    <tr>
                        <th>기준일자</th>
                        <td colspan="3">
                            <input id="holi_date" class="date select_date_input" readOnly>
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
        	           	    <input id="regButton" value="휴가신청" readOnly style="cursor:pointer">
                        </td>
                    </tr>
                    <tr>
                        <th>휴가구분</th>
                        <td scope="col" >
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
                        <th>신청구분</th>
                        <td scope="col" >
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
            <!-- // data-st2 -->          
        </form>
        
        <div id="listArea"></div>
    </div>
    <!--/container-->
  
    <jsp:include page="common/Footer.jsp" />
    <script>includeHTML();</script>
</body>

<div id="subArea">
    <div id="regArea" class="modal"></div>
</div>

</html>