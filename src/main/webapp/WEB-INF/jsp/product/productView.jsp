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
	<div class="app-content-padding flex-grow-1 panel" data-scrollbar="true" data-height="100%">
		<!-- BEGIN tab-content -->
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				<!-- <div>기본 패키지 포함 사항 : 팜리조트 2인 1실, 골프 그린피 및 카트비, 식사 3식 (조식 호텔식, 중석식 연식당 한식), 호텔 관광세 </div> -->
				<!-- 기본 패키지 -->
				<table class="table table-pk">
					<colgroup>
						<col style="width:30%">
						<col style="width:35%">
						<col style="width:35%">
					</colgroup>
					
					<thead>
						<tr class="table-success">
							<th>기본 패키지</th>
							<c:choose>
								<c:when test = "${(tableLists[0].DT1 eq tableLists[0].DT2) or (empty tableLists[0].DT2)}">
									<th colspan="2">${tableLists[0].DT1}</th>
								</c:when>
								<c:otherwise>
									<th>${tableLists[0].DT1}</th>
									<th>${tableLists[0].DT2}</th>
								</c:otherwise>
							</c:choose>
						</tr>
					</thead>
					
					<tbody>
						<c:forEach items="${tableLists}" var="tableList">
							<c:set var = "hongGbnList" value = "01,02,03,04,05,06,07,28"/>
							<c:if test="${fn:contains(hongGbnList, tableList.HDNG_GBN)}">
								<tr>
									<td class="table-light">${tableList.TITLE}</td>
									<c:choose>
										<c:when test="${(tableList.CNTN1 eq tableList.CNTN2) or (empty tableList.CNTN2)}">
											<td colspan="2">${tableList.CNTN1}</td>
										</c:when>
										<c:otherwise>
											<td>${tableList.CNTN1}</td>
											<td>${tableList.CNTN2}</td>
										</c:otherwise>
									</c:choose>
								</tr>
							</c:if>
						</c:forEach>
					</tbody>
				</table>
				
				<!-- 추가사항 -->
				<table class="table table-pk">
					<colgroup>
						<col style="width:30%">
						<col style="width:35%">
						<col style="width:35%">
					</colgroup>
					
					<thead>
						<tr class="table-success">
							<th>추가사항</th>
							<c:choose>
								<c:when test = "${(tableLists[0].DT1 eq tableLists[0].DT2) or (empty tableLists[0].DT2)}">
									<th colspan="2">${tableLists[0].DT1}</th>
								</c:when>
								<c:otherwise>
									<th>${tableLists[0].DT1}</th>
									<th>${tableLists[0].DT2}</th>
								</c:otherwise>
							</c:choose>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${tableLists}" var="tableList">
							<c:set var = "hongGbnList" value = "08,09,10,11,12,13,14,15,16,17,30,31,32"/>
							<c:if test="${fn:contains(hongGbnList, tableList.HDNG_GBN)}">
								<tr>
									<td class="table-light">${tableList.TITLE}</td>
									<c:choose>
										<c:when test="${(tableList.CNTN1 eq tableList.CNTN2) or (empty tableList.CNTN2)}">
											<td colspan="2">${tableList.CNTN1}</td>
										</c:when>
										<c:otherwise>
											<td>${tableList.CNTN1}</td>
											<td>${tableList.CNTN2}</td>
										</c:otherwise>
									</c:choose>
								</tr>
							</c:if>
						</c:forEach>
					</tbody>
				</table>
				
				<!-- 미팅샌딩 -->
				<table class="table table-pk">
					<colgroup>
						<col style="width:30%">
						<col style="width:35%">
						<col style="width:35%">
					</colgroup>
					
					<thead>
						<tr class="table-success">
							<th>상품정보</th>
							<th>차량</th>
							<th>금액</th>
						</tr>
					</thead>
					
					<tbody>
						<tr>
							<c:forEach items="${tableLists}" var="tableList">
								<c:set var = "hongGbnList" value = "18,19"/>
								<c:if test="${fn:contains(hongGbnList, tableList.HDNG_GBN)}">
									<c:if test="${tableList.PROD_COND eq '0'}" >
										<tr>
											<td rowspan="4"  class="table-light">미팅샌딩</td>
											<td>스나이공항</td>
											<td>${tableList.CNTN1}</td>
										</tr>
									</c:if>
									
									<c:if test="${tableList.PROD_COND eq '4'}" >
										<tr>
											<td style="border-left:1px solid var(--bs-component-table-border-color);">싱가폴 (4인 기준)</td>
											<td>${tableList.CNTN1}</td>
										</tr>
									</c:if>
									
									<c:if test="${tableList.PROD_COND eq '3'}" >
										<tr>
											<td style="border-left:1px solid var(--bs-component-table-border-color);">싱가폴  (3인 기준)</td>
											<td>${tableList.CNTN1}</td>
										</tr>
									</c:if>
									
									<c:if test="${tableList.PROD_COND eq '2'}" >
										<tr>
											<td style="border-left:1px solid var(--bs-component-table-border-color);">싱가폴 (2인 기준)</td>
											<td>${tableList.CNTN1}</td>
										</tr>
									</c:if>
								</c:if>
							</c:forEach>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<!-- END tab-content -->
	</div>
	<!-- END content-container -->
</div>