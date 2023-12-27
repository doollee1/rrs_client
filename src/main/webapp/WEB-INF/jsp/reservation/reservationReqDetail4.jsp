<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
<c:set var="msg"  value="" />
	<c:set var="msg2" value="" />
	<c:if test="${reservationDetail.PRC_STS eq '05'}">
		<c:set var="msg"  value="예약을 취소 하시겠습니까?" />
		<c:set var="msg2" value="예약이 취소 되었습니다." />
	</c:if>
	<c:if test="${reservationDetail.PRC_STS eq '06'}">
		<c:set var="msg"  value="환불요청을 하시겠습니까?" />
		<c:set var="msg2" value="환불요청이 등록 되었습니다." />
	</c:if>

$(document).ready(function() {
	<c:if test="${reservationDetail.PRC_STS eq '05'}">
		setTitle("입금대기");
	</c:if>
	<c:if test="${reservationDetail.PRC_STS eq '06'}">
		setTitle("예약확정");
	</c:if>
	<c:if test="${reservationDetail.PRC_STS eq '07'}">
		setTitle("예약취소");
	</c:if>
	<c:if test="${reservationDetail.PRC_STS eq '08'}">
		setTitle("환불요청");
	</c:if>
	setEvent();

	<%-- 데이터 셋팅 --%>
	var detailData = JSON.parse('${strReservationDetail}');
	for(key in detailData) {
		var objId = "#" + key.toLowerCase();
		if($(objId).length >= 1) {
			if($(objId).hasClass("toNumber")) {
				$(objId).val(numberComma(detailData[key]));
			} else {
				$(objId).val(detailData[key]);
			}
		}
	}

	<%-- 이벤트 함수 --%>
	function setEvent() {
		<%-- 예약취소 버튼 --%>
		$("#reservationCancelBtn").on("click", function() {
			var data = {
				  req_dt  : $("#req_dt").val()
				, seq     : $("#seq"   ).val()
				, prc_sts : "${reservationDetail.PRC_STS}"
			}

			$.ajax({
				type : "POST",
				url : "getPrcSts.do",
				data : data,
				dataType : "json",
				success : function(retData) {
					if(retData.result == "SUCCESS") {
						if(retData.prc_sts == "${reservationDetail.PRC_STS}") {
							if(confirm("${msg}")) {
								dimOpen();
								$.ajax({
									type : "POST",
									url : "reservationCancel.do",
									data : data,
									dataType : "json",
									success : function(retData2) {
										dimClose();
										if(retData2.result == "SUCCESS") {
											alert("${msg2}");
											location.replace("/main.do");
										} else if(retData2.msg != ""){
											alert(retData2.msg);
										} else {
											alert("상태값이 변경되어 수정할 수 없습니다.");
										}
									}
								});
							}
						}
					}
			 	}
			})
		});
	}
});
</script>

<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
		<!-- BEGIN nav-tabs -->
		<ul class="nav nav-tabs">
			<li class="nav-item">
				<a href="#default-tab-1" data-bs-toggle="tab" class="nav-link active">
					<span class="d-sm-none">객실</span>
					<span class="d-sm-block d-none">Default 객실</span>
				</a>
			</li>
			<li class="nav-item">
				<a href="#default-tab-2" data-bs-toggle="tab" class="nav-link">
					<span class="d-sm-none">옵션</span>
					<span class="d-sm-block d-none">Default 옵션</span>
				</a>
			</li>
		</ul>
		<!-- END nav-tabs -->
		<!-- BEGIN tab-content -->
		<div class="tab-content panel rounded-0 p-3 m-0">
			<input type="hidden" id="req_dt"       name="req_dt"       />
			<input type="hidden" id="seq"          name="seq"          />
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				<div class="input-daterange">
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4">체크인</label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="chk_in_dt" name="chk_in_dt" class="form-control text-start" placeholder="날짜를 선택하세요" readonly>
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4">체크아웃</label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="chk_out_dt" name="chk_out_dt" class="form-control text-start" placeholder="날짜를 선택하세요" readonly>
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">한글이름</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" value="${sessionScope.login.han_name}" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">영문이름</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" value="${sessionScope.login.eng_name}" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">객실타입</label>
					<div class="col-md-9">
						<select id="room_type" name="room_type" class="form-select readonly">
							<c:forEach items="${roomTypeList}" var="room" varStatus="status">
								<option value="${room.CODE}">${room.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="total-people-wrap">
					<div class="inline-flex">
						<div class="col-form-label">총인원</div>
						<input type="text" id="tot_person" name="tot_person" class="toNumber form-control text-end" readonly>명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">라운딩</div>
						<input type="text" id="r_person" name="r_person" maxlength="3" class="toNumber form-control text-end" readonly>명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">비라운딩</div>
						<input type="text" id="n_person" name="n_person" maxlength="3" class="toNumber form-control text-end" readonly>명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">소아</div>
						<input type="text" id="k_person" name="k_person" maxlength="3" class="toNumber form-control text-end" readonly>명
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Flight In</label>
					<div class="col-sm-9">
						<select id="flight_in" name="flight_in" class="form-select readonly">
							<c:forEach items="${fligthInList}" var="fligthIn" varStatus="status">
								<option value="${fligthIn.CODE}">${fligthIn.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Flight Out</label>
					<div class="col-sm-9">
						<select id="flight_out" name="flight_out" class="form-select readonly">
							<c:forEach items="${fligthOutList}" var="fligthOut" varStatus="status">
								<option value="${fligthOut.CODE}">${fligthOut.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">항공권 첨부</label>
					<div class="col-sm-9" style="display:none;">
						<input id="fligthImage" name="fligthImage" type="file" accept="image/*" class="form-control" readonly/>
						수정 시 필수 사항이 아닙니다.
					</div>
					<div class="col-sm-9">
						<input id="fligth_image" name="fligth_image" type="text" class="form-control" readonly>
					</div>
				</div>
			</div>
			<!-- END tab-pane -->
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-2">
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">패키지</label>
					<div class="col-sm-9">
						<select id="package_" class="form-select readonly">
							<c:forEach items="${packageList}" var="package_" varStatus="status">
								<option value="${package_.CODE}">${package_.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">미팅샌딩</label>
					<div class="col-md-9 inline-flex">
						<select id="pick_gbn" name="pick_gbn" class="form-select readonly">
							<c:forEach items="${pickupSvcList}" var="pickupSvc" varStatus="status">
								<option value="${pickupSvc.CODE}">${pickupSvc.CODE_NM}</option>
							</c:forEach>
						</select>
						<input id="per_num" type="text" maxlength="3" class="toNumber form-control text-end" readonly>명
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">싱글룸 추가</label>
					<div class="col-md-9 inline-flex">
						<input type="text" id="add_r_s_per" name="add_r_s_per" maxlength="3" class="toNumber form-control text-end" readonly>명
						<input type="text" id="add_r_s_day" name="add_r_s_day" maxlength="3" class="toNumber form-control text-end" readonly>일
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">프리미어룸 추가</label>
					<div class="col-md-9 inline-flex">
						<input type="text" id="add_r_p_per" name="add_r_p_per" maxlength="3" class="toNumber form-control text-end" readonly>명
						<input type="text" id="add_r_p_day" name="add_r_p_day" maxlength="3" class="toNumber form-control text-end" readonly>일
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Late Check Out</label>
					<div class="col-md-9">
						<select id="late_check_out" name="late_check_out" class="form-select readonly">
							<c:forEach items="${lateOutYnList}" var="lateOutYn" varStatus="status">
								<option value="${lateOutYn.CODE}">${lateOutYn.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">추가 요청사항</label>
					<div class="col-md-9">
						<textarea id="remark" name="remark" class="form-control readonly" rows="3"></textarea>
					</div>
				</div>
					<div class="mb-2">
						<div class="inline-flex calc">
							<label class="form-label col-form-label">계약금</label>
							<input type="text" id="dep_amt" name="dep_amt" class="toNumber form-control text-end" readonly>원
						</div>
					</div>
					<div class="mb-2">
						<div class="inline-flex calc">
							<label class="form-label col-form-label">잔금</label>
							<input type="text" id="bal_amt" name="bal_amt" class="toNumber form-control text-end" value="1800000" readonly>원
						</div>
					</div>
					<div class="mb-2">
						<div class="inline-flex calc">
							<label class="form-label col-form-label">총액</label>
							<input type="text" id="cal_amt" name="cal_amt" class="toNumber form-control text-end" value="" readonly>원
						</div>
					</div>
			</div>
			<!-- END tab-pane -->
		</div>
		<!-- END tab-content -->

	</div>
	<!-- END content-container -->

	<!-- BEGIN #footer -->
	<c:if test="${reservationDetail.PRC_STS eq '05'}">
		<div id="footer" class="app-footer m-0">
			<a href="javascript:;" id="reservationCancelBtn" class="btn btn-gray btn-lg">예약취소</a>
		</div>
	</c:if>
	<c:if test="${(reservationDetail.PRC_STS eq '06') and (reservationDetail.REFUND_YN eq 'Y')}">
		<div id="footer" class="app-footer m-0">
			<a href="javascript:;" id="reservationCancelBtn" class="btn btn-danger btn-lg">환불요청</a>
		</div>
	</c:if>
	<!-- END #footer -->
	
</div>
