<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
	<c:if test="${sessionScope.loginYn eq 'Y' && sessionScope.usrlvl eq '0'}">
	
	<script>
		function del(value){
			
			confirm("삭제하시겠습니까?\n삭제하시면 복구되지 않습니다.");

			$.ajax({
				type:"POST",
				url:"projectDelete.do",
				data:{no : value,
					 },
				dataType:"json",
				success:function(data){
					if(data == 'Y'){
						alert("정상 삭제 되었습니다.");
						location.href="Project_actual.do";
					}else{
						alert("삭제 중 오류가 발생하였습니다.");
					}
				},
				error:function(data){
					console.log("통신중 오류가 발생하였습니다.");
				}
			});
			
		}
		
	</script>
	</c:if>
		<table style="min-width: 800px">
			<!-- 기본값 원하는최소값으로 지정-->
			<colgroup>
				<col style="width: 10%" />
				<col style='width: 15%' />
				<col style='width: 35%' />
				<col style='width: 20%' />
				<col style='width: 20%' />
			</colgroup>
			<thead>
				<tr>
					<th>구분</th>
					<th>업체명</th>
					<th>주요업무</th>
					<th>개발환경</th>
					<th>구축시기</th>
				<c:if test="${sessionScope.loginYn eq 'Y' && sessionScope.usrlvl eq '0'} }">
					<th></th>					
				</c:if>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${listTotal}" var="listTotal">
				<tr>
				<c:if test="${listTotal.gubun eq '1' }">
				<td>공공</td>
				</c:if>
				<c:if test="${listTotal.gubun eq '2' }">
				<td>일반</td>
				</c:if>
				<c:if test="${listTotal.gubun eq '3' }">
				<td>납품</td>
				</c:if>
					<td><c:out value="${listTotal.company}"/></td>
					<td><c:out value="${listTotal.main_work}"/></td>
					<td><span class="basiccustomtooltip"><span class="makeshort"><c:out value="${listTotal.utill}"/></span><span class="basiccustomtooltiptext"><c:out value="${listTotal.utill}"/></span></span></td>
					<c:if test="${fn:length(listTotal.from_dt) > 1 }">
					<td><c:out value="${fn:substring(listTotal.from_dt,0,4)}"/>.<c:out value="${fn:substring(listTotal.from_dt,4,6)}"/>~<c:out value="${fn:substring(listTotal.to_dt,0,4)}"/>.<c:out value="${fn:substring(listTotal.to_dt,4,6)}"/><td>
					</c:if>
					<c:if test="${fn:length(listTotal.from_dt) <= 1 }">
					<td><td>
					</c:if>
					<c:if test="${sessionScope.loginYn eq 'Y' && sessionScope.usrlvl eq '0'}">
						<td><input class="btn-type2 type1 min-size1"
							type="button" value="삭제" onclick="del(${listTotal.no})" ></td>					
					</c:if>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>