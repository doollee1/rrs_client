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
	  if(pop_gbn=="insert"){
		  if($("#transRegForm #prod_no").val()=="") {
			  alert("장비 번호를 입력해주세요.");
			  return;
		  } else if($("#transRegForm #trans_project").val()=="") {
			  alert("인계 프로젝트를 입력해주세요.");
			  return;
		  } else if($("#transRegForm #take_project").val()=="") {
			  alert("인수 프로젝트를 입력해주세요.");
			  return;
		  } else if($("#transRegForm #trans_dt").val()=="") {
			  alert("인계일자를 입력해주세요.");
			  return;
	      } else if($("#transRegForm #take_user_name").val()=="") {
			  alert("인수자를 입력해주세요.");
			  return;
		  } else {
			  var param = $("#transRegForm").serializeArray();
			  param.push({name:"prod_no", value: $("#transRegForm #prod_no").val()});
			  param.push({name:"take_sts", value: $("#transRegForm #take_sts").val()});//disabled 처리
			  param.push({name:"trans_gbn", value: $("#transRegForm #trans_gbn").val()});//disabled 처리
			  param.push({name:"trans_project", value: $("#transRegForm #trans_project").val()});
			  param.push({name:"take_project", value: $("#transRegForm #take_project").val()});
			  //var asd = $("#transRegForm #trans_gbn option:selected").val();
		      $.ajax({
				url : "insertTransTake.do",
				data : param,
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				type : "POST",
				success : function(result) {
					selectListMain();
					alert("저장되었습니다.");
					$("#regArea").css("display","none");
					$("body").css("overflow" , "");
					$("#regArea").html("");
				},
				error : function(e) {
					alert(e.responseText);
				}
		      });
		  }
	  }else if(pop_gbn=="update"){
		  //alert("prod_no ::: " + $("#transRegForm #prod_no").val());
		  var param = $("#transRegForm").serializeArray();
		  param.push({name:"trans_gbn", value: $("#transRegForm #trans_gbn").val()});//disabled 처리
		  param.push({name:"trans_dt", value: $("#transRegForm #trans_dt").val()});//disabled 처리
		  param.push({name:"take_dt", value: $("#transRegForm #take_dt").val()});//disabled 처리
		  param.push({name:"take_sts", value: $("#transRegForm #take_sts").val()});//disabled 처리
		  //param.push({name:"prod_no", value: $("#transRegForm #prod_no").val()});
		  //param.push({name:"trans_project", value: $("#transRegForm #trans_project").val()});
		  //param.push({name:"take_project", value: $("#transRegForm #take_project").val()});
		  //param.push({name:"SEQ", value: $("#transRegForm #SEQ").val()});
	      $.ajax({
			url : "updateTransTake.do",
			data : param,
				/*{
					prod_no : $("#transRegForm #prod_no").val(),
					SEQ : $("#transRegForm #SEQ").val(),
					repair_gbn : $("#transRegForm #repair_gbn").val(),
					repair_st_dt : $("#transRegForm #repair_st_dt").val(),
					repair_ed_dt : $("#transRegForm #repair_ed_dt").val(),
					repair_comp : $("#transRegForm #repair_comp").val(),
					repair_fee : $("#transRegForm #repair_fee").val(),
					repair_expl : $("#transRegForm #repair_expl").val(),
	    	  		remark : $("#transRegForm #remark").val()
    	  		},*/
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			type : "POST",
			success : function(result) {
                				
				$("#regArea").css("display","none");
				$("body").css("overflow" , "");
				$("#regArea").html("");
				alert("저장되었습니다.");
				
				$("#prodTransForm #btnSearch").trigger("click");
			},
			error : function(e) {
				alert(e.responseText);
			}
	      });
	  }
}

function deleteList(delyn) {//'Y'
	if(confirm("정말로 삭제 하시겠습니까?")){
		if(pop_gbn=="update") {
			$.ajax({
				url : "updateYnTransTake.do",
				data : {prod_no : $("#transRegForm #prod_no").val(),
						SEQ : $("#transRegForm #SEQ").val(),
						trans_gbn : $("#transRegForm #trans_gbn option:selected").val(),
						del_yn : delyn},
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				type : "POST",
				success : function(result) {
		  				selectListMain();
						$("#regArea").css("display","none");
						$("body").css("overflow" , "");
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
		$("#transRegForm #take_user_name").val("");
		$("#transRegForm #take_user_id").val("");
		$("#transRegForm #take_project_nm").val("");
		$("#transRegForm #take_project").val("");
	} else if(selectValue == '3'||selectValue == '4'){
		$("#transRegForm #take_user_name").val("본사");
		$("#transRegForm #take_user_id").val("admin");
		$("#transRegForm #take_project_nm").val("본사");
		$("#transRegForm #take_project").val("0");
	}
}

function select_prod_pop() {
  $.ajax({
		url : "prodSelPop.do",
		data : {"trans_gbn" : $("#transRegForm #trans_gbn option:selected").val()},
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		type : "POST",
		success : function(result) {
			selPop_gbn = "insert";
			$("#prodSelPop").css("display","block");
			$("#prodSelPop").html(result);
		},
		error : function(e) {
			alert(e.responseText);
		}
      });
}

function init_pop()
{
	$("#transRegForm table input").not("input[type=button]").val("");
	$("#transRegForm option:selected").removeAttr("selected");
}

/* 퀵메뉴 창닫기 기능 */ 
function winClose()
{
	$("#regArea").css("display","none");
	$("body").css("overflow" , "");
	selPop_gbn = "select";
}

var userPopTitle;
function callUsrPop(objId){//trans_user or take_user
	userPopTitle = objId; 
	$.ajax({
			url : "userPop.do",
			data : null,
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			type : "POST",
			success : function(result) {
				$("#userSelPop").css("display","block");
				$("#userSelPop").html(result);
			},
			error : function(e) {
				alert(e.responseText);
			}
	      });
  }

function selectUser(mb_id, mb_name){
    $('#transRegForm #'+userPopTitle+'_id').val(mb_id);
    $('#transRegForm #'+userPopTitle+'_name').val(mb_name);
	$("#userSelPop").css("display","none");
	
}
//장비번호 찾기 버튼 보이거나 안보이게 하기
$(document).ready(function() {
	if(pop_gbn=="insert") {
		

		
		$('#transRegForm #trans_dt').datepicker({
		    format: "yyyy-mm-dd",
		    language: "kr",
		    autoclose : true,
		});
		/*$('#transRegForm .date').datepicker({
		    format: "yyyy-mm-dd",
		    language: "kr",
		    autoclose : true,
		});*/
		$("#transRegForm .right > input:eq(0)").css("display","inline");
		getTimeStamp();
		$('#transRegForm #trans_dt').datepicker('setDate', 'today'); // 오늘 날짜로 세팅
		//$('#transRegForm #take_dt').datepicker('setDate', 'today'); // 오늘 날짜로 세팅
		$("#transRegForm #trans_dt").attr("readonly", true);//적용 안됨
		$("#transRegForm #take_dt").attr("readonly", true);//적용 안됨
		$("#transRegForm #take_sts").val('1');  // 인수진행중
		$("#transRegForm #take_sts").attr("disabled", true);
		//$("#transRegForm #trans_gbn").attr("disabled", true);
		//$("#transRegForm #take_gbn").attr("disabled", true);
		checkLoginUser();
		
	}else if(pop_gbn=="update") {
		$('#transRegForm #take_dt').datepicker({
		    format: "yyyy-mm-dd",
		    language: "kr",
		    autoclose : true,
		});
		$("#transRegForm .right > input:eq(2)").css("display","inline");
		$("#transRegForm #trans_dt").attr("disabled", true);
		$("#transRegForm #take_dt").attr("disabled", true);//적용 안됨
		$("#transRegForm #take_sts").attr("disabled", true);
		$("#transRegForm #trans_gbn").attr("disabled", true);
		$("#transRegForm #remark").attr("disabled", true);
		$("#transRegForm #prod_no + input").attr("disabled", true);
		$("#transRegForm #trans_user_name + input").attr("disabled", true);
		$("#transRegForm #take_user_name + input").attr("disabled", true);
		$("#transRegForm #trans_project_nm + input").attr("disabled", true);
		$("#transRegForm #take_project_nm + input").attr("disabled", true);
		$("#transRegForm #take_place").attr("disabled", true);
		if($("#transRegForm #take_user_id").val() == '${sessionScope.usrid }' && $("#transRegForm #take_sts").val() == "1") {
			$("#transRegForm #take_dt").attr("disabled", false);
			$("#transRegForm #take_sts").attr("disabled", false);
			$("#transRegForm #remark").attr("disabled", false);
			$("#transRegForm #take_place").attr("disabled", false);
			$("#transRegForm .right > input:eq(2)").css("display","none");
			$('#transRegForm #take_dt').datepicker('setDate', 'today'); // 오늘 날짜로 세팅
			$("#transRegForm #take_sts").val(2);
		} else if($("#transRegForm #trans_user_id").val() == '${sessionScope.usrid }') {
			$("#transRegForm .right > input:eq(2)").css("display","inline");
		}
	}
	//$("#transRegForm #trans_user_name + input").attr("disabled", true);//인계자 찾기 버튼 무효화
});

function getTimeStamp() {
    var d = new Date();

    var date = leadingZeros(d.getFullYear(), 4) + '-' +
        leadingZeros(d.getMonth() + 1, 2) + '-' +
        leadingZeros(d.getDate(), 2) + ' ';
    //$('transRegForm #trans_dt').val(date);
    //$('transRegForm #take_dt').val(date);
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

var projectObj;
function callProjectPop(objId){
	 projectObj = objId;
	 $.ajax({
			url : "callProjectPop.do",
			data : null,
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			type : "POST",
			success : function(result) {
				selPop_gbn = "trans";
				$("#projectSelPop").css("display","block");
				$("#projectSelPop").html(result);
			},
			error : function(e) {
				alert(e.responseText);
			}
	      });
}

function selectProject(project_no, project_nm){
	 $("#transRegForm #"+projectObj).val(project_no);
	 $("#transRegForm #"+projectObj+"_nm").val(project_nm);
	 $("#projectSelPop").css("display","none");
}

function checkLoginUser() {
	var log_in = '${sessionScope.login}';
	var usr_nm = '${sessionScope.login.mb_name}';
	var usr_id = '${sessionScope.usrid }';
	var usr_lvl = '${sessionScope.usrlvl }';
	var login_Yn = '${sessionScope.loginYn }';
	var workNm  = '${sessionScope.login.mb_workNm}';
	var project_No = '${sessionScope.projectNo }';
	var project_PlYn = '${sessionScope.projectPlYn }';

	if(usr_lvl == "0") {//admin(관리자) 일 때
		$("#transRegForm #trans_gbn").val(1);//본사인계
		//$("#transRegForm #trans_gbn").attr("disabled", true);
	}else if(usr_lvl == "1"){
		$("#transRegForm #trans_gbn").children('option:first').remove();
	}else if(usr_lvl == "2"){
		alert("lvl 2");
	}
	
	$("#transRegForm #trans_user_name").val(usr_nm);
	$("#transRegForm #trans_user_id").val(usr_id);
	
	$("#transRegForm #trans_project").val(project_No);
	$("#transRegForm #trans_project_nm").val(workNm);

		
	
}

</script>

</head>

<div class="modal-content-s">
    <form name="sentMessage" id="transRegForm" action="" method="post" >
    
      <div class="data-top">
        <div class="left">
          <p class="tit-type3">${modal_title}</p>
        </div>
        <div class="right">
          <input class="btn-type3 type3 min-size3" type="button" value="초기화" onclick="init_pop();" style="display: none;">
          <input class="btn-type3 type3 min-size3" type="button" value="저장" onclick="insertList();" >
          <input class="btn-type3 type3 min-size3" type="button" value="삭제" onclick="deleteList('1');" style="display: none;">
          <input class="btn-type3 type3 min-size3" type="button" value="닫기" onclick="winClose();" >
        </div>
      </div>
      
      <!-- data-st2 -->
      <div class="data-pop-reg">
      	<input type="text" id="SEQ" name="SEQ" class="chk" value="${SEQ}" style="display: none;">
        <table>
          <colgroup >
            <col style="width:13%" />
            <col style="width:37%" />
            <col style="width:13%" />
            <col style="width:auto" />
          </colgroup >
          <tr>
            <th>인수/인계 구분 <span class="essential">*</span></th>
            <td scope="col" style="border-right:hidden !important">
                <select id="trans_gbn" name="trans_gbn" class="chk" size="1" onchange="chageGbnSelect(this.value)">
                    <!-- <option value="">전체</option> -->
                    <c:forEach var="trans_gbn_list" items="${trans_gbn_list}" varStatus="i">
                        <option value="${trans_gbn_list.simp_c}" <c:if test="${trans_gbn_list.simp_cnm == trans_gbn}">selected</c:if>>${trans_gbn_list.simp_cnm}</option>
                    </c:forEach>
                </select>
            </td>
            <th>장비번호 <span class="essential">*</span></th>
            <td scope="col" >
                <div style="display:flex;">
                    <input type="text" style="width: 100%" id="prod_no" name="prod_no" class="chk" value="${prod_no}" readonly>
                    <input id="sel_prod_pop" onclick="select_prod_pop()" class="btn-type3 type3 min-size3" type="button" value="찾기">
                </div>              
            </td>
          </tr>
          <tr>
            <th>인계일자</th>
            <td scope="col" style="border-right:hidden !important">
                <input type="text" id="trans_dt" name="trans_dt" class="chk date" value="${trans_dt}">
	        </td>
            <th>인계자</th>
            <td scope="col" style="border-right:hidden !important">
	            <div style="display:flex;">
	                <input type="text" id="trans_user_name" name="trans_user_name" class="chk" <c:if test="${trans_user_name != null}">value="${trans_user_name}"</c:if> readonly>
	                <!-- value="${trans_user_name} -->
	           	    <input onclick="callUsrPop(this.title)" class="btn-type3 type3 min-size3" type="button" value="찾기" title="trans_user">
	        	    <input type="text" id="trans_user_id" name="trans_user_id" class="chk" <c:if test="${trans_user_id != null}">value="${trans_user_id}"</c:if> style="display: none;">
	        	</div>
            </td>
          </tr>
          <tr>
            <th>인수일자</th>
            <td scope="col" style="border-right:hidden !important">
                <input type="text" id="take_dt" name="take_dt" class="chk date" value="${take_dt}">
            </td>
            <th>인수자</th>
            <td scope="col" style="border-right:hidden !important">
	            <div style="display:flex;">
	                <input type="text" id="take_user_name" name="take_user_name" class="chk" value="${take_user_name}" readonly>
	        	    <input onclick="callUsrPop(this.title)" class="btn-type3 type3 min-size3" type="button" value="찾기" title="take_user">
	           	    <input type="text" id="take_user_id" name="take_user_id" class="chk" value="${take_user_id}" style="display: none;">
           	    </div>
            </td>
          </tr>
          <tr>
            <th>인계프로젝트</th>
            <td scope="col" style="border-right:hidden !important">
                <input type="text" style="width: 15%" id="trans_project" name="trans_project" class="chk"   value="${trans_project}" readonly>
                <input type="text" style="width: 55%" id="trans_project_nm" name="trans_project_nm" class="chk" value="${trans_project_nm}" readonly>
                <input onclick="callProjectPop(this.title)" style="width:auto;" class="btn-type3 type3 min-size3" type="button" value="찾기" title="trans_project"> 
            </td>
            <th>인수프로젝트</th>
            <td scope="col" style="border-right:hidden !important">
                <input type="text" style="width: 15%" id="take_project" name="take_project" class="chk" value="${take_project}" readonly>
                <input type="text" style="width: 55%" id="take_project_nm" name="take_project_nm" class="chk" value="${take_project_nm}" readonly>
                <input onclick="callProjectPop(this.title)" style="width:auto" class="btn-type3 type3 min-size3" type="button" value="찾기" title="take_project"> 
            </td>           
          </tr>
          <tr>
          	<th>인수상태 <span class="essential">*</span></th>
            <td scope="col" style="border-right:hidden !important">
              <select id="take_sts" name="take_sts" class="chk" size="1">
                <!-- <option value="">전체</option> -->
                <c:forEach var="take_sts_list" items="${take_sts_list}" varStatus="i">
                      <option value="${take_sts_list.simp_c}" <c:if test="${take_sts_list.simp_cnm == take_sts}">selected</c:if>>${take_sts_list.simp_cnm}</option>
                </c:forEach>
              </select>
            </td>
            <th>인수장소</th>
            <td scope="col" style="border-right:hidden !important">
              <input type="text" id="take_place" name="take_place" class="chk" value="${take_place}">
            </td>
          </tr>
          <tr>
          	<th>비고</th>
          	<td scope="col" style="border-right:hidden !important" colspan="3">
                <input type="text" id="remark" name="remark" class="chk"  value="${remark}"> 
            </td>  
          </tr>
        </table>
      </div>
      <!-- // data-st2 -->
   </form>
   <div id="subArea">
      <div id="userSelPop" style="display:none; z-index : 2" class="modal"></div>
  </div>
  </div>
  
  