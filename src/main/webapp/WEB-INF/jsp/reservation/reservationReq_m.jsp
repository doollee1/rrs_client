<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
$(document).ready(function() {
	setTitle("예약요청");

	$(".input-daterange").datepicker({
		todayHighlight: true,
		autoclose: true,
		startDate: new Date()
	});
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
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				<div class="input-daterange">
				
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4">체크인</label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" class="form-control text-start" id="datepicker-autoClose" name="start" placeholder="날짜를 선택하세요">
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4">체크아웃</label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" class="form-control text-start" id="datepicker-autoClose" name="end" placeholder="날짜를 선택하세요">
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
				
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">객실타입</label>
					<div class="col-md-9">
						<select class="form-select">
							<option>트윈베드</option>
							<option>킹베드</option>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Flight In</label>
					<div class="col-sm-9">
						<select class="form-select">
							<option>KE643</option>
							<option>KE645</option>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Flight Out</label>
					<div class="col-sm-9">
						<select class="form-select">
							<option>OZ752</option>
							<option>--</option>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">항공권 첨부</label>
					<div class="col-sm-9">
						<input type="file" class="form-control" />
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
				<div class="total-people-wrap">
					<div class="inline-flex">
						<div class="col-form-label">총인원</div>
						<input type="text" class="form-control text-end" value="" readonly>명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">멤버</div>
						<input type="text" class="form-control text-end" value="">명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">비멤버</div>
						<input type="text" class="form-control text-end" value="">명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">소아</div>
						<input type="text" class="form-control text-end" value="">명
					</div>
				</div>
			</div>
			<!-- END tab-pane -->
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-2">
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">미팅샌딩</label>
					<div class="col-md-9 inline-flex">
						<select class="form-select">
							<option>선택안함</option>
							<option>싱가폴</option>
							<option>스나이공항</option>
						</select>
						<input type="text" class="form-control text-end" value="">명
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">싱글룸 추가</label>
					<div class="col-md-9 inline-flex">
						<input type="text" class="form-control text-end" value="">명
						<input type="text" class="form-control text-end" value="">일
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">프리미어룸 추가</label>
					<div class="col-md-9 inline-flex">
						<input type="text" class="form-control text-end" value="">명
						<input type="text" class="form-control text-end" value="">일
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Late Check Out</label>
					<div class="col-md-9">
						<select class="form-select">
							<option>선택</option>
							<option>선택안함</option>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">추가 요청사항</label>
					<div class="col-md-9">
						<textarea class="form-control" rows="3"></textarea>
					</div>
				</div>
				<div class="mb-2">
					<div class="inline-flex calc">
						<button type="button" class="btn btn-pink">가계산</button>
						<input type="text" class="form-control text-end" value="2000000" readonly>원
					</div>
					<small class="text-theme">
						계산 금액은 정확한 금액이 아닙니다. 예약전송해 주시면 추후 정확한 금액을 안내 드립니다.
					</small>
				</div>
			</div>
			<!-- END tab-pane -->
		</div>
		<!-- END tab-content -->

	</div>
	<!-- END content-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="#" class="btn btn-success btn-lg">등록</a>
	</div>
	<!-- END #footer -->
	
</div>
