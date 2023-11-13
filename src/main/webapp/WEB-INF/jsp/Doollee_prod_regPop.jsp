﻿<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
#prodRegForm table td, #prodRegForm table th {
    font-size: 13px;
    padding: 5px 0 ;
}
#prodRegForm input, #prodRegForm textarea {
    font-size: 13px;
    padding: 7px 10px ;
    width: 100%;
}
#prodRegForm table th:nth-child(3) {
    padding-left: 3%;
}
.popupDivArea {
    display: block;
    background: white;
    max-width: 500px;
    min-width: 400px;
    max-height: 600px;
    width: 80%;
    position: relative;
    top: 50%;
    transform: translate(0, -50%);
    margin: auto;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 2px 2px 5px 0px black;
}
.datepicker { width: 360px; height: 250px; }
.areaLine { border: 1px solid silver; border-left: 0; border-right: 0; margin-bottom: 0.3rem; height: 3px; }
input:disabled, textarea:disabled {cursor:default; background:transparent; color:darkgray; opacity:0.8}

@media screen and (max-width: 500px) { .modal-content { width: 100%; } } /* 화면너비 300px 이하에서 vw, vh값 이상해짐? */
</style>

<script>
var pop_gbn = '${prod_no}' ? 'update' : 'insert' ;

/* 세로스크롤 존재여부에 따라 오른쪽 여백처리 변경 (스크롤개체 안쪽의 개체 크기변화로 판단) */
var objectResize = new ResizeObserver(entries => {
    var scrollObj = $("#prodRegForm").parents(".data-pop-reg.scrollCat");
    for(let entry of entries) {
       if( Math.round(scrollObj.outerHeight()) == scrollObj.prop("scrollHeight") ) scrollObj.removeClass("pageScroll");
       else                                                                        scrollObj.addClass   ("pageScroll");
    }
});
objectResize.observe( document.getElementById("prodRegForm") );

/* 장비상태 선택 변경시 이벤트 */
$(document).off("change", "[regkeyname=prod_sts]");
$(document).on ("change", "[regkeyname=prod_sts]", function() {
    if( $(this).val() == '9' ) {
        $("[regkeyname=disuse_dt]"  ).val( $("[regkeyname=disuse_dt]"  ).attr("originData") );
        $("[regkeyname=disuse_expl]").val( $("[regkeyname=disuse_expl]").attr("originData") );
        $("[regkeyname=disuse_dt], [regkeyname=disuse_expl]").parents("tr").show();
    } else {
        $("[regkeyname=disuse_dt]"  ).val( "" );
        $("[regkeyname=disuse_expl]").val( "" );
        $("[regkeyname=disuse_dt], [regkeyname=disuse_expl]").parents("tr").hide();
    }
});

$(document).ready(function(){
    $('.date').datepicker({
        displayFormat: "yyyy-mm-dd",
        format       : "yyyy-mm-dd",
        language     : "kr"        ,
        autoclose    : true
    });
    $('[regkeyname=prod_ym]').datepicker({
        changeMonth  : true      ,
        changeYear   : true      ,
        displayFormat: "yyyy-mm" ,
        format       : "yyyy-mm" ,
        language     : "kr"      ,
        autoclose    : true
    });
    if( pop_gbn == "update" ) {
        //수정상태로 진입시만 처리내용
        $("[regkeyname=prod_gbn]"    ).prop("disabled", true);
        $("[regkeyname=buy_dt]"      ).prop("disabled", true);
    } else {
        //신규등록상태로 진입시만 처리내용
        $(".footerButtonArea > input").last() .hide();
        $(".footerButtonArea > input").first().css("width", "254px");
        //구입일자 초기값 오늘날짜로
        var thsDate    = new Date();
            thsDate    = new Array( thsDate.getFullYear(), thsDate.getMonth() + 1, thsDate.getDate() );
            thsDate[1] = (thsDate[1] + "").padStart(2, '0');
            thsDate[2] = (thsDate[2] + "").padStart(2, '0');
        $('[regkeyname=buy_dt]').datepicker("setDate", thsDate.join("-") );
    }
    //장비상태 초기값으로 이벤트 발생
    $("[regkeyname=prod_sts]").change();
    
    $(window).resize();
});

$(window).resize( function() {
    var obj = $("#prodRegForm").parents(".modal-content");
    if( $(window).innerWidth() > 500 ) {
        obj.children("div").addClass("popupDivArea");
        obj.css("background", "transparent").css("top", "50%");
        obj.find(".data-pop-reg").css("max-height", "400px");
    } else {
        obj.children("div").removeClass("popupDivArea");
        obj.css("background", "").css("top", "15px");
        obj.find(".data-pop-reg").css("max-height", "100%")
        .css("height", ($(window).innerHeight()-15-154) +"px");
    }
});

/* ** 제조년월만 월 달력 사용하기 */
var prodYnUseYn = false;
var originDate  = ""   ;
$(document).off("focus", "#prodRegForm .date, [regkeyname=prod_ym]");
$(document).on ("focus", "#prodRegForm .date, [regkeyname=prod_ym]", function() {
    originDate = $(this).val();
    if( $(this).attr("regkeyname") == "prod_ym" ) {
        setTimeout( function() {
            if( $(".datepicker > .datepicker-days").css("display") == "block" ) {
                $(".datepicker-days .datepicker-switch").click();
            }
            prodYnUseYn = true;
        }, 0 );
    }
});
$(document).off("blur", "#prodRegForm .date, [regkeyname=prod_ym]");
$(document).on ("blur", "#prodRegForm .date, [regkeyname=prod_ym]", function() {
    var obj = $(this);
    setTimeout( function() {
        if( !obj.val() ) obj.datepicker("setDate", originDate );
        originDate = "";

        if( $("[regkeyname=buy_dt]").val() ) {
            if( $("[regkeyname=buy_dt]").val().substr(0, 7) < $("[regkeyname=prod_ym]").val() && $("[regkeyname=prod_ym]").val() ) {
                toastMsgCall( "제조년월은 구입일자보다 이전이어야 합니다" );
                $("[regkeyname=prod_ym]").datepicker("setDate", "" );
            }
            if( $("[regkeyname=buy_dt]").val() > $("[regkeyname=disuse_dt]").val() && $("[regkeyname=disuse_dt]").val() ) {
                toastMsgCall( "폐기일자는 구입일자보다 이후여야 합니다" );
                $("[regkeyname=disuse_dt]").datepicker("setDate", "" );
            }
        }
        
    }, 0 );
});
$(document).off("click", "span.month");
$(document).on ("click", "span.month", function() {
    if( prodYnUseYn ) {
        setTimeout( function() {
            $(".datepicker-days td.day").not('.old').first().click();
            $("[regkeyname=prod_ym]").blur();
            prodYnUseYn = false;
        }, 0 );
    }
});

/* 수량 입력값 없으면 1로 초기화하기 */
$(document).off("blur", "[regkeyname=qty]");
$(document).on ("blur", "[regkeyname=qty]", function() {
    if( $(this).val() < 1 ) $(this).val("1");
});

/* 저장/삭제 버튼 클릭 */
var chkPassYn = false;
$(document).off("click", ".footerButtonArea > input");
$(document).on ("click", ".footerButtonArea > input", function() {
    if( !validateCK() ) { return false; }

    var obj     = $(this);
    var param   = new Object();
    var v_delYn = obj.parent().find("*").length == obj.index() + 1 ;
    
    if( !chkPassYn ) {
        confirm( (v_delYn ? "삭제" : "저장") + "하시겠습니까?" , function( userCk ) {
            if( userCk ) {
                chkPassYn = true;
                obj.click();
            }
        });
        return ;
    }
    chkPassYn = false;
    
    $("#prodRegForm").find("input, textarea").each( function() {
        param[ $(this).attr("regkeyname") ] = $(this).val();
    });
    param["status" ] = pop_gbn ;
    param["del_yn" ] = v_delYn ? "1" : "0" ;
    param["prod_no"] = '${prod_no}' ;

    $.ajax({
  	    url      : "insertProdInfo.do",
  	    data     : param,
        dataType : "json",
  	    type     : "POST",
  	    success  : function(result) {
  	        if( result.errorTest == "sessionOut" ) {
  	            location.replace("go_Login.do");
            } else if( result.errorTest.length == 0 ) {
                winClose( (v_delYn ? "삭제" : "저장") + "되었습니다." ); //팝업닫기
                selectList();
            } else alert( result.errorTest );
  	    },
  	    error : function(e) {
  	        alert(e.responseText);
  	    }
    });
});

/* 필수입력 체크 */
function validateCK() {
    var chkObjLen = 0;
    $(".essential").each( function() {
        if( !$(this).parents("th").next().find("input, textarea").val() ) {
            alert( $(this).parent().text().replace(" *", "") + "은(는) 필수 입력 항목입니다" );
            return false;
        }
        chkObjLen++;
    });
    return $(".essential").length == chkObjLen ;
}

/* 퀵메뉴 창닫기 기능 */ 
function winClose(inMsg)
{
	var afFunc = function() {
	    $("#regArea").css("top", "110%");
	    setTimeout( function() { $("#regArea").html(""); }, 400 );
	    
	    $("body").css("overflow-y", "auto"); //닫은 후 모창의 스크롤 복원
	}
    if( inMsg ) alert(inMsg, afFunc);
    else afFunc();
}

</script>

<div class="modal-content" style="background: transparent; top: 50%; border: 0">
    <div class="popupDivArea">
        <div class="data-top">
            <div class="left" style="width:100%">
                <label class="tit-type3">${modal_title}</label>
                <label style="margin-left: 5px;height: 10px;color: burlywood;font-weight: bold;">${prod_no}</label>
                <label class="areaLine" style="width: 100%; margin-top: 10px;"></label>
            </div>
            <div class="right">
                <div style="position:absolute;top:9px;right:20px;cursor:pointer;font-size:30px" onclick="winClose();">×</div>
            </div>
        </div>
        <!-- data-st2 -->
        <div class="data-pop-reg scrollCat pageScroll" style="overflow-y:auto; max-height:400px;">
            <form name="sentMessage" id="prodRegForm" action="" method="post" >
            <table>
                <colgroup >
                    <col style="width:25%" />
                    <col style="width:75%" />
                </colgroup >
                <tr>
                    <th>제품구분 <span class="essential">*</span></th>
                    <td scope="col">
                        <label class="selectbox-form">
                            <input type="text" regkeyname="prod_gbn" value="${prod_gbn_nm}" code="${prod_gbn}" readOnly>
                            <div>
            	                <ul class="scrollCat-selbox">
            	                    <c:forEach var="prod_gbn_list" items="${prod_gbn_list}" varStatus="i">
                                        <li value="${prod_gbn_list.simp_c}">${prod_gbn_list.simp_cnm}</li>
                                    </c:forEach>
            	                </ul>
            	            </div>
            	        </label>
                    </td>
                </tr>
                <tr>
                    <th>구입일자 <span class="essential">*</span></th>
                    <td scope="col">
                        <input type="text" regkeyname="buy_dt" class="date chk" value="${fn:trim(buy_dt)}" readOnly>
                    </td>
                </tr>
                <tr>
                    <th>장비상태 <span class="essential">*</span></th>
                    <td scope="col">
                        <label class="selectbox-form">
                            <input type="text" regkeyname="prod_sts" value="${prod_sts_nm}" code="${prod_sts}" readOnly>
                            <div>
            	                <ul class="scrollCat-selbox">
            	                    <c:forEach var="prod_sts_list" items="${prod_sts_list}" varStatus="i">
                                        <li value="${prod_sts_list.simp_c}">${prod_sts_list.simp_cnm}</li>
                                    </c:forEach>
            	                </ul>
            	            </div>
            	        </label>
                    </td>          
                </tr>
                <tr>
                    <th>제조사</th>
                    <td scope="col">
                        <input type="text" regkeyname="prod_comp" class="chk" maxlength="100" value="${prod_comp}">
                    </td>
                </tr>
                <tr>
                    <th>모델명</th>
                    <td scope="col">
                        <input type="text" regkeyname="model_nm" class="chk" value="${model_nm}" maxlength="100">
                    </td>
                </tr>
                <tr>
                    <th>S/N</th>
                    <td scope="col">
                        <input type="text" regkeyname="serial_no" class="chk" value="${serial_no}" maxlength="50">
                    </td>
                </tr>
                <tr>
                    <th>크기/수량</th>
                    <td scope="col">
                        <input type="text"   regkeyname="size_expl" maxlength="50" value="${size_expl}" style="width:49%;min-width:1px">
                        <input type="number" regkeyname="qty" maxlength="5" value="<c:if test='${null eq qty }'>1</c:if><c:if test='${null ne qty }'>${qty }</c:if>"
                               style="width:49%;min-width:1px;float:right">
                    </td>
                </tr>
                <tr>
                    <th>제조년월</th>
                    <td scope="col">
                        <input type="text" regkeyname="prod_ym" class="chk" value="${fn:trim(prod_ym)}" readOnly>
                    </td>
                </tr>
                <tr>
                    <th>폐기일자</th>
                    <td scope="col">
                        <input type="text" regkeyname="disuse_dt" class="date chk" value="${fn:trim(disuse_dt)}" originData="${fn:trim(disuse_dt)}" readOnly>
                    </td>
                </tr>
                <tr>
                    <th>폐기사유</th>
                    <td scope="col">
                        <input type="text" regkeyname="disuse_expl" class="chk" value="${disuse_expl}" originData="${disuse_expl}"> 
                    </td>  
                </tr>
                <tr>
                    <th style="vertical-align:top; padding-top:15px">비고</th>
                    <td scope="col">
                        <textarea style="width:100%; height:100px; line-height: 120%;" regkeyname="remark" maxlength="500">${remark}</textarea>
                    </td>  
                </tr>
            </table>
            </form>		
        </div>
        <!-- // data-st2 -->
        <div class="footerButtonArea" style="margin-top: 20px; text-align: right; margin: 20px 3px 3px 3px;">
            <label class="areaLine" style="width: calc(100% - 265px); margin-right: 7px;"></label>
            <input type="button" value="저장" style="height: 40px; width: 125px; background: cornflowerblue; color: white; border-radius: 5px;">
            <input type="button" value="삭제" style="height: 40px; width: 125px; background: coral; color: white; border-radius: 5px;">
        </div>
    <div>
</div>

