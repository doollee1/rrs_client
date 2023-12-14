<%--
	File Name : noticeList.jsp - (PalmResort > html > board_notice_list.html)
	Description : 공지사항 페이지
	Creation : 2023.11.29 이민구
	Update
	2023.11.29 이민구 - 최초생성
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

$(window).ready( function() {
	setTitle("공지사항");
	setEvent();
});

var page = 2;

<%//페이지 이벤트 설정 %>
function setEvent(){
	scrollEvent();
}

<%//공지사항 상세보기%>
function goDetail(notice_seq){
	location.href="/noticeView.do?notice_seq="+notice_seq;
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
		url:"/noticeListNextPage.do",
		data:
		{ "page":page
		},
		dataType:"json",
	}).done(function(data){
		page++;
		var html = "";
		for(var i = 0; i < data.length; i++) {
			html += '<tr onclick="goDetail(' + data[i].notice_seq + ')">';
			html += '	<td class="date"><span>' + data[i].st_dt + '</span></td>';
			html += '	<td><span>' + data[i].title + '</span></td>';
			html += '</tr>';
		}
		$('tbody').last().append(html);
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
			<div id="eol"></div>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
</div>