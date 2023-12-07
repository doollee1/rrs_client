<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set value="${sessionScope.login}" var="login" />

<div id="content" class="index-wrap">
	<div class="intro-text">
		<p>Palm Resort</p>
	</div>
	
	<%//로그인 전 화면 : index.html %>
	<c:if test="${sessionScope.login == null}">
		<ul class="btn-wrap list-unstyled">
			<li><a href="javascript:;" class="btn btn-white btn-lg d-block">리조트&골프장</a></li>
			<li><a href="/productInfo.do" class="btn btn-white btn-lg d-block">상품소개</a></li>
			<li><a href="/signIn.do" class="btn btn-white btn-lg d-block">로그인</a></li>
		</ul>
	</c:if>
	
	<%//로그인 후 화면 : main_btn.html %>
	<c:if test="${sessionScope.login != null}">
		<div class="main-btn-wrap">
			<div class="goto-menu">
				<a href="/reservationReq.do" class="btn btn-success"><i class="fas fa-calendar-check"></i>예약요청</a>
				<a href="#" class="btn btn-success"><i class="fas fa-calendar-days"></i>예약현황</a>
				<a href="/qnaList.do" class="btn btn-success"><i class="fas fa-pencil-alt"></i>문의사항</a>
				<a href="/noticeList.do" class="btn btn-success"><i class="far fa-message"></i>공지사항</a>
			</div>
			<a href="/setting.do" class="btn btn-dark btn-sm btn-set">설정</a>
		</div>
	</c:if>
</div>
