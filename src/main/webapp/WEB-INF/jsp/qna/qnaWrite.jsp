<%--
	File Name : qnaWrite.jsp (PalmResort > html > board_qna_write.html)
	Description : 문의사항 작성 페이지
	Creation : 2023.12.05 이민구
	Update
	2023.12.05 이민구 - 최초생성
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

$(window).ready( function() {
	setTitle("문의사항");
});

function qnaWrite(){
	let user_id = '${sessionScope.user_id}';
	let title = $('#title').val();
	let content = $('#cont').val();
	let secret_yn = 'N';
	
	if ($('#qna_chk').is(':checked')) {
		secret_yn = 'Y';
	}

	$.ajax({
		type:"post",
		url:"/qnaWrite.do",
		dataType:'json',
		data: {	"title":title
			,	"content":content
			,	"user_id":user_id
			,   "secret_yn":secret_yn
		},
		success:function(data){
			if(data == "Y") {
				alert("문의사항 등록이 완료되었습니다.");
				location.href="/qnaList.do";
			} else {
				alert("문의사항 등록 도중 오류가 발생했습니다. 다시 시도해주세요.");
			}
		},
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
					<!-- BEGIN 비밀글 check -->
					<div class="qna_secret_chk">
						<input type="checkbox" id="qna_chk"><span>비밀글 설정</span>
					</div>
					<!-- END 비밀글 check -->
					
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