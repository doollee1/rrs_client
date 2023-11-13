<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">

<head>
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<title>(주)둘리정보통신</title>
<!-- Bootstrap core CSS -->
<link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
<!-- Custom styles for this template -->
<!-- <link href="css/modern-business.css" rel="stylesheet"> -->
<!--css-->
<link href="resrc/css/common.css" rel="stylesheet">
<!-- <link href="css/Business_consulting.css" rel="stylesheet"> -->
<!--script-->
<script src="resrc/js/includeHTML.js"></script>
<script src="resrc/vendor/jquery/jquery.js"></script>
<script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>
<body>
	<div class='data-st1'>
		<table style="min-width: 520px">
			<!-- 기본값 원하는최소값으로 지정-->
			<colgroup>
				<col style='width: 30%' />
				<col style='width: 70%' />
			</colgroup>
			<thead>
				<tr>
					<th>업체명</th>
					<th>주요업무</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${listMainten}" var="listMainten">
				<tr>
					<td><c:out value="${listMainten.company}"/></td>
					<td><c:out value="${listMainten.main_work}"/></td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>