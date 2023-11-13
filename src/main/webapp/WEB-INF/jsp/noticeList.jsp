<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">

<head>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <title>(주)둘리정보통신</title>
  <!-- Bootstrap core CSS -->
  <link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
  <!-- Custom styles for this template -->
  <!-- <link href="css/modern-business.css" rel="stylesheet"> -->
  <!--css-->  
  <link href="resrc/css/common.css" rel="stylesheet">
  <!-- <link href="css/Business_service.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script>
	   function moveDetail(value){
	       $("#target").attr("action","noticeDetail.do")
	       $("#target").append($('<input/>',{type:'hidden', name: 'wr_id', value:value }  ));
	       $("#target").appendTo('body');
	       $('#target').submit();
	   }
  </script>
</head>

<body class="sticky-footer-wrap">
	<!--navigation-->
	<jsp:include page="common/Navigation.jsp"></jsp:include>

	<div class="visual company">
		<p class="txt">Company</p>
		<div class="page-nav">
			<a href="/mainPage.do">Home</a>
			<a href="#">Company</a>
			<a href="#" class="on">공지사항</a>
		</div>
	</div>

	<!--container-->
	<div class="container sticky-footer">
			<div class="data-top">
				<div class="left"><span class="total">Total <c:out value='${rsListCnt}'/>건</span></div>
				<div class="right">
					<select name="" id="" class="sm"><option value="">제목</option><option value=""><span class="red">제</span>목</option></select>
					<input type="text" class="sm">
					<button class="btn-type1 type1 btn-search"><img src="resrc/image/ico_search.png" alt=""></button>
				</div>
			</div>

				<!-- table -->
				<div class='data-st1'>
					<table style="min-width:520px"> <!-- 기본값 원하는최소값으로 지정-->
						<colgroup>
							<col style='width:80px' />
							<col style='width:auto' />
							<col style='width:190px' />
						</colgroup>
						<thead>
							<tr>
								<th>No.</th>
								<th>제목</th>
								<th>등록일</th>
							</tr>
						</thead>
						

					
						<tbody>
							<c:forEach var="rsMap" items="${rsList}">
							<tr>
								<td><c:out value="${rsMap.wr_id}" /></td>
								<td class="align-l"><a href="javascript:void(0);" onclick="moveDetail('${rsMap.wr_id}')" class="elp"><c:out value="${rsMap.wr_subject}"/></a>
									<!-- <span class="new"></span> -->
								</td>
								<td><c:out value="${rsMap.wr_date}"/></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
					</div>
					<!-- //table -->
					<script>
					
						function movePage(value){
							$("#target").attr("action","noticeList.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value:value }  ));
							$("#target").appendTo('body');
							$('#target').submit();
						}
					
					
						function first(){
							$("#target").attr("action","noticeList.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value:'1' }  ));
							$("#target").appendTo('body');
							$('#target').submit();
						}
						
						function previous(value){
							
							if(value == 1){
								alert("첫 페이지입니다.");
								return;
							}
							
							$("#target").attr("action","noticeList.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value: +value-1 }  ));
							$("#target").appendTo('body');
							$('#target').submit();
						}
						
						function next(lastpage, value){
							
							if(value == lastpage){
								alert("마지막  페이지입니다.");
								return;
							}
							
							$("#target").attr("action","noticeList.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value : +value+1 }  ));
							$("#target").appendTo('body');
							$('#target').submit();
						}
						
						function last(value){
							$("#target").attr("action","noticeList.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value: value }  ));
							$("#target").appendTo('body');
							$('#target').submit();
						}
					
					</script>
					<div class="paging">
						<a onclick="first()" class="first disabled">처음</a>
						<a onclick="previous('${page}')" class="prev disabled">이전</a>
						<span class="page">
						    <c:set var="page" value="${page}" ></c:set>
							<c:forEach var="i" begin="${startPage}" end="${endPage}">
							    <c:choose>
								<c:when test='${i == page}'>
									<a href="javascript:void(0);" class="on">${i}</a>
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0);" onclick="movePage('${i}')">${i}</a>
								</c:otherwise>
								</c:choose>
							</c:forEach>
						</span>
						
						<a onclick="next('${lastPage}','${page}')" class="next">다음</a>
						<a onclick="last('${lastPage}')" class="last">마지막</a>
					</div>
					<c:if test="${sessionScope.loginYn eq 'Y' && sessionScope.usrlvl eq '0'}">
						<script>
			        	    function writePage(){
								$("#target").attr("action","noticeWrite.do")
								$("#target").appendTo('body');
								$('#target').submit();
			        	    }
		        		</script>  
						<div class="data-top">
							<div class="left">
							</div>
							<div class="right">
	                			<a href="javascript:void(0);" onclick="writePage()" class="btn-type1 type1 min-size1">글등록</a>
	            			</div>
	            		</div>
            		</c:if>
					<form method="POST" id="target" >
					</form>					
<br>
	</div>
	<!--/container-->

	<jsp:include page ="common/Footer.jsp"></jsp:include>
	
	<script>includeHTML();</script>
</body>
</html>