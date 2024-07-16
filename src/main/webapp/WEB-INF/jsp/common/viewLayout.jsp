<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<tiles:insertAttribute name="header"/>
</head>
<body>
	<div class="dim-layer"></div>
	<div id="div_load_image" style="position:fixed; top:calc(50% - 50px); left:calc(50% - 50px);width:0px;height:0px; z-index:9999; background:#f0f0f0; filter:alpha(opacity=50); opacity:alpha*0.5; margin:auto; padding:0; text-align:center;display:none">
      <img src="/PalmResort/assets/img/img.gif" style="width:100px; height:100px;">
    </div>
	<!-- BEGIN #app -->
	<div id="app" class="app app-header-fixed app-sidebar-fixed app-content-full-height">
		<!-- BEGIN #header -->
		<div id="header" class="app-header">
			<!-- BEGIN navbar-header -->
			<div class="navbar-header">
				<button id="back-button" type="button" class="navbar-mobile-toggler btn-pre" >
					<i class="fas fa-angle-left"></i>
				</button>
				<h1></h1>
				<button type="button" class="navbar-mobile-toggler<c:if test="${sessionScope.login == null}"> hidden</c:if>" data-toggle="app-sidebar-mobile">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
			</div>
			<!-- END navbar-header -->
		</div>
		<!-- END #header -->

		<tiles:insertAttribute name="sidebar"/>
		<tiles:insertAttribute name="content"/>

		<!-- BEGIN scroll-top-btn -->
		<a href="javascript:;" class="btn btn-icon btn-circle btn-theme btn-scroll-to-top" data-toggle="scroll-to-top"><i class="fa fa-angle-up"></i></a>
		<!-- END scroll-top-btn -->
	</div>
	<!-- END #app -->
</body>
</html>