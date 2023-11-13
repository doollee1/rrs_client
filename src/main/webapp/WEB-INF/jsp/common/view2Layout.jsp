﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"     prefix="tiles" %>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date" %>
<%@ page import="java.security.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">

<head>
    <tiles:insertAttribute name="header"/>
</head>
<body>
    <div id="navi_area"><tiles:insertAttribute name="navi" /></div>
    <div id="body_area"><tiles:insertAttribute name="body" /></div>
</body>

<script>
var PageNm = $(location).attr('pathname').split("/");
    PageNm = PageNm[PageNm.length-1].split(".")[0]; //pageId
if( PageNm.substr(PageNm.length-4, PageNm.length) == "_app" || PageNm.substr(PageNm.length-3, PageNm.length) == "App" ) {
	//mobile에서는 메뉴화면 사용안함/앱에서 생성
	//$("#navi_area").remove();
    //css 세팅으로 인한 화면 크기별 padding값 삭제 (mobile에서만)
    $("body").css("padding","0px");

    $(".data-st4 table td").css("padding","6px");
}
</script>

</html>