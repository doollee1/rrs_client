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
  <link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
  <link href="resrc/vendor/bootstrap/css/datepicker3.css" rel="stylesheet">  <!-- date picker 관련 import -->
  <script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.js"></script>     <!-- date picker 관련 import -->
  <script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.kr.js"></script>  <!-- date picker 관련 import -->
  <link href="resrc/css/common_admin.css" rel="stylesheet">
</head>

<body>
  <script>
      var pop_gbn = "";
      // 조회
      function selectListMain(){
    	  $.ajax({
			type:"POST",
			url:"selectProdTrans.do",
			data:{
				  prod_plc    : $("#prodTransForm #prod_plc").val()
				 ,take_project: $("#prodTransForm #take_project").val()
				 ,take_sts    : $("#prodTransForm #take_sts").val()
				 ,prod_no     : $("#prodTransForm #prod_no").val()
				 ,usr_id	  : '${sessionScope.usrid }'
				 ,usr_lvl	  : '${sessionScope.usrlvl }'
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
      
      function selectProd(prod_no){
    	  $("#prodSelPop").css("display","none");
      	  $("#prodSelPop").html('');
      	  
    	  if(selPop_gbn == "trans"){
    		  $("#prodTransForm #prod_no").val(prod_no);  
       	  } else if(selPop_gbn == "insert") {
       		$("#transRegForm #prod_no").val(prod_no);
       	  }
    	  
      }
      
      function init(){
    	  $("#prod_plc").val("");
    	  $("#prod_no").val("");
    	  $("#take_project").val("");
    	  $("#take_project_nm").val("");
    	  $("#take_sts").val("");
    	  
    	  //$("#listArea").css("display","none");
    	  selectListMain();
    	  
      }
      
      function regInfo(){
  	      $.ajax({
  			url : "prodTransReg.do",
  			data : null,
  			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
  			type : "POST",
  			success : function(result) {
  				pop_gbn = "insert";
  				$("#regArea").css("display","block");
  				$("body").css("overflow" , "hidden");
  				$("#regArea").html(result);
  			},
  			error : function(e) {
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
       
	      /*var desl_ynVal; 
		  if($("#del_yn").prop("checked")=="true"){
			  desl_ynVal = "Y"
		  } else {
			  desl_ynVal = "N"
		  }*/
		  
	      // 반복문을 이용해서 배열에 값을 담아 사용할 수 도 있다.
	      td.each(function(i){
	          tdArr.push(td.eq(i).text());
	      });
	      //tdArr.push(td.eq(15).desl_ynVal);
	      
	            
	      console.log("배열에 담긴 값 : "+tdArr);

	      
	      $.ajax({
	    	  url : "prodTransUpd.do",
	    	  data : {
	    		    prod_no : tdArr[0],
					SEQ : tdArr[1],
					trans_gbn : tdArr[3],
					trans_dt : tdArr[4],
					trans_user_name : tdArr[5],
					trans_project_nm : tdArr[6],
					take_dt : tdArr[7],
					take_user_name : tdArr[8],
					take_project_nm : tdArr[9],
					take_place : tdArr[10],
					take_sts : tdArr[11],
	    	  		trans_project : tdArr[12],
	    	  		take_project : tdArr[13],
	    	  		trans_user_id : tdArr[14],
	    	  		take_user_id : tdArr[15],
	    	  		remark : tdArr[16]
	    	  },
	    	  contentType : "application/x-www-form-urlencoded; charset=UTF-8",
    		  type : "POST",
    		  success : function(result) {
    			  pop_gbn = "update";
    			  $("#regArea").css("display","block");
    			  $("body").css("overflow" , "hidden");
    			  $("#regArea").html(result);
    		  },
    		  error : function(e) {
    				alert(e.responseText);
    			}
    			  
	      });
     });
     
     function callProdPop() {
   	     $.ajax({
  			url : "prodSelPop.do",
  			data : {"trans_gbn" : "0",
  					"attr_1" : "1"},
  			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
  			type : "POST",
  			success : function(result) {
  				selPop_gbn = "trans";
  				$("#prodSelPop").css("display","block");
  				$("#prodSelPop").html(result);
  			},
  			error : function(e) {
  				alert(e.responseText);
  			}
  	      });
     }
     
     var userPopTitle;
     function callUsrPop(objId){
    	userPopTitle = objId; 
     	$.ajax({
    			url : "userPop.do",
    			data : {
    				
    			},
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
     
     function selectUser(mb_id){
         $('#'+userPopTitle).val(mb_id);     	    	 
    	 $("#userSelPop").css("display","none");
     	
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
    	 $("#"+projectObj).val(project_no);
    	 $("#"+projectObj+"_nm").val(project_nm);
    	 $("#projectSelPop").css("display","none");
     }
     
     $(document).ready(function(){
    	 $('.date').datepicker({
   		    format: "yyyy-mm-dd",
   		    language: "kr",
   		    autoclose : true
   		    
   		 });
    	 selectListMain();
     });
     
  
  </script>

  <!--navigation-->
  <jsp:include page="common/Navigation.jsp" />
  	
  <!--container-->
  
      
  <div class="container">
     <div class="left">
       <p class="tit-type4">장비 인수/인계 관리</p>  <!-- <span class="c-org">(*필수입력)</span> -->
     </div>
    <form name="prodTransForm" id="prodTransForm" action="" method="post" >
    
      <div class="data-top">
        <div class="left">
          <p class="tit-type3">조회조건 </p>  <!-- <span class="c-org">(*필수입력)</span> -->
        </div>
        <div class="right">
          <input class="btn-type3 type3 min-size3" type="button" value="초기화" onclick="init();" >
          <input id="btnSearch" class="btn-type3 type3 min-size3" type="button" value="조회" onclick="selectListMain();" >
          <input class="btn-type3 type3 min-size3" type="button" value="등록" onclick="regInfo();" >
        </div>
      </div>
      
      <div class="data-pop-reg">
        <table style="overflow: auto;">
          <colgroup >
            <col style="width:10%" />
            <col style="width:40%" />
            <col style="width:10%" />
            <col style="width:40%" />
          </colgroup >
          <tr>
            <th>장비위치</th>
            <td scope="col" >
                <select id="prod_plc" name="prod_plc" class="chk" size="1">
                    <option value="">전체</option>
                    <option value="1">본사</option>
                    <option value="2">프로젝트</option>
                </select>
            </td>
            <th>프로젝트</th>
            <td scope="col" style="border-right:hidden !important">
                <div style="width:100%">
                    <div style="width:73%; float:left">
                        <input type="text" style="width: 20%" id="take_project" name="take_project" class="chk" value="" disabled="disabled" >
                        <input type="text" style="width: 78%" id="take_project_nm" name="take_project_nm" class="chk" value="" disabled="disabled" >
                    </div>
                    <div style="width: 23% float:right">
                        <input onclick="callProjectPop(this.title)" class="btn-type3 type3 min-size3" type="button" value="찾기" title="take_project">
                    </div>
                </div>  
            </td>
            
          </tr>
          
          <tr>
            <th>장비번호</th>
            <td>
            	<div style="width:100%">
                    <div style="width:73%; float:left">
                        <input type="text" style="width: 100%" id="prod_no" name="prod_no" class="chk" value="" disabled="disabled">
                    </div>
                    <div style="width: 23% float:right">
                        <input onclick="callProdPop()" class="btn-type3 type3 min-size3" type="button" value="찾기">
                    </div>
                </div>     
            </td>
            <th>인수상태</th>
            <td scope="col" style="border-right:hidden !important">
              <select id="take_sts" name="take_sts" class="chk" size="1">
                  <option value="">전체</option>
                  <c:forEach var="take_sts_list" items="${take_sts_list}" varStatus="i">
                        <option value="${take_sts_list.simp_c}">${take_sts_list.simp_cnm}</option>
                  </c:forEach>
              </select>
              <!-- <input type="text" id="trans_gbn_main" name="trans_gbn" class="chk" value="0" style="display: none;"> -->
            </td>
<!--             <th>인수/인계자</th> -->
<!--             <td> -->
<!--                 <div style="width:100%"> -->
<!--                     <div style="width:73%; float:left"> -->
<!--             	        <input id="mb_id" name="mb_id" style="width: 100%" type="text" readonly="readonly"> -->
<!--             	    </div> -->
<!--             	    <div style="width: 23% float:right"> -->
<!--             	        <input onclick="callUsrPop(this.title)" class="btn-type3 type3 min-size3" type="button" value="찾기" title="mb_id"> -->
<!--             	    </div> -->
<!--             	</div> -->
<!--             </td> -->
            
            
<!--             <th>인계기간</th> -->
<!--             <td scope="col" style="border-right:hidden !important"> -->
<!--             <input type="text" id="" name="" class="date" readonly="readonly"> ~ <input type="text" class="date" readonly="readonly"> -->
<!--             </td> -->
          </tr>
        </table>
        
      </div>
      <!-- // data-st2 -->
          
   </form>
   <div id="listArea" style="display:none;" ></div>
        
  </div>
  
  <!--/container-->

  <jsp:include page="common/Footer.jsp" />
  
  <script>includeHTML();</script>
</body>

<div id="subArea">
      <div id="prodSelPop" style="display:none; z-index : 2" class="modal"></div>
      <div id="projectSelPop" style="display:none; z-index : 2" class="modal"></div>
      
<!--       <div id="userSelPop" style="display:none;" class="modal"></div> -->
	  <div id="regArea" style="display:none;" class="modal"></div>
  </div>
</html>