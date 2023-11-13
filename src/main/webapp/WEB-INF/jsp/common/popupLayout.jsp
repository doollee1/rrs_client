<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"     prefix="tiles" %>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date" %>
<%@ page import="java.security.*"%>

<div id="body_area"><tiles:insertAttribute name="body"  /></div>

<script>
var PageNm = $(location).attr('pathname').split("/");
    PageNm = PageNm[PageNm.length-1].split(".")[0]; //pageId
if( PageNm.substr(PageNm.length-4, PageNm.length) == "_app" || PageNm.substr(PageNm.length-3, PageNm.length) == "App" ) {
    $(".modal-content").css({"border":"0px", "border-radius":"0px", "height":"100vh"})
                       .parents(".modal").css("border","0px") ;

    $(".data-st4 table td").css("padding","6px");
    //$(".wHead").html(""); //모바일에서는 상단제목 안보이게
}
//뒤로가기 이벤트 재정의 (팝업화면에서는 팝업종료, 팝업실행시 항상 재정의 되게 하기 위해 레이아웃에 설정)
history.pushState(null,null,location.href);
window.onpopstate = function(event) {
    if( $(".modal-content").hasClass("modal-content") ) {
        $("#regArea").css("display","none");
        $("#regArea").html("");
    } else {
        return true;
    }
}
</script>
