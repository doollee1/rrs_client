<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<tiles:insertAttribute name="header"/>
</head>
<body>
	<!-- BEGIN #app -->
	<div id="app" class="app app-content-full-height">
		<tiles:insertAttribute name="content"/>
		<a href="javascript:;" class="btn btn-icon btn-circle btn-theme btn-scroll-to-top" data-toggle="scroll-to-top"><i class="fa fa-angle-up"></i></a>
	</div>
	<!-- END #app -->

	<!-- ================== BEGIN core-js ================== -->
	<script src="PalmResort/assets/js/vendor.min.js"></script>
	<script src="PalmResort/assets/js/app.min.js"></script>
	<!-- ================== END core-js ================== -->
</body>
</html>