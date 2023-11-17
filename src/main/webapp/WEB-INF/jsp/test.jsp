<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- 순서유의 --%>
<script src="resrc/rsa/rsa.js"  ></script>
<script src="resrc/rsa/jsbn.js" ></script>
<script src="resrc/rsa/prng4.js"></script>
<script src="resrc/rsa/rng.js"  ></script>

<script>
$(document).ready(function() {
	setTitle("테스트");
});

function login() {
	let rsa = new RSAKey();
	rsa.setPublic($('#RSAModulus').val(),$('#RSAExponent').val());
	let in_id = $("#in_id").val();
	let in_pw = rsa.encrypt($("#in_pw").val());

	alert(in_pw);

	$.ajax({
		type: "POST",
		url : "login.do",
		data: { "in_id":in_id, "in_pw":in_pw },
		dataType:"json",
		success:function(data) {
			alert(data);
		},
		error:function(data) {
			console.log("통신중 오류가 발생하였습니다.");
		}
	});
}
</script>
<div id="content" class="app-content d-flex flex-column p-0">
	<!-- BEGIN content-container -->
	<div class="app-content-padding flex-grow-1 overflow-hidden" data-scrollbar="true" data-height="100%">
		<!-- BEGIN panel -->
		<div class="panel panel-inverse">
			<div class="panel-body">
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
				<p>
					Add the <code>.app-content-full-height</code> css class to <code>.app</code> container for full height page element. 
					<br />
					<b>If</b> you only need the footer to be fixed at the bottom for <b>minimum max page height</b>, you are not required to add the <code>data-scrollbar="true"</code> and <code>data-height="100%"</code>;
				</p>
			</div>
			<%-- 테스트!!!!!!!!!!!!!!!!! start--%>
			<input type="text"     id="in_id" name="in_id" placeholder="아이디"  required><BR>
			<input type="password" id="in_pw" name="in_pw" placeholder="비밀번호" required><br>
			<input type="hidden"   id="RSAModulus"  value="${RSAModulus }"/>
			<input type="hidden"   id="RSAExponent" value="${RSAExponent}"/>
			<%-- 테스트!!!!!!!!!!!!!!!!! end--%>
		</div>
		<!-- END panel -->
	</div>
	<!-- END content-container -->
	
	<!-- BEGIN #footer -->
	<div id="footer" class="app-footer m-0">
		<a href="javascript:;" onclick="login();" class="btn btn-success btn-lg d-block">Block Button</a>
	</div>
	<!-- END #footer -->
</div>