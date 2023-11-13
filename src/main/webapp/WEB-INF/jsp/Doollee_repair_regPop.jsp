<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<head>
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<title>(주)둘리정보통신</title>
<!-- Bootstrap core CSS -->
<link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">   
<link href="resrc/vendor/bootstrap/css/datepicker3.css" rel="stylesheet">  <!-- date picker 관련 import -->
<!--css-->
<link href="resrc/css/common.css" rel="stylesheet">
<!--script-->
<script src="resrc/js/includeHTML.js"></script>
<script src="resrc/vendor/jquery/jquery.js"></script>
<script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.js"></script>     <!-- date picker 관련 import -->
<script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.kr.js"></script>  <!-- date picker 관련 import -->

<link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">

<script>
function insertList(){
	if($("#prodRegForm #prod_no").val()==""){
		  alert("장비번호를 선택해주세요.");
	}else if($("#prodRegForm #repair_st_dt").val()==""){
		  alert("수리요청 일자를 입력해주세요.");
	}else if(($("#prodRegForm #repair_gbn").val()=="2")&&($("#prodRegForm #repair_ed_dt").val()=="")){
		  alert("수리완료 날짜를 입력해주세요.");
	}else{
		  if(pop_gbn=="insert"){
			  //var param = $("#prodRegForm").serialize();
		      $.ajax({
				url : "insertProdRepair.do",
				data : //param,
					{
						prod_no : $("#prodRegForm #prod_no").val(),
						repair_gbn : $("#prodRegForm #repair_gbn").val(),
						repair_st_dt : $("#prodRegForm #repair_st_dt").val(),
						repair_ed_dt : $("#prodRegForm #repair_ed_dt").val(),
						repair_comp : $("#prodRegForm #repair_comp").val(),
						repair_fee : $("#prodRegForm #repair_fee").val(),
						repair_expl : $("#prodRegForm #repair_expl").val(),
		    	  		remark : $("#prodRegForm #remark").val()
	    	  		},
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				type : "POST",
				success : function(result) {
					$("#regArea").css("display","none");
					$("#regArea").html("");
					alert("저장되었습니다.");
					selectList();
				},
				error : function(e) {
					alert(e.responseText);
				}
		      });
		  }else if(pop_gbn=="update"){
			  $.ajax({
				url : "updateProdRepair.do",
				data : //param,
					{
						prod_no : $("#prodRegForm #prod_no").val(),
						SEQ : $("#prodRegForm #SEQ").val(),
						repair_gbn : $("#prodRegForm #repair_gbn").val(),
						repair_st_dt : $("#prodRegForm #repair_st_dt").val(),
						repair_ed_dt : $("#prodRegForm #repair_ed_dt").val(),
						repair_comp : $("#prodRegForm #repair_comp").val(),
						repair_fee : $("#prodRegForm #repair_fee").val(),
						repair_expl : $("#prodRegForm #repair_expl").val(),
		    	  		remark : $("#prodRegForm #remark").val()
	    	  		},
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				type : "POST",
				success : function(result) {
					$("#regArea").css("display","none");
					$("#regArea").html("");
					alert("저장되었습니다.");
					selectList();
				},
				error : function(e) {
					alert(e.responseText);
				}
		      });
		  }
	}
}

function deleteList(delyn) {
	if(confirm("정말로 삭제 하시겠습니까?")){
		if(pop_gbn=="update") {
			$.ajax({
				url : "updateYnProdRepair.do",
				data : {prod_no : $("#prodRegForm #prod_no").val(),
						SEQ : $("#prodRegForm #SEQ").val(),
						del_yn : delyn},
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				type : "POST",
				success : function(result) {
						$("#regArea").css("display","none");
		  				$("#regArea").detach(result);
				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		}
	}else{
		//삭제하지 않음
	}
}

function chageGbnSelect(selectValue){
	if(selectValue == '2') {
		var d = new Date();

	    var date = leadingZeros(d.getFullYear(), 4) + '-' +
	        leadingZeros(d.getMonth() + 1, 2) + '-' +
	        leadingZeros(d.getDate(), 2) + ' ';
	    
		$("#repair_ed_dt").attr("disabled", false);
		$("#repair_ed_dt").val(date);
	} else {
		$("#repair_ed_dt").val("");
		$("#repair_ed_dt").attr("disabled", true);
	}
}

function select_prod_pop() {
  $.ajax({
		url : "prodSelPop.do",
		data : null,
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		type : "POST",
		success : function(result) {
			selPop_gbn = "update";
			$("#prodSelPop").css("display","block");
			$("#prodSelPop").html(result);
		},
		error : function(e) {
			alert(e.responseText);
		}
      });
}

$('.date').datepicker({
    format: "yyyy-mm-dd",
    language: "kr",
    autoclose : true
    
});


function init_pop()
{
	$("#prodRegForm table input").val("");
	$("#prodRegForm option:selected").removeAttr("selected");
}

/* 퀵메뉴 창닫기 기능 */ 
function winClose()
{
	$("#regArea").css("display","none");
	selPop_gbn = "select";
}

$(document).ready(function() {
	if(pop_gbn=="insert") {
		$("#prodRegForm .right > input:eq(0)").css("display","inline");
		$("#sel_prod_pop").css("display","display");
		getTimeStamp();
	}else if(pop_gbn=="update") {
		$("#prodRegForm .right > input:eq(2)").css("display","inline");
		$("#sel_prod_pop").css("display","none");
	}
	
	if($("#repair_fee").val()=="") {
		$("#repair_fee").val("0");
	}
	
});

function getTimeStamp() {
    var d = new Date();

    var date = leadingZeros(d.getFullYear(), 4) + '-' +
        leadingZeros(d.getMonth() + 1, 2) + '-' +
        leadingZeros(d.getDate(), 2) + ' ';

    $('#repair_st_dt').val(date);
}

function leadingZeros(n, digits) {
    var zero = '';
    n = n.toString();

    if (n.length < digits) {
        for (i = 0; i < digits - n.length; i++)
            zero += '0';
    }
    return zero + n;
}

</script>

</head>

<div class="modal-content-s">
    <form name="sentMessage" id="prodRegForm" action="" method="post" >
    
      <div class="data-top">
        <div class="left">
          <p class="tit-type3">${modal_title}</p>
        </div>
        <div class="right">
          <input class="btn-type3 type3 min-size3" type="button" value="초기화" onclick="init_pop();" style="display: none;">
          <input class="btn-type3 type3 min-size3" type="button" value="저장" onclick="insertList();" >
          <input class="btn-type3 type3 min-size3" type="button" value="삭제" onclick="deleteList('Y');" style="display: none;">
          <input class="btn-type3 type3 min-size3" type="button" value="닫기" onclick="winClose();" >
        </div>
      </div>
      
      <!-- data-st2 -->
      <div class="data-pop-reg">
      	<input type="text" id="SEQ" name="seq" class="chk" value="${SEQ}" style="display: none;">
        <table>
          <colgroup >
            <col style="width:15%" />
            <col style="width:35%" />
            <col style="width:15%" />
            <col style="width:auto" />
          </colgroup >
          <tr>
            <th>장비번호 <span class="essential">*</span></th>
            <td scope="col" >
                <div style="display:flex;">
                    <input type="text" style="width: 100%" id="prod_no" name="prod_no" class="chk" value="${prod_no}" disabled="disabled">
                    <input id="sel_prod_pop" onclick="select_prod_pop()" class="btn-type3 type3 min-size3" type="button" value="찾기">
                </div>              
            </td>
            <th>수리구분 <span class="essential">*</span></th>
            <td scope="col" style="border-right:hidden !important">
                <select id="repair_gbn" name="repair_gbn" class="chk" size="1"  onchange="chageGbnSelect(this.value)">
                    <!-- <option value="">전체</option> -->
                    <c:forEach var="repair_gbn_list" items="${repair_gbn_list}" varStatus="i">
                        <option value="${repair_gbn_list.simp_c}" <c:if test="${repair_gbn_list.simp_cnm == repair_gbn}">selected</c:if>>${repair_gbn_list.simp_cnm}</option>
                    </c:forEach>
                </select>
            </td>            
          </tr>
          <tr>
            <th>수리처</th>
            <td scope="col" style="border-right:hidden !important">
                <input type="text" id="repair_comp" name="repair_comp" class="chk" value="${repair_comp}" maxlength="100">
            </td>
            <th>수리요청일자</th>
            <td scope="col" style="border-right:hidden !important">
                <input type="text" id="repair_st_dt" class="date" name="repair_st_dt" class="chk" value="${repair_st_dt}">
            </td>
          </tr>
          <tr>
            <th>수리비</th>
            <td scope="col" style="border-right:hidden !important">
                <input type="text" id="repair_fee" name="repair_fee" class="chk" value="${repair_fee}" maxlength="7" >&ensp;원
            </td>
            <th>수리완료일자</th>
            <td scope="col" style="border-right:hidden !important">
                <input type="text" id="repair_ed_dt" class="date" name="repair_ed_dt" class="chk" value="${repair_ed_dt}"  disabled="disabled">
            </td>
          </tr>
          <tr>
            <th>수리내용</th>
            <td scope="col" style="border-right:hidden !important" colspan="3">
                <input type="text" id="repair_expl" name="repair_expl" class="chk"  value="${repair_expl}" maxlength="1000"> 
            </td>           
          </tr>
          <tr>
            <th>비고</th>
            <td scope="col" style="border-right:hidden !important" colspan="3">
                <input type="text" id="remark" name="remark" class="chk"  value="${remark}" maxlength="1000"> 
            </td>           
          </tr>
        </table>
      </div>
      <!-- // data-st2 -->
   </form>

  </div>