<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>

<style>
#holiRegForm table td {padding:0 !important; padding-bottom:10px !important}
select:disabled, input:disabled, textarea:disabled {cursor:default; background:transparent; color:darkgray; opacity:0.8}
select option {color:black}
.datepickter-today {color:red}

@media screen and (max-width: 500px) { .modal-content { width: 100%; } } /* 화면너비 300px 이하에서 vw, vh값 이상해짐? */
</style>

<div class="modal-content" style="padding:20px;height:100%">
    <form name="sentMessage" id="holiRegForm" action="" method="post" style="height:100%">
    	<div class="left wHead">
            <table><tr>
                <td style="width:135px"><p class="tit-type4">휴가신청</p></td>
                <td style="color:red;font-weight:bold;font-style:oblique"><p id="masterAdminTit" style="display:none">MASTER LOGIN</p></td>
                <td style="text-align:right;font-size:250%">
                    <div style="position:absolute;top:12px;right:20px;cursor:pointer" onclick="winClose();">×</div>
                </td>
            </tr></table>
        </div>
        <!-- data-st4 -->
        <div class="data-st4 scrollCat pageScroll" style="padding-top: 10px;overflow-y: auto;height: calc(100% - 90px);scroll-behavior: smooth;">
            <c:forEach items="${holiList}" var="holiList" varStatus="status">
                <input type="hidden" id="holi_seq" class="chk" value="${holiList.holi_seq}">
                <table id="requestArea">
                    <colgroup>
                        <col style="width:30%"  />
                        <col style="width:auto" />
                    </colgroup>
                    <tr>
                        <th>휴가구분 </th>
                        <td scope="col" style="border-right:hidden !important">
                            <label class="selectbox-form">
                                <input type="text" id="holi_tp" value="${holiList.holi_tp_nm}" code="${holiList.holi_tp}" readOnly>
                                <div>
        	           	            <ul class="scrollCat-selbox">
        	           	                <c:forEach var="holi_gbn_list" items="${holi_gbn_list}" varStatus="i">
                                            <li value="${holi_gbn_list.simp_c}">${holi_gbn_list.simp_cnm}</li>
                                        </c:forEach>
        	           	            </ul>
        	           	        </div>
                            </label>
                        </td>            
                    </tr>
                    <tr>
                        <th rowspan="2">휴가일자</th>
                        <td scope="col" style="border-right:hidden !important">
                            <input type="text" id="holi_st_dt" class="date" inputmode="Numeric" value="${holiList.holi_st_dt}" onchange="dateDiff();" readOnly>
                        </td>
                    </tr>
                    <tr>
                        <td scope="col" style="border-right:hidden !important">
                            <input type="text" id="holi_ed_dt" class="date" inputmode="Numeric" value="${holiList.holi_ed_dt}" onchange="dateDiff();" readOnly>
                        </td>
                    </tr>
                    <tr>
                        <th>휴가일수</th>
                        <td scope="col" style="border-right:hidden !important">
                            <input type="text" id="holi_dayNum" value="${holiList.holi_dayNum}" disabled="disabled">
                        </td>
                    </tr>
                    <tr>
                        <th>신청자 </th>
                        <td scope="col" style="border-right:hidden !important">
                            <label class="selectbox-form">
                                <input type="text" id="requestor_id" value="${holiList.requestor_nm}" code="${holiList.requestor_id}" readOnly disabled>
                                <div class="selmode-popup">
                                    <div class="title-area">신청자 선택</div>
        	           	            <ul class="scrollCat-selbox">
        	           	                <c:forEach var="member_sel_list" items="${member_sel_list}" varStatus="i">
        	           	                    <li value="${member_sel_list.mb_id}">
        	           	                        <label style="width:100px">${member_sel_list.mb_name}</label>
        	           	                        <label style="width:calc(100% - 106px);text-align:right">
        	           	                            ${member_sel_list.mb_hp}
        	           	                        </label>
        	           	                        <div style="display:none">${member_sel_list.mb_name}</div>
        	           	                    </li>
        	           	                </c:forEach>
        	           	            </ul>
        	           	        </div>
                            </label>
                        </td>            
                    </tr>
                    <tr>
                        <th>승인자 </th>
                        <td scope="col" style="border-right:hidden !important">
                            <label class="selectbox-form">
                                <input type="text" id="approver_id" value="${holiList.approver_nm}" code="${holiList.approver_id}" readOnly>
                                <div>
        	           	            <ul class="scrollCat-selbox">
        	           	                <c:forEach var="holi_appr_list" items="${holi_appr_list}" varStatus="i">
        	           	                    <c:if test="${holi_appr_list.simp_c != login_id || master_yn == '1'}">
        	           	                        <li value="${holi_appr_list.simp_c}">${holi_appr_list.simp_cnm}</li>
        	           	                    </c:if>
                                        </c:forEach>
        	           	            </ul>
        	           	        </div>
                            </label>
                        </td>            
                    </tr>
                    <tr>
                        <th style="vertical-align:top; padding-top:15px">신청사유</th>
                        <td scope="col" style="border-right:hidden !important">
                            <textarea style="width:100%;height:100px;"  id="holi_rsn" maxlength="500" ><c:out value='${holiList.holi_rsn}'/></textarea>
                        </td>
                    </tr>
                </table>
                <table id="apprArea">
                    <colgroup>
                        <col style="width:30%"  />
                        <col style="width:auto" />
                    </colgroup>
                    <tr>
                        <th>승인구분 </th>
                        <td scope="col" style="border-right:hidden !important">
                            <label class="selectbox-form">
                                <input type="text" id="appr_gbn" value="${holiList.appr_gbn_nm}" code="${holiList.appr_gbn}" readOnly>
                                <div>
        	           	            <ul class="scrollCat-selbox">
        	           	                <c:forEach var="holi_sts_list" items="${holi_sts_list}" varStatus="i">
                                            <li value="${holi_sts_list.simp_c}">${holi_sts_list.simp_cnm}</li>
                                        </c:forEach>
        	           	            </ul>
        	           	        </div>
                            </label>
                        </td>            
                    </tr>
                    <tr>
                        <th style="vertical-align:top; padding-top:15px">반려사유</th>
                        <td scope="col" style="border-right:hidden !important">
                            <textarea style="width:100%;height:100px;" id="return_rsn" maxlength="500" ><c:out value='${holiList.return_rsn}'/></textarea>
                        </td>
                    </tr>
                </table>
            </c:forEach>
        </div>
        <!-- // data-st2 -->
            <div class="data-top" id="btmBtnLayer" style="margin-bottom:0;">
                <div style="text-align:center;width:100%">
                    <input id="bt_delete" class="btn-type3 type3 min-size3 select_form_btn" type="button" value="삭제"  onclick="deleteList();" style="background:linear-gradient(45deg, azure, crimson)">
                    <input id="bt_update" class="btn-type3 type3 min-size3 select_form_btn" type="button" value="저장"  onclick="insertList();" style="background:linear-gradient(45deg, azure, royalblue)">
                </div>
            </div>
    </form>
</div>

<div id="userSelPop"></div>

<script>
//현재일자 set
var regPopThsDate = new Date();
regPopThsDate     = new Array( regPopThsDate.getFullYear(), regPopThsDate.getMonth() + 1, regPopThsDate.getDate() );
regPopThsDate[1]  = (regPopThsDate[1] + "").padStart(2, '0');
regPopThsDate[2]  = (regPopThsDate[2] + "").padStart(2, '0');
regPopThsDate     = regPopThsDate.join("-");

//form 내부 표의 selectbox크기 꽉차게
$("#holiRegForm").find("select, input, textarea").css("width","100%");

var initYn = false;
$(window).ready( function() {
    if( !initYn ) {
        //초기실행/설정
        regPopApp_init();
        //날짜관련설정
        betweenDtCheck('#holi_st_dt', '#holi_ed_dt');
	    //하단버튼 위치조정
        var btnFrmObj = $("#btmBtnLayer");
        var popFrmBtm = $("#holiRegForm").offset().top + $("#holiRegForm").innerHeight();
        var btnheight = popFrmBtm - btnFrmObj.offset().top - btnFrmObj.innerHeight() ;
        btnFrmObj.css("margin-top", (btnheight < 10 ? 10 : btnheight) + "px");
        //datepicker set
        $('#holiRegForm .date').datepicker({
            format: "yyyy-mm-dd",
            language: "kr",
            autoclose: true
        });
        
        initYn = true;
    }
});

// 세로스크롤 존재여부에 따라 오른쪽 여백처리 변경 (스크롤개체 안쪽의 개체 크기변화로 판단)
var objectResize = new ResizeObserver(entries => {
    var scrollObj = $("#holiRegForm > .data-st4.scrollCat");
    for(let entry of entries) {
        if( Math.round(scrollObj.outerHeight()) == scrollObj.prop("scrollHeight") ) scrollObj.removeClass("pageScroll");
        else                                                                        scrollObj.addClass   ("pageScroll");
    }
});
objectResize.observe( document.getElementById("requestArea") );

$("#holiRegForm > .data-st4.scrollCat").scroll( function() {
    //스크롤시 selectbox layer 위치 조정
    var scrollT = $(this).scrollTop();
    var obj     = $("#holiRegForm .selectbox-form > div");
    $("#holiRegForm .selectbox-form > div").each( function() {
        $(this).css("margin-top", (-1 * scrollT + 2) + "px");
    });
});

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

//입력내용 저장
function insertList(){
    if(!funCheck()) return;
    
    var param = {}
    $("#holiRegForm .data-st4").find("input, select, textarea").each( function() {
        param[ $(this).attr("id") ] = $(this).val();
    });
    //신청자/승인자 명 저장 (push 보낼때 사용)
    param["requestor_nm"] = $("#requestor_id").attr("value");
    param["approver_nm" ] = $("#approver_id" ).attr("value");
    //신청구분이 없는 경우 신청상태로
    if( !param["appr_gbn"] ) param["appr_gbn"] = "01" ;
    
    $.ajax({
        url         : "updateHoliRegInfo.do",
        data        : param,
        //contentType : "application/x-www-form-urlencoded; charset=UTF-8",
        dataType    : "json",
        type        : "POST",
        success     : function(result) {
            if( result.errorTest.length == 0 ) {
        	    winClose( "저장되었습니다." ); //팝업닫기
                selectListSearch(); 
            } else {
                //세션out
	            if( result.errorTest == "sessionOut" ) {
	                alert("세션이 중단되었습니다.\n재로그인 후 이용해 주세요", function() {
	                    location.replace("go_Login.do");
	                });
	            }
	            if( result.errorTest == "FirebaseMessagingException" ) {
	            	alert(result.device_mb +"-"+ result.device_id + "\n만료된 토큰을 사용중입니다.");
	            }
            }
        },
        error : function(e) {
            alert(JSON.stringify(e));
        }
    });
}

//입력내용 삭제
function deleteList(delyn) {
	if(!$("#holi_seq").val()) {
		alert("삭제할 자료가 없습니다.");
	} else {
		confirm("삭제하시겠습니까?", function( result ) {
		    if( result ) {
				$.ajax({
		            url : "deleteHoliRegInfo.do",
		            data : {holi_seq : $("#holiRegForm #holi_seq").val()},
		            //contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		            dataType :"json",
		            type : "POST",
		            success : function(result) {
		                if( result.errorTest.length == 0 ) {
		            	    winClose( "삭제되었습니다." ); //팝업닫기
		                    selectListSearch();
		                } else {
		                    //세션out
		                    if( result.errorTest == "sessionOut" ) {
		                        alert("세션이 중단되었습니다.\n재로그인 후 이용해 주세요", function() {
			                        location.replace("go_Login.do");
		                        });
		                    }
		                }
		            },
		            error : function(e) {
		                alert(e.responseText);
		            }
		        });
		    }
		});
	}	
}

/* 퀵메뉴 창닫기 기능 */ 
function winClose(inMsg)
{
	var afFunc = function() {
	    $("#regArea").css("top", "110%");
	    setTimeout( function() { $("#regArea").html(""); }, 400 );
	    
	    $(".windowScroll").css("overflow-y", "auto"); //닫은 후 모창의 스크롤 복원
	    $(document).off("change", "#appr_gbn");
	}
    if( inMsg ) alert(inMsg, afFunc);
    else afFunc();
}

//초기실행 함수
function regPopApp_init() {
    if( "${master_yn}" == "1" ) {
        // 마스터 관리자의 경우 전 작업 가능
        $("#holiRegForm .tit-type4").text("휴가관리");
        $("#masterAdminTit").show();
        // 마스터 관리자는 신청자 수정 가능
        $("#requestor_id").prop("disabled", false);
        
        if( !$("#holi_seq").val() ) $("#bt_delete").remove(); //신규 신청시 삭제버튼 없음
        
    } else if( $("#holi_seq").val() ) {
        //기 등록 내용 수정/삭제/승인/반려 처리시

        if( $("#approver_id").val() == "${login_id}" ) {
            $("#holiRegForm #requestArea").find("input, select, textarea").prop("disabled", true);
            $("#bt_delete").remove(); //승인자로 실행시 삭제버튼 없음
            
            $("#holiRegForm .tit-type4").text("휴가승인/반려");

            //휴가시작일이 오늘 이전이면 수정불가
            if( $("#holi_st_dt").val() < regPopThsDate ) {
                $("#holiRegForm table").find("input, select, textarea").prop("disabled", true);
                $("#bt_update").remove();
                $("#holiRegForm .data-st4").css("height", "calc(100% - 40px)");
            }
            
        } else {
            if( $("#appr_gbn").val() == "01" ) $("#holiRegForm #apprArea").remove();
            else {
                //신청자로 실행시 승인/반려 상태이면 수정불가 삭제불가
                $("#holiRegForm table").find("input, select, textarea").prop("disabled", true);
                $("#bt_update, #bt_delete").remove();
                $("#holiRegForm .data-st4").css("height", "calc(100% - 40px)");
            }
        }
        
    }else {
        //신규등록시 저장버튼만 사용, 승인/반려 처리 없음
        $("#bt_delete").remove();
        $("#holiRegForm #apprArea").remove();
    }

    $("#holiRegForm #appr_gbn").change(); //승인구분 초기 이벤트 발생
    contolBtnSize();         //버튼 크기/위치조정
    
    $(".windowScroll").css("overflow-y", "hidden"); //실행 후 모창의 스크롤 막기
}

//승인구분 변경 이벤트
$(document).off("change", "#holiRegForm #appr_gbn");
$(document).on ("change", "#holiRegForm #appr_gbn", function() {
    if( $(this).val() == "09" ) {
        $(this).parents("tr").next().show();
        if( $("body").css("overflow-y") == "hidden" ) {
            $(this).parents(".data-st4").scrollTop($(this).parents(".data-st4").prop("scrollHeight"));
        }
    } else $(this).parents("tr").next().hide();
    
    if( "${master_yn}" == "1" ) {
        //마스터 승인자인 경우 신청구분을 승인,반려 선택시 승인자선택을 로그인사용자로 고정 신청 선택시 기존값으로 변경
        if( $(this).val() == "02" || $(this).val() == "09" ) {
            $("#approver_id").attr("originalValue", $("#approver_id").val());
            $("#approver_id").val("${login_id}");
            $("#approver_id").prop("disabled", true);
        } else {
            if( typeof $("#approver_id").attr("originalValue") !== "undefined" ) {
                $("#approver_id").val( $("#approver_id").attr("originalValue") );
                $("#approver_id").removeAttr("originalValue");
                $("#approver_id").prop("disabled", false);
            }
        }
    }
});

//달력에 현재일 표시
$(document).off("focus", "#holiRegForm .date");
$(document).on ("focus", "#holiRegForm .date", function() {
    setTimeout( function() {
        var obj        = "";
        var pickerData = "";
        var thsDate    = regPopThsDate.split("-");
        if( $(".datepicker-days").css("display")!="none" ) {
            pickerData = $(".datepicker-days .datepicker-switch").text().split("월 ");
            if( Number(thsDate[1])==pickerData[0] && thsDate[0]==pickerData[1] ) {
                obj = $(".datepicker-days").find(".day").not(".old").not(".new").eq( thsDate[2]-1 );
            }
        }
        if( $(".datepicker-months").css("display")!="none" ) {
            pickerData = $(".datepicker-months .datepicker-switch").text();
            if( thsDate[0]==pickerData ) {
                obj = $(".datepicker-months").find(".month").eq( thsDate[1]-1 );
            }
        }
        if( $(".datepicker-years").css("display")!="none" ) {
            pickerData = $(".datepicker-years .datepicker-switch").text().split("-");
            for(var i=0; i<=pickerData[1]-pickerData[0]; i++) {
                if( i + Number(pickerData[0]) == thsDate[0] ) {
                    obj = $(".datepicker-years").find(".year").not(".old").not(".new").eq( i );
                    break;
                }
            }
        }
        if( obj ) if(!obj.hasClass("active")) obj.css("color","white").css("background","aquamarine");
    }, 1);
});

function betweenDtCheck(frObj, toObj) {
    $(document).off("change", frObj);
    $(document).on ("change", frObj, function() {
        if( $(frObj).val() < regPopThsDate ) {
            $(frObj).datepicker("setDate",regPopThsDate);
        }
        if( $(frObj).val() > $(toObj).val() ) {
        	$(toObj).datepicker("setDate",$(frObj).val());
        }
    });
    $(document).off("change", toObj);
    $(document).on ("change", toObj, function() {
        if( $(toObj).val() < regPopThsDate ) {
            $(toObj).datepicker("setDate",regPopThsDate);
        }
    	if( $(frObj).val() > $(toObj).val() ) {
        	$(frObj).datepicker("setDate",$(toObj).val());
        }
    });
    $(document).off("keyup", ".date");
    $(document).on ("keyup", ".date", function(event) {
        var iDate = $(this).val().split("-");     
        iDate = iDate.join("");
        if(iDate.length > 6) {
            iDate = iDate.substr(0,6) + "-" + iDate.substr(6,2);
        }
        if(iDate.length > 4) {
            iDate = iDate.substr(0,4) + "-" + iDate.substr(4);
        }
        if(event.keyCode == '13') $(this).datepicker("setDate",iDate);
        else                      $(this).val(iDate);
    });
}

//두개의 날짜를 비교하여 차이를 알려준다.
function dateDiff(){
    var start_date = $('#holi_st_dt').val();
    var end_date   = $('#holi_ed_dt').val();
    
    var fromDate = new Date(start_date);
    var toDate = new Date(end_date);
    var workingdays = 0;
    var weekday     = new Array(7);
    weekday[0]="Sunday";
    weekday[1]="Monday";
    weekday[2]="Tuesday";
    weekday[3]="Wednesday";
    weekday[4]="Thursday";
    weekday[5]="Friday";
    weekday[6]="Saturday";
    while (fromDate <= toDate){
        var day = weekday[fromDate.getDay()];
        if(day != "Saturday" && day != "Sunday"){
            workingdays++;
        }
        fromDate = new Date(fromDate.getTime() + (60*60*24*1000));
    }
    $('#holi_dayNum').val(workingdays + "");
}

function funCheck(){
    if($("#holiRegForm #holi_st_dt").val()==""){
        alert("휴가시작일자는 필수항목입니다.");
        return false;
    }
    if($("#holiRegForm #holi_ed_dt").val()==""){
        alert("휴가종료일자는 필수항목입니다.");
        return false;
    }
    if($("#holiRegForm #holi_dayNum").val()==""){
        alert("휴가일수는 필수항목입니다.");
        return false;
    }
    if(Number($("#holiRegForm #holi_st_dt").val().split("-").join("")) > Number($("#holiRegForm #holi_ed_dt").val().split("-").join(""))){
        alert("휴가종료일자는 휴가시작일자보다 커야합니다.");
        return false;
    }
    if( !$("#holi_tp").val() ){
        alert("휴가구분을 선택해주세요.");
        return false;
    }
    if( !$("#approver_id").val() ){
        alert("승인자를 선택해주세요.");
        return false;
    }
    if( !$("#holi_rsn").val() ){
        alert("신청사유를 적어주세요.");
        return false;
    }
    if( $("#appr_gbn").val()=="09" && $.trim($("#return_rsn").val())=="" ){
        alert("반려사유를 적어주세요.");
        return false;
    }
    if( $("#holi_dayNum").val()=="0" || $("#holi_dayNum").val()=="" ){
        alert("휴가일수가 0입니다. 휴가일자를 다시 확인해주세요.\n(휴가기간에는 주말 이외의 날짜가 포함되어야 합니다.)");
        return false;
    }
    return true;
}

</script>
