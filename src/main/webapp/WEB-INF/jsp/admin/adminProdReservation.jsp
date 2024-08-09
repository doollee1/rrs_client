<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
	.prodReservationListBox {display: flex;width: 100%;justify-content: space-around;gap:10px;text-align:left;}
	.prodReservationListBox > span {width:inherit;word-break:break-word;}
	.prodReservationListBox .reservationUser {margin-left:0%;}
	.prodReservationListBox .reservationUser2 {margin-right:50%;}
	@media (max-width: 767.98px) {
		.prodReservationListBox {flex-direction: column;align-items: flex-start;}
		.prodReservationListBox > span{display:flex;}
		.prodReservationListBox .reservationUser {margin-left:0%;}
	}
</style>

<script>
$(document).ready(function() {	
	setTitle("관리자");
	
	fn_Init();   //최초세팅
	setEvent();
});

//최초 세팅
function fn_Init(){
	//메뉴 감추기
	$(".menu-item").each(function(index, item){

		//로그아웃 제외		
		if ($(this).find(".fa-solid").length < 1){				
			//navigation 메뉴 감추기
			$(this).hide();
		}
		
		if ($(this).find(".flight").length > 0){				
			//navigation 메뉴 감추기
			$(this).show();
		}
				
	});		
	
	var startDt = "${param.start_dt}";
	var endDt   = "${param.end_dt}"
	
	if(isEmpty(startDt) || isEmpty(endDt)){
		//현재일
		var day = new Date();
		startDt = String(day.getFullYear()) + '-'+ String(("0" + (1 + day.getMonth())).slice(-2)) + '-' + String(("0" + day.getDate()).slice(-2));		
		
		//다음달 마지말날짜
		endDt = getlastDayNextMonth();
		$("#start_dt").val(startDt);   	//조회시작일자를 현재일로 설정
		$("#end_dt").val(endDt);  		//조회종료일자를 다음달 마지막날로 설정
		
	} else if(!isEmpty(startDt) && !isEmpty(endDt)){
		$("#start_dt").val(startDt.substring(0, 4) + '-' + startDt.substring(4, 6) + '-' +startDt.substring(6));   	//조회시작일자를 현재일로 설정
		$("#end_dt").val(endDt.substring(0, 4) + '-' + endDt.substring(4, 6) + '-' + endDt.substring(6));  			//조회종료일자를 다음달 마지막날로 설정
		
	}
}

function setEvent() {
	
	//달력클릭시
	var curDate     = new Date();
	var startDate = new Date();
	var endDate   = new Date();
	startDate.setDate(curDate.getDate() -30);       //오늘부터 1달전
	endDate.setFullYear(curDate.getFullYear() + 1); //오늘부터 1년후
	
	
	<%-- datepicker setting --%>
	$(".input-daterange").datepicker({
		todayHighlight: true,
		autoclose: true,
		startDate: startDate,
		endDate: endDate
	})
		
	<%-- datepicker 버튼  이벤트--%>
	$(".input-daterange .input-group").on("click", function() {
		$(this).find("input").datepicker().focus();
	});
	
	$(".reserve-list > li").on("click", function() {
		var form = document.createElement("form");
		var data = $(this).data();

		if(!isEmpty(data)){
			for(key in data) {
				var inputData = document.createElement("input");
				inputData.setAttribute("type" , "hidden" );
				inputData.setAttribute("name" , key      );
				inputData.setAttribute("value", data[key]);
				form.appendChild(inputData);
			}
			
			form.setAttribute("method", "GET");
			form.setAttribute("action", "adminProdDetail.do");
			document.body.appendChild(form);
			form.submit();
		}
	});
}

function isEmpty(value) {
	if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){
		return true
	}else{
		return false
	}
}

//관리자 예약목록 조회
function fn_adminReservationList(){
	if($("#start_dt").val() == "") {
		alert("시작일자를 선택하세요.");
		return false;
	}

	if($("#end_dt").val() == "") {
		alert("종료일자를 선택하세요.");
		return false;
	}
	
	var startDt = $("#start_dt").val().replace(/-/gi, "");  // '-'제거
	var endDt   = $("#end_dt").val().replace(/-/gi, "");    // '-'제거 
	
	location.href = "/adminProdReservation.do?start_dt="+startDt+"&end_dt="+endDt;
}

//다음달 마지막날 구하기
function getlastDayNextMonth(){
	var today = new Date();
	var mm = today.getMonth() + 2;
	var yyyy = today.getFullYear();
	var dd = new Date(yyyy, mm, 0).getDate();

	if(dd < 10) {
		dd='0'+dd
	}
	
	if(mm < 10) {
		mm='0'+mm
	}
	return yyyy + '-'+ mm + '-'+ dd;
}

</script>

<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->	
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">	
		<!-- BEGIN panel -->
		<ul class="nav nav-tabs">
			<li class="nav-item">
				<a href="#default-tab-1" data-bs-toggle="tab" class="nav-link active">
					<span class="d-sm-none">예약상태변경</span>
					<span class="d-sm-block d-none">예약상태변경</span>
				</a>
			</li>
		</ul>
		
		<div class="tab-content panel rounded-0 p-3 m-0">
			<div class="tab-pane fade active show" id="default-tab-1">
				<div class="input-daterange">
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4">시작일자(체크인)</label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="start_dt" name="start_dt" class="form-control text-center" placeholder="날짜를 선택하세요" readonly>
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4">종료일자(체크아웃)</label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="end_dt" name="end_dt" class="form-control text-center" placeholder="날짜를 선택하세요" readonly>
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
					<br/>
					<button id="inqBtn" name="inqBtn" type="button" class="btn btn-theme h-45px w-100 btn-lg fs-14px" onclick="javascript:fn_adminReservationList()">조회</button>
				</div>
				<div>
					<label class="form-label col-form-label  col-md-2"></label>
				</div>
				<div class="panel panel-inverse">
					<div class="panel-body">
						<ul class="reserve-list">									
							<c:if test="${empty prodReservationList}">
								<li class="none">
									<a href="#"><i class="fa fa-times"></i>예약내역이 없습니다.</a>
								</li>
							</c:if>
							
							<c:if test="${not empty prodReservationList}">
								
								<c:forEach items="${prodReservationList}" var = "list">
									<fmt:parseDate var="reqDate" pattern="yyyyMMdd" value="${list.REQ_DT}"/>
									<li class="active" data-req_dt="${list.REQ_DT}" data-seq="${list.SEQ}">
										<a href="javascript:;" style="text-align:center;">
											<span class="prodReservationListBox">
												<span class="date"><span style="min-width: 60px;">예약일 :</span>
													<span style="font-weight:600"><fmt:formatDate value="${reqDate}" pattern="yyyy-MM-dd"/></span>
												</span>
												<span class="reservationUser"><span style="min-width: 60px;">예약자 : </span><span style="font-weight:600">${list.REQ_HAN_NM }</span></span>
												<span class="reservationUser2"><span style="min-width: 60px;">예약상태 : </span><span style="font-weight:600">${list.PRC_NM }</span></span>
											</span>
											<span><i class="fa fa-angle-right fa-lg"></i></span>
										</a>
									</li>
								</c:forEach>
							</c:if>
							
						</ul>
					</div>
				</div>
				<!-- END panel -->
			</div>
		</div>
		<!-- END tab-content -->
	</div>
	<!-- END content-container -->
</div>
