<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
$(document).ready(function() {
	setTitle("예약현황");
	setEvent();
});

function setEvent() {
	$(".reserve-list > li").on("click", function() {
		var form = document.createElement("form");
		var data = $(this).data();
		for(key in data) {
			var inputData = document.createElement("input");
			inputData.setAttribute("type" , "hidden" );
			inputData.setAttribute("name" , key      );
			inputData.setAttribute("value", data[key]);
			form.appendChild(inputData);
		}
		form.setAttribute("method", "POST");
		form.setAttribute("action", "reservationDetail.do");
		document.body.appendChild(form);
		form.submit();
	});
}
</script>

<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
		<!-- BEGIN panel -->
		<div class="panel panel-inverse">
			<div class="panel-body">
				<ul class="reserve-list">
					<c:forEach items="${reservationList}" var = "list">
						<fmt:parseDate var="reqDate" pattern="yyyyMMdd" value="${list.REQ_DT}"/>
						<li class="active" data-req_dt="${list.REQ_DT}" data-seq=${list.SEQ}>
							<a href="javascript:;">
								<span class="date"><fmt:formatDate value="${reqDate}" pattern="yyyy-MM-dd"/></span>
								<span>${list.PRC_STS_NM }</span>
								<span><i class="fa fa-angle-right fa-lg"></i></span>
							</a>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
</div>
