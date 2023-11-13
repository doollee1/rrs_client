<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
  <!-- <link href="css/Business_consulting.css" rel="stylesheet"> -->
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
	<div class="visual business">
		<p class="txt">Business</p>
		<div class="page-nav">
			<a href="/mainPage.do">Home</a>
			<a href="#">Business</a>
			<a href="#" class="on">컨설팅</a>
		</div>
	</div>

  <!--container-->
  <div class="container">

	<div class="section">    
	    <p class="top-txt">
		      ㈜둘리정보통신은 공공, 금융, 제조, 유통, 통신 등의 각 사업 분야에 고객의 경쟁력 강화와  프로세스 혁신을 위하여<br>
		      정보수집, 경영분석, BPM, CRM, CPM, ERM 등 다양한 솔루션을 이용한 전략컨설팅 등의  비지니스 컨설팅을 제공하여<br> 
		      고객의 사업 효율화 및 생산성 증대에 보탬이 되겠습니다.
	    </p>

		<!-- business-info -->
		<div class="business-info consult">
			<div class="row">
				<div class="col-md-4 col-sm-12">
					<div class="info-unit">
						<div class="card-transition-zoom">						
							<div class="card-transition-zoom-item">
				            	<img class="card-img" src="resrc/image/consulting_01.png" alt="">
				            </div>
						</div>
						<div class="tit">Business 전략 컨설팅 </div>
						<div class="text">고객의 경영 효율화를 위한 경영전략 수립, 기업 경영 내용이나 경영과정 전반을 분석 하여 경영 목표 달성에 가장 적합하도록 재설계(BPR)를 통한 프로세스 혁신</div>
					</div>
				</div>
				<div class="col-md-4 col-sm-12">
					<div class="info-unit">
						<div class="card-transition-zoom">
							<div class="card-transition-zoom-item">
				            	<img class="card-img" src="resrc/image/consulting_02.png" alt="">
				            </div>
						</div>
						<div class="tit">IT(Information Technology) 컨설팅 </div>
						<div class="text">정보시스템 구조가 메인프레임, 클라이언트
					              환경에서 서버, 인트라넷, 네트워크 컴퓨팅으로
					              패러다임이 변화하면서 다양한 요소 기술과
					              이를 구현할 수 있는 정보화 전략 계획(ISP), 
					              정보기술 아키텍처(ITA), 정보화 수준 진단, 
					              솔루션 기반 컨설팅
	              		</div>
					</div>
				</div>
				<div class="col-md-4 col-sm-12">
					<div class="info-unit">
						<div class="card-transition-zoom">
							<div class="card-transition-zoom-item">
				            	<img class="card-img" src="/resrc/image/consulting_03.png" alt="">
				            </div>
						</div>
						<div class="tit">Network 컨설팅</div>
						<div class="text">네트워크 구축 및 통합 컨설팅, 네트워크 Planning 및 디자인, 용량 Planning, 유지보수 Planning</div>
					</div>
				</div>
			</div>
		</div>
		<!-- // business-info -->
	</div>

  </div>

  <jsp:include page="common/Footer.jsp" />
  
  <script>includeHTML();</script>
</body>
</html>