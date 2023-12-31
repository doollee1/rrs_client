﻿<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="PalmResort/assets/plugins/jquery-sticky-header-footer.js"></script>
<script>
var arr;
$(document).ready(function() {
	setTitle("상품소개");
	$("table").stickyHeaderFooter();
});
</script>

<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1" data-scrollbar="true" data-height="100%">
		<!-- BEGIN tab-content -->
		<div class="tab-content panel rounded-0 p-3 m-0">
			<c:set var="clazz" value=""/>
			<c:if test="${ssnGbn eq '1'}">
				<c:set var="clazz" value="table-success"/>
			</c:if>
			<c:if test="${ssnGbn eq '2'}">
				<c:set var="clazz" value="table-warning"/>
			</c:if>
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				<%-- forEach tableLists Start --%>
				<c:forEach items="${tableLists}" var="tableList" varStatus="status">
					<c:set var="headerSize" />
						<c:choose>
							<c:when test="${(not empty tableLists[status.index][0].DT1) and (empty tableLists[status.index][0].DT2) and (empty tableLists[status.index][0].DT3)}">
								<c:set var="headerSize" value="1"/>
							</c:when>
							<c:when test="${(not empty tableLists[status.index][0].DT1) and (not empty tableLists[status.index][0].DT2) and (empty tableLists[status.index][0].DT3)}">
								<c:set var="headerSize" value="2"/>
							</c:when>
							<c:otherwise>
								<c:set var="headerSize" value="3"/>
							</c:otherwise>
						</c:choose>

						<table class="table table-pk">
						<colgroup>
							<col style="width:50%">
							<col style="width:50%">
						</colgroup>
						<thead>
							<c:choose>
								<c:when test="${headerSize eq 1}">
									<tr class="${clazz}">
										<th colspan="2"><span>${tableLists[status.index][0].DT1}</span></th>
									</tr>
								</c:when>
								<c:when test="${headerSize eq 2}">
									<tr class="${clazz}">
										<th><span>${tableLists[status.index][0].DT1}</span></th>
										<th><span>${tableLists[status.index][0].DT2}</span></th>
									</tr>
								</c:when>
								<c:otherwise>
									<tr class="${clazz}">
										<th><span>${tableLists[status.index][0].DT1}</span></th>
										<th rowspan="2"><span>${tableLists[status.index][0].DT3}</span></th>
									</tr>
									<tr class="${clazz}">
										<th><span>${tableLists[status.index][0].DT2}</span></th>
									</tr>								
								</c:otherwise>
							</c:choose>
						</thead>
						<tbody>
							<tr class="${clazz}">
							<%-- forEach tableList Start --%>
							<c:forEach items="${tableList}" var = "list">
								<tr>
									<td colspan="2"><span>${fn:replace(list.TITLE, '\\n', '</br>')}</span></td>
								</tr>
								<c:choose>
									<c:when test="${(headerSize eq 1) or ((list.CNTN1 eq list.CNTN2) and (list.CNTN1 eq list.CNTN3))}">
										<tr class="bg">
											<td colspan="2"><span>${fn:replace(list.CNTN1, '\\n', '</br>')}</span></td>
										</tr>
									</c:when>
									<c:when test="${(headerSize eq 2) and ((list.CNTN1 eq list.CNTN2))}">
										<tr class="bg">
											<td colspan="2"><span>${fn:replace(list.CNTN1, '\\n', '</br>')}</span></td>
										</tr>
									</c:when>
									<c:when test="${(headerSize eq 2) or (list.CNTN1 eq list.CNTN2)}">
										<tr class="bg">
											<c:if test = "${headerSize eq 2}">
												<td><span>${fn:replace(list.CNTN1, '\\n', '</br>')}</span></td>
												<td><span>${fn:replace(list.CNTN2, '\\n', '</br>')}</span></td>
											</c:if>
											<c:if test="${(headerSize ne 2) and (list.CNTN1 eq list.CNTN2)}">
												<td><span>${fn:replace(list.CNTN1, '\\n', '</br>')}</span></td>
												<td><span>${fn:replace(list.CNTN3, '\\n', '</br>')}</span></td>
											</c:if>
										</tr>
									</c:when>
									<c:otherwise>
										<tr class="bg">
											<td><span>${fn:replace(list.CNTN1, '\\n', '</br>')}</span></td>
											<td rowspan="2"><span>${fn:replace(list.CNTN3, '\\n', '</br>')}</span></td>
										</tr>
										<tr class="bg">
											<td><span>${fn:replace(list.CNTN2, '\\n', '</br>')}</span></td>
										</tr>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<%-- forEach tableList End --%>
						</tbody>
					</table>
				</c:forEach>
				<%-- forEach tableLists End --%>
			</div>
			<!-- END tab-pane -->
		</div>
		<!-- END tab-content -->
	</div>
	<!-- END content-container -->
</div>