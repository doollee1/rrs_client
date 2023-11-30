<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- 순서유의 --%>
<script src="resrc/rsa/rsa.js"  ></script>
<script src="resrc/rsa/jsbn.js" ></script>
<script src="resrc/rsa/prng4.js"></script>
<script src="resrc/rsa/rng.js"  ></script>

<script>
let fileMap = new Map();

var resizeImage = function (settings) {
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
		if (!file.type.match(/image.*/)) {
			no(new Error("Not an image"));
			return;
		}
		reader.onload = function (readerEvent) {
			image.onload = function () { return ok(resize()); };
			image.src = readerEvent.target.result;
		};
		reader.readAsDataURL(file);
	});
};

function select() {
	let reader = new FileReader();
	let file = this.files[0];
	reader.onload = function(e) {
		$("#preview").attr("src", e.target.result);
	};
	reader.readAsDataURL(file);
}

$(document).ready(function() {
	setTitle("테스트");

	$("#photoFile").on('change', select);
});

function login() {
	let rsa = new RSAKey();
	rsa.setPublic($('#RSAModulus').val(),$('#RSAExponent').val());
	let in_id = $("#in_id").val();
	let in_pw = rsa.encrypt($("#in_pw").val());

	alert(in_pw);

	$.ajax({
		type: "POST",
		url : "login.do",
		data: { "in_id":in_id, "in_pw":in_pw },
		dataType:"json",
		success:function(data) {
			alert(data);
		},
		error:function(data) {
			console.log("통신중 오류가 발생하였습니다.");
		}
	});
}

function imageTest() {
	let formData = new FormData();
	if($("#photoFile")[0].files && $("#photoFile")[0].files[0]) {
		formData.append("file", $("#photoFile")[0].files[0]);
		//let reader = new FileReader(); 
		//resizeImage({
		//	file: $("#photoFile")[0].files[0],
		//	maxSize: 600
		//}).then(function (resizedImage) {
		//	console.log($("#photoFile")[0].files[0]);
		//	console.log(resizedImage);
		//	reader.onload = function(e) {
		//		document.getElementById('output').src = URL.createObjectURL(resizedImage);
		//	};
		//	reader.readAsDataURL($("#photoFile")[0].files[0]);
		//	formData.append("file", resizedImage);
		//});
	}

	let data = {
		test : "1",
		test2 : "3"
	};
	formData.append("param", new Blob([JSON.stringify(data)], {type:"application/json"}));

	for (const x of formData.entries()) {
		console.log(x);
	}
	
	$.ajax({
		type : "POST",
		//url : "/testImage.do",
		url : "testImage3.do",
		data : formData,
		dataType : "json",
		processData: false,
		contentType: false,
		success : function(data) {
			if(data.result == "SUCCESS") {
				alert("파일이 전송되었습니다.");
			} else {
				alert("파일 전송에 실패하였습니다.");
			}
	 	},
	 	error : function(request, status, error) {
	 		alert("code : " + request.status + "\n" + "message : " + request.responseText + "\n" + "error : " + error);
		}
	});
}

function imageTest2() {
	$.ajax({
		type : "POST",
		url : "/testImage2.do",
		data : "",
		dataType : "json",
		success : function(data) {
			if(data.result == "SUCCESS") {
				alert("파일이 전송되었습니다.");
				$("#photoImg2").attr('src', data.ADD_PATH + data.ADD_FILE);
				$("#photoImg2").show();
			} else {
				alert("파일 전송에 실패하였습니다.");
			}
	 	},
	 	error : function(request, status, error) {
	 		alert("code : " + request.status + "\n" + "message : " + request.responseText + "\n" + "error : " + error);
		}
	});
}
</script>
<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
		<!-- BEGIN panel -->
		<div class="panel panel-inverse">
			<div class="panel-body">
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
			</div>
			<%-- 테스트!!!!!!!!!!!!!!!!! start--%>
			<input type="text"     id="in_id" name="in_id" placeholder="아이디"  required><BR>
			<input type="password" id="in_pw" name="in_pw" placeholder="비밀번호" required><br>
			<input type="hidden"   id="RSAModulus"  value="${RSAModulus }"/>
			<input type="hidden"   id="RSAExponent" value="${RSAExponent}"/>


		<img src="" id="photoImg" width="100px" height="100px" style="display:none;">
		<img src="" id="photoImg2" width="100px" height="100px" style="display:none;">
		<img src="" id="preview">
		<img src="" id="output" >
		<input type="file" name="photoFile" id="photoFile" accept="image/*" >
		<!-- <input type="file" name="photoFile" id="photoFile" accept="image/*" capture="camera" style="display:none;"> -->
		<br>
		<!-- <input type="button" value="카메라"> -->
		<br>
		<div id="result"></div>
			<%-- 테스트!!!!!!!!!!!!!!!!! end--%>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="javascript:;" onclick="imageTest();" class="btn btn-success btn-lg d-block">Image Save</a>
		<a href="javascript:;" onclick="imageTest2();" class="btn btn-success btn-lg d-block">Image Load</a>
	</div>
	<!-- END #footer -->
</div>