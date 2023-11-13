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
<div class="data-st4">
    <form class="form-horizontal" id="listForm">
	    <table style="min-width: 1200px; overflow: auto;" id="tblList">
			<!-- 기본값 원하는최소값으로 지정-->
			<colgroup>
				<col style="width: 10%" /> 
				<col style="width: 6%" /> 
				<col style="width: 10%" />  
				<col style="width: 8%" />  
				<col style="width: 6%" />  
				<col style="width: 15%" />  
				<col style="width: 8%" />  
				<col style="width: 6%" />
				<col style="width: 15%" />
				<col style="width: 10%" />
				<col style="width: 8%" />
			</colgroup>
			<thead>
				<tr>
					<th>장비번호</th>
					<th>장비구분</th>
					<th>인수/인계</th>
					<th>인계일자</th>
					<th>인계자</th>
					<th>인계프로젝트</th>
					<th>인수일자</th>
					<th>인수자</th>
					<th>인수프로젝트</th>
					<th>인수장소</th>
					<th>인수상태</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${transList}" var="transList">
				<tr>
				    <td class="tbl_text"><c:out value="${transList.prod_no}"/></td>
					<td style="display:none;"><c:out value="${transList.SEQ}"/></td>
					<td class="tbl_text"><c:out value="${transList.prod_gbn}"/></td>
				    <td class="tbl_text"><c:out value="${transList.trans_gbn}"/></td>
				    <td class="tbl_text"><c:out value="${fn:substring(transList.trans_dt,0,4)}"/>-<c:out value="${fn:substring(transList.trans_dt,4,6)}"/>-<c:out value="${fn:substring(transList.trans_dt,6,8)}"/></td>
				    <td class="tbl_text"><c:out value="${transList.trans_user_nm}"/></td>
				    <td class="tbl_text"><c:out value="${transList.trans_project_nm}"/></td>
				    <td class="tbl_text">
				    <c:if test="${transList.take_dt ne '' }" >
				    	<c:out value="${fn:substring(transList.take_dt,0,4)}"/>-<c:out value="${fn:substring(transList.take_dt,4,6)}"/>-<c:out value="${fn:substring(transList.take_dt,6,8)}"/>
				    </c:if>
				    </td>
				    <td class="tbl_text"><c:out value="${transList.take_user_nm}"/></td>
				    <td class="tbl_text"><c:out value="${transList.take_project_nm}"/></td>
				    <td class="tbl_text"><c:out value="${transList.take_place}"/></td>
				    <td class="tbl_text"><c:out value="${transList.take_sts}"/></td>
				    <td style="display:none;"><c:out value="${transList.trans_project}"/></td>
				    <td style="display:none;"><c:out value="${transList.take_project}"/></td>
				    <td style="display:none;"><c:out value="${transList.trans_user_id}"/></td>
				    <td style="display:none;"><c:out value="${transList.take_user_id}"/></td>
				    <td style="display:none;"><c:out value="${transList.remark}"/></td>
			    </tr> 
			</c:forEach>
			</tbody>
		</table>
    </form>
</div>