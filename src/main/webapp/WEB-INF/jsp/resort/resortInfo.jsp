<%--
	File Name : resortInfo.jsp (PalmResort > html > info_resort.html)
	Description : 리조트&골프장 소개 페이지
	Creation : 이민구
	Update
	2023.12.20 이민구 - 최초생성
--%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script>

$(window).ready( function() {
	setTitle("리조트소개");
});

</script>

<!-- BEGIN #content -->
<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden info-resort" data-scrollbar="true" data-height="100%">
							
		<!-- BEGIN nav-tabs -->
		<ul class="nav nav-tabs">
			<li class="nav-item">
				<a href="#default-tab-1" data-bs-toggle="tab" class="nav-link active">
					<span class="d-sm-none">Le Grandeur Hotel</span>
				</a>
			</li>
			<li class="nav-item">
				<a href="#default-tab-2" data-bs-toggle="tab" class="nav-link">
					<span class="d-sm-none">Golf Country Club</span>
				</a>
			</li>
		</ul>
		<!-- END nav-tabs -->
		<!-- BEGIN tab-content -->
		<div class="tab-content panel rounded-0 p-3 m-0">
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade active show" id="default-tab-1">
				
				<div class="type-room">
					<div class="pic-tit">일반딜럭스</div>
					<ul class="room-list">
						<li><img src="PalmResort/assets/img/hotel_d01.jpg" ></li>
						<li><img src="PalmResort/assets/img/hotel_d02.jpg" ></li>
					</ul>
				</div>
				<div class="type-room">
					<div class="pic-tit">프리미어딜럭스</div>
					<ul class="room-list">
						<li><img src="PalmResort/assets/img/hotel_p01.jpg" ></li>
						<li><img src="PalmResort/assets/img/hotel_p02.jpg" ></li>
						<li><img src="PalmResort/assets/img/hotel_p03.jpg" ></li>
						<li><img src="PalmResort/assets/img/hotel_p04.jpg" ></li>
						<li><img src="PalmResort/assets/img/hotel_p05.jpg" ></li>
						<li><img src="PalmResort/assets/img/hotel_p06.jpg" ></li>
					</ul>
				</div>
				<div class="type-room">
					<div class="pic-tit">호텔 로비 및 바, 수영장</div>
					<ul class="room-list">
						<li><img src="PalmResort/assets/img/hotel_etc01.png" ></li>
						<li><img src="PalmResort/assets/img/hotel_etc02.png" ></li>
						<li><img src="PalmResort/assets/img/hotel_etc03.png" ></li>
					</ul>
				</div>
				<div class="type-room">
					<div class="pic-tit">호텔 내 레스토랑 </div>
					<ul class="room-list">
						<li><img src="PalmResort/assets/img/hotel_etc04.png" ></li>
						<li><img src="PalmResort/assets/img/hotel_etc05.png" ></li>
					</ul>
				</div>
			</div>
			<!-- END tab-pane -->
			<!-- BEGIN tab-pane -->
			<div class="tab-pane fade" id="default-tab-2">
				<div class="type-room">
					<div class="pic-tit">골프장 클럽하우스</div>
					<ul class="room-list">
						<li><img src="PalmResort/assets/img/golf02.jpg" ></li>
						<li><img src="PalmResort/assets/img/golf06.png" ></li>
					</ul>
				</div>
				<div class="type-room">
					<div class="pic-tit">골프장 코스</div>
					<ul class="room-list">
						<li><img src="PalmResort/assets/img/golf01.jpg" ></li>
						<li><img src="PalmResort/assets/img/golf03.jpg" ></li>
						<li><img src="PalmResort/assets/img/golf04.jpg" ></li>
						<li><img src="PalmResort/assets/img/golf05.png" ></li>
					</ul>
				</div>
				<div class="type-room">
					<div class="pic-tit">골프장 한국 식당 '연'</div>
					<ul class="room-list">
						<li><img src="PalmResort/assets/img/golf_etc01.png" ></li>
						<li><img src="PalmResort/assets/img/golf_etc02.png" ></li>
						<li><img src="PalmResort/assets/img/golf_etc03.png" ></li>
						<li><img src="PalmResort/assets/img/golf_etc04.png" ></li>
						<li><img src="PalmResort/assets/img/golf_etc05.png" ></li>
					</ul>
				</div>
				<div class="type-room">
					<div class="pic-tit">골프장 기타 부대시설</div>
					<ul class="room-list">
						<li><img src="PalmResort/assets/img/golf_etc06.png" ></li>
						<li><img src="PalmResort/assets/img/golf_etc07.png" ></li>
						<li><img src="PalmResort/assets/img/golf_etc08.png" ></li>
						<li><img src="PalmResort/assets/img/golf_etc09.png" ></li>
					</ul>
				</div>
			</div>
			<!-- END tab-pane -->					
		</div>
		<!-- END tab-content -->

	</div>
	<!-- END content-container -->
	
	<!-- BEGIN #footer -->
	<!-- END #footer -->			
	
</div>
<!-- END #content -->