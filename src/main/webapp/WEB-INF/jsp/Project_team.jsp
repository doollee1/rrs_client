<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">

<head>
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<title>(주)둘리정보통신</title>
<!-- Bootstrap core CSS -->
<link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
<!-- Custom styles for this template -->
<!-- <link href="css/modern-business.css" rel="stylesheet"> -->
<!--css-->
<link href="resrc/css/common.css" rel="stylesheet">
<!-- <link href="css/Business_consulting.css" rel="stylesheet"> -->
<!--script-->
<script src="resrc/js/includeHTML.js"></script>
<script src="resrc/vendor/jquery/jquery.js"></script>
<script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>
<script>
	
	var addrow = false;
	var clickNo =0;
	$(document).ready(function(){
		mainSearch();
		
	});
	
	function new_init(){
		
		$("#no").val("");
		$("#main_work").val("");
		$("#detail").empty();
		
		$("#no").attr("readonly",false);
		
		addrow = true;
		
	}
	
	function checkFields(){

		var result = true;
		
		
		var no = $("#no").val();
		var main_work = $("#main_work").val();
		
		if(no == "" || no == null ){
			alert("코드를 입력하여 주세요.");
			result = false;
			return;
		}
		
		if(no == "" || no == null ){
			alert("코드명을 입력하여 주세요.");
			result = false;
			return;
		} 
		
		var frm = $("#detailForm :input").not(":input[type=hidden]");

		frm.each(function(idx, ele){
			if( $(ele).attr("name") != "no" && $(ele).attr("name") != "main_work" ){
				if( "" == $(ele).val() || null == $(ele).val() ){
					if($(ele).attr("name") != "use_yn"){
						alert($(ele).attr("title") + "을(를) 입력하세요");
						$(ele).focus();
						result = false;
						return false;
					}
				};
				
				if($(ele).attr("name") == "userId"){
					if($(ele).val() == '' ){
						alert("직원을 선택해 주세요.");
						$(ele).focus();
						result = false;
						return false;
					}
				}
			}
			
		});

		return result;

	}
	
	function comm_save(){
		
		if(!checkFields()){
			return;
		}
		
		var dataSerialize = $("#detailForm").serialize();
		var no   = $("#no").val();
		var main_work = $("#main_work").val();
		
		if( dataSerialize == "") return;		
		
		$.ajax({
	     	type:"POST",
	     	url:"teamSave.do",
	     	dataType:"json",
	     	data: dataSerialize ,
	     	success:function(data){
	     		alert("저장 되었습니다.");
				mainSearch();
	     	},
	     	error:function(data){
	     		console.log("통신중 오류가 발생하였습니다.");
	     	}
	     });
	}
	
	function deleteMem(mb_id){
		var no = $("#no").val();
		
		$.ajax({
	     	type:"POST",
	     	url:"teamMemDelete.do",
	     	dataType:"json",
	     	data: {
	     		no : no
	     	   ,userId : mb_id
	     	},
	     	success:function(data){
	     		alert("삭제 되었습니다.");
	     		mainSearch();
	     	},
	     	error:function(data){
	     		console.log("통신중 오류가 발생하였습니다.");
	     	}
	     });
	}

	function mainSearch(){
		
	    $.ajax({
	     	type:"POST",
	     	url:"selectProject.do",
	     	dataType:"json",
	     	success:function(data){
	     		
	     		var idx=0;
	     		var html;
	     		
	     		$("#projectList").empty();
	     		$("#no").val("");
	     		$("#main_work").val("");
	     		$("#detail").empty();
	     		addrow = false;

	  			for (var i = 0; i < data.length; i++) {
	  				
		  			idx++;
		  			html =  "<tr onclick=\"detailSearch('"+data[i].no+"','"+data[i].main_work+"')\" style=\"cursor:pointer;\"> ";
		  			html += "<td id=\"a"+idx+"\">"+ data[i].no   +"</td> ";
		  			html += "<td id=\"b"+idx+"\">"+ data[i].main_work +"</td>";
		  			html += "<td id=\"c"+idx+"\">"+ data[i].from_dt+"~"+data[i].to_dt +"</td>" ;
		  			
		  			html += "</tr>";
		  			
		  			$("#projectList").append(html);
														
				}
		  			
	     	},
	     	error:function(data){
	     		console.log("통신중 오류가 발생하였습니다.");
	     	}
	     });
	}
	
	
	function detailSearch(no,main_work){
		$("#no").val(no);
		$("#main_work").val(main_work);
        $.ajax({
         	type:"POST",
         	url:"teamList.do",
        	    data :{"no" : $("#no").val()
       	    },
         	dataType:"json",
         	success:function(data){
         		$("#detail").empty();
         		addrow = true;
         		
         		var idx=0;
         		var html;
         		
   	  			for (var i = 0; i < data.length; i++) {
   	  				
   	  				idx++;
   	  				
   	  				html =  "<tr id=\"trID"+ idx +"\"   >";
   	  			    html += "<td> <input type=\"text\" readOnly=\"readOnly\" title=\"직원ID\" name=\"no\"         value=\""+ data[i].no +"\"  id=\"no"+idx+"\"        style=\"width:0px; display:none\" /> ";
   				    html += "     <input type=\"text\" readOnly=\"readOnly\" title=\"직원ID\" name=\"main_work\"  value=\""+ data[i].main_work +"\"  id=\"main_work"+idx+"\" style=\"width:0px; display:none\" /> ";
   				
   	  			    html += "     <input type=\"text\" readOnly=\"readOnly\" title=\"직원ID\" name=\"userId\"  value=\""+ data[i].userId +"\"  id=\"userId"+idx+"\" style=\"width:95px;\" /> </td>";
   			  	    html += "<td> <input type=\"text\" maxlength=\"50\" readOnly=\"readOnly\" title=\"직원명\" name=\"userId_nm\" value=\""+data[i].userNm +"\"  id=\"userId"+idx+"_nm\"  style=\"width:79px\" /> <input onclick=\"callUsrPop(this.title)\" class=\"btn-type3 type3 min-size3\" type=\"button\" value=\"찾기\" title=\"userId"+idx+"\"> </td>";
   			  	    html += "<td style=\"text-align:center;\" > <input type=\"date\" maxlength=\"10\" title=\"투입일자\" value=\""+ data[i].tuip_fr_dt.substr(0,4)+'-'+data[i].tuip_fr_dt.substr(4,2)+'-'+data[i].tuip_fr_dt.substr(6,2) +"\" name=\"tuip_fr_dt\" id=\"tuip_fr_dt"+idx+"\" style=\"width:115px;\" /> </td>";
   			  	    if(data[i].tuip_ed_dt != null)
   			  	        html += "<td style=\"text-align:center;\" > <input type=\"date\" maxlength=\"10\" title=\"철수일자\" value=\""+ data[i].tuip_ed_dt.substr(0,4)+'-'+data[i].tuip_ed_dt.substr(4,2)+'-'+data[i].tuip_ed_dt.substr(6,2) +"\" name=\"tuip_ed_dt\" id=\"tuip_ed_dt"+idx+"\" style=\"width:120px;\" /> </td>";
   			  	    else 
   			  	    html += "<td style=\"text-align:center;\" > <input type=\"date\" maxlength=\"10\" title=\"철수일자\" value=\"\" name=\"tuip_ed_dt\" id=\"tuip_ed_dt"+idx+"\" style=\"width:120px;\" /> </td>";	
   			  	    html += "<td style=\"text-align:center;\" > <input type=\"button\" maxlength=\"10\" title=\"삭제\" value=\"삭제\" name=\"delMem\" id=\"delMem"+idx+"\" style=\"width:100px;\" class=\"btn-type3 type3 min-size3\"  onclick=\"deleteMem('"+ data[i].userId + "')\" /></td>";
   	  				html += "</tr>";
					
					$("#detail").append(html);
					$("#use_yn"+idx).val(data[i].USE_YN);
															
				}
   	  			
   	  			
   	  			
         	},
         	error:function(data){
         		console.log("통신중 오류가 발생하였습니다.");
         	}
         });
	}	
	
	function detailAdd(){
		
 		var idx = $("#detail tr").length+1;
	    var html =  "<tr id=\"trID"+ idx +"\"   >";
		if(addrow){

			html += "<td> <input type=\"text\" readOnly=\"readOnly\" title=\"직원ID\" name=\"no\"         value=\"" + $('#no').val() + "\" + id=\"no"+idx+"\"        style=\"width:0px; display:none\" /> ";
			html += "<input type=\"text\" readOnly=\"readOnly\" title=\"직원ID\" name=\"main_work\"  value=\"\"  id=\"main_work"+idx+"\" style=\"width:0px; display:none \" /> ";
			
			html += "<input type=\"text\" readOnly=\"readOnly\" title=\"직원ID\" name=\"userId\"  value=\"\"  id=\"userId"+idx+"\" style=\"width:95px;\" /> </td>";
		  	html += "<td> <input type=\"text\" readOnly=\"readOnly\" maxlength=\"50\" title=\"직원명\" name=\"userId_nm\" value=\"\"  id=\"userId"+idx+"_nm\"  style=\"width:79px\" /> <input onclick=\"callUsrPop(this.title)\" class=\"btn-type3 type3 min-size3\" type=\"button\" value=\"찾기\" title=\"userId"+idx+"\"> </td>";
		  	html += "<td style=\"text-align:center;\" > <input type=\"date\" maxlength=\"10\" title=\"투입일자\" value=\"\" name=\"tuip_fr_dt\" id=\"tuip_fr_dt"+idx+"\" style=\"width:120px;\" /> </td>";
		  	html += "<td style=\"text-align:center;\" > <input type=\"date\" maxlength=\"10\" title=\"철수일자\" value=\"\" name=\"tuip_ed_dt\" id=\"tuip_ed_dt"+idx+"\" style=\"width:120px;\" /> </td>";
		  	html += "<td></td>"
		  	html += "";
		  	html += "</tr>";
			$("#detail").append(html);
		}else{
			alert("행추가를 하실 수 없습니다.\n프로젝트를 선택해 주세요.");			
		}
		
	}
	
	function detailDelete(){
		
		var idx = $("#detail tr").length;
		var chk = $("#chk"+idx).val();
		
		if(idx == 0){
			alert("삭제할 행이 존재 하지 않습니다 ");
		}
		
		
		if(chk == 1){
			alert("이미 저장되어있는 데이터는 행삭제 하실수 없습니다.\n사용하시지 않으실거면 사용여부를 부로 변경하여 주세요.");
			return;
		}
		
		$("#trID"+idx).remove();
	}
	
	var userPopTitle;
	function callUsrPop(objId){
		userPopTitle = objId; 
		$.ajax({
				url : "userPop.do",
				data : {
					gubun : "project"
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
    
	function selectUser(mb_id, mb_nm){
		console.log("userPopTitle:::"+userPopTitle);  
		console.log("mb_id::::::"+ mb_id);
		console.log("mb_nm::::::"+ mb_nm);
	    $('#detailForm #'+userPopTitle).val(mb_id);     	    	 
	    $('#detailForm #'+userPopTitle+'_nm').val(mb_nm);
		$("#userSelPop").css("display","none");
		
	}
	


	
</script>
<body>
	<!--navigation-->
	<jsp:include page="common/Navigation.jsp" />

	<!--container--> <!-- position:absolute; width:200px;  height: 400px; -->
  	
 	
<!-- 	<div class ="btn-box" style="max-width:1280px;"> -->
<!-- 	    <div class="left"> -->
<!-- 		</div> -->
<!--         <div class="right"> -->
<!--           <button class="btn-type3 type3 min-size3" onclick="new_init();">신규</button> -->
          
<!--         </div> -->
<!-- 	</div > -->
		
	<div class="container" style="max-width:1250px; height: 620px;">
	    <div class="left">
          <p class="tit-type4">팀원등록 </p>  <!-- <span class="c-org">(*필수입력)</span> -->
        </div>
		<!-- 목록 -->
		<div class='data-st4' style="width:450px; height:550px; overflow:scroll; position:absolute;  box-sizing: border-box;">
			<table>
				<!-- 기본값 원하는최소값으로 지정-->
				<colgroup>
					<col style="width: 40px" />
					<col style="width: 200px" />
					<col style="width: 145px" />
				</colgroup>
				<thead>
					<tr>
						<th>NO</th>
						<th>프로젝트</th>
						<th>기간</th>
					</tr>
				</thead>
				<tbody id="projectList">
				</tbody>
			</table>
		</div>
		<!-- 마스터 -->
		<div class='data-st4' style="position:relative; left:485px; height:20px; width:60%; box-sizing: border-box;">
			<table>
				<!-- 기본값 원하는최소값으로 지정-->
				<colgroup>
					<col style="width: 20%" />
					<col style='width: 70%' />
				</colgroup>
				<tbody>
					<tr>
						<th>NO</th>
						<td><input type="text" id="no" name="no" readonly="readonly" style="width:80%; border: 0px !important"/></td>
					</tr>
					<tr>
						<th>프로젝트</th>
						<td><input type="text" id="main_work" name="main_work" readonly="readonly" style="width:80%; border: 0px !important"/></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class ="btn-box" style="position:absolute; left:485; top:265px; height:20px; width:1235px; box-sizing: border-box;">
			<div class="left">
			</div>
	        <div class="right">
	          <button class="btn-type3 type3 min-size3" onclick="comm_save();">저장</button>
	          <button class="btn-type3 type3 min-size3" onclick="detailAdd();">행추가</button>
	          <button class="btn-type3 type3 min-size3" onclick="detailDelete();">행삭제</button>
	        </div>
		</div >
		
		<!-- 상세 -->
		<div class='data-st4'  style="position:relative; left:485px; top:150px; width:60%; height:380px; overflow:scroll;  box-sizing: border-box;">
			<form id="detailForm">
				<table>
					<!-- 기본값 원하는최소값으로 지정-->
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 25%" />
						<col style="width: 20%" />
						<col style="width: 20%" />
						<col style="width: 20%" />
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">직원ID</th>
							<th style="text-align: center;">직원명</th>
							<th style="text-align: center;">투입일자</th>
							<th style="text-align: center;">철수일자</th>
							<th style="text-align: center;">삭제</th>
						</tr>
					</thead>
					<tbody id="detail">
					</tbody>
					
				</table>
			</form>
		</div>
		
	</div>
	
	<div id="subArea">
	  <div id="userSelPop" style="display:none;" class="modal"></div>
    </div>
	<!-- /.container -->

	<!-- Contact form JavaScript -->
	<!-- Do not edit these files! In order to set the email address and subject line for the contact form go to the bin/contact_me.php file. -->
	<script src="resrc/js/jqBootstrapValidation.js"></script>

	<jsp:include page="common/Footer.jsp" />

	<script>
		includeHTML();
	</script>
</body>

</html>