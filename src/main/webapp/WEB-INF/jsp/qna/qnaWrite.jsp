﻿<%--
	File Name : qnaWrite.jsp (PalmResort > html > board_qna_write.html)
	Description : 문의사항 작성 페이지
	Creation : 2023.12.05 이민구
	Update
	2023.12.05 이민구 - 최초생성
	----------남은일----------
	관리자에게 텔레그램 알림 전송
	----------남은일----------
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

$(window).ready( function() {
	setTitle("문의사항");
	setEvent();
});

<%//페이지 이벤트 설정 %>
function setEvent(){
	
}

function qnaWrite(){
	
	let user_id = '${sessionScope.user_id}';
	let title = $('#title').val();
	let content = $('#cont').val();
	
	$.ajax({
		type:"post",
		url:"/qnaWrite.do",
		dataType:'json',
		data: {	"title":title
			,	"content":content
			,	"user_id":user_id
		},
		success:function(data){
			if(data == "Y") {
				alert("문의사항 등록이 완료되었습니다.");
				location.href="/qnaList.do";
			} else {
				alert("문의사항 등록 도중 오류가 발생했습니다. 다시 시도해주세요.");
			}
		},
		error:function(request, status, error){
			console.log("code: " + request.status)
			console.log("message: " + request.responseText)
			console.log("error: " + error);
			console.log("통신중 오류가 발생하였습니다.");
		}
	});
	
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
					<input type="text" class="form-control" id="title" placeholder="제목을 넣어주세요"  />
					<!-- END 제목 -->
					
					<hr class="bg-gray-500">
					
					<!-- BEGIN 문의 내용 -->
					<textarea class="form-control" rows="10" id="cont" placeholder="문의사항을 남겨주세요"></textarea>
					<!-- END 문의 내용 -->
					
				</div>
			</div>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="#" class="btn btn-success btn-lg" onclick="qnaWrite();">등   록</a>
	</div>
	<!-- END #footer -->
	
</div>
<!-- END #content -->