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

	$("#default_tab_1 #late_check_out").val("3"); // 부 default
	$("#default_tab_1 #pick_gbn").change();

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
		
		console.log("Validation 처리");
		
		var isValid = true;
		
		var size	 = $(".tab-pane.fade").length / 2;	
		for(var i=0; i<size; i++) {
						
			var naviIdx = i*2;
			console.log("navi idx :"+naviIdx);
			
			var tabIdx = i*2+1;
			console.log("tab idx :"+tabIdx);
			
			var tabOptionIdx = i*2+2;
			console.log("tabOptionIdx idx :"+tabOptionIdx);
			
			var naviStr = $(".nav-tabs li").eq(naviIdx).find(".d-sm-none").text();
			console.log("네비게이션 str : "+naviStr);
			
			//체크인 날짜 검사
			if($("#default-tab-"+tabIdx).find("#chk_in_dt").val() == "") {
				
				alert(naviStr+" 체크인 날짜를 선택하세요.");
				isValid = false;	
				
				$(".nav-tabs li").eq(naviIdx).find(".d-sm-none").trigger("click");
				break;
			}
			
			//체크아웃 날짜 검사
			if($("#default-tab-"+tabIdx).find("#chk_out_dt").val() == "") {
				
				alert(naviStr+" 체크아웃 날짜를 선택하세요.");
				isValid = false;
				
				$(".nav-tabs li").eq(naviIdx).find(".d-sm-none").trigger("click");
				break;
			}
			
			var inDate  = new Date($("#default-tab-"+tabIdx).find("#chk_in_dt").val());	//new Date($("#chk_in_dt" ).val());
			var outDate = new Date($("#default-tab-"+tabIdx).find("#chk_out_dt").val());
			console.log(naviStr+" 체크인 날짜 : "+inDate);
			console.log(naviStr+" 체크아웃 날짜 : "+outDate);
			
			// 숙박일
			var stayDay = outDate.getTime() - inDate.getTime();
			stayDay = Math.ceil(stayDay / (1000 * 60 * 60 * 24));
			if(stayDay < 1) {
				alert(naviStr+" 체크아웃 날짜를 다시 선택하세요.");
				isValid = false;
				break;
			}
			
			//한글이름
			if($("#default-tab-"+tabIdx+" #han_name").val() == "") {
				alert(naviStr+" 한글이름을 입력하세요.");
				isValid = false;
				
				$(".nav-tabs li").eq(naviIdx).find(".d-sm-none").trigger("click");
				break;
			}
			
			//영문이름
			if($("#default-tab-"+tabIdx+" #eng_name").val() == "") {
				alert(naviStr+" 영문이름을 입력하세요.");
				isValid = false;
				
				$(".nav-tabs li").eq(naviIdx).find(".d-sm-none").trigger("click");
				break;
			}
			
			//항공권 이미지
			if($("#default-tab-"+tabIdx).find("#fligthImage").val() == "") {
				alert(naviStr+" 항공권 이미지를 첨부하세요.");
				isValid = false;
				
				$(".nav-tabs li").eq(naviIdx).find(".d-sm-none").trigger("click");
				break;
			}
			
			var pickGbn   = $("#default-tab-"+tabOptionIdx).find("#pick_gbn").val();
			console.log("pickGbn : "+pickGbn);
			
			var totPerson= $("#default-tab-"+tabIdx).find("#tot_person").length ? Number($("#default-tab-"+tabIdx).find("#tot_person").val().replace(/,/gi, "")) + 1 : 1; //(본인포함)
			console.log("totPerson : "+totPerson);
			
			var perNum    = $("#default-tab-"+tabOptionIdx).find("#per_num").val().replace(/,/gi, "");
			console.log("perNum : "+perNum);
			
			if(pickGbn != "01") {
				if(totPerson < perNum) {
					alert(naviStr+" 미팅샌딩 인원이 총 인원 보다 많습니다.");
					isValid = false;
					break;
				}
				if(perNum == "0") {
					alert(naviStr+" 미팅샌딩 인원을 추가해주세요.");
					isValid = false;
					break;
				}
			}
			
			var rSPer = $("#default-tab-"+tabOptionIdx).find("#add_r_s_per").val().replace(/,/gi, "");
			console.log("rSPer : "+rSPer);
			var rSDay = $("#default-tab-"+tabOptionIdx).find("#add_r_s_day").val().replace(/,/gi, "");
			console.log("rSPer : "+rSDay);
			
			if( (rSPer == "0" && rSDay != "0") ||
				(rSPer != "0" && rSDay == "0")) {
				alert(naviStr+" 싱글룸 추가 인원 이나 추가 일수를 확인해주세요.");
				isValid = false;
				break;
			}
			if(totPerson < rSPer) {
				alert(naviStr+" 싱글룸 추가 인원이 총 인원 보다 많습니다.");
				isValid = false;
				break;
			}
			if(stayDay < rSDay) {
				alert(naviStr+" 싱글룸 추가 일자가 숙박일 보다 많습니다.");
				isValid = false;
				break;
			}

			var rPPer = $("#default-tab-"+tabOptionIdx).find("#add_r_p_per").val().replace(/,/gi, "");
			console.log("rPPer : "+rPPer);
			var rPDay = $("#default-tab-"+tabOptionIdx).find("#add_r_p_day").val().replace(/,/gi, "");
			console.log("rPDay : "+rPDay);
			
			if( (rPPer == "0" && rPDay != "0") ||
				(rPPer != "0" && rPDay == "0")) {
					alert(naviStr+" 프리미엄룸 추가 인원 이나 추가 일수를 확인해주세요.");
					isValid = false;
					break;
				}
			if(totPerson < rPPer) {
				alert(naviStr+" 프리미엄룸 추가 인원이 총 인원 보다 많습니다.");
				isValid = false;
				break;
			}
			if(stayDay < rPDay) {
				alert(naviStr+" 프리미엄룸 추가 일자가 숙박일 보다 많습니다.");
				isValid = false;
				break;
			}
			
		}
				

		return isValid;
	}

	<%-- 이벤트 함수 --%>
	function setEvent() {
		var curDate     = new Date();
		var startDate = new Date();
		var endDate   = new Date();
		startDate.setDate(curDate.getDate() + 1);
		endDate.setFullYear(curDate.getFullYear() + 1);
		
		<%-- datepicker setting --%>		
		$("#default-tab-1 .input-daterange").datepicker({
			todayHighlight: true,
			autoclose: true,
			startDate: startDate,
			endDate: endDate
		}).on("changeDate", function(e) {
			isCal = false;
			$("#cal_amt").val(0);
		});
		
		
		<%-- datepicker 버튼  이벤트--%>
		$("#default-tab-1 .input-daterange .input-group").on("click", function() {								
				$(this).find("input").datepicker().focus();
		});
		
		<%-- 가계산 버튼 클릭 --%>
		$("#calBtn").on("click", function() {
			if(!isValidate()) {
				return;
			}

			var data = {
				  chk_in_dt      : $("#default-tab-1 #chk_in_dt").val().replace(/-/gi, "")
				, chk_out_dt     : $("#default-tab-1 #chk_out_dt").val().replace(/-/gi, "")
				, flight_in      : $("#default-tab-1 #flight_in" ).val()
				, flight_out     : $("#default-tab-1 #flight_out").val()
				, tot_person     : Number($("#default-tab-1 #tot_person").val().replace(/,/gi, "")) + 1
				, pick_gbn       : $("#default-tab-2 #pick_gbn").val()
				, per_num        : $("#default-tab-2 #per_num").val().replace(/,/gi, "")
				, late_check_out : $("#default-tab-2 #late_check_out").val()
				, add_r_s_per    : $("#default-tab-2 #add_r_s_per").val().replace(/,/gi, "")
				, add_r_s_day    : $("#default-tab-2 #add_r_s_day").val().replace(/,/gi, "")
				, add_r_p_per    : $("#default-tab-2 #add_r_p_per").val().replace(/,/gi, "")
				, add_r_p_day    : $("#default-tab-2 #add_r_p_day").val().replace(/,/gi, "")
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
						$("#default-tab-2 #cal_amt").val(numberComma(data.totalAmt));
						alert(`숙박비 : \${numberComma(data.roomCharge)},
미팅샌딩비 : \${numberComma(data.sendingAmt)},
SURCHAGE : \${numberComma(data.surchageAmt)},
룸 추가 : \${numberComma(data.roomupAmt)},
lateCheckOut : \${numberComma(data.lateCheckOutAmt)}`);
					} else {
						isCal = false;
						$("#default-tab-2 #cal_amt").val(0);
					}
			 	}
			});
		});

		<%-- 이미지 이벤트 --%>
		$("#default-tab-1 #fligthImage").on("change", handleImgInput);
		$("#default-tab-1 #flight_in, #default-tab-1 #flight_out, #default-tab-2 #late_check_out").on("change", function() {
			isCal = false;
			$("#default-tab-1 #cal_amt").val(0);
		});

		<%-- 등록버튼 이벤트 --%>
		$("#reservationBtn").on("click", function() {
			
			console.log("등록버튼 이벤트");
			
			var isValid = isValidate();
			console.log("isValidate : "+isValid);
			
			if(!isValid) {
				return;
			}
			
			if(!isCal) {
				alert("가계산을 확인해주세요.");
				$(".nav-tabs li").eq(1).find(".d-sm-none").trigger("click");
				return;
			}

			var size	 = $(".tab-pane.fade").length / 2;	
			var paramList = [];
			for(var i=0; i<size; i++) {
				
				var tabIdx = i*2+1;
				console.log("tab idx :"+tabIdx);
				
				var tabOptionIdx = i*2+2;
				console.log("tabOptionIdx idx :"+tabOptionIdx);
				
				var data = {
					  chk_in_dt      : $("#default-tab-"+tabIdx+" #chk_in_dt" ).val().replace(/-/gi, "")
					, chk_out_dt     : $("#default-tab-"+tabIdx+" #chk_out_dt").val().replace(/-/gi, "")
					, flight_in      : $("#default-tab-"+tabIdx+" #flight_in" ).val()
					, flight_out     : $("#default-tab-"+tabIdx+" #flight_out").val()
					, han_name       : $("#default-tab-"+tabIdx+" #han_name").val()
					, eng_name       : $("#default-tab-"+tabIdx+" #eng_name").val()
					, room_type      : $("#default-tab-"+tabIdx+" #room_type" ).val()
					, tot_person     : $("#default-tab-"+tabIdx+" #tot_person").length? Number($("#tot_person").val().replace(/,/gi, "")) + 1 : 1  //본인포함
					, r_person       : $("#default-tab-"+tabIdx+" #r_person").length?   Number($("#r_person"  ).val().replace(/,/gi, "")) + 1 : 1 //본인포함
					, nr_person      : $("#default-tab-"+tabIdx+" #nr_person").length? $("#nr_person" ).val().replace(/,/gi, "") : 0
					, k_person       : $("#default-tab-"+tabIdx+" #k_person").length?  $("#k_person"  ).val().replace(/,/gi, "") : 0
					, pick_gbn       : $("#default-tab-"+tabOptionIdx+" #pick_gbn").val().replace(/,/gi, "")
					, per_num        : $("#default-tab-"+tabOptionIdx+" #per_num").val().replace(/,/gi, "")
					, late_check_out : $("#default-tab-"+tabOptionIdx+" #late_check_out").val()
					, add_r_s_per    : $("#default-tab-"+tabOptionIdx+" #add_r_s_per").val().replace(/,/gi, "")
					, add_r_s_day    : $("#default-tab-"+tabOptionIdx+" #add_r_s_day").val().replace(/,/gi, "")
					, add_r_p_per    : $("#default-tab-"+tabOptionIdx+" #add_r_p_per").val().replace(/,/gi, "")
					, add_r_p_day    : $("#default-tab-"+tabOptionIdx+" #add_r_p_day").val().replace(/,/gi, "")
					, remark         : $("#default-tab-"+tabOptionIdx+" #remark"     ).val()
					, first_yn       : $("#default-tab-"+tabIdx+" #tot_person").length ? "Y" : "N"
				};
				
				paramList.push(data);
			}
			
			
			console.log("paramList : "+JSON.stringify(paramList));
			

			formData.append("list", new Blob([JSON.stringify(paramList)], {type:"application/json"}));

			dimOpen();
			$.ajax({
				type : "POST",
				url : "reservationInsert2.do",
				data : formData,
				dataType : "json",
				processData: false,
				contentType: false,
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

		<%-- 미팅센드 변경 이벤트 --%>
		$("#default-tab-2 #pick_gbn").on("change", function() {
			isCal = false;
			$("#default-tab-2 #cal_amt").val(0);
			var pickValue = this.value;
			if(pickValue == "01") {
				$("#default-tab-2 #per_num").val("0").attr("disabled", true);
			} else {
				$("#default-tab-2 #per_num").attr("disabled", false);
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
	
	
	<%-- 예약추가 이벤트 --%>
	$("#reservationAdd").on("click", function() {
		
		console.log("예약추가 예약추가");
		
		var naviIndex	   = $(".tab-pane.fade").length / 2;	//navi인덱스
		var tabIndex  	   = $(".tab-pane.fade").length + 1;	//추가인덱스
		var tabOptionIndex = $(".tab-pane.fade").length + 2;	//옵션인덱스
		
		console.log("네비Index : "+naviIndex);
		console.log("탭Index : "+tabIndex);
		console.log("탭옵션Index : "+tabOptionIndex);
		
		
		//navigation추가
		var navigation = "";
		navigation += " <li class=\"nav-item\">";
		navigation += "	  <a href=\"#default-tab-"+tabIndex+"\" data-bs-toggle=\"tab\" class=\"nav-link\">";
		navigation += "		  <span class=\"d-sm-none\">추가"+naviIndex+"</span>";
		navigation += "		  <span class=\"d-sm-block d-none\">Default 추가"+naviIndex+"</span>";
		navigation += "	  </a>";
		navigation += " </li>";
		navigation += " <li class=\"nav-item\">";
		navigation += "		 <a href=\"#default-tab-"+tabOptionIndex+"\" data-bs-toggle=\"tab\" class=\"nav-link\">";
		navigation += "			<span class=\"d-sm-none\">옵션"+naviIndex+"</span>";
		navigation += "			<span class=\"d-sm-block d-none\">Default 옵션"+naviIndex+"</span>";
		navigation += "		 </a>";
		navigation += " </li>";
					
		$(".nav.nav-tabs").append(navigation);

		
		//탭추가
		var content = "";
		
		<!-- BEGIN tab-pane -->
		content+=	"	<div class=\"tab-pane fade\" id=\"default-tab-"+tabIndex+"\">";
		content+=	"		<div class=\"input-daterange\">";
		content+=	"			<div class=\"form-group row mb-2\">";
		content+=	"				<label class=\"form-label col-form-label col-lg-4\">체크인</label>";
		content+=	"				<div class=\"col-lg-12\">";
		content+=	"					<div class=\"input-group date\" >";
		content+=	"						<input type=\"text\" id=\"chk_in_dt\" name=\"chk_in_dt\" class=\"form-control text-start\" placeholder=\"날짜를 선택하세요\" readonly>";
		content+=	"						<span class=\"input-group-text input-group-addon\"><i class=\"fa fa-calendar\"></i></span>";
		content+=	"					</div>";
		content+=	"				</div>";
		content+=	"			</div>";
		content+=	"			<div class=\"form-group row mb-2\">";
		content+=	"				<label class=\"form-label col-form-label col-lg-4\">체크아웃</label>";
		content+=	"				<div class=\"col-lg-12\">";
		content+=	"					<div class=\"input-group date\" >";
		content+=	"						<input type=\"text\" id=\"chk_out_dt\" name=\"chk_out_dt\" class=\"form-control text-start\" placeholder=\"날짜를 선택하세요\" readonly>";
		content+=	"						<span class=\"input-group-text input-group-addon\"><i class=\"fa fa-calendar\"></i></span>";
		content+=	"					</div>";
		content+=	"				</div>";
		content+=	"			</div>";
		content+=	"		</div>";		
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">객실타입</label>";
		content+=	"			<div class=\"col-md-9\">";	
		content+=	"				<select id=\"room_type\" name=\"room_type\" class=\"form-select\">";
		content+=	"					<option value=\"01\">트윈</option>";
		content+=	"					<option value=\"02\">더블</option>";
		content+=	"				</select>";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">Flight In</label>";
		content+=	"			<div class=\"col-sm-9\">";
		content+=	"				<select id=\"flight_in\" name=\"flight_in\" class=\"form-select\">";			
		content+=	"					<option value=\"SQ601\">SQ601</option>";
		content+=	"					<option value=\"SQ607\">SQ607</option>";
		content+=	"					<option value=\"SQ609\">SQ609</option>";
		content+=	"					<option value=\"SQ615\">SQ615</option>";
		content+=	"					<option value=\"KE643\">KE643</option>";
		content+=	"					<option value=\"KE645\">KE645</option>";
		content+=	"					<option value=\"KE647\">KE643</option>";
		content+=	"					<option value=\"OZ751\">OZ751</option>";
		content+=	"					<option value=\"OZ753\">OZ753</option>";
		content+=	"					<option value=\"TW171\">TW171</option>";
		content+=	"					<option value=\"7C4055\">7C4055</option>";
		content+=	"					<option value=\"TR841\">TR841</option>";
		content+=	"					<option value=\"TR843\">TR843</option>";
		content+=	"				</select>";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">Flight Out</label>";
		content+=	"			<div class=\"col-sm-9\">";
		content+=	"				<select id=\"flight_out\" name=\"flight_out\" class=\"form-select\">";			
		content+=	"					<option value=\"SQ600\">SQ600</option>";
		content+=	"					<option value=\"SQ602\">SQ602</option>";
		content+=	"					<option value=\"SQ606\">SQ606</option>";
		content+=	"					<option value=\"SQ608\">SQ608</option>";
		content+=	"					<option value=\"KE644\">KE644</option>";
		content+=	"					<option value=\"KE646\">KE646</option>";
		content+=	"					<option value=\"KE648\">KE648</option>";
		content+=	"					<option value=\"OZ752\">OZ752</option>";
		content+=	"					<option value=\"OZ754\">OZ754</option>";
		content+=	"					<option value=\"TW172\">TW172</option>";
		content+=	"					<option value=\"7C4056\">7C4056</option>";
		content+=	"					<option value=\"TR840\">TR840</option>";
		content+=	"					<option value=\"TR842\">TR842</option>";			
		content+=	"				</select>";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">한글이름</label>";
		content+=	"			<div class=\"col-sm-9\">";
		content+=	"				<input type=\"text\" id=\"han_name\" class=\"form-control\" value=\"\">";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">영문이름</label>";
		content+=	"			<div class=\"col-sm-9\">";
		content+=	"				<input type=\"text\" id=\"eng_name\" class=\"form-control\" value=\"\">";
		content+=	"			</div>";
		content+=	"		</div>";						
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">항공권 첨부</label>";
		content+=	"			<div class=\"col-sm-9\">";
		content+=	"				<input id=\"fligthImage\" name=\"fligthImage\" type=\"file\" accept=\"image/*\" class=\"form-control\" />";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">패키지</label>";
		content+=	"			<div class=\"col-sm-9\">";
		content+=	"				<select id=\"package_\" class=\"form-select\">";								
		content+=	"					<option value=\"01\">주중 36홀, 주말 오후 18홀</option>";
		content+=	"					<option value=\"02\">주중 27홀, 주말 오후 18홀</option>";
		content+=	"					<option value=\"03\">주중 18홀, 주말 오후 18홀</option>";
		content+=	"					<option value=\"04\">주중 36홀, 주말 노라운딩</option>";
		content+=	"					<option value=\"05\">주중 27홀, 주말 노라운딩</option>";
		content+=	"					<option value=\"06\">주중 18홀, 주말 노라운딩</option>";
		content+=	"					<option value=\"07\">주중 18홀, 토요일 노라운딩, 일요일 오후 18홀</option>";
		content+=	"				</select>";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"	</div>"			
		<!-- END tab-pane -->
		<!-- BEGIN tab-pane -->
		content+=	"	<div class=\"tab-pane fade\" id=\"default-tab-"+tabOptionIndex+"\">";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">미팅샌딩</label>";
		content+=	"			<div class=\"col-md-9 inline-flex\">";
		content+=	"				<select id=\"pick_gbn\" name=\"pick_gbn\" class=\"form-select\">";				
		content+=	"					<option value=\"01\">미신청</option>";
		content+=	"					<option value=\"02\">스나이공항</option>";
		content+=	"					<option value=\"02\">싱가폴공항</option>";
		content+=	"				</select>";
		content+=	"				<input id=\"per_num\" type=\"text\" maxlength=\"3\" class=\"toNumber form-control text-end\" value=\"0\">명";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">싱글룸 추가</label>";
		content+=	"			<div class=\"col-md-9 inline-flex\">";
		content+=	"				<input type=\"text\" id=\"add_r_s_per\" name=\"add_r_s_per\" maxlength=\"3\" class=\"toNumber form-control text-end\" value=\"0\">명";
		content+=	"				<input type=\"text\" id=\"add_r_s_day\" name=\"add_r_s_day\" maxlength=\"3\" class=\"toNumber form-control text-end\" value=\"0\">일";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">프리미어룸 추가</label>";
		content+=	"			<div class=\"col-md-9 inline-flex\">";
		content+=	"				<input type=\"text\" id=\"add_r_p_per\" name=\"add_r_p_per\" maxlength=\"3\" class=\"toNumber form-control text-end\" value=\"0\">명";
		content+=	"				<input type=\"text\" id=\"add_r_p_day\" name=\"add_r_p_day\" maxlength=\"3\" class=\"toNumber form-control text-end\" value=\"0\">일";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">Late Check Out</label>";
		content+=	"			<div class=\"col-md-9\">";
		content+=	"				<select id=\"late_check_out\" name=\"late_check_out\" class=\"form-select\">";				
		content+=	"					<option value=\"1\">Late Check Out - 6시까지</option>";
		content+=	"					<option value=\"2\">Late Check Out - 6시이후</option>";
		content+=	"					<option value=\"2\">부</option>";
		content+=	"				</select>";
		content+=	"			</div>";
		content+=	"		</div>";
		content+=	"		<div class=\"row mb-2\">";
		content+=	"			<label class=\"form-label col-form-label col-md-3\">추가 요청사항</label>";
		content+=	"			<div class=\"col-md-9\">";
		content+=	"				<textarea id=\"remark\" name=\"remark\" class=\"form-control\" rows=\"3\"></textarea>";
		content+=	"			</div>";
		content+=	"		</div>";	
		content+=	"	</div>";
		
		//패널에 추가
		$(".tab-content.panel.rounded-0.p-3.m-0").append(content);
		
		//체크인, 체크아웃 이벤트 핸들러 수정
		var curDate     = new Date();
		var startDate = new Date();
		var endDate   = new Date();
		startDate.setDate(curDate.getDate() + 1);
		endDate.setFullYear(curDate.getFullYear() + 1);
		
				
		<%-- datepicker setting --%>
		$("#default-tab-"+tabIndex).find(".input-daterange").datepicker({
			todayHighlight: true,
			autoclose: true,
			startDate: startDate,
			endDate: endDate
		}).on("changeDate", function(e) {			
		});
		
				
		<%-- datepicker 버튼  이벤트--%>
		$("#default-tab-"+tabIndex+" .input-daterange .input-group").on("click", function() {								
			$(this).find("input").datepicker().focus();
		});		
						
		<%-- 이미지 이벤트 --%>
		$("#default-tab-"+tabIndex+" #fligthImage").on("change", handleImgInput);
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
					<span class="d-sm-none">기본</span>
					<span class="d-sm-block d-none">Default 기본</span>
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
						<select id="room_type" name="room_type" class="form-select">
							<c:forEach items="${roomTypeList}" var="room" varStatus="status">
								<option value="${room.CODE}">${room.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Flight In</label>
					<div class="col-sm-9">
						<select id="flight_in" name="flight_in" class="form-select">
							<c:forEach items="${fligthInList}" var="fligthIn" varStatus="status">
								<option value="${fligthIn.CODE}">${fligthIn.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Flight Out</label>
					<div class="col-sm-9">
						<select id="flight_out" name="flight_out" class="form-select">
							<c:forEach items="${fligthOutList}" var="fligthOut" varStatus="status">
								<option value="${fligthOut.CODE}">${fligthOut.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">항공권 첨부</label>
					<div class="col-sm-9">
						<input id="fligthImage" name="fligthImage" type="file" accept="image/*" class="form-control" />
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">한글이름</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" id="han_name" value="${sessionScope.login.han_name}" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">영문이름</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" id="eng_name" value="${sessionScope.login.eng_name}" readonly>
					</div>
				</div>
				<div class="total-people-wrap">
					<div class="inline-flex">
						<div class="col-form-label">총인원(추가인원)</div>
						<input type="text" id="tot_person" name="tot_person" class="toNumber form-control text-end" value="0" readonly>명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">멤버</div>
						<input type="text" id="r_person" name="r_person" maxlength="3" class="toNumber form-control text-end" value="0">명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">비멤버</div>
						<input type="text" id="nr_person" name="nr_person" maxlength="3" class="toNumber form-control text-end" value="0">명
					</div>
					<div class="inline-flex">
						<div class="col-form-label">소아</div>
						<input type="text" id="k_person" name="k_person" maxlength="3" class="toNumber form-control text-end" value="0">명
					</div>
				</div>
			</div>
			<!-- END tab-pane -->
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-2">
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">미팅샌딩</label>
					<div class="col-md-9 inline-flex">
						<select id="pick_gbn" name="pick_gbn" class="form-select">
							<c:forEach items="${pickupSvcList}" var="pickupSvc" varStatus="status">
								<option value="${pickupSvc.CODE}">${pickupSvc.CODE_NM}</option>
							</c:forEach>
						</select>
						<input id="per_num" type="text" maxlength="3" class="toNumber form-control text-end" value="0">명
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">싱글룸 추가</label>
					<div class="col-md-9 inline-flex">
						<input type="text" id="add_r_s_per" name="add_r_s_per" maxlength="3" class="toNumber form-control text-end" value="0">명
						<input type="text" id="add_r_s_day" name="add_r_s_day" maxlength="3" class="toNumber form-control text-end" value="0">일
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">프리미어룸 추가</label>
					<div class="col-md-9 inline-flex">
						<input type="text" id="add_r_p_per" name="add_r_p_per" maxlength="3" class="toNumber form-control text-end" value="0">명
						<input type="text" id="add_r_p_day" name="add_r_p_day" maxlength="3" class="toNumber form-control text-end" value="0">일
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Late Check Out</label>
					<div class="col-md-9">
						<select id="late_check_out" name="late_check_out" class="form-select">
							<c:forEach items="${lateOutYnList}" var="lateOutYn" varStatus="status">
								<option value="${lateOutYn.CODE}">${lateOutYn.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">추가 요청사항</label>
					<div class="col-md-9">
						<textarea id="remark" name="remark" class="form-control" rows="3"></textarea>
					</div>
				</div>
				<div class="mb-2">
					<div class="inline-flex calc">
						<button id="calBtn" name="calBtn" type="button" class="btn btn-pink">가계산</button>
						<input id="cal_amt" name="cal_amt" type="text" class="form-control text-end toNumber" value="0" readonly>원
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
		<a href="javascript:;" id="reservationAdd" class="btn btn-pink btn-lg">예약추가</a>
		<a href="javascript:;" id="reservationBtn" class="btn btn-success btn-lg">등록</a>
	</div>
	<!-- END #footer -->
	
</div>
