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
		<%//예약 현황이 존재하지 않을 경우 에러 대응 20240103 이민구%>
		if(!isEmpty(data)){
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
		}
	});
}

function isEmpty(value) {
	if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){
		return true
	}else{
		return false
	}
}
</script>

<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
		<!-- BEGIN panel -->
		<div class="panel panel-inverse">
			<div class="panel-body">
				<ul class="reserve-list">
					<c:if test="${empty reservationList}">
						<li class="none">
							<a href="#"><i class="fa fa-times"></i>예약내역이 없습니다.</a>
						</li>
					</c:if>
					<c:if test="${not empty reservationList}">
						<c:forEach items="${reservationList}" var = "list">
							<fmt:parseDate var="reqDate" pattern="yyyyMMdd" value="${list.REQ_DT}"/>
							<li class="active" data-req_dt="${list.REQ_DT}" data-seq="${list.SEQ}">
								<a href="javascript:;">
									<span class="date"><fmt:formatDate value="${reqDate}" pattern="yyyy-MM-dd"/></span>
									<span>${list.PRC_STS_NM }</span>
									<span><i class="fa fa-angle-right fa-lg"></i></span>
								</a>
							</li>
						</c:forEach>
					</c:if>
				</ul>
			</div>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
</div>
