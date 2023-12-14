<%--
	File Name : noticeView.jsp (PalmResort > html > board_notice_view.html)
	Description : 공지사항 상세보기 페이지
	Creation : 2023.11.29 이민구
	Update
	2023.11.29 이민구 - 최초생성
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

$(window).ready( function() {
	setTitle("공지사항");
});

</script>

<!-- BEGIN #content -->
<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
	
		<!-- BEGIN panel -->
		<div class="panel panel-inverse">
			<div class="panel-body">
				<div class="notice-view">
					<!-- BEGIN 공지사항 제목 -->
					<h3>${title }</h3>
					<!-- END 공지사항 제목 -->
					
					<hr class="bg-gray-500">
					
					<!-- BEGIN 공지사항 내용 -->
					<p>
						${content }
					</p>
					<!-- END 공지사항 내용 -->
					
					<hr class="bg-gray-500">
					<a href="#" class="btn btn-success btn-list" onclick="history.back();">목록</a>
				</div>
			</div>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
	
	<!-- BEGIN #footer -->
	<!-- END #footer -->
	
</div>
<!-- END #content -->