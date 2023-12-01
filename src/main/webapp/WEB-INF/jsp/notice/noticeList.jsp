<%--
	File Name : noticeList.jsp - (PalmResort > html > board_notice_list.html)
	Description : 공지사항 페이지
	Creation : 2023.11.29 이민구
	Update
	2023.11.29 이민구 - 최초생성
	----------남은일----------
	스크롤시 10건씩 추가로 불러오는 기능
	----------남은일----------
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

$(window).ready( function() {
	setTitle("공지사항");
	setEvent();
});

<%//페이지 이벤트 설정 %>
function setEvent(){
	
}

<%//공지사항 상세보기%>
function goDetail(notice_seq){
	location.href="/noticeView.do?notice_seq="+notice_seq
}

</script>

<!-- BEGIN #content -->
<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
	
		<!-- BEGIN panel -->
		<div class="panel panel-inverse">
			<div class="panel-body">
				<table class="table table-hover table-board">
					<colgroup>
						<col style="width:90px">
						<col style="width:">
					</colgroup>
					<tbody>
						<c:forEach var="list" items="${list}">
							<tr onclick="goDetail('${list.notice_seq}')">
								<td class="date"><span>${list.st_dt }</span></td>
								<td><span>${list.title }</span></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
</div>