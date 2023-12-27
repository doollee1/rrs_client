<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"     prefix="tiles" %>

		<div id="sidebar" class="app-sidebar" data-bs-theme="dark">
			<!-- BEGIN scrollbar -->
			<div class="app-sidebar-content" data-scrollbar="true" data-height="100%">
				<!-- BEGIN menu -->
				<div class="menu">
					<div class="menu-profile">
						<div class="menu-profile-link">
							<div class="menu-profile-cover with-shadow"></div>
							<div class="menu-profile-info">
								<div class="d-flex align-items-center">
									<div class="flex-grow-1">
										팜리조트 예약시스템
									</div>
								</div>
								<small>어서오세요</small>
							</div>
						</div>
					</div>

					<div class="menu-header">Navigation</div>

					<div class="menu-item">
						<a href="/reservationReq.do" class="menu-link">
							<div class="menu-icon">
								<i class="fas fa-calendar-check"></i>
							</div>
							<div class="menu-text">예약요청 </div>
						</a>
					</div>
					<div class="menu-item ">
						<a href="/reservationList.do" class="menu-link">
							<div class="menu-icon">
								<i class="fas fa-calendar-days"></i>
							</div>
							<div class="menu-text">예약현황</div> 
						</a>
					</div>
					<div class="menu-item">
						<a href="/qnaList.do" class="menu-link">
							<div class="menu-icon">
								<i class="fas fa-pencil-alt"></i> 
							</div>
							<div class="menu-text">문의사항</div>
						</a>
					</div>
					<div class="menu-item">
						<a href="/noticeList.do" class="menu-link">
							<div class="menu-icon">
								<i class="far fa-message"></i> 
							</div>
							<div class="menu-text">공지사항</div>
						</a>
					</div>
					<div class="menu-item">
						<a href="/setting.do" class="menu-link">
							<div class="menu-icon">
								<i class="fa fa-cog"></i>
							</div>
							<div class="menu-text">개인설정</div>
						</a>
					</div>
					<div class="menu-item logout">
						<a href="/signOut.do" class="menu-link">
							<div class="menu-icon">
								<i class="fa-solid fa-right-from-bracket"></i>
							</div>
							<div class="menu-text">로그아웃</div>
						</a>
					</div>
					
					<!-- BEGIN minify-button -->
					<div class="menu-item d-flex">
						<a href="javascript:;" class="app-sidebar-minify-btn ms-auto d-flex align-items-center text-decoration-none" data-toggle="app-sidebar-minify"><i class="fa fa-angle-double-left"></i></a>
					</div>
					<!-- END minify-button -->
				</div>
				<!-- END menu -->
			</div>
			<!-- END scrollbar -->
		</div>
		<div class="app-sidebar-bg" data-bs-theme="dark"></div>
		<div class="app-sidebar-mobile-backdrop"><a href="#" data-dismiss="app-sidebar-mobile" class="stretched-link"></a></div>