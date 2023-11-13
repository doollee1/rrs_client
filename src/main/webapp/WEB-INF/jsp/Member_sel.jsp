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
  <link href="resrc/css/common_admin.css" rel="stylesheet">
  <!-- <link href="css/Business_service.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script>
	   function moveDetail(value){
	       $("#target").attr("action","Member_upd.do")
	       $("#target").append($('<input/>',{type:'hidden', name: 'mb_id', value:value }  ));
	       $("#target").appendTo('body');
	       $('#target').submit();
	   }
  </script>
</head>

<body>
	<!--navigation-->
	<jsp:include page="common/Navigation.jsp"></jsp:include>

	
	<!--container-->
	<div class="container" style="min-width:1400px">
	  <div class="left">
          <p class="tit-type4">회원 목록 </p>  <!-- <span class="c-org">(*필수입력)</span> -->
      </div>
			<div class="data-top">
				<div class="left"><span class="total">Total <c:out value='${rsListCnt}'/>건</span></div>
				<div class="right">
					<select name="searchType" id="searchType"><option value="0">ID</option><option value="1">이름</option></select>
					<input type="text" name="searchParam" id="searchParam" style="width:200px;max-width:80%;">
					<button class="btn-type1 type1 btn-search"><img src="resrc/image/ico_search.png" alt=""></button>
				</div>
			</div>

				<!-- table -->
				<div class='data-st1'>
					<table style="min-width:1300px"> <!-- 기본값 원하는최소값으로 지정-->
						<colgroup>
							<col style='width:120px' /> <!-- ID -->
							<col style='width:160px' /> <!-- 성명 -->
							<col style='width:160px' /> <!-- 이메일주소 -->
							<col style='width:150px' /> <!-- 핸드폰 -->
							<col style='width:300px' /> <!-- 주소 -->
							<col style='width:80px' />  <!-- 재직여부 -->
							<col style='width:150px' />  <!-- 입사일자 -->
							<col style='width:150px' />  <!-- 퇴사일자 -->
						</colgroup>
						<thead>
							<tr>
								<th>ID</th>
								<th>이름</th>
								<th>이메일주소</th>
								<th>핸드폰</th>
								<th>주소</th>
								<th>상태</th>
								<th>입사일자</th>
								<th>퇴사일자</th>
							</tr>
						</thead>
						
						<tbody>
							<c:forEach var="rsMap" items="${rsList}">
							<tr>
								<td class="align-c" ><a href="javascript:void(0);" onclick="moveDetail('${rsMap.mb_id}')" class="elp"><c:out value="${rsMap.mb_id}"/></a>
									<!-- <span class="new"></span> -->
								</td>
								<td><c:out value="${rsMap.mb_name}"/></td>
								<td><c:out value="${rsMap.mb_email}"/></td>
								<td><c:out value="${rsMap.mb_hp}"/></td>
								<td><c:if test='${not empty rsMap.mb_zip}' >
										(<c:out value="${rsMap.mb_zip}"/>)
									</c:if>
									&nbsp;<c:out value="${rsMap.mb_addr1}"/>&nbsp;<c:out value="${rsMap.mb_addr2}"/>
								</td>
								<td><c:out value="${rsMap.mb_level_str}"/></td>
								<td><c:out value="${rsMap.mb_join_date}"/></td>
								<td><c:out value="${rsMap.mb_retire_date}"/></td>
								
							</tr>
							</c:forEach>
						</tbody>
					</table>
					</div>
					<!-- //table -->
					<script>
					
						function movePage(value){
							$("#target").attr("action","Member_sel.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value:value }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchType', value:$("#searchType option:selected").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchParam', value:$("#searchParam").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchSel' , value:'0' }  ));
							
							$("#target").appendTo('body');
							$('#target').submit();
						}
					
					
						function first(){
							$("#target").attr("action","Member_sel.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value:'1' }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchType', value:$("#searchType option:selected").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchParam', value:$("#searchParam").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchSel' , value:'0' }  ));
							$("#target").appendTo('body');
							$('#target').submit();
						}
						
						function previous(value){
							
							if(value == 1){
								alert("첫 페이지입니다.");
								return;
							}
							
							$("#target").attr("action","Member_sel.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value: +value-1 }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchType', value:$("#searchType option:selected").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchParam', value:$("#searchParam").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchSel' , value:'0' }  ));
							$("#target").appendTo('body');
							$('#target').submit();
						}
						
						function next(lastpage, value){
							
							if(value == lastpage){
								alert("마지막  페이지입니다.");
								return;
							}
							
							$("#target").attr("action","Member_sel.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value : +value+1 }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchType', value:$("#searchType option:selected").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchParam', value:$("#searchParam").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchSel' , value:'0' }  ));
							$("#target").appendTo('body');
							$('#target').submit();
						}
						
						function last(value){
							$("#target").attr("action","Member_sel.do")
							$("#target").append($('<input/>',{type:'hidden', name: 'page', value: value }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchType', value:$("#searchType option:selected").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchParam', value:$("#searchParam").val() }  ));
							$("#target").append($('<input/>',{type:'hidden', name: 'searchSel' , value:'0' }  ));
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
								$("#target").attr("action","Member_insert.do")
								$("#target").appendTo('body');
								$('#target').submit();
			        	    }
		        		</script>  
						<div class="data-top">
							<div class="left">
							</div>
							<div class="right">
	                			<a href="/Member_newIns.do" class="btn-type1 type1 min-size1">회원등록</a>
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