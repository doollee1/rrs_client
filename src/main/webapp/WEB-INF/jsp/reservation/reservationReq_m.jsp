<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
	#wrapper_popup div[id ^= 'layerPop'] {position:absolute; width:86%; left:7%; top:30%; padding:0px 8px; background:#fff; z-index:100000;border-radius:10px;overflow:auto;display:none;border:double;}
	#wrapper_popup div[id ^= 'layerPop'] h2 {display:block;margin:10px 0 0;padding-bottom:15px;border-bottom:1px #d8d8d8 solid;font-size:1.1em;font-weight:bold}
	#wrapper_popup #layerPop .popup_top_box {display: flex; justify-content: space-between; margin-top:5px;}
	#wrapper_popup .c-blue {color:blue !important}
	#reserve_popup {display:flex; flex-direction:column; gap:9px; margin:5px 0 7px;}
	#reserve_popup .radioSet div {display:flex; justify-content: center; gap:7px;}
	.find-btn {display: flex; justify-content: space-between;}
	.find-btn button {width:49%;}
</style>

<script>
$(document).ready(function() {
	var isCal    = false;
	var formData = new FormData();
	var chkReqDt = ""; // 동반자 등록을 위한 등록한 예약일자
	var chkSeq = "";   // 동반자 등록을 위한 등록한 순번
	var addBasyy = "";
	var addBasyySeq = "";
	var addProdSeq = "";
	var comBasyy = "";
	var comBasyySeq = "";
	var comProdSeq = "";
	var nokidBasyy = "";
	var nokidBasyySeq = "";
	var nokidProdSeq = "";		// 비라운딩,소아 상품 항목
	var roomPlus = 1;			// 레이크인아웃 체크를위함
	var roomChk = 0;			// 인원보다 방이 더 많을경우를 위한 체크변수
	var roomPerson = 0;			// 숙박인원
	var nokidPerson = 0;		// 비라운딩, 소아 인원
	var prodCond = 0;			// 미팅샌딩 싱가폴 항목 금액산정을 위한 변수 
	var twinCnt = 0;			// 숙박인원에따른 사용 트윈 갯수
	var kingCnt = 0;			// 숙박인원에따른 사용 킹 갯수
	var comTemp = "";
	var comTempChk = "";
	$("#packageDiv").hide();
	$("#sessionTelNo").append(("${sessionScope.login.tel_no}").replace(/[^0-9]/gi, "").replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`));
	$("#late_check_in").val("3");
	$("#late_check_out").val("3"); // 부 default
	$("#per_num").val("00").attr("disabled", true);
	$('.radioSet').buttonset();
	setTitle("예약요청");
	setEvent();
	
	$("#g_person").change(function(){   
		if($("#g_person").val() > 0){
			$("#packageDiv").show();
		}else{
			$("#packageDiv").hide();
		}
	});
	
	$(document).on("focusout", '[id^=onlyKor]', function() {
		const regExp = /[ㄱ-ㅎㅏ-ㅣ가-힣]/gi; 
		if($(this).val() != "" && !regExp.test($(this).val())){
	    	alert("한글로 작성해주세요.");
	    	$(this).val("");
	    }
	});
	
	$(document).on("focusout", '[id^=onlyEng]', function() {
		const regExp =  /^[a-zA-Z]*$/; 
		if($(this).val() != "" && !regExp.test($(this).val())){
	    	alert("영문으로 작성해주세요.");
	    	$(this).val("");
	    }
	});
	
	$(document).on("focusout", '[id^=onlyNum]', function() {
		const regExp = /^[0123456789-]*$/;
		if($(this).val() != "" && !regExp.test($(this).val())){
	    	alert("숫자로 작성해주세요.");
	    	$(this).val("");
	    }else{
	    	$(this).val($(this).val().replace(/^(\d{2,3})(\d{3,4})(\d{4})$/g, "$1-$2-$3"));
	    }
	});
	
	// 동반자 등록 순번
	function numbering(){
		var cnt = 1;
		$('tr#com_board td:first-child').each(function() {
			$(this).eq(0).text(cnt++)
		});
		$("#num_gbn").val("");
		$("#com_han_nm").val("");
		$("#com_eng_nm").val("");
		$("#com_tel_no").val("");
		
	}
	
	// 동반자 목록 내 구분추가
	function setPeopleGbn(s_data) {
		var $combo = $('<select id="list_num_gbn" name="list_num_gbn" style="min-width:70px;" disabled="disabled"/>');
		    $combo.append($('<option/>',{'value':'01'}).text('멤버')); 
		    $combo.append($('<option/>',{'value':'02'}).text('일반')); 
		    $combo.append($('<option/>',{'value':'03'}).text('비라운딩')); 
		    $combo.append($('<option/>',{'value':'04'}).text('소아')); 
		    $combo.append($('<option/>',{'value':'05'}).text('영유아'));
		    $combo.val(s_data); //여기서 seleted하고 싶은 값을 넣어줌.
		  return $combo; //리턴
	}
	
	// 동반자 등록 된 ReqDt/Seq 검토
	function reservationKeyChk() {
		var addHdng = $("#add_hdng_gbn" ).val() != "" ? $("#add_hdng_gbn" ).val() : "00";
	
		var data = {  user_id 		: "${sessionScope.login.user_id}"	
					, mem_gbn 		: "01"
					, chk_in_dt 	: $("#chk_in_dt" ).val().replace(/-/gi, "")
					, chk_out_dt	: $("#chk_out_dt" ).val().replace(/-/gi, "")
					, g_person      : Number($("#g_person"  ).val())
					, add_hdng_gbn  : addHdng
					, nokid_person  : nokidPerson
		           };
		$.ajax({
			type : "POST",
			url : "reservationChk.do",
			data : data,
			dataType : "json",
			async: false,
			success : function(data) {
				dimClose();
				if(data.result == "SUCCESS") {
					chkReqDt	= data.REQ_DT;
					chkSeq 		= data.SEQ;
					addCompanion(); // 동반자목록 등록
				} else {
					alert("예약자체크 실패");
				}
		 	}
		});
	}
	
	// 동반자목록 등록
	function addCompanion() {
    	 // 객체 담을 배열
        let tableArr = new Array();
        $("tr#com_board").each(function (index, item) {
        	let parmBasyy = null;
        	let parmBasyyseq = null;
        	let parmProdseq = null;
        	let parmhdngGbn = null;
            let td = $(this).children();
           
            if(td.eq(2).find('#list_num_gbn option:selected').val() == "01"){
            	parmBasyy    = comBasyy;
            	parmBasyyseq = comBasyySeq;
            	parmProdseq  = comProdSeq;
            	parmhdngGbn  = "28";
            }else if(td.eq(2).find('#list_num_gbn option:selected').val() == "02"){
            	parmBasyy    = addBasyy;
            	parmBasyyseq = addBasyySeq;
            	parmProdseq  = addProdSeq;
            	parmhdngGbn  = $("#add_hdng_gbn" ).val();
            }else if(td.eq(2).find('#list_num_gbn option:selected').val() == "03" || td.eq(2).find('#list_num_gbn option:selected').val() == "04"){
            	parmBasyy    = nokidBasyy
            	parmBasyyseq = nokidBasyySeq;
            	parmProdseq  = nokidProdSeq;
            	parmhdngGbn  = "30";
            }
            // 테이블 객체
            let td_obj = {
            	req_dt 			: chkReqDt, 													// 예약일자
            	seq 			: chkSeq,														// 예약일련번호
        		bas_yy			: parmBasyy,													// 기준년도
        		bas_yy_seq		: parmBasyyseq,													// 기준년도순번
        		prod_seq		: parmProdseq,													// 상품순번
        		hdng_gbn		: parmhdngGbn,													// 항목구분
        		dseq 			: td.eq(0).text(),												// 상세일련번호
            	com_gbn 		: td.eq(1).text(),												// 동반자구분
            	num_gbn			: td.eq(2).find('#list_num_gbn option:selected').val(),			// 인원구분
                com_han_name	: td.eq(3).text(),							  					// 동반자한글명
                com_eng_name	: td.eq(4).text(),							  					// 동반자영문명
                comn_tel_no 	: td.eq(5).text().replace(/-/gi, ""),							// 동반자전화번호
                user_id			: td.eq(6).text(),												// 신청자ID
                chk_in_dt   	: $("#chk_in_dt" ).val().replace(/-/gi, ""),					// 체크인일자
				chk_out_dt  	: $("#chk_out_dt").val().replace(/-/gi, ""),					// 체크아웃일자
				flight_in   	: $("#flight_in" ).val(),										// 도착항공기편
				flight_in_hh	: $("#flight_in_hh" ).val(),									// 도착항공기시각
				flight_out  	: $("#flight_out").val(),										// 출발항공기편
				flight_out_hh	: $("#flight_out_hh" ).val(),									// 도착항공기편
				late_check_in   : $("#late_check_in").val(),									// 레이트체크인
				late_check_out  : $("#late_check_out").val(),									// 레이트체크아웃
				room_type  		: $("#room_type" ).val() 										// 출발항공기시각
            };
            // 배열에 객체를 저장
            tableArr.push(td_obj);
        });
        alert(JSON.stringify(tableArr));
		$.ajax({
			type : "POST",
			url : "reservationComInsert.do",
			data : JSON.stringify(tableArr),
			dataType : "json",
			contentType: "application/json; charset=UTF-8",
			success : function(data) {
				if(data.result == "SUCCESS") {
					chkReqDt = "";
					chkSeq = "";
					addBasyy = "";
					addBasyySeq = "";
					addProdSeq = "";
					comBasyy = "";
					comBasyySeq = "";
					comProdSeq = "";
					nokidBasyy = "";
					nokidBasyySeq = "";
					nokidProdSeq = "";
					roomPlus = 1;
					roomChk = 0;
					roomPerson = 0;
					nokidPerson = 0;
					prodCond = 0;
					twinCnt = 0;
					kingCnt = 0;
					alert("등록이 완료되었습니다.");
					location.replace("/main.do");
				} else {
					chkReqDt = "";
					chkSeq = "";
					addBasyy = "";
					addBasyySeq = "";
					addProdSeq = "";
					comBasyy = "";
					comBasyySeq = "";
					comProdSeq = "";
					nokidBasyy = "";
					nokidBasyySeq = "";
					nokidProdSeq = "";
					roomPlus = 1;
					roomChk = 0;
					roomPerson = 0;
					nokidPerson = 0;
					prodCond = 0;
					twinCnt = 0;
					kingCnt = 0;
					alert("동반자 등록이 실패하였습니다.관리자에게 문의 하세요.");
				}
		 	}
		});
    }
	
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

		var pickGbn   = $("#pick_gbn").val();
		var perNum    = $("#per_num").val();
		var totPerson= Number($("#tot_person").val());
		
		if(pickGbn != "01") {
			if(totPerson < perNum) {
				alert("미팅샌딩 인원이 총 인원 보다 많습니다.");
				return false;
			}
			if(perNum == "00") {
				alert("미팅샌딩 인원을 추가해주세요.");
				return false;
			}
		}

		var rSPer = $("#add_r_s_per").val();
		var rSDay = $("#add_r_s_day").val();
		
		if( (rSDay == "00" && rSPer != "00") ||
			(rSDay != "00" && rSPer == "00")) {
			alert("싱글룸 추가 인원 이나 추가 일수를 확인해주세요.");
			return false;
		}
		
		if(totPerson < strToNum(rSPer)) {
			alert("싱글룸 추가 인원이 총 인원 보다 많습니다.")
			return false;
		}
		
		if(stayDay < strToNum(rSDay)) {
			alert("싱글룸 추가 일자가 숙박일 보다 많습니다.")
			return false;
		}

		var rPPer = $("#add_r_p_per").val();
		var rPDay = $("#add_r_p_day").val();
		
		if( (rPDay == "00" && rPPer != "00") ||
			(rPDay != "00" && rPPer == "00")) {
				alert("프리미엄룸 추가 인원 이나 추가 일수를 확인해주세요.");
				return false;
			}
		
		if(totPerson < strToNum(rPPer)) {
			alert("프리미엄룸 추가 인원이 총 인원 보다 많습니다.")
			return false;
		}
		
		if(stayDay < strToNum(rPDay)) {
			alert("프리미엄룸 추가 일자가 숙박일 보다 많습니다.")
			return false;
		}
		
		if(strToNum($("#g_person").val()) > 0){
			 if($("#add_hdng_gbn" ).val() == ""){
				 alert("일반인원의 패키지 정보를 선택해주세요.")
				 return false;
			 }
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
		}).on("changeDate", function(e) {
			isCal = false;
			$("#cal_amt").val(0);
		});

		<%-- datepicker 버튼  이벤트--%>
		$(".input-daterange .input-group").on("click", function() {
			$(this).find("input").datepicker().focus();
		});

		<%-- 가계산 버튼 클릭 --%>
		$("#calBtn").on("click", function() {
			if(!isValidate()) {
				return;
			}
			// 숙박인원 성인기준:(멤버 + 일반 + 비라운딩 + 소아)
			roomPerson = Math.round((strToNum($("#m_person").val()) + strToNum($("#g_person").val()) + strToNum($("#n_person").val()) + strToNum($("#k_person").val()))/2);
			roomPerson = roomPerson > 0 ? roomPerson : 1;
			
			// 인원보다 방이 더 많을경우를 위한 체크변수  (레이트 인/아웃 산정을 위함)
			if($("#add_hdng_gbn" ).val() != ""){
				roomPlus = 2;
			}
			roomChk = roomPlus ;
			roomPerson = roomChk > roomPerson ? roomChk : roomPerson ;
			
			// 비라운드 + 소아 : 식사+숙박
			nokidPerson = strToNum($("#n_person").val()) + strToNum($("#k_person").val());
			
			//미팅샌딩인원조건
			if($("#pick_gbn").val() == "03"){
				if(strToNum($("#per_num").val()) == 1){
					prodCond = 1;
				}else if(strToNum($("#per_num").val()) == 2){
					prodCond = 2;
				}else if(strToNum($("#per_num").val()) == 3){
					prodCond = 3;
				}else if(strToNum($("#per_num").val()) >= 4){
					prodCond = 4;
				}
			}
				
			var data = {
				  chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")			//체크인
				, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")			//체크아웃
				, flight_in      : $("#flight_in" ).val()								//비행출발일자
				, flight_out     : $("#flight_out").val()								//비행도착일자
				, pick_gbn       : $("#pick_gbn").val()									//미팅샌딩구분
				, per_num        : $("#per_num").val()									//미팅샌딩인원수
				, late_check_in  : $("#late_check_in").val()							//레이트체크인
				, late_check_out : $("#late_check_out").val()							//레이트체크아웃
				, add_r_s_per    : $("#add_r_s_per").val()								//싱글룸추가갯수
				, add_r_s_day    : $("#add_r_s_day").val()								//싱글룸추가일수
				, add_r_p_per    : $("#add_r_p_per").val()								//프리미엄추가갯수
				, add_r_p_day    : $("#add_r_p_day").val()								//프리미엄추가일수
				, room_person    : roomPerson											//숙박인원
				, nokid_person   : nokidPerson											//비라운드,소아인원
				, m_person       : Number($("#m_person").val())							//멤버인원
				, g_person		 : Number($("#g_person").val())							//일반인원
				, tot_person     : Number($("#tot_person").val())						//총인원
				, add_hdng_gbn   : $("#add_hdng_gbn" ).val()							//일반패키지
				, prod_cond   	 : prodCond												//미팅샌딩인원조건
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
						addBasyy 	  = data.add_bas_yy;
						addBasyySeq   = data.add_bas_yy_seq;
						addProdSeq	  = data.add_prod_seq;
						comBasyy 	  = data.com_bas_yy;
						comBasyySeq   = data.com_bas_yy_seq;
						comProdSeq 	  = data.com_prod_seq;
						nokidBasyy 	  = data.nokid_bas_yy;
						nokidBasyySeq = data.nokid_yy_seq;
						nokidProdSeq  = data.nokid_prod_seq;
						
						alert(`숙박비 : \${numberComma(data.roomCharge)},
							    미팅샌딩비 : \${numberComma(data.sendingAmt)},
							    야간할증가격 : \${numberComma(data.surchageAmt)},
							    룸 추가 : \${numberComma(data.roomupAmt)},
							    추가일반패키지 : \${numberComma(data.packageAmt)},
							    비라운드소아(숙박+식사) : \${numberComma(data.nokidAmt)},
							  EarlyCheckIn(방기준2인1실) : \${numberComma(data.lateCheckInAmt)},
							  lateCheckOut(방기준2인1실) : \${numberComma(data.lateCheckOutAmt)}`
						);
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

		<%-- ●●●●●●●● 등록버튼 이벤트 ●●●●●●●● --%>
		$("#reservationBtn").on("click", function() {
			if(!isValidate()) {
				return;
			}

			if(!isCal) {
				alert("가계산을 확인해주세요.");
				return;
			}
			
			// 레이트 인아웃 산정을 위함 : 숙박인원 성인기준:(멤버 + 일반 + 비라운딩 + 소아)
			roomPerson = Math.round((strToNum($("#m_person").val()) + strToNum($("#g_person").val()) + strToNum($("#n_person").val()) + strToNum($("#k_person").val()))/2);
			roomPerson = roomPerson > 0 ? roomPerson : 1;
			
			// 인원보다 방이 더 많을경우를 위한 체크변수  (레이트 인아웃 산정을 위함)
			if($("#add_hdng_gbn" ).val() != ""){
				roomPlus = 2;
			}
			roomChk = roomPlus ;
			roomPerson = roomChk > roomPerson ? roomChk : roomPerson ;
			
			if($("#room_type" ).val() =="01"){			// 트윈
				twinCnt = roomPerson;
			}else if($("#room_type" ).val() =="02"){	// 킹
				kingCnt = roomPerson;
			}else{
				twinCnt = 0;
				kingCnt = 0;
			}
			
			// 비라운드 + 소아 : 식사+숙박
			nokidPerson = strToNum($("#n_person").val()) + strToNum($("#k_person").val());
			
			//미팅샌딩인원조건
			if($("#pick_gbn").val() == "03"){
				if(strToNum($("#per_num").val()) == 1){
					prodCond = 1;
				}else if(strToNum($("#per_num").val()) == 2){
					prodCond = 2;
				}else if(strToNum($("#per_num").val()) == 3){
					prodCond = 3;
				}else if(strToNum($("#per_num").val()) >= 4){
					prodCond = 4;
				}
			}

			var data = {
					  chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")	// 체크인
					, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")	// 체크아웃
					, late_check_in : $("#late_check_in").val()						// 레이트체크인
					, late_check_out : $("#late_check_out").val()					// 레이트체크아웃
					, room_type      : $("#room_type" ).val()						// 객실타입
					, flight_in      : $("#flight_in" ).val()						// 비행출발일자
					, flight_in_hh   : $("#flight_in_hh" ).val()					// 비행출발시간
					, flight_out     : $("#flight_out").val()						// 비행도착일자
					, flight_out_hh  : $("#flight_out_hh").val()					// 비행도착시간
					, m_person       : Number($("#m_person"  ).val())				// 멤버(본인포함)
					, g_person       : Number($("#g_person"  ).val())				// 일반
					, n_person       : Number($("#n_person"  ).val())				// 비라운딩
					, k_person       : Number($("#k_person"  ).val())				// 소아
					, i_person       : Number($("#i_person"  ).val())				// 영유아
					, tot_person     : Number($("#tot_person").val())				// 총인원					
					, add_hdng_gbn   : $("#add_hdng_gbn"     ).val()				// 추가 패키지구분
					, pick_gbn       : $("#pick_gbn"  ).val()						// 미팅샌딩구분
					, per_num        : $("#per_num"   ).val()						// 미팅샌딩인원수
					, add_r_s_per    : $("#add_r_s_per").val()						// 싱글룸추가갯수
					, add_r_s_day    : $("#add_r_s_day").val()						// 싱글룸추가일수
					, add_r_p_per    : $("#add_r_p_per").val()						// 프리미엄추가갯수
					, add_r_p_day    : $("#add_r_p_day").val()						// 프리미엄추가일수
					, twin_cnt		 : twinCnt										// 트윈 갯수
					, king_cnt		 : kingCnt										// 킹 갯수
					, room_person    : roomPerson									// 숙박인원
					, nokid_person   : nokidPerson									// 비라운드,소아인원
					, prod_cond   	 : prodCond										// 미팅샌딩인원조건
					, remark         : $("#remark"     ).val()
			};
			formData.append("param", new Blob([JSON.stringify(data)], {type:"application/json;charset=UTF-8"}));
			dimOpen();
			$.ajax({
				type : "POST",
				url : "reservationInsert.do",
				data : formData,
				dataType : "json",
				processData: false,
				contentType: false,
				success : function(data) {
					dimClose();
					if(data.result == "SUCCESS") {
						if(data.roomChkMsg == ""){
							$("#no_room_chk").val("Check OK")
							$("#no_room_chk").css("color","green");
							reservationKeyChk();
						}else{
							$("#no_room_chk").val("STAND BY");
							$("#no_room_chk").css("color","red");
							$("#chk_in_dt").val("");
							$("#chk_out_dt").val("");
							$("#room_type").val("");
							alert(data.roomChkMsg);
							formData = new FormData();
						}
					} else {
						alert("상품이 없습니다. 관리자에게 문의 하세요.");
					}
			 	}
			});
		});

		<%-- 미팅센드 변경 이벤트 --%>
		$("#pick_gbn").on("change", function() {
			isCal = false;
			$("#cal_amt").val(0);
			var pickValue = this.value;
			if(pickValue == "01") {
				$("#per_num").val("00").attr("disabled", true);
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
			}
		});

		<%-- input 이벤트 --%>
		$(".toNumber").on("propertychange change keyup input", function() {
			isCal = false;
			$("#cal_amt").val(0);
			this.value = numberComma(this.value);
		});
		
		<%-- input 이벤트 --%>
		$(".toNumbers").change(function(){  
			isCal = false;
			$("#cal_amt").val(0);
			
			var id = this.id;
			if(id == "m_person" || id == "g_person" || id == "n_person"|| id == "k_person"|| id == "i_person") {
				var sum = strToNum($("#m_person").val()) + strToNum($("#g_person").val()) + strToNum($("#n_person").val()) + strToNum($("#k_person").val()) + strToNum($("#i_person").val());
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
						  chk_in_dt      : $("#chk_in_dt" ).val().replace(/-/gi, "")	//체크인
						, chk_out_dt     : $("#chk_out_dt").val().replace(/-/gi, "")	//체크아웃
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
			$("#room_type").val("")
		});
		
		$("#chk_out_dt").on("change", function() {
			$("#room_type").val("")
		});
		
		<%-- input 이벤트 --%>
		$(".addCom").change(function(){
			var idvalue = (this.id == "m_person" ? "01" : this.id == "g_person" ? "02" : this.id == "n_person" ? "03" : this.id == "k_person" ? "04" : this.id == "i_person" ? "05" : "00");
			var personCnt = strToNum(this.value);
			if(this.id == "m_person"){
				personCnt = personCnt - 1;
			}
			$("tr#com_board").each(function (index, item) {
				let td = $(this).children();
				let comListChk = td.eq(2).find('#list_num_gbn option:selected').val(); // 인원구분
				if(td.eq(1).text() == "2" && comListChk == idvalue){
					td.remove();
				}
			});
 			for (var i = 0; i < personCnt; i++){
				$("#list_table").append(
						$("<tr id=com_board>").append(
							$("<td style=min-width:45px>").append(),										// 순번
							$("<td style=display:none >").append( "2" ),									// 예약자구분 (1:예약자,2:동반자')
							$("<td>").append(setPeopleGbn(idvalue) ),										// 인원구분
							$("<td style=min-width:70px>").append(),		// 한글명
							$("<td style=min-width:70px>").append(),		// 영문명
							$("<td style=min-width:120px>").append(),		// 연락처
							$("<td style=display:none>").append( $("#com_user_id").val() ),					// 등록자
						)	
				);
			}
			numbering(); 
			idvalue = "";
			personCnt = 0;
		});
		
		
		
		
		
		// 동반자 추가 레이어팝업 열기
		$("#comPlusBtn").on("click", function() {
			$("#layerPop2").css("display","block");
		});
		
		// 동반자 추가 레이어팝업 이벤트
		$("#comAddListBtn").on("click", function() {
			var comRdChk = $('input:radio[name="comAddradio"]:checked').val();
			$("#list_table").append(
					$("<tr id=com_board>").append(
						$("<td style=min-width:45px>").append(),						// 순번
						$("<td style=display:none >").append( "2" ),					// 예약자구분 (1:예약자,2:동반자')
						$("<td>").append(setPeopleGbn(comRdChk) ),						// 인원구분
						$("<td style=min-width:70px>").append(),				// 한글명
						$("<td style=min-width:70px>").append(),				// 영문명
						$("<td style=min-width:120px>").append(),			// 연락처
						$("<td style=display:none>").append( $("#com_user_id").val() ),	// 등록자
					)	
			);
			
			var temPerson = "";

			if(comRdChk == "01"){
				temPerson = Number($("#m_person").val())+1;
				if(temPerson < 10){
					temPerson = "0" + temPerson.toString();
				}
				$("#m_person").val(temPerson.toString());
			}else if(comRdChk == "02"){
				temPerson = Number($("#g_person").val())+1;
				if(temPerson < 10){
					temPerson = "0" + temPerson.toString();
				}
				$("#g_person").val(temPerson.toString());
			}else if(comRdChk == "03"){
				temPerson = Number($("#n_person").val())+1;
				if(temPerson < 10){
					temPerson = "0" + temPerson.toString();
				}
				$("#n_person").val(temPerson.toString());
			}else if(comRdChk == "04"){
				temPerson = Number($("#k_person").val())+1;
				if(temPerson < 10){
					temPerson = "0" + temPerson.toString();
				}
				$("#k_person").val(temPerson.toString());
			}else if(comRdChk == "05"){
				temPerson = Number($("#i_person").val())+1;
				if(temPerson < 10){
					temPerson = "0" + temPerson.toString();
				}
				$("#i_person").val(temPerson.toString());
			}
			
			isCal = false;
			$("#cal_amt").val(0);
			
			var sum = strToNum($("#m_person").val()) + strToNum($("#g_person").val()) + strToNum($("#n_person").val()) + strToNum($("#k_person").val()) + strToNum($("#i_person").val());
			if(sum <=9){
				$("#tot_person").val("0"+sum);
			}else{
				$("#tot_person").val(numberComma(sum));
			}
			
			numbering();
			
			$("#layerPop2").css("display","none");
		});
			
		// 동반자 상세 이벤트	
		$("#list_table").on('click', 'tr', function(){
			comTemp = $(this).children().eq(0).text();
			if(comTemp != "번호"){
				if(comTemp == "1"){
					$("#comDelBtn").attr("disabled", true);
					$("#comNumChk span").text( "# " + comTemp + "번째 예약자 (삭제불가)");
				}else{
					$("#comDelBtn").removeAttr("disabled");
					$("#comNumChk span").text( "# " + comTemp + "번째 동반자");	
				}
				
				$('input[name="add_han_name"]').val($(this).children().eq(3).text());
				$('input[name="add_eng_name"]').val($(this).children().eq(4).text());
				$('input[name="add_telno"]').val($(this).children().eq(5).text());
				$("#layerPop").css("display","block");
			}
		});
		
		// 동반자 상세 입력
		$("#comAddBtn").on("click", function() {
			$('tr#com_board').each(function() {
				comTempChk = $(this).children().eq(0).text();
				if(comTemp == comTempChk){
					$(this).children().eq(3).text($('input[name="add_han_name"]').val());
					$(this).children().eq(4).text($('input[name="add_eng_name"]').val());
					$(this).children().eq(5).text($('input[name="add_telno"]').val());
				}
				
			});
			$("#layerPop").css("display","none");
		});
		
		// 동반자 상세 삭제
		$("#comDelBtn").on("click", function() {
			$('tr#com_board').each(function() {
				comTempChk = $(this).children().eq(0).text();
				let comGbnChk = $(this).children().eq(2).find('#list_num_gbn option:selected').val();
				if(comTemp != "1" && comTemp == comTempChk){
					var temPerson = "";
					$(this).remove();
					if(comGbnChk == "01"){
						temPerson = Number($("#m_person").val())-1;
						if(temPerson < 10){
							temPerson = "0" + temPerson.toString();
						}
						$("#m_person").val(temPerson.toString());
					}else if(comGbnChk == "02"){
						temPerson = Number($("#g_person").val())-1;
						if(temPerson < 10){
							temPerson = "0" + temPerson.toString();
						}
						$("#g_person").val(temPerson.toString());
					}else if(comGbnChk == "03"){
						temPerson = Number($("#n_person").val())-1;
						if(temPerson < 10){
							temPerson = "0" + temPerson.toString();
						}
						$("#n_person").val(temPerson.toString());
					}else if(comGbnChk == "04"){
						temPerson = Number($("#k_person").val())-1;
						if(temPerson < 10){
							temPerson = "0" + temPerson.toString();
						}
						$("#k_person").val(temPerson.toString());
					}else if(comGbnChk == "05"){
						temPerson = Number($("#i_person").val())-1;
						if(temPerson < 10){
							temPerson = "0" + temPerson.toString();
						}
						$("#i_person").val(temPerson.toString());
					}
				}
				
			});

			isCal = false;
			$("#cal_amt").val(0);
			
			var sum = strToNum($("#m_person").val()) + strToNum($("#g_person").val()) + strToNum($("#n_person").val()) + strToNum($("#k_person").val()) + strToNum($("#i_person").val());
			if(sum <=9){
				$("#tot_person").val("0"+sum);
			}else{
				$("#tot_person").val(numberComma(sum));
			}
			
			numbering();
			
			$("#layerPop").css("display","none");
		});
		
		$("#popup_close_btn").on("click", function() {
			$("#layerPop").css("display","none");
		});
		
		$("#popup_close_btn2").on("click", function() {
			$("#layerPop2").css("display","none");
		});
		
		$("#list_table").on('mouseover', 'tr', function(){
		    $(this ).css("background-color", "#afeeee");
		    $(this).children().css("cursor", "pointer");
		});

		$("#list_table").on('mouseleave', 'tr', function(){
		    $(this).css("background-color", "white");
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
					<span class="d-sm-block d-none">[예약신청]ㆍ객실</span>
				</a>
			</li>
			<li class="nav-item">
				<a href="#default-tab-2" data-bs-toggle="tab" class="nav-link">
					<span class="d-sm-none">옵션</span>
					<span class="d-sm-block d-none">[예약신청]ㆍ옵션</span>
				</a>
			</li>
			<li class="nav-item">
				<a href="#default-tab-3" data-bs-toggle="tab" class="nav-link">
					<span class="d-sm-none">동반자</span>
					<span class="d-sm-block d-none">[예약신청]ㆍ동반자</span>
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
								<input type="text" id="chk_in_dt" name="chk_in_dt" class="form-control text-center " placeholder="날짜를 선택하세요" readonly>
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
					<label class="form-label col-form-label col-md-3">Flight In</label>
					<div class="col-md-9 inline-flex">
						<select id="flight_in" name="flight_in" class="form-select text-center">
							<option value="">-선택-</option>
							<c:forEach items="${fligthInList}" var="fligthIn" varStatus="status">
								<option value="${fligthIn.CODE}">${fligthIn.CODE_NM}</option>
							</c:forEach>
						</select>
						<select id="flight_in_hh" name="flight_in_hh" class="form-select text-center">
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
						<select id="flight_out" name="flight_out" class="form-select text-center">
							<option value="">-선택-</option>
							<c:forEach items="${fligthOutList}" var="fligthOut" varStatus="status">
								<option value="${fligthOut.CODE}">${fligthOut.CODE_NM}</option>
							</c:forEach>
						</select>
						<select id="flight_out_hh" name="flight_out_hh" class="form-select text-center">
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
						<input id="fligthImage" name="fligthImage" type="file" accept="image/*" class="form-control" />
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">한글이름</label>
					<div class="col-sm-9">
						<input type="text" class="form-control text-muted text-center" value="${sessionScope.login.han_name}" readonly>
					</div>
				</div>
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">영문이름</label>
					<div class="col-sm-9">
						<input type="text" class="form-control text-muted text-center" value="${sessionScope.login.eng_name}" readonly>
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
						<select id="per_num" name="per_num" class="form-select text-center toNumbers">
							<option value="00">00</option>
							<c:forEach var="i" begin="1" end="30" step="1">
								<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>명
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">싱글룸 추가</label>
					<div class="col-md-9 inline-flex">
						<select id="add_r_s_day" name="add_r_s_day" class="form-select text-center toNumbers">
							<c:forEach var="i" begin="0" end="30" step="1">
								<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>일
						<select id="add_r_s_per" name="add_r_s_per" class="form-select text-center toNumbers">
							<c:forEach var="i" begin="0" end="10" step="1">
								<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>개
						
					
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">프리미엄 추가</label>
					<div class="col-md-9 inline-flex">
						<select id="add_r_p_day" name="add_r_p_day" class="form-select text-center toNumbers">
							<c:forEach var="i" begin="0" end="30" step="1">
								<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>일
						<select id="add_r_p_per" name="add_r_p_per" class="form-select text-center toNumbers">
							<c:forEach var="i" begin="0" end="10" step="1">
								<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
									<fmt:formatNumber value="${i}" minIntegerDigits="2" />
								</option>
							</c:forEach>
						</select>개
						
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Early Check In</label>
					<div class="col-md-9">
						<select id="late_check_in" name="late_check_in" style="text-align: center" class="form-select">
							<c:forEach items="${lateInYnList}" var="lateInYn" varStatus="status">
								<option value="${lateInYn.CODE}">${lateInYn.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">Late Check Out</label>
					<div class="col-md-9">
						<select id="late_check_out" name="late_check_out" style="text-align: center" class="form-select">
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
								<select id="m_person" name="m_person" class="form-select text-center toNumbers addCom">
									<c:forEach var="i" begin="1" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
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
								<select id="g_person" name="g_person" class="form-select text-center toNumbers addCom">
									<c:forEach var="i" begin="0" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
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
								<select id="n_person" name="n_person" class="form-select text-center toNumbers addCom">
									<c:forEach var="i" begin="0" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
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
								<select id="k_person" name="k_person" class="form-select text-center toNumbers addCom">
									<c:forEach var="i" begin="0" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
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
								<select id="i_person" name="i_person" class="form-select text-center toNumbers addCom">
									<c:forEach var="i" begin="0" end="15" step="1">
										<option value="<fmt:formatNumber value="${i}" minIntegerDigits="2"/>">
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
								<input id="tot_person" name="tot_person" type="text" class="form-control text-center toNumbers" maxlength="2" value="01" readonly>명
							</div>
						</div>
					</div>
					<span style="text-align:left; opacity:30%; color:red; font-size:0.7rem">
									         ※   인원 등록 시 [동반자]탭 내역이 자동생성 되며,<br/>
					  &nbsp;&nbsp;&nbsp;&nbsp;수정 시 [동반자]탭 내역이 재생성 됩니다.
					</span>
				</div>

				<div id="packageDiv" class="row mb-2">
					<label class="form-label col-form-label col-md-3">패키지</label>
					<div class="col-md-9">
						<select id="add_hdng_gbn" class="form-select text-center">
							<option value="">-선택-</option>
							<c:forEach items="${packageList}" var="add_hdng_gbn" varStatus="status">
								<option value="${add_hdng_gbn.CODE}">${add_hdng_gbn.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				
				<div class="row mb-2">
					<label class="form-label col-form-label col-md-3">추가 요청사항</label>
					<div class="col-md-9">
						<textarea id="remark" name="remark" class="form-control" rows="2"></textarea>
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
			
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-3">
				<button id="comPlusBtn" name="comPlusBtn" type="button" class="btn btn-success btn-icon btn-lg btn-write" style="opacity:30%; background-color:#348FE2; width:22px; height:22px; font-size:12px; line-height:22px; right:2rem; top:122px;">
					<i class="fas fa-plus"></i>
				</button>
				<div class="total-people-wrap">
					<div class="container2"  style="overflow:auto">
						<table border="1" id="list_table" class="table table-bordered" style="text-align:center;">
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
								<tr id="com_board">
									<td style="min-width:45px;">1</td>
									<td style="display:none">1</td>
									<td >
										<select id="list_num_gbn" name="list_num_gbn" disabled="disabled" style="min-width:70px;">
											<option value="01" <c:if test="${sessionScope.login.mem_gbn eq '01' }">selected</c:if>>멤버</option>
											<option value="02" <c:if test="${sessionScope.login.mem_gbn eq '02' }">selected</c:if>>일반</option>
											<option value="04" <c:if test="${sessionScope.login.mem_gbn eq '04' }">selected</c:if>>소아</option>
											<option value="03" <c:if test="${sessionScope.login.mem_gbn eq '03' }">selected</c:if>>비라운딩</option>									
											<option value="05" <c:if test="${sessionScope.login.mem_gbn eq '05' }">selected</c:if>>영유아</option>
										</select>
									</td>
									<td style="min-width:70px;">${sessionScope.login.han_name}</td>
									<td style="min-width:70px;">${sessionScope.login.eng_name}</td>
									<td id="sessionTelNo" style="min-width:120px;"></td>
									<td style="display:none">${sessionScope.login.user_id}</td>
								</tr>
							</tbody>
						</table>
						<!-- 동반자 테이블 END -->
						
						<div id="wrapper_popup">
							<div id="layerPop" class="layer-shadow">
							<div class="popup_top_box">
								<div id="comNumChk"><span style="text-align:left; opacity:30%; color:red"></span></div>
								<i class="fa fa-close" id="popup_close_btn"></i>
							</div>
								<div class="total-people-wrap" id="reserve_popup">
									<div class="input-group">
										<div class="input-group-prepend">
											<span class="input-group-text">한글이름</span>
										</div>
										<input id="onlyKor" name="add_han_name" type="text" class="form-control text-center" style="min-width:70px;">
									</div>
									
									<div class="input-group">
										<div class="input-group-prepend">
											<span class="input-group-text">영문이름</span>
										</div>
										<input id="onlyEng" name="add_eng_name" type="text" class="form-control text-center" style="min-width:70px;">
									</div>
									
									<div class="input-group">
										<div class="input-group-prepend">
											<span class="input-group-text">전화번호</span>
										</div>
										<input id="onlyNum" name="add_telno" type="text" class="form-control text-center" style="min-width:70px;">
									</div>
									<div class="find-btn">	
										<button id="comAddBtn" name="comAddBtn" type="button" class="btn btn-primary btn-lg">입력</button>
										<button id="comDelBtn" name="comDelBtn" type="button" class="btn btn-primary btn-lg">삭제</button>
									</div>
								</div>
							</div>
						</div>
						<!-- /.wrapper_popup1 -->
						
						<div id="wrapper_popup">
							<div id="layerPop2" class="layer-shadow">
								<i class="fa fa-close" id="popup_close_btn2" style="width:100%; text-align:right;"></i>
								<div class="total-people-wrap" id="reserve_popup">
									<div class="radioSet">
										<div>
											<input type="radio" id ="r1" name="comAddradio" value="01" checked="checked"/><label for="r1" style="border-radius:8px; width:32%;">멤버</label>
											<input type="radio" id ="r2" name="comAddradio" value="02"/><label for="r2" style="border-radius:8px;width:32%;">일반</label>
											<input type="radio" id ="r4" name="comAddradio" value="04"/><label for="r4" style="border-radius:8px;width:32%;">소아</label>
										</div>
										<div style="margin-top:5px;">
											<input type="radio" id ="r3" name="comAddradio" value="03"/><label for="r3" style="border-radius:8px;width:40%;">비라운드</label>
											<input type="radio" id ="r5" name="comAddradio" value="05"/><label for="r5" style="border-radius:8px;width:40%;">영유아</label>
										</div>
									</div>
								</div>
								<button id="comAddListBtn" name="comAddListBtn" type="button" class="btn btn-outline-primary btn-lg" style="width:100%; margin-bottom:5px;">추가</button>
							</div>
						</div>
						<!-- /.wrapper_popup2 -->
					</div> 
					<!-- /.container -->
				</div>
			</div>
				<!-- END tab3-pane -->
		</div>
	<!-- END content-container -->
	</div>
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="javascript:;" id="reservationBtn" class="btn btn-success btn-lg">등록</a>
	</div>
	<!-- END #footer -->
	
</div>
