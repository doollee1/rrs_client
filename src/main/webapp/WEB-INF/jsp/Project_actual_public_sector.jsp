<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
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
<!-- <link href="css/Project_actual.css" rel="stylesheet"> -->
<!--script-->
<script src="resrc/js/includeHTML.js"></script>
<script src="resrc/vendor/jquery/jquery.js"></script>
<script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<body>   
   <div class='data-st1'>
	<table style="min-width: 800px">
         <!-- 기본값 원하는최소값으로 지정-->
         <colgroup>
            <col style='width: 20%' />
            <col style='width: 40%' />
            <col style='width: 20%' />
            <col style='width: 20%' />
         </colgroup>
         <thead>
            <tr>
               <th>업체명</th>
               <th>주요업무</th>
               <th>개발환경</th>
               <th>구축시기</th>
            </tr>
         </thead>
         <tbody>
           <c:forEach items="${public_sector}" var="public_sector">
            <tr>
               <td><c:out value="${public_sector.company}"/></td>
               <td><c:out value="${public_sector.main_work}"/></td>
               <td>
                <span class="basiccustomtooltip">
			     <span class="makeshort">
                  <c:out value="${public_sector.utill}"/>
                 </span>
                 <span class="basiccustomtooltiptext">
                  <c:out value="${public_sector.utill}"/>
                 </span>
                </span>  
               </td>
               <td>
                <c:out value="${fn:substring(public_sector.from_dt,0,4)}"/>.<c:out value="${fn:substring(public_sector.from_dt,4,6)}"/> 
                ~ <c:out value="${fn:substring(public_sector.to_dt,0,4)}"/>.<c:out value="${fn:substring(public_sector.to_dt,4,6)}"/>
               </td>
            </tr>
           </c:forEach>   
         </tbody>
    </table>
   </div>
</body>
</html>