<%@ page import ="java.text.SimpleDateFormat" %>
<%@ page import ="java.util.Date" %>
<%
	Date dt = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월");
	String str_dt = sdf.format(dt);

%>
<div class="tab-cont company-intro">
  <h2 class="tit-type1">회사소개</h2>
  <div class="data-st2">
    <table>
      <colgroup class="m-hide">
        <col style="width:30%" />
        <col style="width:70%" />
      </colgroup >
      <colgroup class="w-hide">
        <col style="width:40%" />
        <col style="width:60%" />
      </colgroup >
      <tbody>
        <tr>
          <th>회사명</th>
          <td>주식회사 둘리정보통신</td>
        </tr>
        <tr>
          <th>주소</th>
          <td>본사 : (06313) 서울시 강남구 논현로 6, 6층 (혜정빌딩) <br><br>기술연구소 : (16006) 경기 의왕시 성고개로 53, 823호(에이스청계타워)</td>
        </tr>
        <tr>
          <th>전화번호</th>
          <td>TEL: 02-572-7896 (FAX 02-572-7897)</td>
        </tr>
        <tr>
          <th>사업분야</th>
          <td>시스템 통합사업(SI), 시스템 운영사업(SM), 컨설팅</td>
        </tr>
        <tr>
          <th>설립년도</th>
          <td>1994년 07월</td>
        </tr>
        <tr>
          <th>해당분야사업기간</th>
          <td>1994년 07월 ~ <%=str_dt %> 현재 (25년)</td>
        </tr>
      </tbody>
    </table>
  </div>
  
  
  <h2 class="tit-type2"><span>주요연혁</span></h2>
  <!-- company-history -->
  <div class="company-history">
  
    <ul class="history">
      <li>
        <strong class="year">2015</strong>
        <div class="cellbox">
          <div class="cell month"><p><span><!-- 06.01--></span></p></div>
          <div class="cell text">
            <p class="tit">축산대표감사패 수상(축산경제통합시스템 구축)</p>
          </p>
          </div>
        </div>
      </li>
      <li>
        <strong class="year">2012</strong>
        <div class="cellbox">
          <div class="cell month"><p><span><!-- 06.01--></span></p></div>
          <div class="cell text">
            <p class="tit">(주)농협정보시스템 전략 협력업체 등록</p>
          </p>
          </div>
        </div>
      </li>
      <li>
        <strong class="year">2011</strong>
        <div class="cellbox">
          <div class="cell month"><p><span><!-- 06.01--></span></p></div>
          <div class="cell text">
            <p class="tit">무인정산시스템 Solution 공급</p>
          </p>
          </div>
        </div>
      </li>
      <li>
        <strong class="year">2006</strong>
        <div class="cellbox">
          <div class="cell month"><p><span><!-- 06.01--></span></p></div>
          <div class="cell text">
            <p class="tit">(주)농협정보시스템 협력업체 등록</p>
          </p>
          </div>
        </div>
      </li>
      <li>
        <strong class="year">2003</strong>
        <div class="cellbox">
          <div class="cell month"><p><span><!-- 06.01--></span></p></div>
          <div class="cell text">
            <p class="tit">(사)한국정보통신산업협회 가입</p>
          </p>
          </div>
        </div>
      </li>
      <li>
        <strong class="year">2001</strong>
        <div class="cellbox">
          <div class="cell month"><p><span><!-- 06.01--></span></p></div>
          <div class="cell text">
            <p class="tit">CBD기반 소프트웨어개발</p>
            <p class="tit">업무제휴 협의(한,일)</p>
          </p>
          </div>
        </div>
      </li>
      <li>
        <strong class="year">2000</strong>
        <div class="cellbox">
          <div class="cell month"><p><span><!-- 06.01--></span></p></div>
          <div class="cell text"><p class="tit">소프트웨어 공제조합 가입</p></div>
        </div>
      </li>
      <li>
        <strong class="year">1999</strong>
        <div class="cellbox">
          <div class="cell month"><p><span><!-- 06.01--></span></p></div>
          <div class="cell text">
            <p class="tit">정보통신부 시스템 통합사업자 등록</p>
          </div>
        </div>
      </li>
      <li>
        <strong class="year">1997</strong>
        <div class="cellbox">
          <div class="cell month"><p><span><!-- 06.01--></span></p></div>
          <div class="cell text">
            <p class="tit">소프트웨어산업협회</p>
            <p class="tit">병무청 병역특례 지정업체 선정</p>
            <p class="tit">가입 한국 전산업 협동조합가입</p>
            <p class="txt"></p>
          </div>
        </div>
      </li>
      <li>
        <strong class="year">1994</strong>
        <div class="cellbox">
          <div class="cell month"><p><span></span></p></div>
          <div class="cell text">
            <p class="tit">(주)둘리정보통신 설립</p>
            <p class="txt"></p>
          </div>
        </div>
      </li>
    </ul>
  </div>
  <!-- // company-history -->
  
  <h2 class="tit-type2"><span>조직도</span></h2>
  <div class="org-chart">
    <img src="resrc/image/organization.png" style="width:100%;height:auto">
  </div>
</div>