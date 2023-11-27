<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="java.security.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script>
var arr;
$(document).ready(function() {
	setTitle("상품소개");
});
</script>

<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
							
		<!-- BEGIN nav-tabs -->
		<ul class="nav nav-tabs">
			<li class="nav-item">
				<a href="#default-tab-1" data-bs-toggle="tab" class="nav-link active">
					<span class="d-sm-none">시즌</span>
				</a>
			</li>
			<li class="nav-item">
				<a href="#default-tab-2" data-bs-toggle="tab" class="nav-link">
					<span class="d-sm-none">비시즌</span>
				</a>
			</li>
		</ul>
		<!-- END nav-tabs -->
		<!-- BEGIN tab-content -->
		<div class="tab-content panel rounded-0 p-3 m-0">
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				<%-- forEach tableLists Start --%>
				<c:forEach items="${tableLists}" var="tableList" varStatus="status">
					<%-- 
					<c:out value="${status.current} 111"></c:out>
					<c:out value="${status.index}"></c:out>
					<c:out value="${tableLists[status.index]}"/>
					--%>
					<c:set var="headerSize" />
						<c:choose>
							<c:when test="${(tableLists[status.index][0].DT1 eq tableLists[status.index][0].DT2) and (tableLists[status.index][0].DT1 eq tableLists[status.index][0].DT3)}">
								<c:set var="headerSize" value="1"/>
							</c:when>
							<c:when test="${   ((tableLists[status.index][0].DT1 eq tableLists[status.index][0].DT2) ne tableLists[status.index][0].DT3)
											or ((tableLists[status.index][0].DT2 eq tableLists[status.index][0].DT3) ne tableLists[status.index][0].DT1)}">
								<c:set var="headerSize" value="2"/>
							</c:when>
							<c:otherwise>
								<c:set var="headerSize" value="3"/>
							</c:otherwise>
						</c:choose>
						<%-- <c:out value="${headerSize}"></c:out> --%>

						<table class="table table-pk">
						<colgroup>
							<col style="width:50%">
							<col style="width:50%">
						</colgroup>
						<thead>
							<c:choose>
								<c:when test="${headerSize eq 1}">
									<tr class="table-success">
										<th colspan="2"><span>${tableLists[status.index][0].DT1}</span></th>
									</tr>
								</c:when>
								<c:when test="${headerSize eq 2}">
									<tr class="table-success">
										<th><span>${tableLists[status.index][0].DT1}</span></th>
										<th><span>${tableLists[status.index][0].DT3}</span></th>
									</tr>
								</c:when>
								<c:otherwise>
									<tr class="table-success">
										<th><span>${tableLists[status.index][0].DT1}</span></th>
										<th rowspan="2"><span>${tableLists[status.index][0].DT3}</span></th>
									</tr>
									<tr class="table-success">
										<th><span>${tableLists[status.index][0].DT2}</span></th>
									</tr>								
								</c:otherwise>
							</c:choose>
						</thead>
						<tbody>
							<tr class="table-success">
							<%-- forEach tableList Start --%>
							<c:forEach items="${tableList}" var = "list">
								<tr>
									<td colspan="2"><span>${fn:replace(list.TITLE, '\\n', '</br>')}</span></td>
								</tr>
								<c:choose>
									<c:when test="${(list.CNTN1 eq list.CNTN2) and (list.CNTN1 eq list.CNTN3)}">
										<tr class="bg">
											<td colspan="2"><span>${fn:replace(list.CNTN1, '\\n', '</br>')}</span></td>
										</tr>
									</c:when>
									<c:when test="${(list.CNTN1 eq list.CNTN2) and (list.CNTN1 ne list.CNTN3)}">
										<tr class="bg">
											<td><span>${fn:replace(list.CNTN1, '\\n', '</br>')}</span></td>
											<td><span>${fn:replace(list.CNTN3, '\\n', '</br>')}</span></td>
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
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-2">
				<%-- forEach tableLists2 Start --%>
				<c:forEach items="${tableLists2}" var="tableList" varStatus="status">
					<c:set var="headerSize" />
						<c:choose>
							<c:when test="${(tableLists2[status.index][0].DT1 eq tableLists2[status.index][0].DT2) and (tableLists2[status.index][0].DT1 eq tableLists2[status.index][0].DT3)}">
								<c:set var="headerSize" value="1"/>
							</c:when>
							<c:when test="${   ((tableLists2[status.index][0].DT1 eq tableLists2[status.index][0].DT2) ne tableLists2[status.index][0].DT3)
											or ((tableLists2[status.index][0].DT2 eq tableLists2[status.index][0].DT3) ne tableLists2[status.index][0].DT1)}">
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
									<tr class="table-warning">
										<th colspan="2"><span>${tableLists2[status.index][0].DT1}</span></th>
									</tr>
								</c:when>
								<c:when test="${headerSize eq 2}">
									<tr class="table-warning">
										<th><span>${tableLists2[status.index][0].DT1}</span></th>
										<th><span>${tableLists2[status.index][0].DT3}</span></th>
									</tr>
								</c:when>
								<c:otherwise>
									<tr class="table-warning">
										<th><span>${tableLists2[status.index][0].DT1}</span></th>
										<th rowspan="2"><span>${tableLists2[status.index][0].DT3}</span></th>
									</tr>
									<tr class="table-warning">
										<th><span>${tableLists2[status.index][0].DT2}</span></th>
									</tr>								
								</c:otherwise>
							</c:choose>
						</thead>
						<tbody>
							<tr class="table-warning">
							<%-- forEach tableList Start --%>
							<c:forEach items="${tableList}" var = "list">
								<tr>
									<td colspan="2"><span>${fn:replace(list.TITLE, '\\n', '</br>')}</span></td>
								</tr>
								<c:choose>
									<c:when test="${(list.CNTN1 eq list.CNTN2) and (list.CNTN1 eq list.CNTN3)}">
										<tr class="bg">
											<td colspan="2"><span>${fn:replace(list.CNTN1, '\\n', '</br>')}</span></td>
										</tr>
									</c:when>
									<c:when test="${(list.CNTN1 eq list.CNTN2) and (list.CNTN1 ne list.CNTN3)}">
										<tr class="bg">
											<td><span>${fn:replace(list.CNTN1, '\\n', '</br>')}</span></td>
											<td><span>${fn:replace(list.CNTN3, '\\n', '</br>')}</span></td>
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
				<%-- forEach tableLists2 End --%>
			</div>
			<!-- END tab-pane -->
		</div>
		<!-- END tab-content -->
	</div>
	<!-- END content-container -->
</div>