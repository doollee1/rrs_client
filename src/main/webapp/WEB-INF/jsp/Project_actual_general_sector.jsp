<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>(주)둘리정보통신</title>
<!-- Bootstrap core CSS -->
<link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="resrc/css/modern-business.css" rel="stylesheet">
<!--css-->
<link href="resrc/css/common.css" rel="stylesheet">
<!-- <link href="css/notices.css" rel="stylesheet"> -->
<!--script-->
<script src="resrc/js/includeHTML.js"></script>
<script src="resrc/vendor/jquery/jquery.js"></script>
<script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<script type="text/javascript" language="javascript">
</script>
<style>

</style>
<body>
	<div class='data-st1'>
	<form id="generalForm" name="generalForm" method="post">
		<table style="min-width: 520px">
			<!-- 기본값 원하는최소값으로 지정-->
			<colgroup>
				<col style='width: 100px' />
				<col style='width: 400px' />
				<col style='width: auto' />
				<col style='width: 170px' />
			</colgroup>
			<thead>
				<tr>
					<th>업체명</th>
					<th>주요업무</th>
					<th>개발환경</th>
					<th>구축시기</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${projectList}" var="list">
					<tr>
						<c:if test="${usrid eq 'admin'}">
						<td id="genCom"><a href="projectView?no=${list.no}"><c:out value="${list.company}"/></a></td>
						</c:if>
						<c:if test="${usrid ne 'admin'}">
						<td id="genCom"><c:out value="${list.company}"/></td>
						</c:if>
						<td id="genWork"><c:out value="${list.main_work}"/></td>
						<td><span class="basiccustomtooltip"><span class="makeshort"><c:out value="${list.utill}"/></span><span class="basiccustomtooltiptext"><c:out value="${list.utill}"/></span></span></td>
						<td><span id="genFromdt"><c:out value="${fn:substring(list.from_dt,0,4)}"/>.<c:out value="${fn:substring(list.from_dt,4,6)}"/></span> ~ <span id="genTodt"><c:out value="${fn:substring(list.to_dt,0,4)}"/>.<c:out value="${fn:substring(list.to_dt,4,6)}"/></span></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		</form>
	</div>
</body>
</html>