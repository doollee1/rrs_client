<!DOCTYPE html>
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
  <!-- <link href="css/Business_outline.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
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
			<a href="#" class="on">개요</a>
		</div>
	</div>
  
  <!--container-->
  <div class="container">
    
	<!-- business-info -->
	<div class="business-info">
		<h2> IT Total Service</h2><!-- 둘리정보통신의 차별된시스템 -->
		<div class="row">
			<div class="col-md-4 col-sm-12">
				<div class="info-unit">
					<i class="bi bi-chat-square-quote"></i>
<!-- 					<i class="fa fa-connectdevelop"></i> -->
					<div class="tit">컨설팅 </div>
					<div class="text">고객혁신을 위한<br> 컨설팅을 제공합니다.</div>
					<a href="Business_consulting.do" class="card-transition-zoom">
						<div class="blind">자세히보기 <i class="bi bi-arrow-right"></i></div>
						<div class="card-transition-zoom-item">
			            	<img class="card-img" src="/resrc/image/main_img1.jpg" alt="Image Description">
			            </div>
					</a>
					<ul class="check-list">
						<li>IT 토탈 컨설팅 제공</li>
						<li>다양한 전문기술 및 솔루션 컨설팅</li>
						<li>고객 사업 효율화 및 생산성 증대 컨설팅</li>
					</ul>
					
				</div>
			</div>
			<div class="col-md-4 col-sm-12">
				<div class="info-unit">
					<i class="bi bi-gear"></i>
					<div class="tit">서비스 </div>
					<div class="text">성공적인 비즈니스에<br> 필수적인 통합 ICT 서비스를 제공합니다.</div>
					<a href="Business_service.do" class="card-transition-zoom">
						<div class="blind">자세히보기 <i class="bi bi-arrow-right"></i></div>
						<div class="card-transition-zoom-item">
			            	<img class="card-img" src="/resrc/image/main_img2.jpg" alt="Image Description">
			            </div>
					</a>
					<ul class="check-list">
						<li>고객의 비지니스 환경에 가장 적합한 맞춤형 시스템 개발</li>
						<li>하드웨어, 소프트웨어, 데이타베이스, 네트워크 정보기술 분석</li>
						<li>시스템 통합 고객 사업 목표 달성</li>
						<li>시스템 운영 경험과 차별화된 기술력으로 서비스제공</li>
						<li>고객 환경에 맞는 최적화된 장비 제공</li>
					</ul>
				</div>
			</div>
			<div class="col-md-4 col-sm-12">
				<div class="info-unit">
					<i class="bi bi-toggles2"></i>
					<div class="tit">솔루션 </div>
					<div class="text">고객의 요구에 맞춘 <br>가장 빠르고 효율적인 솔루션을 제공합니다.</div>
					<a href="Business_solution.do" class="card-transition-zoom">
						<div class="blind">자세히보기 <i class="bi bi-arrow-right"></i></div>
						<div class="card-transition-zoom-item">
			            	<img class="card-img" src="/resrc/image/main_img3.jpg" alt="Image Description">
			            </div>
					</a>
					<ul class="check-list">
						<li>무인정산시스템, 육질진단시스템, POS시스템을 통한 생산성 향상</li>
						<li>애플리케이션 신규 구축 및 기존 정보 시스템 업그레이드 등 최적화된 솔루션 제공</li>
						
					</ul>
				</div>
			</div>
		</div>
	</div>
	<!-- // business-info -->


  
  </div>

  <jsp:include page="common/Footer.jsp" />
  
  <script>includeHTML();</script>
</body>
</html>