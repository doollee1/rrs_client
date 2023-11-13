<!DOCTYPE html>        
<html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <!DOCTYPE html>
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

<body>
  <script>
   function writeCheck(){
		 var form = document.getElementById("contactForm");
		 
		 
		 var name      = $("#name").val();
		 var tpdsc     = $("#tpdsc option:checked").val();
		 var qna_title = $("#qna_title").val();
         var qna_pw    = $("#qna_pw").val();
         var qna_cntn  = $("#qna_cntn").val();
         
         if(name == null || name == ''){
        	 $("#name").focus();
        	 alert("제목을 입력해주세요.");
        	 return;
         }
		 
         if(tpdsc == '0' ){
        	 $("#tpdsc").focus();
        	 alert("유형을 선택하세요");
        	 return;
         }
         
         if(qna_title == null || $.trim(qna_title) == ''){
        	 $("#qna_title").focus();
        	 alert("제목을 입력해주세요.");
        	 return; 
         }
         
         
         if(qna_pw == null || $.trim(qna_pw) == '' || qna_pw.length < 6){
        	 $("#qna_pw").focus();
        	 alert("비밀번호는 영문, 숫자, 한글  최대 6글자 이내 입니다");
        	 return; 
         }
         
         
         if(qna_cntn == null || $.trim(qna_cntn) == ''){
        	 $("#qna_cntn").focus();
        	 alert("내용을 입력해주세요.");
        	 return; 
         }
		 
         $.ajax({
			type:"POST",
			url:"Contact_insert.do",
			data:{"name":name
			    , "tpdsc":tpdsc
			    , "qna_title":qna_title
			    , "qna_pw":qna_pw
			    , "qna_cntn":qna_cntn
			},
			
			dataType:"json",
			success:function(data){
				
				if(data == 'Y'){
					alert("정상적으로 등록 되었습니다.");
					location.href="Contact_select.do";
				}else{
					alert("문의 등록 중 오류가 발생하였습니다.");
				}
			},
			error:function(data){
				console.log("통신중 오류가 발생하였습니다.");
			}
		});
         
		 //form.submit();
	 }
 </script>

  <!--navigation-->
  <jsp:include page="common/Navigation.jsp"/>


	<!-- visual section -->	
	<div class="visual contact">
		<p class="txt">Contact</p>
		<div class="page-nav">
			<a href="/mainPage.do">Home</a>
			<a href="Contact_insert.do">Contact</a>
			<a href="Contact_insert.do" class="on">고객문의</a>
		</div>
	</div>



  <!--container-->
  <div class="container">

    <form name="sentMessage" id="contactForm" action="" method="post" >
    
      <div class="data-top">
        <div class="left">
          <p class="tit-type3">문의내용 <span class="c-org">(*필수입력)</span></p>
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
            <th>성명 <span class="essential">*</span></th>
            <td scope="col" style="border-right:hidden !important">
              <input type="text" id="name" name="name" class="chk" placeholder="성명"  required data-validation-required-message="Please enter your name.">
            </td>
          </tr>
          <tr>
            <th>유형 <span class="essential">*</span></th>
            <td scope="col" style="border-right:hidden !important">
                  <select id="tpdsc" name="tpdsc" class="chk" size="1">
                    <option value="0">유형 선택</option>
                    <option value="1">컨설팅</option>
                    <option value="2">서비스</option>
                    <option value="3">솔루션</option>
                    <option value="4">인재채용</option>
                    <option value="9">기타</option>
                  </select>
            </td>
          </tr>
          <tr>
            <th>제목 <span class="essential">*</span></th>
             <td>
                  <input type="text" id="qna_title" name="qna_title" placeholder="제목" style="width:90%;"  class="m-per100"
                         maxlength="50" required data-validation-required-message="제목을 입력해주세요.">
            </td>
          </tr>
          <tr>
            <th>비밀번호<span class="essential">*</span></th>
             <td>
                  <input type="password" id="qna_pw" name="qna_pw" placeholder="비밀번호" style="width:20%;"  class="m-per100"
                         required data-validation-required-message="비밀번호는 영문, 숫자, 한글  최대 6글자 이내 입니다">
            </td>
          </tr>
          <tr>
            <th>내용<span class="essential">*</span></th>
            <td style="border-right:hidden !important">
                  <textarea  style="width:90%;height:200px;" class="m-per100" id="qna_cntn" name="qna_cntn"
                            maxlength="500" style="resize:none">
                  </textarea>
            </td>
          </tr>
        </table>
      </div>
      <!-- // data-st2 -->
   </form>
      <div id="success"></div>
      <!-- For success/fail messages -->
      <div class="btn-box">
        <div class="center">
          <button class="btn-type2 type1 min-size1" id="sendMessageButton"  onclick="writeCheck(this);">문의하기</button>
        </div>
      </div>
 

  </div>
  <!-- /.container -->

  <!-- Contact form JavaScript -->
  <script src="resrc/js/jqBootstrapValidation.js"></script>
  <script src="resrc/js/contact_me.js"></script>

  <jsp:include page="common/Footer.jsp"/>
  
  <script>includeHTML();</script>

</body>

</html>
