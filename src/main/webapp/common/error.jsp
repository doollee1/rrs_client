<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
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
</head>
<body>
	<!-- BEGIN #app -->
	<div id="app" class="app app-header-fixed app-sidebar-fixed app-content-full-height">
		<div id="content" class="app-content d-flex flex-column p-0">
			<!-- BEGIN content-container -->
			<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">

				<div class="dim-layer show"></div>
				<div class="error-wrap">
					<i class="far fa-face-grin-beam-sweat"></i>
					<p class="text-error">error</p>
				</div>
			
			</div>
		</div>
		
		<a href="javascript:;" class="btn btn-icon btn-circle btn-theme btn-scroll-to-top" data-toggle="scroll-to-top"><i class="fa fa-angle-up"></i></a>
	</div>
	
	<script src="PalmResort/assets/js/vendor.min.js"></script>
	<script src="PalmResort/assets/js/app.min.js"></script>
</body>
</html>