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
  <link href="resrc/css/common_admin.css" rel="stylesheet">
  <!-- <link href="css/Contact_insert.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
  <script>
	function isEmail(asValue) {

		var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

		return regExp.test(asValue); 

	}
  	
  	function isJobPassword(asValue) {

		var regExp = /^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{8,20}$/; //  8 ~ 20자 영문, 숫자 조합

		return regExp.test(asValue); // 

	}
  	
    function fn_saveBtn(chk){
	  
       var mb_id        = $("#mb_id").val();
       var mb_name      = $("#mb_name").val();
       var mb_birth     = $("#mb_birth").val();
       var mb_email     = $("#mb_email").val();
       var mb_zip       = $("#mb_zip").val();
       var mb_addr1     = $("#mb_addr1").val();
       var mb_addr2     = $("#mb_addr2").val();
       var mb_join_date = $("#mb_join_date").val();     
       var mb_hp1       = $("#mb_hp1").val();
       var mb_hp2       = $("#mb_hp2").val();
       var mb_hp3       = $("#mb_hp3").val();
       
       
       if(mb_id == null || $.trim(mb_id) == ''){
     	    $("#mb_id").focus();
     	    alert("ID를 입력해주세요.");
     	    return;
       }
       
       if(mb_name == null || $.trim(mb_name) == ''){
     	    $("#mb_name").focus();
     	    alert("성명을 입력해주세요.");
     	    return;
       }
       
       if(mb_birth != '' && mb_birth != null){
       	
       	if(mb_birth.length != 8){
       		$("#mb_birth").focus();
       		alert("생년월일을 잘못 입력하였습니다.");
       		return;
       	}
       }
       
       if(mb_email != '' && mb_email != null){
           if(!isEmail(mb_email)){
       	       $("#mb_email").focus();
       		   alert("유효하지 않는 이메일 규칙입니다.");
       		   return;
       	   }
       }
       
       if(mb_join_date != '' && mb_join_date != null){
           if(mb_join_date < 7){
       	       $("#mb_join_date").focus();
       		   alert("입사일자를 잘못 입력 하셨습니다.");
       		   return;
       	   }
       }
       
       $.ajax({
      	type:"POST",
      	url:"Member_save.do",
     	    data :{"mb_id"        :mb_id
    	         , "mb_name"      :mb_name
    	         , "mb_email"     :mb_email
    	         , "mb_birth"     :mb_birth
    	         , "mb_hp1"       :mb_hp1
    	         , "mb_hp2"       :mb_hp2
    	         , "mb_hp3"       :mb_hp3
    	         , "mb_zip"       :mb_zip
    	         , "mb_addr1"     :mb_addr1
    	         , "mb_addr2"     :mb_addr2
    	         , "mb_join_date" :mb_join_date
    	         , "gubun"        :'1'
    	    },
      	
      	dataType:"json",
      	success:function(data){
      		
	  		if(data == 'Y'){	
	 	        alert("정상적으로 등록 되었습니다.");
	 	    	location.href="Member_sel.do";
	 	    }else{
	 	    	alert("등록 실패하였습니다.");
	 	    }
      	},
      	error:function(data){
      		console.log("통신중 오류가 발생하였습니다.");
      	}
      });
	}
    

    function goPopup(){
    	// 주소검색을 수행할 팝업 페이지를 호출합니다.
    	// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
    	var pop = window.open("/common/jusoPopup.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
    	
    	// 모바일 웹인 경우, 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
        //var pop = window.open("/popup/jusoPopup.jsp","pop","scrollbars=yes, resizable=yes"); 
    }


    function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn,detBdNmList,bdNm,bdKdcd,siNm,sggNm,emdNm,liNm,rn,udrtYn,buldMnnm,buldSlno,mtYn,lnbrMnnm,lnbrSlno,emdNo){
    		// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
    		document.form.roadFullAddr.value = roadFullAddr;
    		document.form.roadAddrPart1.value = roadAddrPart1;
    		document.form.roadAddrPart2.value = roadAddrPart2;
    		document.form.addrDetail.value = addrDetail;
    		document.form.engAddr.value = engAddr;
    		document.form.jibunAddr.value = jibunAddr;
    		document.form.zipNo.value = zipNo;
    		document.form.admCd.value = admCd;
    		document.form.rnMgtSn.value = rnMgtSn;
    		document.form.bdMgtSn.value = bdMgtSn;
    		document.form.detBdNmList.value = detBdNmList;
    		/** 2017년 2월 추가제공 **/
    		document.form.bdNm.value = bdNm;
    		document.form.bdKdcd.value = bdKdcd;
    		document.form.siNm.value = siNm;
    		document.form.sggNm.value = sggNm;
    		document.form.emdNm.value = emdNm;
    		document.form.liNm.value = liNm;
    		document.form.rn.value = rn;
    		document.form.udrtYn.value = udrtYn;
    		document.form.buldMnnm.value = buldMnnm;
    		document.form.buldSlno.value = buldSlno;
    		document.form.mtYn.value = mtYn;
    		document.form.lnbrMnnm.value = lnbrMnnm;
    		document.form.lnbrSlno.value = lnbrSlno;
    		/** 2017년 3월 추가제공 **/
    		document.form.emdNo.value = emdNo;
    		
    		$("#mb_zip").val(zipNo);
    		$("#mb_addr1").val(roadAddrPart1+" "+roadAddrPart2);
    		$("#mb_addr2").val(addrDetail);
    		//$("#mb_addr2").val(roadAddrPart2);
    		
    		
    }
 </script>
<body>
  <!--navigation-->
  <jsp:include page="common/Navigation.jsp"/>

  
<!--   <div class="visual" style="background-image: url('resrc/image/sub_visual_03.png')"> -->
<!--     <p class="txt">/회원등록</p> -->
<!--   </div> -->

  <!--container-->
  <div class="container">
    <!-- In order to set the email address and subject line for the contact form go to the bin/contact_me.php file. -->
      <div class="data-top">
        <div class="left">
          <p class="tit-type3">회원 등록 <span class="c-org">(*필수입력)</span></p>
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
                         required data-validation-required-message="사용자ID를 입력해주세요." maxlength="20">
            </td>
          </tr>
          <tr>
            <th>사용자명<span class="essential">*</span></th>
             <td>
                  <input type="text" id="mb_name" name="mb_name" placeholder="Enter title" style="width:40%;" class="m-per100"
                         required data-validation-required-message="사용자명을 입력해주세요" maxlength="20">
            </td>
          </tr>
          <tr>
            <th>이메일</th>
             <td>
                  <input type="text" id="mb_email" name="mb_email" placeholder="Enter title" style="width:40%;" class="m-per100"
                         required data-validation-required-message="이메일을 입력해주세요." maxlength="100">
            </td>
          </tr>
          <tr>
            <th>생년월일</th>
             <td>
                  <input type="text" id="mb_birth" name="mb_birth" placeholder="ex)19870603" style="width:40%;" class="m-per100"
                         required data-validation-required-message="생년월일" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8">
            </td>
          </tr>
          <tr>
            <th>휴대폰</th>
             <td>
                  <input type="text" id="mb_hp1" name="mb_hp1"  style="width:10%;" class="m-per100"
                         onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="3" />
                  -
                  <input type="text" id="mb_hp2" name="mb_hp2"  style="width:10%;" class="m-per100"
                         onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4" />
                  -
                  <input type="text" id="mb_hp3" name="mb_hp3"  style="width:10%;" class="m-per100"
                         onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4" />
            </td>
          </tr>
          <tr>
            <th>입사일자</th>
             <td>
                  <input type="text" id="mb_join_date" name="mb_join_date" placeholder="ex)20150202" style="width:20%;" class="m-per100"
                         required data-validation-required-message="입사일자를 입력해주세요." onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8">
            </td>
          </tr>
          <tr>
            <th>우편번호</th> <!-- U01TX0FVVEgyMDIwMDkyOTE1NTczODExMDI0NDk=   -->
             <td>
                  <input type="text" id="mb_zip" name="mb_zip" placeholder="Enter title" style="width:10%;" class="m-per100"
                         required data-validation-required-message="우편번호를 입력해주세요." onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="6">
            	  <input type="button" class="btn-type1 type1 min-size1" onClick="goPopup();" value="주소찾기"/>
            </td>
          </tr>
          <tr>
            <th>주소</th>
             <td>
                  <input type="text" id="mb_addr1" name="mb_addr1" placeholder="Enter title" style="width:45%;" class="m-per100"
                         required data-validation-required-message="주소를 입력해주세요" maxlength="50">
                  <input type="text" id="mb_addr2" name="mb_addr2" placeholder="Enter title" style="width:45%;" class="m-per100"
                         required data-validation-required-message="상세 주소를 입력해주세요" maxlength="50">
            </td>
          </tr>
        </table>
  <form name="form" id="form" method="post">

	<div id="list"></div>
	<div id="callBackDiv">
		<table style="display:none;">
			<tr><td>도로명주소 전체(포멧)</td><td><input type="text"  style="width:500px;" id="roadFullAddr"  name="roadFullAddr" /></td></tr>
			<tr><td>도로명주소           </td><td><input type="text"  style="width:500px;" id="roadAddrPart1"  name="roadAddrPart1" /></td></tr>
			<tr><td>고객입력 상세주소    </td><td><input type="text"  style="width:500px;" id="addrDetail"  name="addrDetail" /></td></tr>
			<tr><td>참고주소             </td><td><input type="text"  style="width:500px;" id="roadAddrPart2"  name="roadAddrPart2" /></td></tr>
			<tr><td>영문 도로명주소      </td><td><input type="text"  style="width:500px;" id="engAddr"  name="engAddr" /></td></tr>
			<tr><td>지번                 </td><td><input type="text"  style="width:500px;" id="jibunAddr"  name="jibunAddr" /></td></tr>
			<tr><td>우편번호             </td><td><input type="text"  style="width:500px;" id="zipNo"  name="zipNo" /></td></tr>
			<tr><td>행정구역코드        </td><td><input type="text"  style="width:500px;" id="admCd"  name="admCd" /></td></tr>
			<tr><td>도로명코드          </td><td><input type="text"  style="width:500px;" id="rnMgtSn"  name="rnMgtSn" /></td></tr>
			<tr><td>건물관리번호        </td><td><input type="text"  style="width:500px;" id="bdMgtSn"  name="bdMgtSn" /></td></tr>
			<tr><td>상세번물명        	</td><td><input type="text"  style="width:500px;" id="detBdNmList"  name="detBdNmList" /></td></tr>
			<tr><td>건물명        		</td><td><input type="text"  style="width:500px;" id="bdNm"  name="bdNm" /></td></tr>
			<tr><td>공동주택여부       </td><td><input type="text"  style="width:500px;" id="bdKdcd"  name="bdKdcd" /></td></tr>
			<tr><td>시도명        		</td><td><input type="text"  style="width:500px;" id="siNm"  name="siNm" /></td></tr>
			<tr><td>시군구명        	</td><td><input type="text"  style="width:500px;" id="sggNm"  name="sggNm" /></td></tr>
			<tr><td>읍면동명        	</td><td><input type="text"  style="width:500px;" id="emdNm"  name="emdNm" /></td></tr>
			<tr><td>법정리명        	</td><td><input type="text"  style="width:500px;" id="liNm"  name="liNm" /></td></tr>
			<tr><td>도로명        		</td><td><input type="text"  style="width:500px;" id="rn"  name="rn" /></td></tr>
			<tr><td>지하여부        	</td><td><input type="text"  style="width:500px;" id="udrtYn"  name="udrtYn" /></td></tr>
			<tr><td>건물본번        	</td><td><input type="text"  style="width:500px;" id="buldMnnm"  name="buldMnnm" /></td></tr>
			<tr><td>건물부번        	</td><td><input type="text"  style="width:500px;" id="buldSlno"  name="buldSlno" /></td></tr>
			<tr><td>산여부        		</td><td><input type="text"  style="width:500px;" id="mtYn"  name="mtYn" /></td></tr>
			<tr><td>지번본번(번지)     </td><td><input type="text"  style="width:500px;" id="lnbrMnnm"  name="lnbrMnnm" /></td></tr>
			<tr><td>지번부번(호)       </td><td><input type="text"  style="width:500px;" id="lnbrSlno"  name="lnbrSlno" /></td></tr>
			<tr><td>읍면동일련번호       </td><td><input type="text"  style="width:500px;" id="emdNo"  name="emdNo" /></td></tr>
		</table>
	</div>

</form>
      </div>
      <!-- // data-st2 -->
      <div id="success"></div>
      <!-- For success/fail messages -->
      <div class="btn-box">
        <div class="center">
          <button class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="fn_saveBtn('1');">등록하기</button>
          <button type="button" class="btn-type2 type1 min-size1" id="sendMessageButton" onclick="fn_listBtn();">목록</button>
        </div>
      </div>
  </div>
  <!-- /.container -->

  <!-- Contact form JavaScript -->
  <!-- Do not edit these files! In order to set the email address and subject line for the contact form go to the bin/contact_me.php file. -->
  <script src="resrc/js/jqBootstrapValidation.js"></script>
  <script src="resrc/js/contact_me.js"></script>
  <jsp:include page="common/Footer.jsp"/>
  
  <script>includeHTML();</script>
</body>

</html>
