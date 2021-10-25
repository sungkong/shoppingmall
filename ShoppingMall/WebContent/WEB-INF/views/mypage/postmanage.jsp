<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="board.member.*, java.util.List"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%
	MypageDAO mdao = new MypageDAO();
	List<MypageVO> as = mdao.selectpage();
	pageContext.setAttribute("as", as);
%>   

<jsp:include page="/WEB-INF/include/header.jsp"/>
<jsp:include page="/WEB-INF/views/mypage/navbar.jsp"/>

<link rel="stylesheet" type="text/css" href="/css/mypage/mypageStyle.css" />
<title>마이페이지-게시물 관리</title>
<style type="text/css">	
/* 게시판 정렬 , 글자색, 글자크기*/
table td {
	text-align: center;
	color:#616161;
	font-size: 15px;
}

table > tbody > tr > td:nth-child(1){
	width: 6%;
}

table > tbody > tr > td:nth-child(3){
	width: 10%;
}

table > tbody > tr > td:nth-child(4){
	width: 10%;
}

table > tbody > tr > td:nth-child(5){
	width: 10%;
}	
</style>
<%-- ////내용 시작//// --%>

	
<div class="container p-5" >		
	
	<%-- 게시물 --%>
		<table class="table">		  
		    <tr style="background-color: #f9f9f9;">
		      <td>No</td>
		      <td>제목</td>
		      <td>작성일</td>
		      <td>작성자</td>
		      <td>조회수</td>
		    </tr>
		    <c:forEach var="mypage" items="${as}">
				
				  
		  
		    <tr>
		      <td>${mypage.myno}</td>
		      <td><a href="${pageContext.request.contextPath}/board/mypage.go?no=${mypage.myno}">${mypage.mytitle}</a></td>
		      <td>${mypage.myday}</td>
		      <td>${mypage.fk_userid}</td>
		      <td>${mypage.myview}</td>
		      
		    </tr>
		    </c:forEach>
		  
		</table>		
		<br>	
	<%-- 페이지네이션 --%>	
	<nav>
	  <ul class="pagination" >
	    <li class="page-item"><a class="page-link" href="#"><span aria-hidden="true"> << </span></a></li>
	    <li class="page-item"><a class="page-link" href="#"><span aria-hidden="true"> < </span></a></li>
	    	<li class="page-item"><a class="page-link" href="#">1</a></li>
	    <li class="page-item"><a class="page-link" href="#"><span aria-hidden="true"> > </span></a></li>
	    <li class="page-item"><a class="page-link" href="#"><span aria-hidden="true"> >> </span></a></li>
	  </ul>
	</nav>
</div>
<script type="text/javascript">
</script>
<jsp:include page="/WEB-INF/include/footer.jsp"/>