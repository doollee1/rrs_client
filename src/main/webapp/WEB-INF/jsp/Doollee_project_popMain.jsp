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
  <link href="resrc/css/common.css" rel="stylesheet">
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
  <link href="resrc/vendor/bootstrap/css/datepicker3.css" rel="stylesheet">  <!-- date picker 관련 import -->
  <script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.js"></script>     <!-- date picker 관련 import -->
  <script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.kr.js"></script>  <!-- date picker 관련 import -->
</head>

<script>
    // 조회
    function selectList(){
  	  
  	  $.ajax({
			type:"GET",
			url:"selectProjectList.do",
			data:{
				     projectNm  : $("#projectNm").val(),
				     from_dt    : $("#from_dt").val(),
				     to_dt      : $("#to_dt").val()
				 },
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			success:function(data){
				$("#projectListArea").css("display","block");
				$("#projectListArea").html(data);
				
			},
			error:function(data){
				console.log("조회중 오류가 발생하였습니다.");
			}
		});
  	  
    }
    
    function closePop(){
  	  $("#projectSelPop").css("display","none");
  	  $("#projectSelPop").html('');
  	  
    }
    
    function pressEnter(){
    	selectList();
    	return;
    }
    
    function getFormatDate(date){
    	var year = date.getFullYear();              //yyyy
        var month = (1 + date.getMonth());          //M
        month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
        var day = date.getDate();                   //d
        day = day >= 10 ? day : '0' + day;          //day 두자리로 저장
        return  year + '-' + month + '-' + day;

        
    }
    
    $(document).ready(function(){
    	var toDate = new Date();
    	var year = toDate.getFullYear()-1; 
    	var month = toDate.getMonth()+1;
    	var day = toDate.getDate();
    	
    	
        var fromDate = new Date(year+'-'+month+'-'+day);
    	$('#projectSelPop .date').datepicker({
    	    format: "yyyy-mm-dd",
    	    language: "kr",
    	    autoclose : true
    	    
    	});
    	
    	$('#from_dt').val(getFormatDate(fromDate));
        $('#to_dt').val(getFormatDate(toDate));
        
    	selectList();
    });

</script>

<!--navigation-->
  
<div class="modal-content-s">
<!--     <form name="sentMessage" id="userForm" action="" method="post" > -->
  
        <div class="data-top">
	      <div class="left">
	        <p class="tit-type3">프로젝트찾기 </p>
	      </div>
	      <div class="right">
	       <input class="btn-type3 type3 min-size3" type="button" value="조회" onclick="selectList();" >
	       <input class="btn-type3 type3 min-size3" type="button" value="닫기" onclick="closePop()" >
	      </div>    
        </div>
        <!-- data-st1 -->
        
        <div class="data-pop-reg">
            <table>
		        <colgroup >
		            <col style="width:15%" />
		            <col style="width:20%" />
		            <col style="width:15%" />
		            <col style="width:auto" />
		        </colgroup >
              	<tr>
                    <th>프로젝트명</th>
                	<td scope="col" style="border-right:hidden !important">
                    	<input type="text" id="projectNm" class="chk" onkeypress="if(event.keyCode == 13) {pressEnter();}">
                    </td>
                    <th>프로젝트기간</th>
                	<td scope="col" style="border-right:hidden !important">
                    	<input type="text" id="from_dt" class="date" > ~
                    	<input type="text" id="to_dt"   class="date" >
                    </td>
                </tr>
            </table>
      </div>
      <!-- // data-st2 -->
      <div id="projectListArea" style="display:none;" ></div>    
      
<!--     </form> -->
    
    
</div>
