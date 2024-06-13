<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>

function fn_comma(num) {
	num = String(num);
	var arrNumber = num.split('.');
	num = arrNumber[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	if (arrNumber.length > 1) {
		num = num + '.' + arrNumber[1];
	}
	return num;
}

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
		setTitle("환불요청");
	</c:if>
	<c:if test="${reservationDetail.PRC_STS eq '08'}">
		setTitle("환불완료");
	</c:if>
	<c:if test="${reservationDetail.PRC_STS eq '09'}">
		setTitle("예약취소");
	</c:if>
	setEvent();
	if($("#footer").length == 0) {
		$(".app-content-padding").addClass("none-footer");
	}

	<%-- 데이터 셋팅 --%>
	var detailData = JSON.parse('${strReservationDetail}');
	for(key in detailData) {
		<%-- key값 대문자로 받아옴.. --%>
		var objId = "#" + key.toLowerCase();
		if($(objId).length >= 1) {
			if(objId == "#chk_in_dt" || objId == "#chk_out_dt") {
				$(objId).datepicker("setDate", detailData[key]);
			} else if($(objId).hasClass("toNumber")) {
				if(objId == "#tot_person") {  <%-- 총인원-1(본인) --%>
					$(objId).val(numberComma(detailData[key] -1));
				} else if(objId == "#r_person") { <%-- 멤버수 = DB라운딩인원 -1(본인) -DB비멤버인원 --%>
					$(objId).val(numberComma(detailData[key] -1 -detailData["NR_PERSON"]));
				} else {
					$(objId).val(numberComma(detailData[key]));
				}
			} else {
				if(objId == "#bal_amt") {
					$(objId).val(fn_comma(detailData[key]));	
				} else{
					$(objId).val(detailData[key]);	
				}
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
								$.ajax({
									type : "POST",
									url : "reservationCancel.do",
									data : data,
									dataType : "json",
									success : function(retData2) {
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
					<span class="d-sm-block d-none">[예약확인]ㆍ 객실</span>
				</a>
			</li>
			<li class="nav-item">
				<a href="#default-tab-2" data-bs-toggle="tab" class="nav-link">
					<span class="d-sm-none">옵션</span>
					<span class="d-sm-block d-none">[예약확인]ㆍ 옵션</span>
				</a>
			</li>
			<li class="nav-item">
				<a href="#default-tab-3" data-bs-toggle="tab" class="nav-link">
					<span class="d-sm-none">동반자</span>
					<span class="d-sm-block d-none">[예약확인]ㆍ 동반자</span>
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
								<input type="text" id="chk_in_dt" name="chk_in_dt" class="form-control text-muted text-center" placeholder="날짜를 선택하세요" readonly>
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4">체크아웃</label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="chk_out_dt" name="chk_out_dt" class="form-control text-muted text-center" placeholder="날짜를 선택하세요" readonly>
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">객실타입</label>
					<div class="col-md-9">
						<select id="room_type" name="room_type" class="form-select text-muted text-center readonly">
							<c:forEach items="${roomTypeList}" var="room" varStatus="status">
								<option value="${room.CODE}">${room.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Flight In</label>
					<div class="col-md-9 inline-flex">
						<select id="flight_in" name="flight_in" class="form-select text-muted text-center readonly">
							<option value="">-선택-</option>
							<c:forEach items="${fligthInList}" var="fligthIn" varStatus="status">
								<option value="${fligthIn.CODE}">${fligthIn.CODE_NM}</option>
							</c:forEach>
						</select>
						<select id="flight_in_hh" name="flight_in_hh" class="form-select text-muted text-center readonly">
							<option value="">-선택-</option>
							<c:forEach var="i" begin="0" end="23" step="1">
								<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2" />">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />시
								</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Flight Out</label>
					<div class="col-md-9 inline-flex">
						<select id="flight_out" name="flight_out" class="form-select text-muted text-center readonly">
							<option value="">-선택-</option>
							<c:forEach items="${fligthOutList}" var="fligthOut" varStatus="status">
								<option value="${fligthOut.CODE}">${fligthOut.CODE_NM}</option>
							</c:forEach>
						</select>
						<select id="flight_out_hh" name="flight_out_hh" class="form-select text-muted text-center readonly">
							<option value="">-선택-</option>
							<c:forEach var="i" begin="0" end="23" step="1">
								<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2" />">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />시
								</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">항공권 첨부</label>
					<div class="col-sm-9">
						<input id="fligth_image" name="fligth_image" type="text" class="form-control" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">한글이름</label>
					<div class="col-sm-9">
						<input id="req_han_nm" name="req_han_nm" type="text" class="form-control text-muted text-center" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">영문이름</label>
					<div class="col-sm-9">
						<input id="req_eng_nm" name="req_eng_nm" type="text" class="form-control text-muted text-center" readonly>
					</div>
				</div>
			</div>
			<!-- END tab-pane -->
			
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-2">
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">미팅샌딩</label>
					<div class="col-md-9 inline-flex">
						<select id="pick_gbn" name="pick_gbn" class="form-select text-muted text-center readonly">
							<c:forEach items="${pickupSvcList}" var="pickupSvc" varStatus="status">
								<option value="${pickupSvc.CODE}">${pickupSvc.CODE_NM}</option>
							</c:forEach>
						</select>
						<select id="per_num" name="per_num" class="form-select text-muted text-center toNumbers readonly">
							<option value="0">00</option>
							<c:forEach var="i" begin="1" end="30" step="1">
								<option value="<fmt:formatNumber value="${i}"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>명
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">싱글룸 추가</label>
					<div class="col-md-9 inline-flex">
						<select id="add_r_s_per" name="add_r_s_per" class="form-select text-muted text-center toNumbers readonly">
							<c:forEach var="i" begin="0" end="10" step="1">
								<option value="<fmt:formatNumber value="${i}"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>개
						<select id="add_r_s_day" name="add_r_s_day" class="form-select text-muted text-center toNumbers readonly">
							<c:forEach var="i" begin="0" end="30" step="1">
								<option value="<fmt:formatNumber value="${i}"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>일
					
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">프리미엄 추가</label>
					<div class="col-md-9 inline-flex">
						<select id="add_r_p_per" name="add_r_p_per" class="form-select text-muted text-center toNumbers readonly">
							<c:forEach var="i" begin="0" end="10" step="1">
								<option value="<fmt:formatNumber value="${i}"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>개
						<select id="add_r_p_day" name="add_r_p_day" class="form-select text-muted text-center toNumbers readonly">
							<c:forEach var="i" begin="0" end="30" step="1">
								<option value="<fmt:formatNumber value="${i}"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>일
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Late Check In</label>
					<div class="col-md-9">
						<select id="late_check_in" name="late_check_in" style="text-align: center" class="form-select text-muted text-center readonly">
							<c:forEach items="${lateInYnList}" var="lateInYn" varStatus="status">
								<option value="${lateInYn.CODE}">${lateInYn.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Late Check Out</label>
					<div class="col-md-9">
						<select id="late_check_out" name="late_check_out" style="text-align: center" class="form-select text-muted text-center readonly">
							<c:forEach items="${lateOutYnList}" var="lateOutYn" varStatus="status">
								<option value="${lateOutYn.CODE}">${lateOutYn.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				
				<div class="total-people-wrap">
					<div class="row mb-2" style = "justify-content:flex-end">
						<label class="form-label col-form-label col-md-2"></label>
						<div class="col-md-9 inline-flex">
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">멤　버　</span>
								</div>
								<select id="m_person" name="m_person" class="form-select text-muted text-center toNumbers readonly">
									<c:forEach var="i" begin="1" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}"/>">
											<fmt:formatNumber value="${i}" minIntegerDigits="2" />
										</option>
									</c:forEach>
								</select>명
							</div>
							<label class="form-label col-form-label  col-md-2"></label>
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">일　반　</span>
								</div>
								<select id="g_person" name="g_person" class="form-select text-muted text-center toNumbers readonly">
									<c:forEach var="i" begin="0" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}"/>">
											<fmt:formatNumber value="${i}" minIntegerDigits="2" />
										</option>
									</c:forEach>
								</select>명
							</div>
						</div>
					</div>
					
					<div class="row mb-2" style = "justify-content:flex-end">
						<label class="form-label col-form-label col-md-2"></label>
						<div class="col-md-9 inline-flex">
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">비라운딩</span>
								</div>
								<select id="n_person" name="n_person" class="form-select text-muted text-center toNumbers readonly">
									<c:forEach var="i" begin="0" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}"/>">
											<fmt:formatNumber value="${i}" minIntegerDigits="2" />
										</option>
									</c:forEach>
								</select>명
							</div>
							<label class="form-label col-form-label  col-md-2"></label>
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">소　아　</span>
								</div>
								<select id="k_person" name="k_person" class="form-select text-muted text-center toNumbers readonly">
									<c:forEach var="i" begin="0" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}"/>">
											<fmt:formatNumber value="${i}" minIntegerDigits="2" />
										</option>
									</c:forEach>
								</select>명
							</div>
						</div>
					</div>
					
					<div class="row mb-2" style = "justify-content:flex-end">
						<label class="form-label col-form-label col-md-2"></label>
						<div class="col-md-9 inline-flex">
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">영유아　</span>
								</div>
								<select id="i_person" name="i_person" class="form-select text-muted text-center toNumbers readonly">
									<c:forEach var="i" begin="0" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}"/>">
											<fmt:formatNumber value="${i}" minIntegerDigits="2" />
										</option>
									</c:forEach>
								</select>명
							</div>
							<label class="form-label col-form-label  col-md-2"></label>
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">총인원　</span>
								</div>
								<input id="tot_person" name="tot_person" type="text" class="form-control text-muted text-end toNumbers" maxlength="2" value="01" readonly>명
							</div>
						</div>
					</div>
				</div>
				
				<div id="packageDiv" class="row mb-2">
					<label class="form-label col-form-label col-md-3">패키지</label>
					<div class="col-md-9">
						<select id="add_hdng_gbn" name="add_hdng_gbn" class="form-select text-muted text-center readonly">
							<c:forEach items="${packageList}" var="add_hdng_gbn" varStatus="status">
								<option value="${add_hdng_gbn.CODE}">${add_hdng_gbn.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">추가 요청사항</label>
					<div class="col-md-9">
						<textarea id="remark" name="remark" class="form-control text-muted readonly" rows="3"></textarea>
					</div>
				</div>
				
				
				<div class="mb-2">
					<div class="inline-flex calc">
						<label class="form-label col-form-label">계약금</label>
						<input id="dep_amt" name="dep_amt" type="text" class="toNumber form-control text-end" readonly>원
					</div>
				</div>
				<div class="mb-2">
					<div class="inline-flex calc">
						<label class="form-label col-form-label">잔금</label>
						<input id="bal_amt" name="bal_amt" type="text" class="form-control text-end" readonly>원
					</div>
				</div>
			</div>
			<!-- END tab-pane -->
			
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-3">
				<div class="total-people-wrap">
					<div class="container2" style="overflow:auto">
						<table border="1" id="list_table" class="table table-bordered readonly" style="text-align:center;">
							<thead class="table-secondary">
								<tr>
									<th>번호</th>
									<th style="display:none">동반자구분</th>
									<th>인원구분</th>
									<th>한글이름</th>
									<th>영문이름</th>
									<th>전화번호</th>
									<th style="display:none">등록자</th>
								</tr>
							</thead>
							
							<tbody>
								<c:forEach items="${reservationComList}" var = "list" varStatus="status">
									<tr id="com_board">
										<td style="min-width:45px;">${list.DSEQ}</td>
										<td style="display:none">${list.COM_GBN}</td>
										<td >
											<select id="list_num_gbn" name="list_num_gbn" class="readonly" style="min-width:70px;">
												<option value="01" <c:if test="${list.NUM_GBN eq '01' }">selected</c:if>>멤버</option>
												<option value="02" <c:if test="${list.NUM_GBN eq '02' }">selected</c:if>>일반</option>
												<option value="03" <c:if test="${list.NUM_GBN eq '03' }">selected</c:if>>비라운딩</option>
												<option value="04" <c:if test="${list.NUM_GBN eq '04' }">selected</c:if>>소아</option>
												<option value="05" <c:if test="${list.NUM_GBN eq '05' }">selected</c:if>>영유아</option>
											</select>
										</td>
										<td style="min-width:70px;">${list.COM_HAN_NM}</td>
										<td style="min-width:70px;">${list.COM_ENG_NM}</td>
										<td style="min-width:120px;">${list.COM_TEL_NO}</td>
										<td style="display:none">${sessionScope.login.user_id}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div> 
						<!-- /.container2 -->
				</div>
					<!-- /total-people-wrap -->
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
