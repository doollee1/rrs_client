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
<div class="data-st4">
    <form class="form-horizontal" id="listForm">
	    <table style="min-width: 900px; overflow: auto;" id="tblList">
			<!-- 기본값 원하는최소값으로 지정-->
			<colgroup>
				<!-- <col style="width: 0%" />  -->  <!-- 장비번호      -->
				<col style="width: 10%" /> <!-- 일련번호 -->
				<col style="width: 10%" />  <!-- 수리구분 -->
				<col style="width: 15%" />  <!-- 수리처   -->
				<col style="width: 15%" />  <!-- 수리요청일자   -->
				<col style="width: 15%" />  <!-- 수리완료일자      -->
				<col style="width: 15%" />  <!-- 수리비용     -->
				<col style="width: 20%" />  <!-- 수리내용      -->
				<!-- <col style="width: 0%" />  -->  <!-- 비고      -->
			</colgroup>
			<thead>
				<tr>
					<th style="display: none"></th>
					<th>일련번호</th>
					<th>수리구분</th>
					<th>수리처</th>
					<th>수리요청일자</th>
					<th>수리완료일자</th>
					<th>수리비용</th>
					<th>수리내용</th>
					<th style="display: none"></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${repairList}" var="repairList">
				<tr>
					<td style="display: none"><c:out value="${repairList.prod_no}"/></td>
				    <td><c:out value="${repairList.SEQ}"/></td>
				    <td><c:out value="${repairList.simp_cnm}"/></td>
					<td><c:out value="${repairList.repair_comp}"/></td>
				    <td><c:out value="${repairList.repair_st_dt}"/></td>
					<td><c:out value="${repairList.repair_ed_dt}"/></td>
				    <td><c:out value="${repairList.repair_fee}"/></td>
				    <td><c:out value="${repairList.repair_expl}"/></td>
				    <td style="display: none"><c:out value="${repairList.remark}"/></td>
			    </tr> 
			</c:forEach>
			</tbody>
		</table>
    </form>
</div>