<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script>
$(document).ready(function() {
	
	var formData = new FormData();   //이미지, json 파라미터
	
	var paramList = [];     //관리자 다중이미지 파라미터 배열
	
	setTitle("파일업로드");
	fn_Init();   //최초세팅
	setEvent();	//이벤트 설정

	
	//최초 세팅
	function fn_Init(){
			
		//메뉴 감추기
		$(".menu-item").each(function(index, item){

		    //로그아웃 제외		
			if ($(this).find(".fa-solid").length < 1){				
				
				//navigation 메뉴 감추기
				$(this).hide();
			} 
					
		});		
	}
	
	<%-- 이미지 변경  --%>
	function handleImgInput() {
		
		console.log("===== 이미지변경 =====");
		
		//동반자 한글명 확인
		var comHanNm = $(this).closest("#adminImg").find("#hanNameDiv #com_han_name").val();
		console.log("=== 동반자 한글명 : "+comHanNm)
		
		var comEngNm = $(this).closest("#adminImg").find("#engNameDiv #com_eng_name").val();
		console.log("=== 동반자 영문명 : "+comEngNm)
		
		var comTelNo = $(this).closest("#adminImg").find("#telNoDiv #com_tel_no").val();
		console.log("=== 동반자 전화번호 : "+comTelNo)
		
		
		//동반자명이 없을경이 반환
		if(isEmpty(comHanNm)){
			
			alert("동반자 한글명을 입력하십시요.");
			$(this).val("");
			return;
		}
		
		
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
				
				var imageFile = new File([resizedImage], file.name, {type: file.type});
				formData.append("file", imageFile);
			});
		} else {
			formData.append("file", file);
		}
		
		//관리자 다중이미지 파라미터 배열에 push
		var data = {
				req_dt : $("#req_dt").val(),
				seq	   : $("#seq").val(),
				dseq   : $(this).siblings("#dseq").val(),
				com_han_nm : comHanNm,
				com_eng_nm : comEngNm,
				com_tel_no : comTelNo
		};
		
		paramList.push(data);
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

	

	<%-- 이벤트 함수 --%>
	function setEvent() {		
		
		<%-- 이미지 이벤트 --%>
		$("input[name=fligthImage]").each(function(index, item){
			
			$(this).on("change", handleImgInput);
		});
		
		
		<%-- 등록버튼 이벤트 --%>
		$("#reservationBtn").on("click", function() {
						
			console.log("before paramList : "+JSON.stringify(paramList));
			
			
			//파일업로드 이후, 한글이름, 영문이름, 전화번호 변경시					
			$.each(paramList, function(idx, value){
				
				var paramDseq = value.dseq;
				//console.log("=== paramDseq : "+paramDseq);
				
				
				$("input:file[id='fligthImage']").each(function(index, item){
										
					//파일이미지가 있을 경우
					if(!isEmpty($(item).val())){
						
						
						var dseq =  $(this).siblings("#dseq").val();						
						//console.log("=== dseq : "+dseq);
						
						//상세일련번호가 같은 경우
						if(paramDseq == dseq) {
						
							var comHanNm = $(this).closest("#adminImg").find("#hanNameDiv #com_han_name").val();
							var comEngNm = $(this).closest("#adminImg").find("#engNameDiv #com_eng_name").val();
							var comTelNo = $(this).closest("#adminImg").find("#telNoDiv #com_tel_no").val();
							
							
							//동반자 한글명 수정
							if(comHanNm != value.com_han_nm) {						
								paramList[idx].com_han_nm = comHanNm;												
							}
							
							//동반자 영문병 수정
							if(comEngNm != value.com_eng_nm) {
								paramList[idx].com_eng_nm = comEngNm;
							}
							
							//동반자 전화번호 수정
							if(comTelNo != value.com_tel_no) {
								paramList[idx].com_tel_no = comTelNo;
							}							
						}
												
					}								
					
				});
				
			});
			
			
				
						
			console.log("after paramList : "+JSON.stringify(paramList));
			
			//등록이미지가 없을 경우
			if(paramList.length < 1) {
				
				if(confirm("이미지 등록을 안하셨습니다. 등록하시겠습니까?")) {
					
					console.log("이미지 미등록, 현재화면에서 대기");
					return false;
				} else {
					
					console.log("이미지 미등록, 예약목록화면으로 이동");
					location.replace("/adminReservationList.do");   //관리자 예약목록으로 이동			
					return false;
				}
				
			}
						

			formData.append("list", new Blob([JSON.stringify(paramList)], {type:"application/json;charset=UTF-8"}));

			dimOpen();
			$.ajax({
				type : "POST",
				url : "adminImageReservationAjax.do",  //관리자 다중 이미지 등록 ajax
				data : formData,
				dataType : "json",
				processData: false,
				contentType: false,
				success : function(data) {
					dimClose();
					if(data.result == "SUCCESS") {
						alert("이미지 등록이 완료되었습니다.");
						location.replace("/adminReservationList.do");   //관리자 예약목록으로 이동
					} else {
						alert("이미지 등록이 실패하였습니다. 관리자에게 문의 하세요.");
					}
			 	}
			});
			
		});
		
	}
	
});


//null 체크
function isEmpty(value) {
	if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){
		return true
	}else{
		return false
	}
}


$(document).on("keyup", "input[onlyNum]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
$(document).on("keyup", "input[onlyKor]", function() {$(this).val( $(this).val().replace(/[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g,"") );});
$(document).on("keyup", "input[onlyEng]", function() {$(this).val( $(this).val().replace(/[^A-Z,a-z, ]/ig,"") );});

</script>

<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
		
		<!-- BEGIN tab-content -->
		<div class="tab-content panel rounded-0 p-3 m-0">
		
			<input type="hidden" id="req_dt"       name="req_dt"   value= "${param.req_dt}"   />
			<input type="hidden" id="seq"          name="seq"      value= "${param.seq}"   />
			
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				
				<c:if test="${empty adminImageUploadList}">
					<li class="none">
						<a href="#"><i class="fa fa-times"></i>예약내역이 없습니다.</a>
					</li>
				</c:if>
				<c:if test="${not empty adminImageUploadList}">
					<c:forEach items="${adminImageUploadList}" var = "list" varStatus = "status">	
						<div id="adminImg">					
							<div class="row mb-2">
								<label class="form-label col-form-label col-md-3">인원구분</label>
								<div class="col-sm-9">								
									<input type="text" class="form-control text-muted text-center" id="num_gbn" value="${list.NUM_GBN}" readonly>																
								</div>
							</div>
							<div id="hanNameDiv" class="row mb-2">
								<label class="form-label col-form-label col-md-3">한글이름</label>
								<div class="col-sm-9">																		
									<input type="text" class="form-control text-muted text-center" id="com_han_name" value="${list.COM_HAN_NM}" onlyKor />									
								</div>
							</div>
							<div id="engNameDiv" class="row mb-2">
								<label class="form-label col-form-label col-md-3">영문이름</label>
								<div class="col-sm-9">																		
									<input type="text" class="form-control text-muted text-center" id="com_eng_name" value="${list.COM_ENG_NM}" onlyEng />									
								</div>
							</div>
							<div id="telNoDiv" class="row mb-2">
								<label class="form-label col-form-label col-md-3">전화번호</label>
								<div class="col-sm-9">																		
									<input type="text" class="form-control text-muted text-center" id="com_tel_no" value="${list.COM_TEL_NO}" onlyNum />										
								</div>
							</div>
							<div class="row mb-2">
								<label class="form-label col-form-label col-md-3">항공권 첨부</label>
								<div class="col-sm-9">
									<input id="fligthImage" name="fligthImage" type="file" accept="image/*" class="form-control" />
									<input type="hidden" id="dseq"          name="dseq"      value= "${list.DSEQ}"   />
								</div>
							</div>
						</div>
					</c:forEach>
				</c:if>				
			</div>
			<!-- END tab-pane -->			
		
		</div>
	<!-- END content-container -->
	</div>
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
	
		<!-- 예약내역이 있을경우만 등록버튼 보여줌 -->
		<c:if test="${not empty adminImageUploadList}">  
			<a href="javascript:;" id="reservationBtn" class="btn btn-success btn-lg">등록</a>
		</c:if>
	</div>
	<!-- END #footer -->
	
</div>
