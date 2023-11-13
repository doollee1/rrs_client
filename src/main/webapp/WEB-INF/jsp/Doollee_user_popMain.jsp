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
  <link href="resrc/css/common_admin.css" rel="stylesheet">
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>

<script>
    var user_pop_gbn = '${gubun}'; 
    
    // 조회
    function selectList(){
  	  $.ajax({
			type:"GET",
			url:"selectUserPop.do",
			data:{
				     userNm  : $("#userNm").val(),
				     gbn : user_pop_gbn
				 },
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			success:function(data){
				$("#userListArea").css("display","block");
				$("#userListArea").html(data);
			},
			error:function(data){
				console.log("조회중 오류가 발생하였습니다.");
			}
		});
    }
    
    function closePop(){
  	  $("#userSelPop").css("display","none");
  	  $("#userSelPop").html('');
    }
    
    function pressEnter(){
    	selectList();
    	return;
    }
    
    $(document).ready(function(){
    	selectList();
    });

</script>

<!--navigation-->
  
<div class="modal-content">
<!--     <form name="sentMessage" id="userForm" action="" method="post" > -->
	<div class="container">  
        <div class="data-top">
	      <div class="left">
	        <p class="tit-type3">사용자찾기 </p>
	      </div>
	      <div class="right">
	       <input class="btn-type1 type1 min-size1" type="button" value="조회" onclick="selectList();" >
	       <input class="btn-type1 type1 min-size1" type="button" value="닫기" onclick="closePop()" >
	      </div>    
        </div>
        <!-- data-st1 -->
        
        <div class="data-pop-reg data-st2">
            <table>
		        <colgroup >
		            <col style="width:20%" />
		            <col style="width:auto" />
		        </colgroup >
              	<tr>
                    <th>사용자명</th>
                	<td scope="col" style="border-right:hidden !important">
                    	<input type="text" id="userNm" class="chk" onkeypress="if(event.keyCode == 13) {pressEnter();}">
                    </td>
                </tr>
            </table>
      </div>
      <!-- // data-st2 -->
      <div id="userListArea" style="display:none;" ></div>    
      
	</div>
<!--     </form> -->
    
    
</div>
