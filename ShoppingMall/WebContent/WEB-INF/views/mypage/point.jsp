<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/include/header.jsp"/>
<jsp:include page="/WEB-INF/views/mypage/navbar.jsp"/>

<link rel="stylesheet" type="text/css" href="/css/mypage/mypageStyle.css" />

<title>마이페이지-적립금</title>
<style type="text/css">
/* 적립금 표 가운데 정렬 , 글자색, 글자크기*/
table td {
	text-align: center;
	color:#616161;
	font-size: 15px;
}		
</style>

<%-- ////내용 시작//// --%>	
<div class="container p-5" >	
	<p style="margin-bottom:8px; font-weight: bold; color: black; text-align: center; font-size: 14pt;">적립금</p>
	<p class="text-secondary" style="margin-bottom:25px; text-align: center; font-size: 9pt;">고객님의 사용가능 적립금 금액 입니다.</p>
	<div class="pt-2 pb-5">	
	  <div class="card">
	    <div class="card-body" style="text-align: center; font-weight: bold; color: black; font-size: 21pt;">
	     	&nbsp; 총 적립금 <span> ${requestScope.mvo.point} P </span> 
	    </div>
	  </div>
	</div>
	<%-- 적립금  표 --%>
		<table class="table">	
		    <tr style="background-color: #f9f9f9;">
		      <td>주문날짜</td>
		      <td>적립금</td>
		      <td>내용</td>
		    </tr>		 
		  <tbody>
		     <c:forEach var="opvo" items="${requestScope.pointList}"> 
	      	   		<tr>
	      	   			<td class="userid">${opvo.order_dt}</td> 
	      	   			<td>${opvo.addpoint}</td>
	      	   			<td>${opvo.prod_name}</td>
	      	   		</tr>
	      	 </c:forEach>	  
		  </tbody>
		</table>

	<%-- 페이지네이션 --%>	

 
	<nav class="pagination pt-5" >
	     	
	     <ul class="pagination">${requestScope.pageBar}</ul>
	     	
	</nav>
	
</div>



<%-- ////내용 끝//// --%>
<script type="text/javascript">
</script
<jsp:include page="/WEB-INF/include/footer.jsp"/>>	