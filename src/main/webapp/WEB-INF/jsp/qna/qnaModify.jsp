<%--
	File Name : qnaModify.jsp (PalmResort > html > board_qna_modify.html)
	Description : 문의사항 수정 페이지
	Creation : 2023.12.05 이민구
	Update
	2023.12.05 이민구 - 최초생성
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
	<%//기존의 작성되었던 내용 추가%>
	
	let qna_seq = '${qna_seq}';
	let title = '${title}';
	let content = '${content}';
	
	$('#qna_seq').val(qna_seq);
	$('#title').val(title);
	$('#cont').val(content);
	
}

<%//문의사항 수정%>
function modQna(){
	
	let qna_seq = $('#qna_seq').val();
	let title = $('#title').val();
	let content = $('#cont').val();
	let user_id = '${sessionScope.user_id}';
	
	$.ajax({
		type:"post",
		url:"/qnaModify.do",
		dataType:'json',
		data: {	"qna_seq":qna_seq
			,	"title":title
			,	"content":content
			,	"user_id":user_id
			,	"reg_sts":"1"
		},
		success:function(data){
			if(data == "Y") {
				alert("문의사항 수정이 완료되었습니다.");
				location.href="/qnaView.do?qna_seq="+qna_seq;
			} else {
				alert("문의사항 수정 도중 오류가 발생했습니다. 다시 시도해주세요.");
			}
		}
	});

}

<%//문의사항 수정 취소%>
function cancle(){
	let qna_seq = $('#qna_seq').val();
	location.href="/qnaView.do?qna_seq="+qna_seq;
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
					<input type="hidden" id="qna_seq" name="qna_seq"/>
					<!-- BEGIN 제목 -->
					<input type="text" class="form-control" id="title" placeholder="제목을 넣어주세요"/>
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
		<a href="#" class="btn btn-gray btn-lg" onclick="cancle();">취소</a>
		<a href="#" class="btn btn-success btn-lg" onclick="modQna();">수정</a>
	</div>
	<!-- END #footer -->
	
</div>
<!-- END #content -->