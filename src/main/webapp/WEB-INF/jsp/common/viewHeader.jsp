<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"     prefix="tiles" %>

<meta charset="utf-8" />
<title>Palm Resort Reservation System</title>
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
<meta content="팜리조트 예약" name="description" />
<meta content="" name="author" />

<!-- ================== BEGIN core-css ================== -->
<link href="PalmResort/assets/css/vendor.min.css" rel="stylesheet" />
<link href="PalmResort/assets/css/default/app.min.css" rel="stylesheet" />
<link href="PalmResort/assets/css/palm.css" rel="stylesheet" />
<!-- ================== END core-css ================== -->
<link href="PalmResort/assets/plugins/bootstrap-datepicker/dist/css/bootstrap-datepicker.css" rel="stylesheet" />

<script src="PalmResort/assets/js/vendor.min.js"></script>
<script src="PalmResort/assets/js/app.min.js"></script>

<script src="PalmResort/assets/plugins/bootstrap-datepicker/dist/js/bootstrap-datepicker.js"></script>
<script src="PalmResort/assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.min.js"></script>
<script src="PalmResort/assets/plugins/clipboard/dist/clipboard.min.js"></script>
<script src="PalmResort/assets/plugins/spectrum-colorpicker2/dist/spectrum.min.js"></script>

<script>
(function($) {
	$.ajaxSetup({
		beforeSend : function(xhr) {
			xhr.setRequestHeader("HEADER", true);
		},
		error : function(xhr, status, err) {
			dimClose();
			if (xhr.status == 999) {
				alert("세션이 종료되어 로그인 화면으로 이동됩니다.");
				location.href="/signIn.do";
			} else {
				console.log(xhr);
				alert("예외가 발생했습니다. 관리자에게 문의하세요.");
			}
		}
	});
})(jQuery);

$(document).ready(function() {
	$("#back-button").click(function() {
		history.back();
	});
		
});

function dimClose() {
	/* if($(".dim-layer").length >= 1 && $(".dim-layer").hasClass("show")) {
		$(".dim-layer").removeClass("show");
	} */
	$("#div_load_image").hide();
}

function dimOpen() {
	/*
	if($(".dim-layer").length >= 1) {
		$(".dim-layer").addClass("show");
	} */
	$("#div_load_image").show();
}
function setTitle(title) {
	$("#app > #header > .navbar-header > h1").html(title);
}

function strToNum(str) {
	return Number(str.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'));
}

function numberComma(val) {
	val += "";
	return strToNum(val).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
</script>