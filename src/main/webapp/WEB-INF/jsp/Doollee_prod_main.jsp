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
    <!-- Bootstrap core CSS -->
    <link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
    <!--css-->
    <link href="resrc/vendor/bootstrap/css/datepicker3.css" rel="stylesheet">    <!-- date picker 관련 import -->
    <link href="resrc/css/common_admin.css" rel="stylesheet">
    <!--script-->
    <script src="resrc/vendor/jquery/jquery.js"></script>
    <script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.js"></script>    <!-- date picker 관련 import -->
    <script src="resrc/vendor/bootstrap/js/bootstrap-datepicker.kr.js"></script> <!-- date picker 관련 import -->
    <script src="resrc/js/includeHTML.js"></script>  
    <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">

    <style>
        #insBtn { width: 100px;
                  border-radius: 10px;
                  background: linear-gradient(45deg, limegreen, white); 
                  font-weight: bold; 
                  color: white; 
                  margin-right:10px; 
                  box-shadow: 2px 2px 5px 0 black;
                }
        /*팝업(신청/승인/반려)에서 사용 css 추가*/
        .select_form_btn {width: 98%;border-radius: 5px;height: 37px !important;background: royalblue;color: white;font-weight: bolder;}
        #subArea > #regArea{position:fixed;top:110%;transition:all 0.5s;display:block;border-radius:10px 10px 0 0;height:100%}
        #regArea > #body_area {max-width:500px;margin:auto;}
        #regArea > #body_area > .modal-content {margin-top:calc(50vh - 55%);}
        #regArea .data-st4 {max-height:420px;}
    </style>

</head>

<body>
    <script>
        $(document).on("change", "#prodInfoForm .selectbox-form input", function() { selectList(); });
    
        // 조회
        function selectList(){
            $.ajax({
                type:"POST",
                url:"selectProdInfo.do",
                data:{ prod_no   : "",
                       prod_gbn  : $("#prodInfoForm #prod_gbn").val(),
                       prod_sts  : $("#prodInfoForm #prod_sts").val()
                     },
                contentType : "application/x-www-form-urlencoded; charset=UTF-8",
                success: function(data) {
                    if( data.indexOf("loginChk()") == -1 ) {
                        $("#listArea").html(data);
                    } else location.replace("go_Login.do");
                },
                error  : function(data) { console.log("조회중 오류가 발생하였습니다."); }
            });
        }
        
        function regInfo(){
            $.ajax({
                url         : "prodInfoReg.do",
                data        : null,
                contentType : "application/x-www-form-urlencoded; charset=UTF-8",
                type        : "POST",
                success     : function(result) {
                    if( result.indexOf("loginChk()") == -1 ) {
                        $("#regArea").html(result).show();
                        $("#regArea").css("top", "0");
                        
                        setTimeout( function() { $("body").css("overflow-y", "hidden"); }, 10 );
                        
                    } else location.replace("go_Login.do");
                },
                error       : function(e) {
                    alert(e.responseText);
                }
            });
        }
        
        $('body').on('click', '#listForm tbody tr', function(){
        	updateView( $(this).find("[name=prod_no]").text() );
        });
        function updateView( inProdNo ) {
            $.ajax({
           	    url         : "prodInfoUpd.do",
           	    data        : { prod_no: inProdNo },
           	    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
        	    type        : "POST",
        	    success     : function(result) {
                    if( result.indexOf("loginChk()") == -1 ) {
                        $("#regArea").html(result).show();
                        $("#regArea").css("top", "0");
                        
                        setTimeout( function() { $("body").css("overflow-y", "hidden"); }, 10 );
                        
                    } else location.replace("go_Login.do");
        	    },
        	    error : function(e) {
        		    alert(e.responseText);
                }
            });
        }
        
        $(document).ready(function(){
            selectList();
        });
    </script>

    <!--navigation-->
    <jsp:include page="common/Navigation.jsp" />
    
    <!--container-->    
    <div class="container">
        <div class="left">
            <p class="tit-type4">장비관리 </p>  <!-- <span class="c-org">(*필수입력)</span> -->
        </div>
        <form name="prodInfoForm" id="prodInfoForm" action="" method="post" >
            <!-- data-st1 -->
            <div class="data-pop-reg">
                <table>
                    <colgroup >
                        <col style="width:100px" />
                        <col style="width:200px" />
                        <col style="width:120px" />
                        <col style="width:200px" />
                        <col style="width:auto"  />
                    </colgroup >
                    <tr>
                        <th>제품구분</th>
                        <td scope="col" style="border-right:hidden !important">
                            <label class="selectbox-form">
                                <input type="text" id="prod_gbn" value="전체" code="" readOnly>
                                <div>
        	           	            <ul class="scrollCat-selbox">
        	           	                <li value="">전체</li>
                                        <c:forEach var="prod_gbn_list" items="${prod_gbn_list}" varStatus="i">
                                            <li value="${prod_gbn_list.simp_c}">${prod_gbn_list.simp_cnm}</li>
                                        </c:forEach>
        	           	            </ul>
        	           	        </div>
        	           	    </label>
                        </td>
                        <th style="padding-left: 20px">장비상태</th>
                        <td scope="col" style="border-right:hidden !important">
                            <label class="selectbox-form">
                                <input type="text" id="prod_sts" value="전체" code="" readOnly>
                                <div class="multi-select-div">
        	           	            <ul class="scrollCat-selbox">
        	           	                <li class="all-select" value=""><input type="checkbox"><label>전체</label></li>
                                        <c:forEach var="prod_sts_list" items="${prod_sts_list}" varStatus="i">
                                            <li value="${prod_sts_list.simp_c}">
        	           	                        <input type="checkbox"><label>${prod_sts_list.simp_cnm}</label>
                                            </li>
                                        </c:forEach>
        	           	            </ul>
        	           	        </div>
        	           	    </label>
                        </td>
                        <td style="text-align:right">
                            <input class="btn-type3 type3 min-size3" id="insBtn" type="button" value="신규등록" onclick="regInfo()">
                        </td>
                    </tr>
                </table>
            </div>
            <!-- // data-st2 -->
        </form>
        <div id="listArea"></div>
    </div>
    <!--/container-->
    
    <jsp:include page="common/Footer.jsp" />
    <script>includeHTML();</script>
</body>

<div id="subArea">
    <div id="regArea" class="modal"></div>
</div>

</html>