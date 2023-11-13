﻿<%@ page language="java" contentType="text/html; charset=utf-8"
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
  <!--css-->
  <link href="resrc/css/common.css" rel="stylesheet">
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>

<body>
  <script>
      var prod_sts = '5';
      // 조회
      function selectList(){
    	  $.ajax({
			type:"POST",
			url:"selectProdRepair.do",
			data:{
  				  prod_no : $("#prod_no").val()
				 },
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			success:function(data){
				$("#listArea").css("display","block");
				$("#listArea").html(data);
			},
			error:function(data){
				console.log("조회중 오류가 발생하였습니다.");
			}
		});
      }
      
      function init(){
    	  $("#prod_no").val("");
    	  //$("#listArea").css("display","none");
    	  $("#listArea").html("");
      }
      
      function select_prod() {
    	  
    	  $.ajax({
   			url : "prodSelPop.do",
   			
   			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
   			type : "POST",
   			success : function(result) {
   				selPop_gbn = "select";
   				$("#prodSelPop").css("display","block");
   				$("#prodSelPop").html(result);
   			},
   			error : function(e) {
   				alert(e.responseText);
   			}
   	      });
      }
      
      function selectProd(prod_no){
    	  $("#prodSelPop").css("display","none");
      	  $("#prodSelPop").html('');
      	  
      	  if(selPop_gbn == "select"){
      		$("#prod_no").val(prod_no);  
      	  } else if(selPop_gbn == "update") {
      		$("#prodRegForm #prod_no").val(prod_no);      		  
      	  }
      }
      
      function test(){
      	  
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
      
      
      function selectUser(usr_id){
    	  alert(usr_id);
      }
      
      $(document).ready(function() {
    	  selectList();
      });
      
      function regInfo(){
  	      $.ajax({
  			url : "prodRepairReg.do",
  			data : null,
  			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
  			type : "POST",
  			success : function(result) {
  				pop_gbn = "insert";
  				$("#regArea").css("display","block");
  				$("#regArea").html(result);
  			},
  			error: function(e) {
  				alert(e.responseText);
  			}
  	      });
     }
      
      $('body').on('dblclick', '#listForm tbody tr', function(){
	      var str = "";
	      var tdArr = new Array();    // 배열 선언
	            
	      // 현재 클릭된 Row(<tr>)
	      var tr = $(this);
	      var td = tr.children();

	      console.log("클릭한 Row의 모든 데이터 : "+tr.text());
       
	      // 반복문을 이용해서 배열에 값을 담아 사용할 수 도 있다.
	      td.each(function(i){
	          tdArr.push(td.eq(i).text());
	      });
	      console.log("배열에 담긴 값 : "+tdArr);
	      
	      $.ajax({
	    	  url : "prodRepairUpd.do",
	    	  data : {
	    		  	prod_no : tdArr[0],
					SEQ : tdArr[1],
					repair_gbn : tdArr[2],
					repair_comp : tdArr[3],
					repair_st_dt : tdArr[4],
					repair_ed_dt : tdArr[5],
					repair_fee : tdArr[6],
					repair_expl : tdArr[7],
	    	  		remark : tdArr[8]
	    	  },
	    	  contentType : "application/x-www-form-urlencoded; charset=UTF-8",
    		  type : "POST",
    		  success : function(result) {
    			  pop_gbn = "update";
    			  $("#regArea").css("display","block");
    			  $("#regArea").html(result);
    		  },
    		  error : function(e) {
    				alert(e.responseText);
    		  }
	      });
     });

  </script>

  <!--navigation-->
  <jsp:include page="common/Navigation.jsp" />
  	
<!--   <div class="visual" style="background-image: url('resrc/image/sub_visual_03.png')"> -->
<!--     <p class="txt">/장비수리 관리</p> -->
<!--   </div> -->
  <!--container-->
  
      
  <div class="container">
      <div class="left">
      <p class="tit-type4">장비수리 관리 </p>  <!-- <span class="c-org">(*필수입력)</span> -->
    </div>
<!--     <form name="prodRepairForm" id="prodRepairForm" action="return false;" method="post" > -->
    
      <div class="data-top">
        <div class="left">
          <p class="tit-type3">조회조건 </p>  <!-- <span class="c-org">(*필수입력)</span> -->
        </div>
        <div class="right">
          <input class="btn-type3 type3 min-size3" type="button" value="초기화" onclick="init();" >
          <input class="btn-type3 type3 min-size3" type="button" value="조회" onclick="selectList();" >
          <input class="btn-type3 type3 min-size3" type="button" value="등록" onclick="regInfo();" >
        </div>
      </div>
      
      <!-- data-st1 -->
      <div class="data-pop-reg">
        <table>
          <colgroup >
            <col style="width:20%" />
            <col style="width:auto" />
          </colgroup >
          <tr>
            <th>장비번호</th>
            <td>
                <div style="display:flex;">
                    <input type="text" id="prod_no" name="prod_no" class="chk" value="" disabled="disabled">
                    <input onclick="select_prod()" class="btn-type3 type3 min-size3" type="button" value="찾기">

                </div>     
                
<!--             	<input id="prod_no" type="text" readonly="readonly"> -->
<!--             	<input onclick="select_prod()" class="btn-type3 type3 min-size3" type="button" value="찾기"> -->
            </td>
          </tr>
        </table>
        
        
      </div>
      <!-- // data-st2 -->
          
<!--    </form> -->
   <div id="listArea" style="display:none;" class=""></div>
    
  </div>
  <!--/container-->
  <div id="subArea">
	  <div id="prodSelPop" style="display:none; z-index : 2" class="modal"></div>
	  <div id="regArea" style="display:none;" class="modal"></div>
	  <div id="modArea" style="display:none;"></div>
	  
	  <div id="userSelPop" style="display:none;" class="modal"></div>
	  
  </div>

  <jsp:include page="common/Footer.jsp" />
  
  <script>includeHTML();</script>
</body>
</html>