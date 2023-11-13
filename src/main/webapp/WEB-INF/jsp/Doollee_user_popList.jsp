<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<div class="data-top" style="margin-top: 20px">
  <div class="left">
    <p class="tit-type3">조회결과 </p>  <!-- <span class="c-org">(*필수입력)</span> -->
  </div>
</div>

<div class="data-st3" style="white-space:nowrap; overflow:auto;  width:100%; height:300px;">
<!--     <form method="get" class="form-horizontal" id="listForm"> -->
	    <table id="tblList">
			<!-- 기본값 원하는최소값으로 지정-->
			<colgroup>
			    <col style="width: 5%"/ >
				<col style="width: 10%" />  
				<col style="width: 10%" />  
				<col style="width: 10%" />  
				<col style="width: 10%" />  
				<col style="width: 10%" />  
				<col style="width: 10%" />
			</colgroup>
			<thead>
				<tr>
				    <th>No</th>
					<th>사용자ID</th>
					<th>사용자명</th>
					<th>재직구분</th>
					<th>생년월일</th>
<!-- 					<th>E-mail</th> -->
					<th>H.P</th>
<!-- 					<th>주소</th> -->
					<th>입사일</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${usrList}" var="usrList" varStatus="status">

				<tr ondblclick="selectUser('${usrList.mb_id}','${usrList.mb_name}')">

				    <td class="tbl_text"><c:out value="${status.count }"/></td>
				    <td class="tbl_text"><c:out value="${usrList.mb_id}"/></td>
				    <td class="tbl_text"><c:out value="${usrList.mb_name}"/></td>
					<td class="tbl_text"><c:out value="${usrList.mb_sts}"/></td>
				    <td class="tbl_text">
				        <c:if test="${not empty usrList.mb_birth}">
					        <c:out value="${fn:substring(usrList.mb_birth,0,4)}"/>-<c:out value="${fn:substring(usrList.mb_birth,4,6)}"/>-<c:out value="${fn:substring(usrList.mb_birth,6,8)}"/>
					    </c:if>
				    </td>
					<td class="tbl_text"><c:out value="${usrList.mb_hp}"/></td>
					<td class="tbl_text">
					    <c:if test="${not empty usrList.mb_join_date}">
					        <c:out value="${fn:substring(usrList.mb_join_date,0,4)}"/>-<c:out value="${fn:substring(usrList.mb_join_date,4,6)}"/>-<c:out value="${fn:substring(usrList.mb_join_date,6,8)}"/>
					    </c:if>
					</td>
					
			    </tr> 
			</c:forEach>
			</tbody>
		</table>
<!--     </form> -->
</div>