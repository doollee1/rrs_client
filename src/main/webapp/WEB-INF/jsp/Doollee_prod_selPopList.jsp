<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<head>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <title>(주)둘리정보통신</title>
  <!-- Bootstrap core CSS -->
  <link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
  <!-- Custom styles for this template -->
  <!-- <link href="css/modern-business.css" rel="stylesheet"> -->
  <!--css-->
  <link href="resrc/css/common.css" rel="stylesheet">
  <!-- <link href="css/Project_actual.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>

<div class="data-top" style="margin-top: 20px">
  <div class="left">
    <p class="tit-type3">조회결과 </p>  <!-- <span class="c-org">(*필수입력)</span> -->
  </div>
</div>

<div class="data-st4" >
    <form method="get" class="form-horizontal" id="listForm">
	    <table style="min-width: 1000px; overflow:auto;"   id="tblList">
			<colgroup>
			    <col style="width: 5%" />
				<col style="width: 10%" />  <!-- 장비번호 -->
				<col style="width: 6%" />  <!-- 제품구분 -->
				<col style="width: 6%" />  <!-- 제조사   -->
				<col style="width: 6%" /><!-- 모델명   -->
				<col style="width: 8%" />  <!-- S/N      -->
<%-- 				<col style="width: 8%" />  <!-- SIZE     --> --%>
<%-- 				<col style="width: 8%" />  <!-- CPU      --> --%>
<%-- 				<col style="width: 8%" />  <!-- HDD      --> --%>
<%-- 				<col style="width: 8%" />  <!-- RAM      --> --%>
				<col style="width: 6%" />  <!-- 장비상태 -->
				<col style="width: 8%" />  <!-- 제조년월 -->
				<col style="width: 10%" />  <!-- 구입일자 -->
				<col style="width: 10%" />  <!-- 폐기일자 -->
			</colgroup>
			<thead>
				<tr>
				    <th>No</th>
					<th>장비번호</th>
					<th>제품구분</th>
					<th>제조사</th>
					<th>모델명</th>
					<th>S/N</th>
<!-- 					<th>SIZE</th> -->
<!-- 					<th>CPU</th> -->
<!-- 					<th>HDD</th> -->
<!-- 					<th>RAM</th> -->
					<th>장비상태</th>
					<th>제조년월</th>
					<th>구입일자</th>
					<th>폐기일자</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${prodList}" var="prodList" varStatus="status">
				<tr ondblclick="selectProd(${prodList.prod_no})">
				    <td><c:out value="${status.count }"/></td>
				    <td><c:out value="${prodList.prod_no}"/></td>
				    <td><c:out value="${prodList.prod_gbn}"/></td>
					<td><c:out value="${prodList.prod_comp}"/></td>
				    <td><c:out value="${prodList.model_nm}"/></td>
					<td><c:out value="${prodList.serial_no}"/></td>
<%-- 				    <td><c:out value="${prodList.size_expl}"/></td> --%>
<%-- 				    <td><c:out value="${prodList.cpu_expl}"/></td> --%>
<%-- 				    <td><c:out value="${prodList.hdd_exp}"/></td> --%>
<%-- 				    <td><c:out value="${prodList.ram_expl}"/></td> --%>
				    <td><c:out value="${prodList.prod_sts_nm}"/></td>
				    <td><c:out value="${prodList.prod_ym}"/></td>
				    <td><c:out value="${prodList.buy_dt}"/></td>
				    <td><c:out value="${prodList.disuse_dt}"/></td>
			    </tr> 
			</c:forEach>
			</tbody>
		</table>
    </form>
</div>