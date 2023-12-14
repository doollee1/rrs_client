<%--
	File Name : qnaList.jsp - (PalmResort > html > board_qna_list.html)
	Description : 문의사항 리스트 페이지
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

var page = 2;
var myListLoad = false;

<%//페이지 이벤트 설정 %>
function setEvent(){
	scrollEvent();
}

/**
 * 문자열이 빈 문자열인지 체크하여 결과값을 리턴한다. 
 * @param str	: 체크할 문자열
 */
function isEmpty(str){
	if(typeof str == "undefined" || str == null || str == "")
		return true;
	else
		return false ;
}

<%//문의사항 상세보기%>
function goDetail(qna_seq){
	location.href="/qnaView.do?qna_seq="+qna_seq;
}

<%//내 문의내역 보기%>
function myQnaList(){
	<%//이미 불러온 내역이 있으면 탭을 클릭해도 .ajax를 실행하지 않고 return %>
	if(myListLoad) {
		return;
	}
	
	let user_id = '${sessionScope.user_id}';
	
	$.ajax({
		type:"post",
		url:"/myQnaList.do",
		data: { "user_id":user_id },
		dataType:'json',
	}).done(function(data){
		myListLoad = true;
		let html = "";
		if(isEmpty(data)) {
			alert('문의하신 내역이 없습니다.');
			location.href="/qnaList.do";
		} else {
			for(let i = 0; i < data.length; i++) {
				html+= '<tr onclick="goDetail('+data[i].qna_seq+')">';
				html+= '	<td class="date"><span>'+data[i].reg_dt+'</span></td>';
				html+= '	<td>';
				if(data[i].reg_sts == 1) {
					html+= '	<span class="qna-label apply">접수</span>';
				} else if(data[i].reg_sts == 2) {
					html+= '	<span class="qna-label finish">완료</span>';
				}
				html+= '	</td>';
				html+= '	<td><span>'+data[i].title+'</span></td>';
				html+= '</tr>';
			}
		}
		$('#default-tab-2 tbody').last().append(html);
	});
}

<%//무한 스크롤%>
function scrollEvent(){
	const eol = document.querySelector('#eol'); <%//관찰할 대상(요소)%>
	const options = {
		root: null,
		rootMargin: '0px 0px 0px 0px',
		threshold: 0,
	};
	const onIntersect = (entries, observer) => {
		entries.forEach(async (entry) => {
			if (entry.isIntersecting && page <= '${endPage}') {
				await nextPage();
			}
		});
	};
	const observer = new IntersectionObserver(onIntersect, options); <%//관찰자 초기화%>
	observer.observe(eol); <%//관찰할 대상(요소) 등록%>
}

<%//다음 페이지 로딩 %>
function nextPage(){
	$.ajax({
		type:"post",
		url:"/qnaListNextPage.do",
		data:
		{ "page":page
		},
		dataType:"json",
	}).done(function(data){
		page++;
		let html = "";
		for(var i = 0; i < data.length; i++) {
			html+= '<tr onclick="goDetail('+data[i].qna_seq+')">';
			html+= '	<td class="date"><span>'+data[i].reg_dt+'</span></td>';
			html+= '	<td>';
			if(data[i].reg_sts == "1") {
				html+= '	<span class="qna-label apply">접수</span>';
			} else if(data[i].reg_sts == "2") {
				html+= '	<span class="qna-label finish">완료</span>';
			}
			html+= '	</td>';
			html+= '	<td><span>'+data[i].title +'</span></td>';
			html+= '</tr>';
		}
		$('#default-tab-1 tbody').last().append(html);
	});
}

</script>

<!-- BEGIN #content -->
<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
		
		<!-- BEGIN write btn -->
		<a href="/qnaWrite.do" class="btn btn-success btn-icon btn-lg btn-write"><i class="fas fa-plus"></i></a>
		<!-- END write btn -->
		
		<!-- BEGIN nav-tabs -->
		<ul class="nav nav-tabs">
			<li class="nav-item">
				<a href="#default-tab-1" data-bs-toggle="tab" class="nav-link active">
					<span class="d-sm-none">전체</span>
				</a>
			</li>
			<li class="nav-item" onclick="myQnaList()">
				<a href="#default-tab-2" data-bs-toggle="tab" class="nav-link">
					<span class="d-sm-none">MY</span>
				</a>
			</li>
		</ul>
		<!-- END nav-tabs -->
		<!-- BEGIN tab-content -->
		<div class="tab-content panel rounded-0 p-3 m-0">
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				<table class="table table-hover table-board">
					<colgroup>
						<col style="width:80px">
						<col style="width:50px">
						<col style="width:">
					</colgroup>
					<tbody>
						<c:forEach var="list" items="${list}">
							<tr onclick="goDetail('${list.qna_seq}')">
								<td class="date"><span>${list.reg_dt}</span></td>
								<td>
									<c:choose>
										<c:when test="${list.reg_sts eq '1'}"><span class="qna-label apply">접수</span></c:when>
										<c:when test="${list.reg_sts eq '2'}"><span class="qna-label finish">완료</span></c:when>
									</c:choose>
								</td>
								<td><span>${list.title }</span></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<div id="eol"></div>
			</div>
			<!-- END tab-pane -->
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-2">
				<!-- MY LIST 영역 -->
				<table class="table table-hover table-board">
					<colgroup>
						<col style="width:80px">
						<col style="width:50px">
						<col style="width:">
					</colgroup>
					<tbody>
					</tbody>
				</table>
			</div>
			<!-- END tab-pane -->
		</div>
		<!-- END tab-content -->
	</div>
	<!-- END content-container -->
	
</div>
<!-- END #content -->