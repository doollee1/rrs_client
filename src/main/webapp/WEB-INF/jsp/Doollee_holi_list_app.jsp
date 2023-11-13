<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<style>
.listDiv { border : 1px solid #acacac;
           width  : calc(100% - 6px);
           height : fit-content;
           border-radius: 5px;
           margin : 10px 3px;
           padding: 10px 15px 12px;
         }
.apprGbn { float      : right;
           margin-left: 10px;
           font-weight: bolder;
         }
.apprGbn01 { color : forestgreen; }
.apprGbn02 { color : blue; }
.apprGbn09 { color : crimson; }
.holiTp  { float: right;
           color: orange;
           font-weight: bolder;
         }
</style>

<div class="data-st4">
    <c:if test="${holiList == ''}">
        <div class="data-st4" style="text-align:center;padding:50px 0px;color:silver">조회된 내용이 없습니다.</div>
    </c:if>
    <c:if test="${holiList != ''}">
        <c:forEach items="${holiList}" var="holiList" varStatus="status">
            <div class="listDiv" holi_seq="${holiList.holi_seq}" onclick="fn_listClick(this)">
                <div>
                    <span>
                        <c:out value="${holiList.holi_st_dt}"/> ~ <c:out value="${holiList.holi_ed_dt}"/> (${holiList.holi_dayNum}일)
                    </span>
                    <span class="apprGbn apprGbn${holiList.appr_gbn}">${holiList.appr_gbn_nm}</span>
                    <span class="holiTp" >${holiList.holi_tp_nm}</span>
                </div>
                <div style="margin-top: 15px; width: 100%; text-align: right;">
                    <span>신청자 <font style="color: chocolate; font-weight: bolder;">${holiList.requestor_nm}</font></span>
                    <span style="margin-left: 10px;">승인자 <font style="color: darkviolet;font-weight: bolder;">${holiList.approver_nm}</font></span>
                    <span style="margin-left: 10px;">요청일 <font style="color: cornflowerblue;font-weight: bolder;">${holiList.request_dt}</font></span>
                </div>
                <c:if test="${holiList.appr_gbn != '01'}">
                    <div style="margin-top: 5px; width: 100%; text-align: right;">
                        <span style="margin-left: 10px;">
                            <c:if test="${holiList.appr_gbn == '02'}"><font>승인일</font> </c:if>
                            <c:if test="${holiList.appr_gbn == '09'}"><font>반려일</font> </c:if>
                            <font class="apprGbn${holiList.appr_gbn}" style="font-weight: bolder;">${holiList.appr_dt}</font>
                        </span>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </c:if>
</div>

<script>
//$(document).off("click", ".listDiv");
//$(document).on ("click", ".listDiv", function() {
//    updateView( $(this).attr("holi_seq") );
//});
function fn_listClick( obj ) {
    updateView( $(obj).attr("holi_seq") );
}
</script>
