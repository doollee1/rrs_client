<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
  <!-- <link href="css/Business_service.css" rel="stylesheet"> -->
  <!--script-->
  <script src="resrc/js/includeHTML.js"></script>  
  <script src="resrc/vendor/jquery/jquery.js"></script>
  <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!--navigation-->
	<jsp:include page="common/Navigation.jsp"></jsp:include>

	<div class="visual" style="background-image: url('resrc/image/sub_visual_01_3.png')">
		<p class="txt">/공지사항</p>
	</div>
	<c:set value="${rsMap}" var="rsMap" />
	<c:set value="${check}" var="check" />
	<c:set value="${sessionScope.login}" var="login" />
	<!--container-->
	<div class="container">
        <div class="data-top">
             <div class="left">
        	</div>
        </div>
        <!-- data-st2 -->
		<div class="data-st2">
            <table>
              <colgroup>
                <col style="width:20%">
                <col style="width:auto">
              </colgroup>
              <tbody><tr>
                <th>제목</th>
                <td scope="col">
                    <input type="text" id="wr_subject" value="<c:out value='${rsMap.wr_subject}' />" style="width:100%;">
                </td>
              </tr>
              <c:if test="${check eq 'UPDATE'}">
                  <input type="hidden" id="wr_id" value="<c:out value='${rsMap.wr_id}' />" />
	              <tr>
	                <th>글쓴이</th>
	                 <td>${rsMap.wr_name}</td>
	              </tr>
              </c:if>
              <tr>
                <th>내용</th>
                <td>
                    <textarea style="width:100%;height:200px;" maxlength="500" id="wr_content"><c:out value='${rsMap.wr_content}'/></textarea>
                    <input type="hidden" id="chk" value="${check}" />
                </td>
              </tr>
            </tbody>
            </table>
          </div>
          <script>
              function noticeCud(del){
            	  var wr_subject = $("#wr_subject").val();
            	  var wr_content = $("#wr_content").val();
            	  var chk        = $("#chk").val();
            	  var wr_id      = $("#wr_id").val();
            	  
            	  if(del == 'DEL'){
            		  chk = 'D';
            	  }else if(chk == 'UPDATE'){
            		  chk = 'U';
            	  }else{
            		  chk = 'I';
            	  }
            	  
            	  $.ajax({
          			type:"POST",
          			url:"noticeIns.do",
          			data:{"wr_subject":wr_subject
          			    , "wr_content":wr_content
          			    , "wr_id":wr_id
          			    , "chk":chk
          			},
          			
          			dataType:"json",
          			success:function(data){
          				
          				if(data == 'Y'){
          					if(chk == 'I'){
	          					alert("정상적으로 등록 되었습니다.");
          					}else if(chk == 'U'){
          						alert("정상적으로 수정 되었습니다.");
          					}else if(chk == 'D'){
          						alert("정상적으로 삭제 되었습니다.");
          					}
          					location.href="noticeList.do";
          				}else if(data == 'N'){
          					if(chk == 'I'){
          						alert("공지사항 등록 중 오류가 발생하였습니다.");
          					}else if(chk == 'U'){
          						alert("공지사항 수정 중 오류가 발생하였습니다.");
          					}else if(chk == 'D'){
          						alert("공지사항 삭제 중 오류가 발생하였습니다.");
          					}
          				}
          			},
          			error:function(data){
          				console.log("통신중 오류가 발생하였습니다.");
          			}
          		});
              }
       	  </script>  
          <!-- // data-st2 -->
          <div class="btn-box">
          
            <div class="left">
                <a href="/noticeList.do" class="btn-type1 type1 min-size1">목록</a>
            </div>
			<div class="right">
				<a onclick="noticeCud('DEL');" class="btn-type1 type1 min-size1">삭제</a>
            	<a onclick="noticeCud();" class="btn-type1 type1 min-size1">등록</a>
         	</div>
        </div>
	</div>
	<!--/container-->

	<jsp:include page="common/Footer.jsp"></jsp:include>
	
	<script>includeHTML();</script>
</body>
</html>