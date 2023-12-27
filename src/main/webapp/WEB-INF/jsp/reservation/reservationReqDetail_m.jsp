<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
$(document).ready(function() {
	var isCal    = false;
	var formData = new FormData();

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
				if(objId == "#tot_person") {  <%-- 총인원-1(본인) --%>
					$(objId).val(numberComma(detailData[key] -1));
				} else if(objId == "#r_person") { <%-- 멤버수 = DB라운딩인원 -1(본인) -DB비멤버인원 --%>
					$(objId).val(numberComma(detailData[key] -1 -detailData["NR_PERSON"]));
				} else {
					$(objId).val(numberComma(detailData[key]));
				}
			} else {
				$(objId).val(detailData[key]);
			}
		}
	}
	<%-- datepicker에서 초기화해서 다시 셋팅 --%>
	$("#cal_amt").val(numberComma(detailData["CAL_AMT"]));

	<%-- 이미지 변경  --%>
	function handleImgInput() {
		var file = this.files[0];
		$("#preview").attr("src", "");
		if (!file.type.match(/image.*/)) {
			alert("지원되는 이미지가 아닙니다.");
			this.value = "";
			return;
		}

		if(file.size >= (1024 * 1024 * 5)) {
			alert("사진 사이즈는 5MB 보다 작아야 됩니다.");
			this.value = "";
			return;
		}

		var reader = new FileReader();
		reader.onload = function(e) {
			//$("#preview").attr("src", e.target.result);
		};
		reader.readAsDataURL(file);
		if(file.size >= (1024 * 512)) {
			resizeImage({
				file: file,
				maxSize: 600
			}).then(function (resizedImage) {
				//reader.onload = function(e){
				//	document.getElementById('output').src = URL.createObjectURL(resizedImage);
				//};
				//reader.readAsDataURL(file);
				// resizing 이후 파일
				var imageFile = new File([resizedImage], file.name, {type: file.type});
				formData.append("file", imageFile);
			});
		} else {
			formData.append("file", file);
		}
	}

	<%-- 이미지 rezise --%>
	function resizeImage(settings) {
		var file = settings.file;
		var maxSize = settings.maxSize;
		var reader = new FileReader();
		var image = new Image();
		var canvas = document.createElement('canvas');
		var dataURItoBlob = function (dataURI) {
			var bytes = dataURI.split(',')[0].indexOf('base64') >= 0 ?
				atob(dataURI.split(',')[1]) :
				unescape(dataURI.split(',')[1]);
			var mime = dataURI.split(',')[0].split(':')[1].split(';')[0];
			var max = bytes.length;
			var ia = new Uint8Array(max);
			for (var i = 0; i < max; i++)
				ia[i] = bytes.charCodeAt(i);
			return new Blob([ia], { type: 'image/jpeg'});
		};
		var resize = function () {
			var width = image.width;
			var height = image.height;
			if (width > height) {
				if (width > maxSize) {
					height *= maxSize / width;
					width = maxSize;
				}
			} else {
				if (height > maxSize) {
					width *= maxSize / height;
					height = maxSize;
				}
			}
			canvas.width = width;
			canvas.height = height;
			canvas.getContext('2d').drawImage(image, 0, 0, width, height);
			var dataUrl = canvas.toDataURL('image/jpeg');
			return dataURItoBlob(dataUrl);
		};
		return new Promise(function (ok, no) {
			reader.onload = function (readerEvent) {
				image.onload = function () { return ok(resize()); };
				image.src = readerEvent.target.result;
			};
			reader.readAsDataURL(file);
		});
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

		var inDate  = new Date($("#chk_in_dt" ).val());
		var outDate = new Date($("#chk_out_dt").val());

		// 숙박일
		var stayDay = outDate.getTime() - inDate.getTime();
		stayDay = Math.ceil(stayDay / (1000 * 60 * 60 * 24));
		if(stayDay < 1) {
			alert("체크아웃 날짜를 다시 선택하세요.");
			return false;
		}

		var pickGbn   = $("#pick_gbn").val();
		var totPerson= Number($("#tot_person").val().replace(/,/gi, "")) + 1; //(본인포함)
		var perNum    = $("#per_num").val().replace(/,/gi, "");
		if(pickGbn != "01") {
			if(totPerson < perNum) {
				alert("미팅샌딩 인원이 총 인원 보다 많습니다.");
				return false;
			}
			if(perNum == "0") {
				alert("미팅샌딩 인원을 추가해주세요.");
				return false;
			}
		}

		var rSPer = $("#add_r_s_per").val().replace(/,/gi, "");
		var rSDay = $("#add_r_s_day").val().replace(/,/gi, "");
		if( (rSPer == "0" && rSDay != "0") ||
			(rSPer != "0" && rSDay == "0")) {
			alert("싱글룸 추가 인원 이나 추가 일수를 확인해주세요.");
			return false;
		}
		if(totPerson < rSPer) {
			alert("싱글룸 추가 인원이 총 인원 보다 많습니다.")
			return false;
		}
		if(stayDay < rSDay) {
			alert("싱글룸 추가 일자가 숙박일 보다 많습니다.")
			return false;
		}

		var rPPer = $("#add_r_p_per").val().replace(/,/gi, "");
		var rPDay = $("#add_r_p_day").val().replace(/,/gi, "");
		if( (rPPer == "0" && rPDay != "0") ||
			(rPPer != "0" && rPDay == "0")) {
				alert("프리미엄룸 추가 인원 이나 추가 일수를 확인해주세요.");
				return false;
			}
		if(totPerson < rPPer) {
			alert("프리미엄룸 추가 인원이 총 인원 보다 많습니다.")
			return false;
		}
		if(stayDay < rPDay) {
			alert("프리미엄룸 추가 일자가 숙박일 보다 많습니다.")
			return false;
		}

		return true;
	}

	<%-- 이벤트 함수 --%>
	function setEvent() {
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
								$("#room_type, #flight_in, #flight_out, #pick_gbn, #late_check_out, #remark").removeClass("readonly");
								$("#r_person, #nr_person, #k_person, #per_num, #add_r_s_per, #add_r_s_day, #add_r_p_per, #add_r_p_day, #fligthImage").removeAttr("readonly");
								$("#calBtn").removeAttr("disabled");
								$("#fligthImage").parent().show();
								$("#fligth_image").parent().hide();
	
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

				if(!isCal) {
					alert("가계산을 확인해주세요.");
					return;
				}
				var data = {
						  req_dt         : $("#req_dt"        ).val()
						, seq            : $("#seq"           ).val()
						, chk_in_dt      : $("#chk_in_dt"     ).val().replace(/-/gi, "")
						, chk_out_dt     : $("#chk_out_dt"    ).val().replace(/-/gi, "")
						, flight_in      : $("#flight_in"     ).val()
						, flight_out     : $("#flight_out"    ).val()
						, room_type      : $("#room_type"     ).val()
						, tot_person     : Number($("#tot_person").val().replace(/,/gi, "")) + 1  //본인포함
						, r_person       : Number($("#r_person"  ).val().replace(/,/gi, "")) + 1  //본인포함
						, nr_person      : $("#nr_person"     ).val().replace(/,/gi, "")
						, k_person       : $("#k_person"      ) .val().replace(/,/gi, "")
						, pick_gbn       : $("#pick_gbn"      ).val().replace(/,/gi, "")
						, per_num        : $("#per_num"       ).val().replace(/,/gi, "")
						, late_check_out : $("#late_check_out").val()
						, add_r_s_per    : $("#add_r_s_per"   ).val().replace(/,/gi, "")
						, add_r_s_day    : $("#add_r_s_day"   ).val().replace(/,/gi, "")
						, add_r_p_per    : $("#add_r_p_per"   ).val().replace(/,/gi, "")
						, add_r_p_day    : $("#add_r_p_day"   ).val().replace(/,/gi, "")
						, remark         : $("#remark"        ).val()
				};

				formData.append("param", new Blob([JSON.stringify(data)], {type:"application/json"}));

				dimOpen();
				$.ajax({
					type : "POST",
					url : "reservationUpdate.do",
					data : formData,
					dataType : "json",
					processData: false,
					contentType: false,
					success : function(data) {
						dimClose();
						if(data.result == "SUCCESS") {
							alert("수정이 완료되었습니다.");
							location.replace("/main.do");
						} else {
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
								dimOpen();
								$.ajax({
									type : "POST",
									url : "reservationCancel.do",
									data : data,
									dataType : "json",
									success : function(retData2) {
										dimClose();
										if(retData2.result == "SUCCESS") {
											alert("예약이 취소되었습니다.");
											location.replace("/main.do");
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
		}).on("changeDate", function(e) {
			isCal = false;
			$("#cal_amt").val(0);
		});

		<%-- 가계산 버튼 클릭 --%>
		$("#calBtn").on("click", function() {
			if(!isValidate()) {
				return;
			}
			var data = {
				  chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")
				, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")
				, flight_in      : $("#flight_in" ).val()
				, flight_out     : $("#flight_out").val()
				, tot_person     : Number($("#tot_person").val().replace(/,/gi, "")) + 1
				, pick_gbn       : $("#pick_gbn").val()
				, per_num        : $("#per_num").val().replace(/,/gi, "")
				, late_check_out : $("#late_check_out").val()
				, add_r_s_per    : $("#add_r_s_per").val().replace(/,/gi, "")
				, add_r_s_day    : $("#add_r_s_day").val().replace(/,/gi, "")
				, add_r_p_per    : $("#add_r_p_per").val().replace(/,/gi, "")
				, add_r_p_day    : $("#add_r_p_day").val().replace(/,/gi, "")
			};

			dimOpen();
			$.ajax({
				type : "POST",
				url : "reservationCal.do",
				data : data,
				dataType : "json",
				success : function(data) {
					dimClose();
					if(data.result == "SUCCESS") {
						isCal = true;
						$("#cal_amt").val(numberComma(data.totalAmt));
						alert(`숙박비 : \${numberComma(data.roomCharge)},
미팅샌딩비 : \${numberComma(data.sendingAmt)},
SURCHAGE : \${numberComma(data.surchageAmt)},
룸 추가 : \${numberComma(data.roomupAmt)},
lateCheckOut : \${numberComma(data.lateCheckOutAmt)}`);
					} else {
						isCal = false;
						$("#cal_amt").val(0);
					}
			 	}
			});
		});

		<%-- 이미지 이벤트 --%>
		$("#fligthImage").on("change", handleImgInput);
		$("#flight_in, #flight_out, #late_check_out").on("change", function() {
			isCal = false;
			$("#cal_amt").val(0);
		});

		<%-- 미팅센드 변경 이벤트 --%>
		$("#pick_gbn").on("change", function() {
			isCal = false;
			$("#cal_amt").val(0);
			var pickValue = this.value;
			if(pickValue == "01") {
				$("#per_num").val("0").attr("disabled", true);
			} else {
				$("#per_num").attr("disabled", false);
			}
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
				if(id == "r_person" || id == "nr_person" || id == "k_person") {
					var sum = strToNum($("#r_person").val()) + strToNum($("#nr_person").val()) + strToNum($("#k_person").val());
					$("#tot_person").val(numberComma(sum));
				}
			}
		});

		<%-- input 이벤트 --%>
		$(".toNumber").on("propertychange change keyup input", function() {
			isCal = false;
			$("#cal_amt").val(0);
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
					<label class="form-label col-form-label col-md-3">객실타입</label>
					<div class="col-md-9">
						<select id="room_type" name="room_type" class="form-select readonly">
							<c:forEach items="${roomTypeList}" var="room" varStatus="status">
								<option value="${room.CODE}">${room.CODE_NM}</option>
							</c:forEach>
						</select>
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
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">한글이름</label>
					<div class="col-sm-9">
						<input id="req_han_nm" name="req_han_nm" type="text" class="form-control" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">영문이름</label>
					<div class="col-sm-9">
						<input id="req_eng_nm" name="req_eng_nm" type="text" class="form-control" readonly>
					</div>
				</div>
				<div class="total-people-wrap">
					<div class="inline-flex">
						<div class="col-form-label">총인원(추가인원)</div>
						<input type="text" id="tot_person" name="tot_person" class="toNumber form-control text-end" readonly>명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">멤버</div>
						<input type="text" id="r_person" name="r_person" maxlength="3" class="toNumber form-control text-end" readonly>명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">비멤버</div>
						<input type="text" id="nr_person" name="nr_person" maxlength="3" class="toNumber form-control text-end" readonly>명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">소아</div>
						<input type="text" id="k_person" name="k_person" maxlength="3" class="toNumber form-control text-end" readonly>명
					</div>
				</div>
			</div>
			<!-- END tab-pane -->
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-2">
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
						<button id="calBtn" name="calBtn" type="button" class="btn btn-pink" disabled="disabled">가계산</button>
						<input id="cal_amt" name="cal_amt" type="text" class="form-control text-end toNumber" readonly>원
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
		<a href="javascript:;" id="reservationCancelBtn" class="btn btn-gray btn-lg">예약취소</a>
		<a href="javascript:;" id="reservationUpdateBtn" class="btn btn-success btn-lg">수정</a>
	</div>
	<!-- END #footer -->
	
</div>
