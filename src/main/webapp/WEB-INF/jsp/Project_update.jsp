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

<body onload="init()">
  <!--navigation-->
  <jsp:include page="common/Navigation.jsp"/>

  
  <div class="visual" style="background-image: url('resrc/image/sub_visual_03.png')">
    <p class="txt">/고객문의</p>
  </div>

  <!--container-->
  <div class="container">
    <!-- In order to set the email address and subject line for the contact form go to the bin/contact_me.php file. -->


    <form id="updateForm" name="sentMessage" method="post" novalidate>
    
      <div class="data-top">
        <div class="left">
          <p class="tit-type3">프로젝트 실적수정 <span class="c-org">(*필수입력)</span></p>
        </div>
      </div>
      
      <!-- data-st2 -->
      <div class="data-st2">
        <table>
          <colgroup >
            <col style="width:5%"/>
            <col style="width:20%" />
          </colgroup >
                <tr>
            <th>No</th>
             <td>
                  <input type="text" id="no" name="no" style="width:10%;" value="${read.no}"  class="m-per100" readonly="readonly">
            </td>
          </tr>
          <tr>
            <th>구분<span class="essential">*</span></th>
            <td scope="col" style="border-right:hidden !important">
            	  <input type="hidden" id="gubunValue" name="gubunValue" value="${read.gubun}">
                  <select id="gubun" name="gubun" size="1" style="width:120px">
                    <option value="1">공공부문</option>
                    <option value="2">일반부문</option>
                    <option value="3">납품유지보수</option>
                  </select>
            </td>
          </tr>
          <tr>
            <th>업체명<span class="essential">*</span></th>
             <td>
                  <input type="text" id="company" name="company" placeholder="Enter title" style="width:90%;" value="${read.company}"  class="m-per100"
                         required data-validation-required-message="제목을 입력해주세요." maxlength="100">
                   <span class="byte">0/100</span>
            </td>
          </tr>
          <tr>
            <th>주요업무<span class="essential">*</span></th>
             <td>
                  <input type="text" id="main_work" name="main_work" value="${read.main_work}" placeholder="Enter title" style="width:90%;" class="m-per100"
                         required data-validation-required-message="제목을 입력해주세요." maxlength="100">
                   <span class="byte">0/100</span>
            </td>
          </tr>
          <tr>
            <th>개발환경<span class="essential">*</span></th>
             <td>
                  <input type="text" id="utill" name="utill" value="${read.utill}" placeholder="Enter title" style="width:90%;" class="m-per100"
                         required data-validation-required-message="제목을 입력해주세요." maxlength="100">
                   <span class="byte">0/100</span>
            </td>
          </tr>
          <tr>
            <th>기간<span class="essential">*</span></th>
             <td>
                  <input type="text" id="from_dt" name="from_dt" value="${read.from_dt}" placeholder="ex)20200101" style="width:15%; text-align:center;" class="m-per100"
                         required data-validation-required-message="기간을 입력해주세요." maxlength="8">
                  <span>  ~  </span>
                  <input type="text" id="to_dt" name="to_dt" value="${read.to_dt}" placeholder="ex)20200101" style="width:15%; text-align:center;" class="m-per100"
                         required data-validation-required-message="기간을 입력해주세요." maxlength="8">
            </td>
          </tr>
          <tr>
            <th>PL<span class="essential">*</span></th>
             <td>
                <input type="text" id="project_pl" name="project_pl" style="width:20%;" class="m-per100" readonly="readonly">
        	    <input onclick="callUsrPop(this.title)" class="btn-type3 type3 min-size3" type="button" value="찾기" title="take_user_id">
            </td>
          </tr>
        </table>
      </div>
      <!-- // data-st2 -->

      <div id="success"></div>
      <!-- For success/fail messages -->
      <div class="btn-box">
        <div class="center">
          <button class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="fn_updBtn();">수정하기</button>
          <button class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="fn_delBtn();">삭제하기</button>
          <button class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="fn_listBtn();">목록</button>
        </div>
      </div>
    </form>

  </div>
  
  <div id="subArea">
      <div id="userSelPop" style="display:none; z-index : 1" class="modal"></div>
  </div>
  <!-- /.container -->

  <!-- Contact form JavaScript -->
  <!-- Do not edit these files! In order to set the email address and subject line for the contact form go to the bin/contact_me.php file. -->
  <script src="resrc/js/jqBootstrapValidation.js"></script>
  <script src="resrc/js/contact_me.js"></script>
  <script>
  	function fn_updBtn(){
  		var form = document.getElementById("updateForm");
  		form.action = "projectUpdate";
  		form.method = 'post';
  		form.submit();
  	}
  	
  	function fn_listBtn(){
  		var form = document.getElementById("updateForm");	
  		form.action = "Project_actual";
  		form.method = 'get';
  		form.submit();
  	}
  	
  	function fn_delBtn(){
  		var form = document.getElementById("updateForm");
  		form.action = "projectDelete";
  		form.method = 'post';
  		form.submit();
  	}
  	
  	function init(){
  		var gubunValue = document.getElementById("gubunValue");
  		var gubun = document.getElementById("gubun");
  		gubun.value = gubunValue.value;
  	}
  	
  	function callUsrPop(){
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
		$('#updateForm #project_pl').val(mb_id);     	    	 
		$("#userSelPop").css("display","none");
	}
  </script>
  <jsp:include page="common/Footer.jsp"/>
  
  <script>includeHTML();</script>
</body>

</html>
