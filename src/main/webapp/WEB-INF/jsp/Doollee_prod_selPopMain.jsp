<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>

<head>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <title>(주)둘리정보통신</title>
  <!-- Bootstrap core CSS -->
  <link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
  <!-- Custom styles for this template -->
  <!-- <link href="css/modern-business.css" rel="stylesheet"> -->
  <!--css-->
  <link href="resrc/css/common.css" rel="stylesheet">
  <!-- <link href="css/Project_actual.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>

<script>
    // 조회
    function selectListPop(){
  	  $.ajax({
			type:"POST",
			url:"selectProdInfoPop.do",
			data:{
				  "prod_no" : $("#prodSelForm #prod_no").val(),
				  "prod_gbn": $("#prodSelForm #prod_gbn").val(),
				  "prod_sts": $("#prodSelForm #prod_sts").val(),
				  "trans_gbn": '${trans_gbn}'
				 },
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			success:function(data){
				$("#PoplistArea").css("display","block");
				$("#PoplistArea").html(data);
			},
			error:function(data){
				console.log("조회중 오류가 발생하였습니다.");
			}
		});
    }
    
    function closePop(){
  	  $("#prodSelPop").css("display","none");
  	  $("#prodSelPop").html("");
    }
    
    $(document).ready(function(){
    	if('${trans_gbn}' == 2 || '${trans_gbn}' == 3 || '${trans_gbn}' == 4 ){
    		$("#prodSelForm #prod_sts").attr("disabled", true);
    		$("#prodSelForm #prod_sts").val("2");
    	} else if('${trans_gbn}' == 1){
	    	$("#prodSelForm #prod_sts").val('${trans_gbn}');
    		$("#prodSelForm #prod_sts").attr("disabled", true);
    	} else {
	    	$("#prodSelForm #prod_sts").val(""); // 전체 찾기
    	}
    	if(prod_sts != null && prod_sts == '5') {
    		if(selPop_gbn == "update"){
    			$("#prodSelForm #prod_sts").val("5");  // 고장
    			$("#prodSelForm #prod_sts").attr("disabled", true);
    		} else if(selPop_gbn == "select"){
    			$("#prodSelForm #prod_sts").val('6');	// 수리중
    			$("#prodSelForm #prod_sts").attr("disabled", true);
    		}
    	}
    	selectListPop();
    });

</script>

<!--navigation-->

<div class="modal-content">
	<form name="sentMessage" id="prodSelForm" style="overflow: auto" method="post">

		<div class="data-top">
			<div class="left">
				<p class="tit-type3">장비찾기</p>
			</div>
			<div class="right">
				<input class="btn-type1 type1 min-size1" type="button" value="조회" onclick="selectListPop();">
				<input class="btn-type1 type1 min-size1" type="button" value="닫기" onclick="closePop();">
			</div>
		</div>
		<!-- data-st1 -->

		<div class="data-pop-reg">
			<table>
				<colgroup>
					<col style="width: 20%" />
					<col style="width: 30%" />
					<col style="width: 20%" />
					<col style="width: auto" />
				</colgroup>
				<tr>
					<th>장비번호</th>
					<td>
                        <input type="text" style="width: 100%" id="prod_no" name="prod_no" class="chk" value="">
					</td>
				</tr>
				<tr>
					<th>제품구분</th>
					<td scope="col" style="border-right: hidden !important">
						<select id="prod_gbn" name="prod_gbn" class="chk" size="1">
							<option value="">전체</option>
							<c:forEach var="prod_gbn_list" items="${prod_gbn_list}" varStatus="i">
								<option value="${prod_gbn_list.simp_c}">${prod_gbn_list.simp_cnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>장비상태</th>
					<td scope="col" style="border-right: hidden !important">
						<select id="prod_sts" name="prod_sts" class="chk" size="1">
							<option value="">전체</option>
							<c:forEach var="prod_sts_list" items="${prod_sts_list}" varStatus="i">
								<option value="${prod_sts_list.simp_c}">${prod_sts_list.simp_cnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<!-- // data-st2 -->
		<div id="PoplistArea" style="display: none;"></div>
	</form>
</div>