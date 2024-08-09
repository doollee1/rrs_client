<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style type="text/css">
	.reserve_count_box {margin:5px 0 0; flex:1;}
	@media (max-width: 767.98px) {
		#comPlusBtn {top:122px !important; right:36px !important;}
		#reserve_cal_box {width:100% !important;}
		#display_label {display:none;}
		#packageDiv {margin-bottom:.66875rem!important;}
	}
	#comPlusBtn {opacity:30%; background-color:#348FE2; width:22px; height:22px; font-size:12px; line-height:22px; right:45px; top:110px;}
	#reserve_count_input_box {width:100%;}
	#reserve_count_input_box > .input-group-text {display:inline-block; width:100%;}
	.person_box {width:100%; padding: .4375rem 0; border:1px solid var(--bs-component-border-color); font-weight:600;}
</style>

<script>
$(document).ready(function() {
	/* 연락처 하이픈처리 */
	$("#req_tel_no").val($("#req_tel_no").val().replace(/[^0-9]/gi, "").replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`));

	setTitle("예약상태변경");
	setEvent();
	
	/******************************************** 
	 * @Subject : 이벤트 함수
	 * @Content : 버튼, ID, CLASS 등 이벤트 정의
	 * @Since   : 2024.08.07
	 * @Author  : 
	 ********************************************/
	function setEvent() {
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
		
		/******************************************** 
		 * @Subject : [상태변경]버튼 이벤트 #1
		 * @Content : readonly / disabled 해지
		 * @Since   : 2024.08.07
		 * @Author  : 
		 ********************************************/
		$("#prcStsUpdateBtn").on("click", function() {
			if(confirm("예약 상태를 변경하시겠습니까?")) {
				var data = {prc_sts : $("#prc_sts").val()
						   ,req_dt  : $("#req_dt").val().replace(/-/gi, "")
						   ,seq     : $("#seq").val()
						   };
				dimOpen(); /* 로딩바 Open */
				$.ajax({
					type : "POST",
					url : "adminPrcStsUpdate.do",
					data : data,
					dataType : "json",
					success : function(data) {
						dimClose(); /* 로딩바 Close */
						if(data.result == "SUCCESS") {
							alert("변경이 완료되었습니다.");
							location.replace("/adminProdReservation.do");
						} else {
							alert("예약 상태 변경 실패하였습니다. 관리자에게 문의해주세요.");
						}
					}
				});
			}
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
					<span class="d-sm-none">예약상태변경</span>
					<span class="d-sm-block d-none">예약상태변경</span>
				</a>
			</li>
		</ul>
		<!-- END nav-tabs -->
		<!-- BEGIN tab-content -->
		<div class="tab-content panel rounded-0 p-3 m-0">
			<c:forEach items="${ProdDetail}" var = "list">
			<input type="hidden" id="seq"     name="seq"     value="${list.SEQ}"/>
			<input type="hidden" id="mem_gbn" name="mem_gbn" value="${list.MEM_GBN}"/>
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				<div class="input-daterange">
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">예약일자</span></label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="req_dt" name="req_dt" class="form-control text-start text-center"disabled="disabled" value="${list.REQ_DT}">
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">체크인일자</span></label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="chk_in_dt" name="chk_in_dt" class="form-control text-start text-center" value="${list.CHK_IN_DT}" disabled="disabled">
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">체크아웃일자</span></label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="chk_out_dt" name="chk_out_dt" class="form-control text-start text-center" value="${list.CHK_OUT_DT}" disabled="disabled">
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">예약자명</span></label>
					<div class="col-md-9">
						<input type="text" class="form-control text-muted text-center" value="${list.REQ_HAN_NM}" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">영문이름</span></label>
					<div class="col-md-9">
						<input type="text" class="form-control text-muted text-center" value="${list.REQ_ENG_NM}" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">연락처</span></label>
					<div class="col-md-9">
						<input type="text" class="form-control text-muted text-center" id="req_tel_no" value="${list.REQ_TEL_NO}" readonly>
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">예약상태</span></label>
					<div class="col-md-9 inline-flex">
						<div class="input-group">
							<select id="prc_sts" name="prc_sts" class="form-select text-center" style="border: 2px solid var(--bs-component-color); border-color: #ff5b57;">
								<c:forEach items="${prcStsGbnList}" var="sts" varStatus="status">
									<c:choose>
										<c:when test="${sts.CODE eq list.PRC_STS}">
											<option value="${sts.CODE}" style="font-size: 0.9rem;font-weight:bold;" selected>${sts.CODE_NM}</option>
										</c:when>
										<c:when test = "${sts.CODE eq '03'}">
											<c:set scope="page" var="ilban" value="${sts.CODE_NM}"/>
										</c:when>
									</c:choose>
								</c:forEach>
								<c:if test = "${list.MEM_GBN eq '02'}" >
									<option value="03" style="font-size: 0.9rem;font-weight:bold;">${ilban}</option>
								</c:if>
								<c:forEach items="${prcStsGbnList}" var="sts" varStatus="status" begin="5">
									<c:if test = "${sts.CODE ne '07'}">
										<option value="${sts.CODE}" style="font-size: 0.9rem;font-weight:bold;">${sts.CODE_NM}</option>
									</c:if>
								</c:forEach>
							</select>
						</div>
					</div>
				</div>
			</div>
			</c:forEach>
			<!-- END tab-pane -->
		</div>
		<!-- END tab-content -->
	</div>
	<!-- END content-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="javascript:;" id="prcStsUpdateBtn" class="btn btn-success btn-lg">상태변경</a>
	</div>
	<!-- END #footer -->
	
</div>
