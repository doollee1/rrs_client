<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<footer class="footer">
    <div class="wrapper">
      <c:if test="${sessionScope.login == null}">
         <span class="footer-logo"><a href="go_Login.do"><img src="resrc/image/logo_white.png"></a></span>
      </c:if>
      <c:if test="${sessionScope.login != null}">
         <span class="footer-logo"><img src="resrc/image/logo_white.png"></span>
      </c:if>
      <div class="text">
        <p class="address"><i class="fa fa-map-marker"></i> <span>(06313) 서울시 강남구 논현로 6, 6층 (혜정빌딩) </span><br class="w-hide"> <span>TEL : 02-572-7896</span> <span> FAX : 02-572-7897</span></p>
        <p class="copyright">COPYRIGHT&copy;2019 DooLLee ICT ALL RIGHT RESERVED.</p>
        <a href="/privacyInfo.do" class="privacy">개인정보처리방침</a>
      </div>
    </div> 
</footer>
