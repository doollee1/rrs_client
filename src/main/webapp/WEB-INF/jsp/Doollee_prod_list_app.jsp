<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<style>
.listDiv { border : 1px solid #acacac;
           width  : calc(100% - 6px);
           height : fit-content;
           border-radius: 5px;
           margin : 15px 3px;
           padding: 3px;
           color  : gray;
         }
         
.key-style { 
    position: relative;
    top: -21px;
    margin-bottom: -10px;
    background: white;
    width: fit-content;
    box-shadow: 0px 0px 5px 5px white;
    text-align: center;
    font-size: 12px;
    color: brown;
    font-weight: bolder;
}
         
.sts-code-style { float: right; font-weight:bold; color: orange; text-align:right; }
.sts-code-color-1, .sts-code-color-5, .sts-code-color-8 { color: dodgerblue; }
.sts-code-color-9                                       { color: crimson;    }

.prod-info-row { margin-bottom: 10px }

.listDiv > .back-color > div:not(.key-style):not(.prod-info-row) { margin-top: 5px; text-align: right; display: inline-block; width: 100%; }

.back-color { background: linear-gradient(45deg, orange, floralwhite, floralwhite, white, white, white, white, white); padding: 10px; }
.back-color-1, .back-color-5, .back-color-8 { background: linear-gradient(45deg, dodgerblue, floralwhite, floralwhite, white, white, white, white, white) }
.back-color-9 { background: linear-gradient(45deg, crimson, floralwhite, floralwhite, white, white, white, white, white) }
</style>

<div class="data-st4">
    <c:if test="${prodList == '[]'}">
        <div class="data-st4" style="text-align:center;padding:50px 0px;color:silver">조회된 내용이 없습니다.</div>
    </c:if>
    <c:if test="${prodList != '[]'}">
        <c:forEach items="${prodList}" var="prodList" varStatus="status">
            <div class="listDiv" onclick="fn_listClick(this)">
                <div class="back-color back-color-${prodList.prod_sts}">
                    <div class="key-style">${prodList.prod_no}</div>
                    <div class="prod-info-row">
                        <span style="font-weight:bolder; color:navy">
                            <c:out value="${prodList.prod_comp}"/> <c:out value="${prodList.prod_gbn_nm}"/> <c:out value="${prodList.model_nm}"/>
                        </span>
                        <span class="sts-code-style sts-code-color-${prodList.prod_sts}">
                            <c:out value="${prodList.prod_sts_nm}"/><c:if test="${prodList.prod_sts == '9'}">(${prodList.disuse_dt})</c:if>
                        </span>
                    </div>
                    <c:if test="${fn:trim(prodList.serial_no) != '' and fn:trim(prodList.serial_no) != null}">
                        <div>
                            <span>
                                <font style="font-weight:bold; color:darkviolet">Serial Number</font>
                                <label style="margin:0;margin-left:5px">${prodList.serial_no}</label>
                            </span>
                        </div>
                    </c:if>
                    <div>
                        <c:if test="${fn:trim(prodList.prod_ym) != '' and fn:trim(prodList.prod_ym.trim()) != null}">
                            <span>
                                <font style="font-weight:bold; color:cadetblue">제조년월</font>
                                <label style="margin:0;margin-left:5px">${prodList.prod_ym}</label>
                            </span>
                        </c:if>
                        <span style="margin-left:10px">
                            <font style="font-weight:bold; color:darkseagreen">구입일자</font>
                            <label style="margin:0;margin-left:5px">${prodList.buy_dt}</label>
                        </span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>
</div>

<script>
function fn_listClick( obj ) {
    updateView( $(obj).find(".key-style").text() );
}

$(window).resize( function() {
    $(".prod-info-row").each( function() {
        if($(this).prop("scrollHeight") > 30) {
            $(this).find("span").last().css("margin","5px 0 5px 10px");
        } else {
            $(this).find("span").last().css("margin","0   0 0   10px");
        }
    });
});
$(window).resize();
</script>
