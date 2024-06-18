<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
$(document).ready(function() {
	var roomPerson = 0;			// 숙박인원 (레이크인아웃 체크를위함)
	var twinCnt = 0;			// 숙박인원에따른 사용 트윈 갯수
	var kingCnt = 0;			// 숙박인원에따른 사용 킹 갯수
	
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
		
		if($("#room_type").val() == "") {
			alert("객실타입을 선택하세요.");
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
		
		if($("#package_" ).val() == ""){
			 alert("패키지 정보를 선택해주세요.")
			 return false;
		}
		
		return true;
	}

	<%-- 이벤트 함수 --%>
	function setEvent() {
		<%-- datepicker setting --%>
		var curDate     = new Date();
		var startDate = new Date();
		var endDate   = new Date();
		startDate.setDate(curDate.getDate() + 1);
		endDate.setFullYear(curDate.getFullYear() + 1);
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

		<%-- 등록버튼 이벤트 --%>
		$("#reservationBtn").on("click", function() {
			if(!isValidate()) {
				return;
			}
			// 숙박인원 기준:(일반 + 비라운딩 + 소아)
			roomPerson = Math.round((strToNum($("#g_person").val()) + strToNum($("#n_person").val()) + strToNum($("#k_person").val()))/2);
			roomPerson = roomPerson > 0 ? roomPerson : 1;
			
			if($("#room_type" ).val() =="01"){			// 트윈
				twinCnt = roomPerson;
			}else if($("#room_type" ).val() =="02"){	// 킹
				kingCnt = roomPerson;
			}else{
				twinCnt = 0;
				kingCnt = 0;
			}
			
			var data = {
					  chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")
					, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")
					, tot_person     : $("#tot_person").val()
					, g_person       : $("#g_person"  ).val()
					, n_person       : $("#n_person"  ).val()
					, k_person       : $("#k_person"  ).val()
					, i_person       : $("#i_person"  ).val()
					, package_       : $("#package_"  ).val()
					, hdng_gbn		 : $("#package_"  ).val()
					, room_type      : $("#room_type" ).val()
					, twin_cnt		 : twinCnt	// 트윈 갯수
					, king_cnt		 : kingCnt	// 킹 갯수
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
						if(data.roomChkMsg == ""){
							roomPerson = 0;
							twinCnt = 0;
							kingCnt = 0;
							alert("등록이 완료되었습니다.");
							location.replace("/main.do");
						}else{
							roomPerson = 0;
							twinCnt = 0;
							kingCnt = 0;
							alert(data.roomChkMsg);
						}
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
			}
		});

		<%-- input 이벤트 --%>
		$(".toNumber").on("propertychange change keyup input", function() {
			this.value = numberComma(this.value);
		});
		
		<%-- input 이벤트 --%>
		$(".toNumbers").change(function(){  
			var id = this.id;
			if(id == "g_person" || id == "n_person"|| id == "k_person"|| id == "i_person") {
				var sum = strToNum($("#g_person").val()) + strToNum($("#n_person").val()) + strToNum($("#k_person").val()) + strToNum($("#i_person").val());
				if(sum <=9){
					$("#tot_person").val("0"+sum);
				}else{
					$("#tot_person").val(numberComma(sum));
				}
			}
		});
		
		<%-- room_type --%>
		$("#room_type").on("change", function() {
			if($("#chk_in_dt").val() == "") {
				alert("체크인 날짜를 선택하세요.");
				$("#room_type").val("")
				return false;
			}

			if($("#chk_out_dt").val() == "") {
				alert("체크아웃 날짜를 선택하세요.");
				$("#room_type").val("")
				return false;
			}
			
			if($("#chk_in_dt").val() != "" && $("#chk_out_dt").val() != "") {
				var data = {
						  chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")			//체크인
						, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")			//체크아웃
						, room_type      : $("#room_type" ).val()						// 객실타입
					};

					dimOpen();
					$.ajax({
						type : "POST",
						url : "noRoomChk.do",
						data : data,
						dataType : "json",
						success : function(data) {
							dimClose();
							if(data.result == "SUCCESS") {
								if(data.roomChkMsg == ""){
									$("#no_room_chk").val("Check OK")
									$("#no_room_chk").css("color","green");
								}else{
									alert(data.roomChkMsg);
									$("#no_room_chk").val("STAND BY")
									$("#no_room_chk").css("color","red");
									$("#chk_in_dt").val("")
									$("#chk_out_dt").val("")
									$("#room_type").val("")
								}
							} else {
								alert("룸 체크 실패. 관리자에게 문의 하세요.");
							}
					 	}
					});
			}
		});
		
		$("#chk_in_dt").on("change", function() {
			$("#room_type").val("");
			$("#chk_out_dt").val("");
			$("#package_").find("option").remove();
			$("#package_").append("<option value='' selected> -선택- </option>");
		});
		
		$("#chk_out_dt").on("change", function() {
			$("#room_type").val("");
			
			if($("#chk_in_dt").val() != "" && $("#chk_out_dt").val() != "") {
				$("#package_").find("option").remove();
				var data = {
						  chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")	//체크인
						, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")	//체크아웃
					};
					dimOpen();
					$.ajax({
						type : "POST",
						url : "packageListReset.do",
						data : data,
						dataType : "json",
						success : function(data) {
							dimClose();
							if(data.result == "SUCCESS") {
								$("#package_").append("<option value='' selected> -선택- </option>");
								for (var i = 0; i < data.packageListReset.length; i++) {
									$("#package_").append("<option value="+data.packageListReset[i].CODE+">"+data.packageListReset[i].CODE_NM+"</option>");
								}
							} else {
								alert("패키지 상품이 없습니다. 관리자에게 문의 하세요.");
								$("#g_person").val("00");
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
					<span class="d-sm-none">요청</span>
					<span class="d-sm-block d-none">예약ㆍ요청</span>
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
								<input type="text" id="chk_in_dt" name="chk_in_dt" class="form-control text-center" placeholder="날짜를 선택하세요" readonly>
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
					
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4">체크아웃</label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="chk_out_dt" name="chk_out_dt" class="form-control text-center" placeholder="날짜를 선택하세요" readonly>
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3"    style="display: flex; align-items: center;" >객실타입
					<input type="text" id="no_room_chk" name="no_room_chk" class="form-control text-center" value="STAND BY"
						   style="border:none;border-right:0px; border-top:0px; boder-left:0px; boder-bottom:0px; width:85px; background: #FFFFFF; opacity:30%; color: red;" readonly></label>
					<div class="col-md-9">
						<select id="room_type" name="room_type" class="form-select text-center">
							<option value="">-선택-</option>
							<c:forEach items="${roomTypeList}" var="room" varStatus="status">
								<option value="${room.CODE}">${room.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">한글이름</label>
					<div class="col-md-9">
						<input type="text" class="form-control text-muted text-center" value="${sessionScope.login.han_name}" readonly>
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">영문이름</label>
					<div class="col-md-9">
						<input type="text" class="form-control text-muted text-center" value="${sessionScope.login.eng_name}" readonly>
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">패키지</label>
					<div class="col-md-9">
						<select id="package_" class="form-select text-center">
							<option value="">-선택-</option>
							<c:forEach items="${packageList}" var="package_" varStatus="status">
								<option value="${package_.CODE}">${package_.CODE_NM}</option>
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
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">일　반　</span>
								</div>
								<select id="g_person" name="g_person" class="form-select text-center toNumbers" style="padding : 0.5rem 0rem 0.5rem 0rem">
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
									<span class="input-group-text" style="padding : 0.5rem 0rem 0.5rem 0rem">비라운딩</span>
								</div>
								<select id="n_person" name="n_person" class="form-select text-center toNumbers" style="padding : 0.5rem 0rem 0.5rem 0rem">
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
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">소　아　</span>
								</div>
								<select id="k_person" name="k_person" class="form-select text-center toNumbers" style="padding : 0.5rem 0rem 0.5rem 0rem">
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
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">영유아　</span>
								</div>
								<select id="i_person" name="i_person" class="form-select text-center toNumbers" style="padding : 0.5rem 0rem 0.5rem 0rem">
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
							<div class="input-group"></div>
							<label class="form-label col-form-label  col-md-2"></label>
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">총　인　원</span>
								</div>
								<input id="tot_person" name="tot_person" type="text" class="form-control text-center toNumbers" style="padding : 0.5rem 0rem 0.5rem 0rem" maxlength="2" value="01" readonly>명
							</div>
						</div>
					</div>
					<span style="text-align:left; opacity:30%; color:red; font-size:0.7rem">
									         ※   신청 인원은 [예약요청]단계에서만 변경이 가능하며,<br/>
					  &nbsp;&nbsp;&nbsp;&nbsp;이 후 [카카오톡:yyoahkim]으로 문의주시길 바랍니다.
					</span>
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
