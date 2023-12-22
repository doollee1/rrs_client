<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
$(document).ready(function() {
	setTitle("예약요청");
	setEvent();

	<%-- validate --%>
	function isValidate() {
		if($("#chk_in_dt").val() == "") {
			alert("체크인 날짜를 선택하세요.");
			return false;
		}

		if($("#chk_out_dt").val() == "") {
			alert("체크아웃 날짜를 선택하세요.");
			return false;
		}

		var inDate  = new Date($("#chk_in_dt" ).val());
		var outDate = new Date($("#chk_out_dt").val());

		// 숙박일
		var stayDay = outDate.getTime() - inDate.getTime();
		stayDay = Math.ceil(stayDay / (1000 * 60 * 60 * 24));
		if(stayDay < 1) {
			alert("체크아웃 날짜를 다시 선택하세요.");
			return false;
		}

		if($("#tot_person").val() == "0") {
			alert("인원을 입력해주세요.");
			return false;
		}
		return true;
	}

	<%-- 이벤트 함수 --%>
	function setEvent() {
		<%-- datepicker setting --%>
		$(".input-daterange").datepicker({
			todayHighlight: true,
			autoclose: true,
			startDate: new Date()
		});

		<%-- datepicker 버튼  이벤트--%>
		$(".input-daterange .input-group").on("click", function() {
			$(this).find("input").datepicker().focus();
		});

		<%-- 등록버튼 이벤트 --%>
		$("#reservationBtn").on("click", function() {
			if(!isValidate()) {
				return;
			}

			var data = {
					  chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")
					, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")
					, tot_person     : $("#tot_person").val().replace(/,/gi, "")
					, r_person       : $("#r_person"  ).val().replace(/,/gi, "")
					, n_person       : $("#n_person"  ).val().replace(/,/gi, "")
					, k_person       : $("#k_person"  ).val().replace(/,/gi, "")
					, package_       : $("#package_"  ).val()
					, room_type      : $("#room_type" ).val()
			};

			dimOpen();
			$.ajax({
				type : "POST",
				url : "reservationInsert1.do",
				data : data,
				dataType : "json",
				success : function(data) {
					dimClose();
					if(data.result == "SUCCESS") {
						alert("등록이 완료되었습니다.");
						location.replace("/main.do");
					} else {
						alert("상품이 없습니다. 관리자에게 문의 하세요.");
					}
			 	}
			});
		});

		<%-- input 이벤트 --%>
		$(".toNumber").on("focus focusout", function(e) {
			if(e.type == "focus") {
				if(this.value == "0") {
					this.value = "";
				} else {
					var len = this.value.length;
					setTimeout(function() {
						var len = this.value.length;
						this.setSelectionRange(len, len);
					}.bind(this), 100);
				}
			} else {
				if(this.value == "") {
					this.value = "0";
				}
				var id = this.id;
				if(id == "r_person" || id == "n_person" || id == "k_person") {
					var sum = strToNum($("#r_person").val()) + strToNum($("#n_person").val()) + strToNum($("#k_person").val());
					$("#tot_person").val(numberComma(sum));
				}
			}
		});

		<%-- input 이벤트 --%>
		$(".toNumber").on("propertychange change keyup input", function() {
			this.value = numberComma(this.value);
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
					<span class="d-sm-none">요청</span>
					<span class="d-sm-block d-none">Default 요청</span>
				</a>
			</li>
		</ul>
		<!-- END nav-tabs -->
		<!-- BEGIN tab-content -->
		<div class="tab-content panel rounded-0 p-3 m-0">
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
						<select id="room_type" name="room_type" class="form-select">
							<c:forEach items="${roomTypeList}" var="room" varStatus="status">
								<option value="${room.CODE}">${room.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="total-people-wrap">
					<div class="inline-flex">
						<div class="col-form-label">총인원</div>
						<input type="text" id="tot_person" name="tot_person" class="toNumber form-control text-end" value="0" readonly>명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">라운딩</div>
						<input type="text" id="r_person" name="r_person" maxlength="3" class="toNumber form-control text-end" value="0">명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">비라운딩</div>
						<input type="text" id="n_person" name="n_person" maxlength="3" class="toNumber form-control text-end" value="0">명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">소아</div>
						<input type="text" id="k_person" name="k_person" maxlength="3" class="toNumber form-control text-end" value="0">명
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">패키지</label>
					<div class="col-sm-9">
						<select id="package_" class="form-select">
							<c:forEach items="${packageList}" var="package_" varStatus="status">
								<option value="${package_.CODE}">${package_.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
			</div>
			<!-- END tab-pane -->
		</div>
		<!-- END tab-content -->

	</div>
	<!-- END content-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="javascript:;" id="reservationBtn" class="btn btn-success btn-lg">예약 전송</a>
	</div>
	<!-- END #footer -->
	
</div>
