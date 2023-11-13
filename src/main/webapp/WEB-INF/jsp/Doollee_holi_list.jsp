<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
.data-st3 thead th {padding:10px}
</style>

<script>
    $(document).off("click", "#tblList tbody tr");
	$(document).on ("click", "#tblList tbody tr", function() {
	    if( $(this).hasClass("nonSelect") ) return;
	    updateView( $(this).attr("holi_seq") );
	});
	
	$(window).resize( function() {
	    var listDiv = $("#tblList").parent();
	    $("footer").css("position", "fixed").css("width", "100%")
	               .css("top", "calc(100vh - "+ $("footer").innerHeight() +"px)");
	    listDiv.css("height", ($("footer").offset().top - listDiv.offset().top - 42) );
	});
	$(window).resize();
</script>

<div class="data-top" style="margin-top: 20px">
  <div class="left">
    <p class="tit-type3">조회결과 </p>  <!-- <span class="c-org">(*필수입력)</span> -->
  </div>
</div>
<div class="data-st3">
   <form class="form-horizontal scrollCat" id="listForm" style="overflow-x:scroll">
		<div class="scrollCat scrollDisible" style="overflow-y: scroll; width: fit-content; border-top:2px solid #1a1e40">
	    <table style="min-width: 850px;">
			<!-- 기본값 원하는최소값으로 지정-->
			<colgroup>
			    <col style="width:  90px" />  
			    <col style="width:  80px" />  
				<col style="width: 180px" />  
				<col style="width:  60px" />  
				<col style="width:  90px" />  
				<col style="width:  70px" />  
				<col style="width:  70px" /> 
			</colgroup>
			<thead>
				<tr>
					<th>요청일자</th>
					<th>휴가구분</th>
					<th>휴가일자</th>
					<th>신청구분</th>
					<th>승인/반려일자</th>
					<th>신청자</th>
					<th>승인자</th>
				</tr>
			</thead>
		</table>
		</div>
		<div class="scrollCat" style="overflow-y: scroll; width: fit-content; min-height: 150px">
	    <table style="min-width: 850px" id="tblList">
			<!-- 기본값 원하는최소값으로 지정-->
			<colgroup>  
				<col style="width:  90px" />
			    <col style="width:  80px" />  
				<col style="width: 180px" />  
				<col style="width:  60px" />  
				<col style="width:  90px" />  
				<col style="width:  70px" />  
				<col style="width:  70px" />  
			</colgroup>
			<tbody>
                <c:if test="${holiList == ''}">
                    <tr class="nonSelect">
                        <td colspan="7" style="border:0">
                            <div style="padding:40px 0;font-size:13px;color:burlywood">
                                <font>조회내용이 없습니다<br />조회조건을 확인해 주세요</font>
                            </div>
                        </td>
                    </tr>
                </c:if>
                <c:if test="${holiList != ''}">
			        <c:forEach items="${holiList}" var="holiList" varStatus="status">
			            <tr holi_seq="${holiList.holi_seq}" style="cursor:pointer">
			                <td class="align-c"><c:out value="${holiList.request_dt}"/></td>
			                <td class="align-c"><c:out value="${holiList.holi_tp_nm}"/></td>
			                <td class="align-c">
			                    <c:out value="${holiList.holi_st_dt}"/> ~ <c:out value="${holiList.holi_ed_dt}"/>
			                    (${holiList.holi_dayNum}일)
			                </td>
			                <td class="align-c"><c:out value="${holiList.appr_gbn_nm}"/></td>
			                <td class="align-c"><c:out value="${holiList.appr_dt}"/></td>
			                <td class="align-c"><c:out value="${holiList.requestor_nm}"/></td>
			                <td class="align-c"><c:out value="${holiList.approver_nm}"/></td>
			            </tr> 
			        </c:forEach>
			    </c:if>
			</tbody>
		</table>
		</div>
    </form>
</div>