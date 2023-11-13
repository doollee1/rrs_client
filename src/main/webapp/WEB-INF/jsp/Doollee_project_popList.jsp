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
  <link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
  <link href="resrc/css/common.css" rel="stylesheet">
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

<div class="data-st4" style="white-space:nowrap; overflow:auto;  width:100%; height:250px;">
<!--     <form method="get" class="form-horizontal" id="listForm"> -->
	    <table id="tblList">
			<!-- 기본값 원하는최소값으로 지정-->
			<colgroup>
			    <col style="width: 10%" />
				<col style="width: auto%" />  
				<col style="width: 10%" />  
				<col style="width: 10%" />  
				<col style="width: 10%" />  
			</colgroup>
			<thead>
				<tr>
				    <th>No</th>
					<th>프로젝트</th>
					<th>시작일</th>
					<th>종료일</th>
					<th>프로젝트PL</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${projectList}" var="projectList" varStatus="status">
				<tr ondblclick="selectProject('${projectList.no}', '${projectList.main_work}')">
				    <td class="tbl_text"><c:out value="${projectList.no}"/></td>
				    <td class="tbl_select"><c:out value="${projectList.main_work}"/></td>
				    <td class="tbl_text date"><c:out value="${projectList.from_dt}"/></td>
				    <td class="tbl_text date"><c:out value="${projectList.to_dt}"/></td>
				    
<%-- 				    <td class="tbl_text"><c:out value="${fn:substring(projectList.from_dt,0,4)}"/>.<c:out value="${fn:substring(projectList.from_dt,4,6)}"/>.<c:out value="${fn:substring(projectList.from_dt,6,8)}"/></td> --%>
<%-- 				    <td class="tbl_text"><c:out value="${fn:substring(projectList.to_dt,0,4)}"/>.<c:out value="${fn:substring(projectList.to_dt,4,6)}"/>.<c:out value="${fn:substring(projectList.to_dt,6,8)}"/></td> --%>
					<td class="tbl_text"><c:out value="${projectList.project_pl}"/></td>
			    </tr> 
			</c:forEach>
			</tbody>
		</table>
<!--     </form> -->
</div>