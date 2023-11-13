<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta charset="utf-8">
<meta name="viewport"    content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author"      content="">

<title>(주)둘리정보통신</title>
<!-- Bootstrap core CSS -->
<link href="resrc/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
<!-- Custom styles for this template -->
<!-- <link href="css/modern-business.css" rel="stylesheet"> -->
<!--css-->
<link href="resrc/css/common_admin.css" rel="stylesheet">
<!-- <link href="css/Business_consulting.css" rel="stylesheet"> -->
<!--script-->
<script src="resrc/js/includeHTML.js"></script>
<script src="resrc/vendor/jquery/jquery.js"></script>
<script src="resrc/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
</head>

<body style="height:100%">
    <style>
        #detailForm table input, #detailForm table select {width: calc(100% - 10px) }
        table tr {height: 50px}
        .data-st2::-webkit-scrollbar {width:10px;height:10px;background:gainsboro}
        .data-st2::-webkit-scrollbar-thumb {background:darkgray;border:3px solid gainsboro;}
        .newInsMsg {
            width: calc(100vw - 30px);
            height: fit-content;
            max-width:600px;
            border: 1px solid darkgray;
            border-radius: 10px;
            position: fixed;
            bottom: -300px;
            margin: 30px 15px;
            background: white;
            padding: 20px;
            color: cornflowerblue;
            font-weight: bold;
            transition: all 1s;
        }
    </style>
    <script>
        var addrow = false;
        
        $(document).ready(function(){
            mainSearch();
            
            $("#simp_tpc"  ).attr("readonly",true);
            $("#simp_tpcnm").attr("readonly",true);

            $("html, body").css("overflow", "hidden");
            $("footer").css("position", "fixed").css("width", "100%").css("bottom", "0");
            $(window).resize();
        });
        
        $(window).resize( function() {
            if( $("footer").length > 0 ) {
                var mHeight = 0;
                $("footer").css("top", window.innerHeight <= 1000 ? "100%" : "auto");
                $("#baseForm, #detailForm").each( function() {
                    mHeight = $("footer").offset().top - $(this).offset().top ;
                    $(this).parent().css("height", mHeight );
                });
            }
        });

        function new_init(){
            $("#simp_tpc").val("");
            $("#simp_tpcnm").val("");
            $("#detail").empty();
            
            $("#simp_tpc").attr("readonly",false);
            $("#simp_tpcnm").attr("readonly",false);
            
            addrow = true;
            
            $(".container").scrollLeft( 390 ); //상세보이기
            if( window.innerWidth <= 500 ) {
                setTimeout( function() { $(".newInsMsg").css("bottom", "0"     ); }, 200  );
                setTimeout( function() { $(".newInsMsg").css("bottom", "-300px"); }, 4000 );
            }
        }

        function checkFields(){
            var result     = true;
            var simp_tpc   = $("#simp_tpc").val();
            var simp_tpcnm = $("#simp_tpcnm").val();
            
            if(simp_tpc == "" || simp_tpc == null ){
                alert("코드를 입력하여 주세요.");
                result = false;
                return;
            }
            if(simp_tpc == "" || simp_tpc == null ){
                alert("코드명을 입력하여 주세요.");
                result = false;
                return;
            } 
            var frm = $("#detailForm :input").not(":input[type=hidden]");
            
            frm.each( function(idx, ele) {
                if( "" == $(ele).val() || null == $(ele).val() ){
                    if($(ele).attr("name") != "use_yn" && $(ele).attr("name") != "attr_1" && $(ele).attr("name") != "attr_2" ){
                        alert($(ele).attr("title") + "을(를) 입력하세요");
                        $(ele).focus();
                        result = false;
                        return result;
                    }
                };
                if($(ele).attr("name") == "order_num"){
                    if(!$.isNumeric($(ele).val())){
                        alert($(ele).attr("title") + " 숫자만 입력하세요");
                        $(ele).focus();
                        result = false;
                        return result;
                    }
                }
            });
            return result;
        }

        function comm_save(){
            if(!checkFields()) { return; }
            
            var dataSerialize = $("#detailForm").serialize();
            var simp_tpc      = $("#simp_tpc"  ).val();
            var simp_tpcnm    = $("#simp_tpcnm").val();
            
            $.ajax({
                type:"POST",
                url:"Comm_codeCud.do",
                dataType:"json",
                data: "simp_tpc="+simp_tpc+"&simp_tpcnm="+simp_tpcnm+"&"+dataSerialize ,
                success:function(data){
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
                url:"Comm_codeList.do",
                dataType:"json",
                success:function(data){
                    var idx = 0;
                    var html   ;
                    
                    $("#commList"  ).empty();
                    $("#simp_tpc"  ).val("");
                    $("#simp_tpcnm").val("");
                    $("#detail"    ).empty();
                    addrow = false;

                    for (var i = 0; i < data.length; i++) {
                        idx++;
                        html =  "<tr onclick=\"detailSearch('"+data[i].simp_tpc+"','"+data[i].simp_tpcnm+"')\" style=\"cursor:pointer;\"> ";
                        html += "<td id=\"a"+idx+"\">"+ data[i].simp_tpc   +"</td> ";
                        html += "<td id=\"b"+idx+"\">"+ data[i].simp_tpcnm +"</td>";
                        html += "</tr>";
                        $("#commList").append(html);
                    }
                },
                error:function(data){
                    console.log("통신중 오류가 발생하였습니다.");
                }
            });
        }

        function detailSearch(simp_tpc,simp_tpcnm){
            $("#simp_tpc").val(simp_tpc);
            $("#simp_tpcnm").val(simp_tpcnm);
            $("#simp_tpc").attr("readonly",true);
            
            $.ajax({
                type:"POST",
                url:"Comm_codeDetail.do",
                data :{"simp_tpc" : simp_tpc},
                dataType:"json",
                success:function(data){
                    $("#detail").empty();
                    addrow = true;
                    
                    var idx = 0 ;
                    var html    ;
                    for (var i = 0; i < data.length; i++) {
                        idx++;
                        html =  "<tr id=\"trID"+ idx +"\"   >";
                        html += "<td style=\"text-align:center; padding:0px;\"> <input type=\"text\" title=\"상세코드\"  maxlength=\"20\" name=\"simp_c\"    id=\"simp_c"+idx+"\"    value=\""+data[i].simp_c    +"\" readonly=\"readonly\" /> <input type=\"hidden\" id=\"chk"+idx+"\"  value=\"1\" /> </td>";
                        html += "<td style=\"text-align:center; padding:0px;\"> <input type=\"text\" title=\"상세코드명\" maxlength=\"50\" name=\"simp_cnm\"  id=\"simp_cnm"+idx+"\"  value=\""+data[i].simp_cnm  +"\" /> </td>";
                        html += "<td style=\"text-align:center; padding:0px;\"> <input type=\"text\" title=\"순서\"     maxlength=\"3\"  name=\"order_num\" id=\"order_num"+idx+"\" value=\""+data[i].order_num +"\" style=\"text-align:right;\"  /> </td>";
                        html += "<td style=\"text-align:center; padding:0px;\"> <select id=\"use_yn"+idx+"\" name=\"use_yn\" style=\"min-width:60px; \"  > <option value=\"1\">여</option> <option value=\"0\">부</option></select> </td>";
                        html += "<td style=\"text-align:center; padding:0px;\"> <input type=\"text\" title=\"참조1\"    maxlength=\"50\" name=\"attr_1\"    id=\"attr_1_"+idx+"\"   value=\""+data[i].attr_1    +"\" /> </td>";
                        html += "<td style=\"text-align:center; padding:0px;\"> <input type=\"text\" title=\"참조2\"    maxlength=\"50\" name=\"attr_2\"    id=\"attr_2_"+idx+"\"   value=\""+data[i].attr_2    +"\" /> </td>";
                        html += "</tr>";
                        $("#detail").append(html);
                        $("#use_yn"+idx).val(data[i].USE_YN);
                    }
                    
                    $(".container").scrollLeft( 390 ); //상세보이기
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
                html += "<td style=\"text-align:center; padding:0px;\" > <input type=\"text\" maxlength=\"20\" title=\"상세코드\"   name=\"simp_c\"    value=\"\"  id=\"simp_c"+idx+"\"    /> <input type=\"hidden\" id=\"chk"+idx+"\"  value=\"0\" /> </td>";
                html += "<td style=\"text-align:center; padding:0px;\" > <input type=\"text\" maxlength=\"50\" title=\"상세코드명\"  name=\"simp_cnm\"  value=\"\"  id=\"simp_cnm"+idx+"\"  />                     </td>";
                html += "<td style=\"text-align:center; padding:0px;\" > <input type=\"text\" maxlength=\"3\"  title=\"순서\"      name=\"order_num\" value=\"\"  id=\"order_num"+idx+"\" style=\"text-align:right; \" />  </td>";
                html += "<td style=\"text-align:center; padding:0px;\" > <select id=\"use_yn"+idx+"\" name=\"use_yn\" style=\"min-width:60px; \" > <option value=\"1\">여</option> <option value=\"0\">부</option></select></td>";
                html += "<td style=\"text-align:center; padding:0px;\" > <input type=\"text\" maxlength=\"50\" title=\"참조1\"     name=\"attr_1\"    value=\"\" id=\"attr_1_"+idx+"\"   />  </td>";
                html += "<td style=\"text-align:center; padding:0px;\" > <input type=\"text\" maxlength=\"50\" title=\"참조2\"     name=\"attr_2\"    value=\"\"  id=\"attr_2_"+idx+"\"  /> </td>";
                html += "";
                html += "</tr>";
                $("#detail").append(html);
            }else{
                alert("행추가를 하실 수 없습니다.\n신규 버튼을 클릭 하여주세요.");			
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
    </script>

    <!--navigation-->
    <jsp:include page="common/Navigation.jsp" />
    
    <!--container--> <!-- position:absolute; width:200px;  height: 400px; -->
    <div class="container" style="max-width:1200px; width:calc(100vw - 25px); height:100%; padding:30px 0px; overflow-x:auto; scroll-behavior:smooth">
        <div class="btn-box code">
            <div class="left">
                <p class="tit-type4">공통코드 관리 </p> <!-- <span class="c-org">(*필수입력)</span> -->
            </div>
            <div class="right" style="position:fixed;right:10px;z-index:10;box-shadow:0px 0px 40px 30px white;background:white;">
                <button class="btn-type1 type1 min-size1" onclick="new_init();">신규</button>
                <button class="btn-type1 type1 min-size1" onclick="comm_save();">저장</button>
            </div>
        </div >		
    
        <!-- 목록 -->
        <div style="position:relative">
            <div class='data-st2' style="width:370px; height:50px; position:absolute; box-sizing: border-box;">
                <table>
                    <!-- 기본값 원하는최소값으로 지정-->
                    <colgroup>
                        <col style="width: 150px" />
                        <col style="width: 200px" />
                        <col style="width:  10px" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>코드</th>
                            <th style="border:0">코드명</th>
                            <th style="border:0"></th>
                        </tr>
                    </thead>
                </table>
            </div>
            <div class='data-st2' style="width:370px; margin-top:50px; overflow:scroll; position:absolute;  box-sizing: border-box;">
                <form id="baseForm">
                    <table>
                        <!-- 기본값 원하는최소값으로 지정-->
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: 200px" />
                        </colgroup>
                        <tbody id="commList">
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
        <!-- 마스터 -->
        <div style="min-width:1000px;max-width:1155px;margin:auto">
        <div class='data-st2' style="position:relative; left:390px; height:27px; width:68%; box-sizing: border-box;">
            <table>
                <!-- 기본값 원하는최소값으로 지정-->
                <colgroup>
                    <col style="width: 20%" />
                    <col style='width: 70%' />
                </colgroup>
                <tbody>
                    <tr>
                        <td style="font-size:16px;color:#5c5c5c;background-color: #f8f8f8; border: 1px solid #dedede; font-weight: bold;">코드</td>
                        <td><input type="text" id="simp_tpc" name="simp_tpc" /> </td>
                    </tr>
                    <tr>
                        <td style="font-size:16px;color:#5c5c5c;background-color: #f8f8f8; border: 1px solid #dedede; font-weight: bold;">코드명</td>
                        <td><input type="text" id="simp_tpcnm" name="simp_tpcnm" /></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class='btn-box' style="position:relative; left:390px; top:100px; height:20px; width:68%; box-sizing: border-box;">
            <div class="left">
            </div>
            <div class="right">
                <button class="btn-type2 type1 min-size1" onclick="detailAdd();">행추가</button>
                <button class="btn-type2 type1 min-size1" onclick="detailDelete();">행삭제</button>
            </div>
        </div >
        <!-- 상세 -->
        <div class='data-st2' style="position:relative; left:390px; top:133px; width:68%; height:50px; box-sizing: border-box;">
            <table>
                <!-- 기본값 원하는최소값으로 지정-->
                <colgroup>
                    <col style="width: 20%"  />
                    <col style="width: 30%"  />
                    <col style="width: 10%"  />
                    <col style="width: 10%"  />
                    <col style="width: 15%"  />
                    <col style="width: 15%"  />
                    <col style="width: 10px" />
                </colgroup>
                <thead>
                    <tr>
                        <th style="text-align: center; padding-left :0px;">상세코드</th>
                        <th style="text-align: center; padding-left :0px;">상세코드명</th>
                        <th style="text-align: center; padding-left :0px;">순서</th>
                        <th style="text-align: center; padding-left :0px;">사용여부</th>
                        <th style="text-align: center; padding-left :0px;">참조1</th>
                        <th style="text-align: center; padding-left :0px; border:0">참조2</th>
                        <th style="border:0"></th>
                    </tr>
                </thead>
            </table>
        </div>
        <div class='data-st2' style="position:relative; left:390px; top:133px; width:68%; overflow:scroll; box-sizing: border-box;">
            <form id="detailForm">
                <table>
                    <!-- 기본값 원하는최소값으로 지정-->
                    <colgroup>
                        <col style="width: 20%" />
                        <col style="width: 30%" />
                        <col style="width: 10%" />
                        <col style="width: 10%" />
                        <col style="width: 15%" />
                        <col style="width: 15%" />
                    </colgroup>
                    <tbody id="detail">
                    </tbody>
                </table>
            </form>
        </div>
        </div>
    </div>
    <!-- /.container -->
    <div class="newInsMsg">코드/코드명을 입력하고 행추가 버튼을 클릭해서 상세내용을 입력해 주세요.</div>
    
    <!-- Contact form JavaScript -->
    <!-- Do not edit these files! In order to set the email address and subject line for the contact form go to the bin/contact_me.php file. -->
    <script src="resrc/js/jqBootstrapValidation.js"></script>
    
    <jsp:include page="common/Footer.jsp" />
    
    <script>includeHTML();</script>
</body>

</html>