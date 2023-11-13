<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>

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
  <!-- <link href="css/Project_actual.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>

<body>
  	<!--navigation-->
  	<jsp:include page="common/Navigation.jsp" />
  	
	<!-- visual section -->	
	<div class="visual project">
		<p class="txt">Project</p>
		<div class="page-nav">
			<a href="/mainPage.do">Home</a>
			<a href="Project_actual.do">Project</a>
			<a href="Project_actual.do" class="on">프로젝트 실적</a>
		</div>
	</div>
  
  
  <!--container-->
  <div class="container">
  	<div align="right">
  		<c:if test="${loginYn eq 'Y' && usrlvl eq '0'}">
  		<button class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="location.href='teamView.do'">팀원등록</button>
  		<button class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="location.href='projectInsert.do'">등록하기</button>
  		</c:if>
  	</div>
    <div class="tab-type1">
      <a href="javascript:void(0);" class="selected"><span>전체</span></a>
      <ul class="nav nav-tabs nav-justified">
          <li class="nav-item on">
            <a class="nav-link active" data-toggle="tab" href="#total">전체</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#public_sector">공공부문</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#general_sector">일반부문</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#maintenance">납품유지보수</a>
          </li>
      </ul>
  </div>
  <script>
    tabMenu();
  </script>
  
    <div class="tab-content">
      <!--전체-->
      <div class="tab-pane fade show active" id="total">
        <jsp:include page="Project_actual_total.jsp" />
      </div>
      <!--공공부문-->
      <div class="tab-pane fade" id="public_sector">
        <jsp:include page="Project_actual_public_sector.jsp" />
      </div>
      <!--일반부문-->
      <div class="tab-pane fade" id="general_sector">
        <jsp:include page="Project_actual_general_sector.jsp"/>
      </div>
      <!--납품유지보수-->
      <div class="tab-pane fade" id="maintenance">
        <jsp:include page="Project_actual_maintenance.jsp" />
      </div>
    </div>
  </div>
  <!--/container-->

  <jsp:include page="common/Footer.jsp" />
  
  <script>includeHTML();</script>
</body>
</html>