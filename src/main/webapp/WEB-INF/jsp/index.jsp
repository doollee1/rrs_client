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
  <link href="resrc/css/modern-business.css" rel="stylesheet">
  <!--css-->
  <link href="resrc/css/common.css" rel="stylesheet">
  <!-- <link href="css/Company.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>

<body>
  	<!--navigation-->
  	<jsp:include page="common/Navigation.jsp" />
  	<!--header-->
  	<jsp:include page="common/Header.jsp" />


	<!--container-->
	<div class="container">
		
		<div class="row main-info">
			<div class="col-lg-7 col-md-7 col-sm-12">
				<div class="main-img-lg img01">
					<div class="main-img-sm sm01"></div>
					<div class="main-img-icon icon01"></div>
				</div>
			</div>
			<div class="col-lg-5 col-md-5 col-sm-12">
				<div class="info-unit">
					<i class="bi bi-chat-square-quote"></i>
					<div class="tit">컨설팅 </div>
					<div class="text">고객혁신을 위한 컨설팅을 제공합니다.</div>
					<ul class="check-list">
						<li>IT 토탈 컨설팅 제공</li>
						<li>다양한 전문기술 및 솔루션 컨설팅</li>
						<li>고객 사업 효율화 및 생산성 증대 컨설팅</li>
					</ul>
					<a href="Business_consulting.do" class="btn-more"><span>자세히 보기</span> <i class="bi bi-arrow-right"></i></a>
				</div>			
			</div>
		</div>
		
		<div class="row main-info bg">
			<div class="col-lg-5 col-md-5 col-sm-12">
				<div class="info-unit">
					<i class="bi bi-chat-square-quote"></i>
					<div class="tit">서비스 </div>
					<div class="text">성공적인 비즈니스에  필수적인 통합 ICT 서비스를 제공합니다.</div>
					<ul class="check-list">
						<li>고객의 비지니스 환경에 가장 적합한 맞춤형 시스템 개발</li>
						<li>하드웨어, 소프트웨어, 데이타베이스, 네트워크 정보기술 분석</li>
						<li>시스템 통합 고객 사업 목표 달성</li>
						<li>시스템 운영 경험과 차별화된 기술력으로 서비스제공</li>
						<li>고객 환경에 맞는 최적화된 장비 제공</li>
					</ul>
					<a href="Business_service.do" class="btn-more"><span>자세히 보기</span> <i class="bi bi-arrow-right"></i></a>
				</div>			
			</div>
			<div class="col-lg-7 col-md-7 col-sm-12">
				<div class="main-img-lg img02">
					<div class="main-img-sm sm02"></div>
					<div class="main-img-icon icon02"></div>
				</div>
			</div>
		</div>
		
		<div class="row main-info">
			<div class="col-lg-7 col-md-7 col-sm-12">
				<div class="main-img-lg img03">
					<div class="main-img-sm sm03"></div>
					<div class="main-img-icon icon03"></div>
				</div>
			</div>
			<div class="col-lg-5 col-md-5 col-sm-12">
				<div class="info-unit">
					<i class="bi bi-chat-square-quote"></i>
					<div class="tit">솔루션 </div>
					<div class="text">고객의 요구에 맞춘 가장 빠르고 효율적인 솔루션을 제공합니다.</div>
					<ul class="check-list">
						<li>무인정산시스템, 육질진단시스템, POS시스템을 통한 생산성 향상</li>
						<li>애플리케이션 신규 구축 및 기존 정보 시스템 업그레이드 등 최적화된 솔루션 제공</li>
					</ul>
					<a href="Business_solution.do" class="btn-more"><span>자세히 보기</span> <i class="bi bi-arrow-right"></i></a>
				</div>			
			</div>
		</div>
		
	</div>
	<!--// container-->
  

    <!-- main-notice -->
    <!-- 
    <div class="main-notice">
      <div class="inner">
        <a href="noticeList.do" class="readmore">READ MORE</a>
        <h2 class="tit">/ Notice</h2>
        <ul class="notice-list">
    		<c:forEach items="${list}" var="list">
        	<li>
    			<a href="#" class="txt"><c:out value="${list.wr_subject}" /></a>
    			<a href="#" class="more">READ MORE</a>
    		</li>
    		</c:forEach>
        </ul>
      </div>
    </div>
     -->
    <!-- // main-notice -->
  <jsp:include page="common/Footer.jsp" />
  
  <script>includeHTML();</script>
  
	<script>
	    $(document).ready(function() {
	        $(".video-unit.v01").hover(function(){
	            $(this).children()[0].classList.add("show");
	        }, function(){
	            $(this).children()[0].classList.remove("show");
	        });
	    });
    </script>
</body>
</html>