<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      <!DOCTYPE html>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">

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
  <!-- <link href="css/Contact_insert.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
  <script>
    function fn_pwdInit(){
    	var mb_id           = $("#mb_id").val();
    	
    	if(confirm("비밀번호를 초기화 하시겠습니까?\n초기화 되는 비밀번호는 doollee 입니다.")){
        	$.ajax({
    	        type :"POST",
    	        url  :"Member_pwdInit.do",
    	        data :{"mb_id"          :mb_id
    	            },
    	        dataType:"json",
    	        
    	        success:function(data){
    	 			console.log(data);
    		 	    if(data == 'Y'){
    		 	    	alert("정상적으로 초기화 되었습니다.");
    		 	    }else{
    		 	    	alert("비밀번호 초기화 실패하였습니다.");
    		 	    }
    	        },
    	        error:function(data){
    	        	alert("통신중 오류가 발생하였습니다.");
    	        }
           });
    	}
    	

    	
    }
	function fn_saveBtn(){
	    var mb_id           = $("#mb_id").val();
        var mb_level        = $("#mb_level option:checked ").val();
        var mb_retire_date  = $("#mb_retire_date").val();
        var mb_join_date    = $("#mb_join_date").val();
        
        if(mb_retire_date != '' && mb_level == '1'){
        	alert("상태가 재직일때 퇴사일자를 입력 하실 수 없습니다.");
        	return;
        }
        
	    if(mb_level == '2'){
	    	if(mb_retire_date == null || $.trim(mb_retire_date) == ''){
	      	    $("#mb_retire_date").focus();
	      	    alert("상태가 퇴사일시 퇴사일자를 입력하셔야 합니다.");
	      	    return;
	        }
	    }
	    
	    $.ajax({
	        type :"POST",
	        url  :"Member_save.do",
	        data :{"mb_id"          :mb_id
	             , "mb_level"       :mb_level
	             , "mb_retire_date" :mb_retire_date
	             , "mb_join_date"   :mb_join_date
	             , "gubun"          :'3'
	            },
	 
	        dataType:"json",
	        success:function(data){
	 	
		 	    if(data == 'Y'){
		 	    	alert("정상적으로 수정 되었습니다.");
		 	    	location.href="Member_sel.do";
		 	    }else{
		 	    	alert("회원정보 수정 실패하였습니다.");
		 	    }
	        },
	        error:function(data){
	 	        console.log("통신중 오류가 발생하였습니다.");
	        }
       });
		 
    }
 </script>
<body>
  <!--navigation-->
  <jsp:include page="common/Navigation.jsp"/>

  
  <div class="visual" style="background-image: url('resrc/image/sub_visual_03.png')">
    <p class="txt">/회원수정</p>
  </div>

  <!--container-->
  <div class="container">
    <!-- In order to set the email address and subject line for the contact form go to the bin/contact_me.php file. -->
	<div class="data-top">
        <div class="left">
          <p class="tit-type3">회원정보 수정 <span class="c-org">(*필수입력)</span></p>
        </div>
      </div>
      
      <!-- data-st2 -->
      <div class="data-st2">
        <table>
          <colgroup >
            <col style="width:20%" />
            <col style="width:auto" />
          </colgroup >
          <tr>
            <th>사용자ID<span class="essential">*</span></th>
             <td>
                  <input type="text" id="mb_id" name="mb_id" placeholder="Enter title" style="width:40%;"  class="m-per100"
                         value="<c:out value='${map.mb_id}' />" maxlength="20" readonly="readonly">
            </td>
          </tr>
          <tr>
            <th>사용자명<span class="essential">*</span></th>
             <td>
                  <input type="text" id="mb_name" name="mb_name" placeholder="Enter title" style="width:40%;" class="m-per100"
                         value="<c:out value='${map.mb_name}' />" maxlength="20" readonly="readonly">
            </td>
          </tr>
          <tr>
            <th>입사일자</th>
             <td>
                  <input type="text" id="mb_join_date" name="mb_join_date" placeholder="ex:20200609" style="width:15%;" class="m-per100"
                         value="<c:out value='${map.mb_join_date}' />" maxlength="8">
            </td>
          </tr>
          <tr>
            <th>상태</th>
             <td>
                  <select id="mb_level" name ="mb_level">
                  	<option value="1" <c:if test="${map.mb_level eq '1'}" >selected</c:if>>재직</option>
                  	<option value="2" <c:if test="${map.mb_level eq '2'}" >selected</c:if>>퇴사</option>
                  </select>
            </td>
          </tr>
          <tr>
          <th>퇴사일자</th>
             <td>
                  <input type="text" id="mb_retire_date" name="mb_retire_date" placeholder="ex:20200609" style="width:15%;" class="m-per100"
                         value="<c:out value='${map.mb_retire_date}' />" maxlength="8">
            </td>
          </tr>
          
        </table>
      
      </div>
      <!-- // data-st2 -->

      <div id="success"></div>
      <!-- For success/fail messages -->
      <div class="btn-box">
        <div class="center">
          <button class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="fn_pwdInit();">비밀번호 초기화</button>
          <button class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="fn_saveBtn();">수정하기</button>
          <button type="button" class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="fn_listBtn();">목록</button>
        </div>
      </div>
  </div>
  <!-- /.container -->

  <!-- Do not edit these files! In order to set the email address and subject line for the contact form go to the bin/contact_me.php file. -->
  <script src="resrc/js/jqBootstrapValidation.js"></script>
  <script src="resrc/js/contact_me.js"></script>
  <jsp:include page="common/Footer.jsp"/>
  
  <script>includeHTML();</script>
</body>

</html>
