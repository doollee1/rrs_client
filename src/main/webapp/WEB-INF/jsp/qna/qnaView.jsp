<%--
	File Name : qnaView.jsp (PalmResort > html > board_qna_view.html)
	Description : 문의사항 상세보기 페이지
	Creation : 2023.12.05 이민구
	Update
	2023.12.05 이민구 - 최초생성
	----------남은일----------
	----------남은일----------
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>

$(window).ready( function() {
	setTitle("문의사항");
	setEvent();
});

<%//페이지 이벤트 설정 %>
function setEvent(){
	
}

function goModify(){
	
	let qna_seq = '${list[0].qna_seq}';
	let title = '${list[0].title}';
	let content = '${list[0].content}';
	
	location.href="/qnaModify.do?qna_seq="+qna_seq+"&&title="+title+"&&content="+content;
}

</script>

<!-- BEGIN #content -->
<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
	
		<!-- BEGIN panel -->
		<div class="panel panel-inverse">
			<div class="panel-body">
				<div class="notice-view">
					<!-- BEGIN 제목 -->
					<h3>${list[0].title }</h3>
					<!-- END 제목 -->
					
					<hr class="bg-gray-500">
					
					<c:choose>
						<c:when test="${fn:length(list) eq 1}">
							<p>
								${list[0].content }
							</p>
						</c:when>
						<c:when test="${fn:length(list) > 1 }">
							<c:forEach var="list" items="${list}" varStatus="status">
								<c:if test="${status.index eq 0 || status.index / 2 eq 0 }">
									<!-- BEGIN 문의 내용 -->
									<p>
										${list.content }
									</p>
									<!-- END 문의 내용 -->
								</c:if>
								
								
								<c:if test="${status.index / 2 ne 0 }">
									<hr class="bg-gray-500">
									<!-- BEGIN 문의 답변-->
									<p class="qna-a">
										${list.content }
									</p>
									<!-- END 문의 답변 -->	
								</c:if>
							</c:forEach>
						</c:when>
					</c:choose>
					
					<a href="/qnaList.do" class="btn btn-success btn-list">목록</a>
				</div>
			</div>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
	
	<!-- BEGIN #footer -->
	<c:if test="${list[0].reg_id eq sessionScope.user_id && answer == false }">
		<div id="footer" class="app-footer m-0">
			<a href="/qnaDelete.do" class="btn btn-gray btn-lg">삭제</a>
			<a href="#" class="btn btn-success btn-lg" onclick="goModify();">수정</a>
		</div>
	</c:if>
	<!-- END #footer -->
	
</div>
<!-- END #content -->