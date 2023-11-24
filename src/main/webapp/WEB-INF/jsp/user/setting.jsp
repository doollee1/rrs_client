<%--
	File Name : setting.jsp (PalmResort > html > setting.html)
	Description : 회원가입 페이지
	Creation : 이민구
	Update
	2023.11.24 이민구 - 최초생성
--%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

$(window).ready( function() {
	setTitle("설정");
});

</script>

<!-- BEGIN #content -->
<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
	
		<!-- BEGIN panel -->
		<div class="panel panel-inverse">
			<div class="panel-body">
				<ul class="reserve-list">
					<li class="active">
						<a href="/policy.do">
							<span>개인정보처리방침</span>
							<span><i class="fa fa-angle-right fa-lg"></i></span>
						</a>
					</li>
					<li class="active">
						<a href="/infoChange.do">
							<span>개인정보 변경</span>
							<span><i class="fa fa-angle-right fa-lg"></i></span>
						</a>
					</li>
					<li class="active">
						<a href="/memberOut">
							<span>회원탈퇴</span>
							<span><i class="fa fa-angle-right fa-lg"></i></span>
						</a>
					</li>
				</ul>
			</div>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
</div>
