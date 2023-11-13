<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">

<head>
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<title>(주)둘리정보통신</title>
<!-- Bootstrap core CSS -->
<link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
<!-- Custom styles for this template -->
<!-- <link href="css/modern-business.css" rel="stylesheet"> -->
<!--css-->
<link href="resrc/css/common.css" rel="stylesheet">
<!-- <link href="css/Business_consulting.css" rel="stylesheet"> -->
<!--script-->
<script src="resrc/js/includeHTML.js"></script>
<script src="resrc/vendor/jquery/jquery.js"></script>
<script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>
<%
	int qna_sqno;
	if (request.getParameter("qna_sqno") != null) {
		qna_sqno = Integer.parseInt(request.getParameter("qna_sqno"));
	}
	String qna_pw;
	if (request.getParameter("qna_pw") != null) {
		qna_pw = request.getParameter("qna_pw");
	}
%>

<body class="sticky-footer-wrap">
	<!--navigation-->
	<jsp:include page="common/Navigation.jsp" />

	<!-- visual section -->	
	<div class="visual contact">
		<p class="txt">Contact</p>
		<div class="page-nav">
			<a href="/mainPage.do">Home</a>
			<a href="Contact_insert.do">Contact</a>
			<a href="Contact_insert.do" class="on">고객문의</a>
		</div>
	</div>

	<!--container-->
	<div class="container sticky-footer">
		<c:if test="${empty param.qna_sqno}">
			<div class='data-st1'>
				<table style="min-width:600px">
					<!-- 기본값 원하는최소값으로 지정-->
					<colgroup>
						<col style="width: 100px" />
						<col style='width: auto' />
						<col style='width: 300px' />
						<col style='width: 150px' />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>등록일</th>
							<th>진행상황</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${listContact}" var="listContact">
							<tr>
								<td><c:out value="${listContact.qna_sqno}" /></td>
								<td><a onclick="pwcheck(${listContact.qna_sqno})"> <c:out value="${listContact.qna_title}" />
								</a></td>
								<script type="text/javascript">
								
									function pwcheck(qna_sqno){
										var loginYn  = "";
										var usrlvl  = "";
										loginYn = "${sessionScope.loginYn}";
										usrlvl  = "${sessionScope.usrlvl}";
										
										if(loginYn == "Y" && usrlvl == '0' ){
											location.href="Contact_select.do?qna_sqno="+qna_sqno;
										}else{
											
											var pw = prompt("비밀번호를 입력하세요.");
											if(pw != null && pw != ""){
												$.ajax({
													type:"POST",
													url:"Contact_pwChk.do",
													data:{qna_sqno: qna_sqno,
														  qna_pw  : pw 
														 },
													dataType:"json",
													success:function(data){
														if(data == 'Y'){
															location.href="Contact_select.do?qna_sqno="+qna_sqno+"&qna_pw="+pw;
														}else{
															alert("비밀번호가 틀렸습니다.");
														}
													},
													error:function(data){
														console.log("통신중 오류가 발생하였습니다.");
													}
												});
												//location.href="Contact_select.do?qna_sqno="+qna_sqno+"&qna_pw="+pw;
											}
										}
										
										
									}
								</script>
								<td><c:out value="${fn:substring(listContact.rg_dtm,0,11)}" /></td>
								<c:if test="${listContact.re_yn == 0 }">
									<td>답변 대기 중</td>
								</c:if>
								<c:if test="${listContact.re_yn == 1 }">
									<td>답변 완료</td>
								</c:if>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</c:if>
		
		<c:if test="${not empty param.qna_sqno and sessionScope.usrlvl ne '0' }">
			<div class='data-st1'>
				<table style="min-width: 520px">
					<!-- 기본값 원하는최소값으로 지정-->
					<colgroup>
						<col style="width: 100px" />
						<col style='width: auto' />
						<col style='width: 300px' />
						<col style='width: 150px' />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>등록일</th>
							<th>진행상황</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${listContactSelect}" var="listContactSelect">
							<tr>
								<td><c:out value="${listContactSelect.qna_sqno}" /></td>
								<td><a href="Contact_select.do"> <c:out
											value="${listContactSelect.qna_title}" />
								</a></td>
								<td><c:out
										value="${fn:substring(listContactSelect.rg_dtm,0,11)}" /></td>
								<c:if test="${listContactSelect.re_yn == 0 }">
									<td>답변 대기 중</td>
								</c:if>
								<c:if test="${listContactSelect.re_yn == 1 }">
									<td>답변 완료</td>
								</c:if>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div style='ft: 4%; text-align: left; font-size: 16px; color: gray'>■
				문의 사항 입니다.</div>
			<br>
			<br>
			<div class='data-st2'>
				<table style="min-width: 520px">
					<colgroup>
						<col style="width: 20%" />
						<col style="width: auto" />
					</colgroup>
 					<c:forEach items="${listContactSelect}" var="listContactSelect">
 						<tr>
							<th>성명</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value='${listContactSelect.name}' />"
								readonly="readonly"></td>
						</tr>
						<tr>
							<th>문의 유형 :
							</td>
							<c:if test="${listContactSelect.tpdsc eq '1'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="컨설팅" readonly="readonly"></td>
							</c:if>
							<c:if test="${listContactSelect.tpdsc eq '2'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="서비스" readonly="readonly"></td>
							</c:if>
							<c:if test="${listContactSelect.tpdsc eq '3'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="솔루션" readonly="readonly"></td>
							</c:if>
							<c:if test="${listContactSelect.tpdsc eq '4'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="인재채용" readonly="readonly"></td>
							</c:if>
							<c:if test="${listContactSelect.tpdsc eq '9'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="기타" readonly="readonly"></td>
							</c:if>
						</tr>
						<tr>
							<th>문의 내용 :</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value="${listContactSelect.qna_cntn}" />"
								readonly="readonly"></td>
						</tr>
						<tr>
							<th>관리자 :</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value="${listContactSelect.re_name}" />"
								readonly="readonly"></td>
						</tr>
						<tr>
							<th>답변 내용 :</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value="${listContactSelect.re_cntn}" />"
								readonly="readonly"></td>
						</tr>
						<tr>
							<th>등록일 :</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value="${fn:substring(listContactSelect.re_rg_dtm,0,11)}" />"
								readonly="readonly"></td>
						</tr>
					 </c:forEach>
				</table>
				</br></br></br></br>
		</c:if>
		<c:if test="${not empty param.qna_sqno}">
			<c:if test="${sessionScope.loginYn eq 'Y' and sessionScope.usrlvl eq '0'}">
			<!-- 관리자 -->
				<div class='data-st1'>
					<table style="min-width: 520px">
						<!-- 기본값 원하는최소값으로 지정-->
						<colgroup>
							<col style="width: 100px" />
							<col style='width: auto' />
							<col style='width: 300px' />
							<col style='width: 150px' />
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>등록일</th>
								<th>진행상황</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${listContactSelect}" var="listContactSelect">
								<tr>
									<td><c:out value="${listContactSelect.qna_sqno}" /></td>
									<td><a href="Contact_select.do"> <c:out
												value="${listContactSelect.qna_title}" />
									</a></td>
									<td><c:out
											value="${fn:substring(listContactSelect.rg_dtm,0,11)}" /></td>
									<c:if test="${listContactSelect.re_yn == 0 }">
										<td>답변 대기 중</td>
									</c:if>
									<c:if test="${listContactSelect.re_yn == 1 }">
										<td>답변 완료</td>
									</c:if>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div style='ft: 4%; text-align: left; font-size: 16px; color: gray'>■
					문의 사항 입니다.</div>
				<br>
				<br>
				<div class='data-st2'>
					<table style="min-width: 520px">
						<colgroup>
							<col style="width: 20%" />
							<col style="width: auto" />
						</colgroup>
						<c:forEach items="${listContactSelect}" var="listContactSelect">
						<tr>
							<th>성명</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value='${listContactSelect.name}' />"
								readonly="readonly"></td>
						</tr>
						<tr>
							<th>문의 유형 :
							</td>
							<c:if test="${listContactSelect.tpdsc eq '1'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="컨설팅" readonly="readonly"></td>
							</c:if>
							<c:if test="${listContactSelect.tpdsc eq '2'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="서비스" readonly="readonly"></td>
							</c:if>
							<c:if test="${listContactSelect.tpdsc eq '3'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="솔루션" readonly="readonly"></td>
							</c:if>
							<c:if test="${listContactSelect.tpdsc eq '4'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="인재채용" readonly="readonly"></td>
							</c:if>
							<c:if test="${listContactSelect.tpdsc eq '9'}">
								<td><input type="text" style="width: 90%;" class="m-per100"
									value="기타" readonly="readonly"></td>
							</c:if>
						</tr>
						<tr>
							<th>문의 내용 :</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value="${listContactSelect.qna_cntn}" />"
								readonly="readonly"></td>
						</tr>
						<tr>
							<th>관리자 :</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value="${listContactSelect.re_name}" />"
								readonly="readonly"></td>
						</tr>
						<tr>
							<th>답변 내용 :</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value="${listContactSelect.re_cntn}" />"
								readonly="readonly"></td>
						</tr>
						<tr>
							<th>등록일 :</th>
							<td><input type="text" style="width: 90%;" class="m-per100"
								value="<c:out value="${fn:substring(listContactSelect.re_rg_dtm,0,11)}" />"
								readonly="readonly"></td>
						</tr>
						</c:forEach>
					</table>
					<div class='data-st2'>
					<form action="" method="POST" class="form-example">
						<table style="min-width: 520px">
							<colgroup>
								<col style="width: 20%" />
								<col style="width: auto" />
							</colgroup>
	
	
							<c:set var="balance" value="${param.qna_sqno}" />
	
							<fmt:parseNumber var="i" type="number" value="${balance}" />
	
							<input type="hidden" name="qna_sqno" value="${i}"
								readonly="readonly" />
							<tr>
								<th>관리자 :</th>
								<td><input type="text" style="width: 90%;" id="re_name"
									name="re_name" value="관리자" readonly="readonly"></td>
							</tr>
							<tr>
								<th>답변 내용 :</th>
								<td><input type="text" style="width: 90%;" id="re_cntn"
									name="re_cntn"></td>
							</tr>
						</table>
					</form>
					<script type="text/javascript">
						function writeCheck(qna_sqno, pw){
							
						    var re_name = $("#re_name").val();
						    var re_cntn = $("#re_cntn").val();
						    
							$.ajax({
								type:"POST",
								url:"updateContact.do",
								data:{qna_sqno : qna_sqno,
									  re_name  : re_name,
									  re_cntn  : re_cntn,
									 },
								dataType:"json",
								success:function(data){
									if(data == 'Y'){
										alert("정상 등록 되었습니다.");
										location.href="Contact_select.do?qna_sqno="+qna_sqno;
									}else{
										alert("등록 중 오류가 발생하였습니다.");
									}
								},
								error:function(data){
									console.log("통신중 오류가 발생하였습니다.");
								}
							});
							
						}
					</script>
					</br>
					<div style="text-align: center;">
						<input class="btn-type2 type1 min-size1" type="reset"
							value="초기화"> <input class="btn-type2 type1 min-size1"
							type="button" value="등록하기" onclick="writeCheck(${param.qna_sqno})" >
					</div>
					</br></br></br></br>
				</div>
			</c:if>
		</c:if>
	</div>
	<!-- /.container -->

	<!-- Contact form JavaScript -->
	<!-- Do not edit these files! In order to set the email address and subject line for the contact form go to the bin/contact_me.php file. -->
	<script src="resrc/js/jqBootstrapValidation.js"></script>

	<jsp:include page="common/Footer.jsp" />

	<script>
		includeHTML();
	</script>
</body>

</html>