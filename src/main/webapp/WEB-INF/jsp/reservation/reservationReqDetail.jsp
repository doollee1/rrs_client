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
	}
	#comPlusBtn {opacity:30%; background-color:#348FE2; width:22px; height:22px; font-size:12px; line-height:22px; right:45px; top:110px;}
	#reserve_count_input_box {width:100%;}
	#reserve_count_input_box > .input-group-text {display:inline-block; width:100%;}
</style>

<script>
$(document).ready(function() {
	var roomPerson = 0;			// 숙박인원 (레이크인아웃 체크를위함)
	var twinCnt = 0;			// 숙박인원에따른 사용 트윈 갯수
	var kingCnt = 0;			// 숙박인원에따른 사용 킹 갯수
	setTitle("예약요청");
	setEvent();

	<%-- 데이터 셋팅 --%>
	var detailData = JSON.parse('${strReservationDetail}');
	for(key in detailData) {
		<%-- key값 대문자로 받아옴.. --%>
		var objId = "#" + key.toLowerCase();
		if($(objId).length >= 1) {
			if(objId == "#chk_in_dt" || objId == "#chk_out_dt") {
				$(objId).datepicker("setDate", detailData[key]);
			} else if($(objId).hasClass("toNumber")) {
				$(objId).val(numberComma(detailData[key]));
			} else {
				$(objId).val(detailData[key]);
			}
		}
	}

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

		<%-- 수정버튼 클릭 --%>
		$("#reservationUpdateBtn").on("click", function() {
			var btnText = $(this).text();
			if(btnText == "수정") {
				var data = {
					  req_dt : $("#req_dt").val()
					, seq    : $("#seq"   ).val()
				}
				$.ajax({
					type : "POST",
					url : "getPrcSts.do",
					data : data,
					dataType : "json",
					success : function(data) {
						if(data.result == "SUCCESS") {
							if(data.prc_sts == "${reservationDetail.PRC_STS}") {
								<%-- datepicker 버튼  이벤트--%>
								$(".input-daterange .input-group").off("click");
								$(".input-daterange .input-group").on("click", function() {
									$(this).find("input").datepicker().focus();
								});
								$("#chk_in_dt").removeAttr("disabled"); /* 체크인 버튼 */
								$("#chk_out_dt").removeAttr("disabled"); /* 체크아웃 버튼 */
								$("#g_person, #n_person, #k_person, #i_person").removeClass("readonly");
								$("#package_, #room_type").removeClass("readonly");
								$("#reservationUpdateBtn").text("수정 등록");
							} else {
								alert("상태값이 변경되어 수정할 수 없습니다.");
							}
						}
				 	}
				});
			} else {
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
						  req_dt         : $("#req_dt"        ).val()
						, seq            : $("#seq"           ).val()
						, chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")
						, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")
						, tot_person     : $("#tot_person").val()
						, g_person       : $("#g_person"  ).val()
						, n_person       : $("#n_person"  ).val()
						, k_person       : $("#k_person"  ).val()
						, i_person       : $("#i_person"  ).val()
						, package_       : $("#package_"  ).val()
						, room_type      : $("#room_type" ).val()
						, twin_cnt		 : twinCnt	// 트윈 갯수
						, king_cnt		 : kingCnt	// 킹 갯수
				};
				var formData = new FormData();
				formData.append("param", new Blob([JSON.stringify(data)], {type:"application/json"}));
				dimOpen(); /* 로딩바 Open */
				$.ajax({
					type : "POST",
					url : "reservationUpdate.do",
					data : formData,
					dataType : "json",
					processData: false,
					contentType: false,
					success : function(data) {
						dimClose(); /* 로딩바 Close */
						if(data.result == "SUCCESS") {
							roomPerson = 0;
							twinCnt = 0;
							kingCnt = 0;
							alert("수정이 완료되었습니다.");
							location.replace("/main.do");
						} else {
							roomPerson = 0;
							twinCnt = 0;
							kingCnt = 0;
							alert("상태값이 변경되어 수정할 수 없습니다.");
						}
					}
				});
			}
		});

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
							if(confirm("예약을 취소하시겠습니까?")) {
								dimOpen(); /* 로딩바 Open */
								$.ajax({
									type : "POST",
									url : "reservationCancel.do",
									data : data,
									dataType : "json",
									success : function(retData2) {
										dimClose(); /* 로딩바 Close */
										if(retData2.result == "SUCCESS") {
											alert("예약이 취소되었습니다.");
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

		<%-- toNumber 이벤트 --%>
		$(".toNumber").on("propertychange change keyup input", function() {
			this.value = numberComma(this.value);
		});
		
		<%-- toNumbers 이벤트 --%>
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
		
		<%-- room_type 이벤트 --%>
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
					$.ajax({
						type : "POST",
						url : "noRoomChk.do",
						data : data,
						dataType : "json",
						success : function(data) {
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
			if(!$("#chk_in_dt").is(":disabled") && $("#g_person").val() > 0){
				$("#chk_out_dt").val("");
				$("#package_").find("option").remove();
				$("#package_").append("<option value='' selected> -선택- </option>");
			}
		});
		
		$("#chk_out_dt").on("change", function() {
			$("#room_type").val("");
			
			if(!$("#chk_out_dt").is(":disabled") && $("#chk_in_dt").val() != "" && $("#chk_out_dt").val() != "") {
				$("#package_").find("option").remove();
				var data = {
						  chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")	//체크인
						, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")	//체크아웃
					};
					$.ajax({
						type : "POST",
						url : "packageListReset.do",
						data : data,
						dataType : "json",
						success : function(data) {
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
			<input type="hidden" id="req_dt"       name="req_dt"       />
			<input type="hidden" id="seq"          name="seq"          />
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				<div class="input-daterange">
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">체크인</span></label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="chk_in_dt" name="chk_in_dt" class="form-control text-start text-center" placeholder="날짜를 선택하세요" disabled="disabled">
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group row mb-2">
						<label class="form-label col-form-label col-lg-4" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">체크아웃</span></label>
						<div class="col-lg-12">
							<div class="input-group date" >
								<input type="text" id="chk_out_dt" name="chk_out_dt" class="form-control text-start text-center" placeholder="날짜를 선택하세요" disabled="disabled">
								<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3" style="display: flex; align-items: center; font-size: 1rem;font-weight:bold;" ><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">객실타입</span>
					<input type="text" id="no_room_chk" name="no_room_chk" class="form-control text-center" value="Check OK"
						   style="border:none;border-right:0px; border-top:0px; boder-left:0px; boder-bottom:0px; width:85px; background: #FFFFFF; opacity:30%; color: green;" readonly></label>
					<div class="col-md-9">
						<select id="room_type" name="room_type" class="form-select text-center readonly">
							<option value="" style="font-size: 0.9rem;font-weight:bold;">-선택-</option>
							<c:forEach items="${roomTypeList}" var="room" varStatus="status">
								<option value="${room.CODE}" style="font-size: 0.9rem;font-weight:bold;">${room.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">한글이름</span></label>
					<div class="col-md-9">
						<input type="text" class="form-control text-muted text-center" value="${sessionScope.login.han_name}" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">영문이름</span></label>
					<div class="col-md-9">
						<input type="text" class="form-control text-muted text-center" value="${sessionScope.login.eng_name}" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3" style="font-size: 1rem;font-weight:bold;"><span style="box-shadow: inset 0 -2px 0 #dcdcdc;">패키지</span></label>
					<div class="col-md-9">
						<select id="package_" class="form-select text-center readonly">
							<option value="" style="font-size: 0.9rem;font-weight:bold;">-선택-</option>
							<c:forEach items="${packageList}" var="package_" varStatus="status">
								<option value="${package_.CODE}" style="font-size: 0.9rem;font-weight:bold;">${package_.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				
				<div class="row mb-2" style="display:flex;">
					<label class="form-label col-form-label col-md-3" style="font-size: 1rem;font-weight:bold;">
						<span style="box-shadow: inset 0 -2px 0 #dcdcdc;">인원내역</span>
						
					</label>
					<div class="total-people-wrap reserve_count_box">
						<div class="row mb-2" style = "justify-content:center">
						<span class="input-group-text" style="color: white; font-size: 1rem; position: relative; top: -10px; opacity:85%; background-color:#008B8B; font-weight:bold; justify-content: center; height:25px">라운딩</span>
							<div class="col-md-9 inline-flex">
								<label class="form-label col-form-label col-md-2"></label>
								<label class="form-label col-form-label col-md-2"></label>
								<div class="input-group">
									<div class="input-group-prepend" id="reserve_count_input_box">
										<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">일　반　</span>
									</div>
									<select id="g_person" name="g_person" class="form-select text-center toNumbers readonly">
										<c:forEach var="i" begin="1" end="15" step="1">
											<option value="<fmt:formatNumber value="${i}"/>" style="font-size: 0.9rem;font-weight:bold;">
												<fmt:formatNumber value="${i}" minIntegerDigits="2" />
											</option>
										</c:forEach>
									</select>
								</div>명
								<label class="form-label col-form-label col-md-2"></label>
								<label class="form-label col-form-label col-md-2"></label>
							</div>
						</div>
					</div>
				</div>

				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3" id="display_label" style="padding:0px;">　</label>
					<div class="total-people-wrap reserve_count_box">
						<div class="row mb-2" style = "justify-content:center">
							<span class="input-group-text" style="color: white; font-size: 1rem; position: relative; top: -10px; opacity:85%; background-color:#008B8B; font-weight:bold; justify-content: center; height:25px">비라운딩</span>
							<div class="col-md-9 inline-flex" style="grid-column-gap: 7px;">
								<div class="input-group">
									<div class="input-group-prepend" id="reserve_count_input_box">
										<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">성　인　</span>
									</div>
									
									<select id="n_person" name="n_person" class="form-select text-center toNumbers readonly">
										<c:forEach var="i" begin="0" end="15" step="1">
											<option value="<fmt:formatNumber value="${i}"/>" style="font-size: 0.9rem;font-weight:bold;">
												<fmt:formatNumber value="${i}" minIntegerDigits="2" />
											</option>
										</c:forEach>
									</select>
								</div>명
								
								<label class="form-label col-form-label  col-md-2"></label>
								<div class="input-group">
									<div class="input-group-prepend" id="reserve_count_input_box">
										<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">소　아　</span>
									</div>
									<select id="k_person" name="k_person" class="form-select text-center toNumbers readonly">
										<c:forEach var="i" begin="0" end="15" step="1">
											<option value="<fmt:formatNumber value="${i}"/>" style="font-size: 0.9rem;font-weight:bold;">
												<fmt:formatNumber value="${i}" minIntegerDigits="2" />
											</option>
										</c:forEach>
									</select>
								</div>명
								
								<label class="form-label col-form-label  col-md-2"></label>
								<div class="input-group">
									<div class="input-group-prepend" id="reserve_count_input_box">
										<span class="input-group-text" style="padding : 0.5rem 0.1rem 0.5rem 0rem">영유아　</span>
									</div>
									<select id="i_person" name="i_person" class="form-select text-center toNumbers readonly">
										<c:forEach var="i" begin="0" end="15" step="1">
											<option value="<fmt:formatNumber value="${i}"/>" style="font-size: 0.9rem;font-weight:bold;">
												<fmt:formatNumber value="${i}" minIntegerDigits="2" />
											</option>
										</c:forEach>
									</select>
								</div>명
							</div>
						</div>
					</div>
				</div>

				<div class="row mb-2" style = "justify-content:flex-end;">
					<div class="col-md-9 inline-flex">
						<div class="input-group">
							<div class="input-group-prepend">
								<span class="input-group-text" id="reserve_select_box" style="height: 2.5rem; padding : 0.5rem 0.1rem 0.5rem 0rem">총　인　원　　　</span>
							</div>
							<input id="tot_person" name="tot_person" type="text" class="form-control text-center toNumbers" style="font-size: 0.9rem;font-weight:bold;" maxlength="2" value="01" readonly>
						</div>명
					</div>
				</div>

				<div style="display:flex; gap:3px; margin-bottom:10px;">
					<label class="form-label col-form-label  col-md-3"></label>
					<span style="color:red;">※</span>
					<span style="text-align:left; opacity:90%; color:red; font-size:0.8rem; word-break:keep-all; padding-right:5%;">
						신청 인원은 [예약요청]단계에서만 변경이 가능하며,<br/>
						이 후 [카카오톡:yyoahkim]으로 문의주시길 바랍니다.
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
		<a href="javascript:;" id="reservationCancelBtn" class="btn btn-gray btn-lg">예약취소</a>
		<a href="javascript:;" id="reservationUpdateBtn" class="btn btn-success btn-lg">수정</a>
	</div>
	<!-- END #footer -->
	
</div>
