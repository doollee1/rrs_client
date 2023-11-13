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
	<!--container-->
	<div class="container">
        <div class="data-top">
            <div class="left">
        	</div>
        	<c:if test ="${sessionScope.loginYn eq 'Y' && sessionScope.usrlvl eq '0'}">
	        	<form method="POST" id="target" >
				</form>					
	        	<script>
	        	    function writePage(value){
	        	    	
						$("#target").attr("action","noticeWrite.do");
						$("#target").append($('<input/>',{type:'hidden', name: 'wr_id', value: value }  ));
	        	    	$("#target").append($('<input/>',{type:'hidden', name: 'check', value: 'UPDATE' }  ));
						$("#target").appendTo('body');
						$('#target').submit();
						
	        	    }
	        	</script>  
	        	<div class="right">
	           		<a href="javascript:void(0);" onclick="writePage('${rsMap.wr_id}');" class="btn-type1 type1 min-size1">수정</a>
	        	</div>
        	</c:if>
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
                    <b>${rsMap.wr_subject}</b>
                </td>
              </tr>
              <tr>
                <th>글쓴이</th>
                 <td>${rsMap.wr_name}</td>
              </tr>
              <tr>
                <th>내용</th>
                <td>
                    <div class="view">
                    <pre>${rsMap.wr_content}</pre>
                    </div>
                </td>
              </tr>
            </tbody>
            </table>
          </div>
          <!-- // data-st2 -->
          <div class="btn-box">
            <div class="left">
                <a href="/noticeList.do" class="btn-type1 type1 min-size1">목록</a>
            </div>
<!--              <div class="right">
                <a href="javascript:void(0);" class="btn-type1 type2 min-size1">이전글</a>
                <a href="javascript:void(0);" class="btn-type1 type2 min-size1">다음글</a>
            </div>  -->
        </div>
	</div>
	<!--/container-->

	<jsp:include page="common/Footer.jsp"></jsp:include>
	
	<script>includeHTML();</script>
</body>
</html>