<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
#listForm th {
    background: linear-gradient(90deg, black, black, black, black, purple, lavender);
    color: white;
}
#listForm th, #listForm td {
    padding: 12px
}
#listForm .nonSelectMsg { height: 100%; text-align:center; margin-top:100px; color:#cccccc; font-weight:bold; }
</style>

<script>
var tabListDivObj = "";
$(window).ready ( function() {
    tabListDivObj = $("#listForm #tblList").parent();
    if( $("#listForm #tblList tr").length == 0 ) {
        tabListDivObj.css ("overflow-y", "hidden")
                     .html("<div class='nonSelectMsg' style='width:"+ $("#listArea").width() +"px'>조회된 내용이 없습니다</div>");
        $("#listArea > .data-st4.scrollCat").removeClass("scrollCat").css("overflow-x", "hidden");
    }
    $(window).resize();
});
$(window).resize( function() {
    if( tabListDivObj ) {
        tabListDivObj.css("height", (window.innerHeight - tabListDivObj.offset().top - 219) + "px");
    }
});
</script>

<div class="data-st4 scrollCat" style="overflow-x: scroll; margin-top: 25px; background: linear-gradient(135deg, lavender, white)">
    <form method="get" class="form-horizontal" id="listForm" style="min-width:1180px; width:100%">
		<div class="scrollCat scrollDisible" style="overflow-y: scroll; width: 100%">
            <table style="width:100%">
                <!-- 기본값 원하는최소값으로 지정-->
                <colgroup>
                    <col style="width: 8%" />  <!-- 장비번호 -->
                    <col style="width: 10%"/>  <!-- 제품구분 -->
                    <col style="width: 8%" />  <!-- 제조사   -->
                    <col style="width: 9%" />  <!-- 모델명   -->
                    <col style="width: 15%"/>  <!-- S/N   -->
                    <col style="width: 5%" />  <!-- SIZE  -->
                    <col style="width: 6%" />  <!-- 수량      -->
                    <col style="width: 8%" />  <!-- 장비상태 -->
                    <col style="width: 7%" />  <!-- 제조년월 -->
                    <col style="width: 8%" />  <!-- 구입일자 -->
                    <col style="width: 8%" />  <!-- 폐기일자 -->
                </colgroup>
                <thead>
                    <tr>
                        <th>장비번호</th>
                        <th>제품구분</th>
                        <th>제조사</th>
                        <th>모델명</th>
                        <th>S/N</th>
                        <th>SIZE</th>
                        <th>수량</th>					
                        <th>장비상태</th>
                        <th>제조년월</th>
                        <th>구입일자</th>
                        <th>폐기일자</th>
                    </tr>
                </thead>
            </table>
        </div>
		<div class="scrollCat" style="overflow-y: scroll; width: 100%; min-height: 150px">
            <table style="width:100%" id="tblList">
                <!-- 기본값 원하는최소값으로 지정-->
                <colgroup>
                    <col style="width: 8%" />  <!-- 장비번호 -->
                    <col style="width: 10%"/>  <!-- 제품구분 -->
                    <col style="width: 8%" />  <!-- 제조사   -->
                    <col style="width: 9%" />  <!-- 모델명   -->
                    <col style="width: 15%"/>  <!-- S/N   -->
                    <col style="width: 5%" />  <!-- SIZE  -->
                    <col style="width: 6%" />  <!-- 수량      -->
                    <col style="width: 8%" />  <!-- 장비상태 -->
                    <col style="width: 7%" />  <!-- 제조년월 -->
                    <col style="width: 8%" />  <!-- 구입일자 -->
                    <col style="width: 8%" />  <!-- 폐기일자 -->
                </colgroup>
                <tbody>
                <c:forEach items="${prodList}" var="prodList" varStatus="status">
                    <tr>
                        <td name="prod_no"  style="font-weight:bold;color:cornflowerblue"><c:out value="${prodList.prod_no}"/></td>
                        <td name="prod_gbn" code="${prodList.prod_gbn}"><c:out value="${prodList.prod_gbn_nm}"/></td>
                        <td name="prod_comp"><c:out value="${prodList.prod_comp}"/></td>
                        <td name="model_nm"><c:out value="${prodList.model_nm}"/></td>
                        <td name="serial_no"><c:out value="${prodList.serial_no}"/></td>
                        <td name="size_expl"><c:out value="${prodList.size_expl}"/></td>
                        <td name="qty"><c:out value="${prodList.qty}"/></td>
                        <td name="prod_sts" code="${prodList.prod_sts}"><c:out value="${prodList.prod_sts_nm}"/></td>
                        <td name="prod_ym"><c:out value="${prodList.prod_ym}" /></td>
                        <td name="buy_dt"><c:out value="${prodList.buy_dt}" /></td>
                        <td name="disuse_dt"><c:out value="${prodList.disuse_dt}" /></td>
                    </tr> 
                </c:forEach>
                </tbody>
            </table>
        </div>
    </form>
</div>
