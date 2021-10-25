<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="board.member.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<jsp:useBean id="dao" class="board.member.BoardDAO"/>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	BoardVO vo = dao.selectOne(num);
	pageContext.setAttribute("vo", vo);
%>
<%
   String ctxPath = request.getContextPath();
%>  
<jsp:include page="../../include/header.jsp"></jsp:include>
<title>글 내용</title>

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath %>/css/style.css" />

<style type="text/css">
   div.container{
      width:80%;
   }
   
	.card:hover {
		background-color: #f2f2f2;
		cursor: pointer;
	}
   
   
</style>

<div class="container">
	<div class="mx-auto border px-5 py-5">
		
			<h3>글 정보</h3>
			<hr>
			<p>번호       : ${vo.num}</p>
			<p>제목       : ${vo.title}</p>
			<p>작성자    : ${vo.writer}</p>
			<p>내용       : ${vo.content}</p>
			<p>등록일자 : ${vo.regdate}</p>
			<p>조회수    : ${vo.cnt}</p>
		
	</div>
</div>
<c:if test="${sessionScope.loginuser != null and sessionScope.loginuser.userid == 'admin'}">	
	<button onclick="javascript:location.href='${pageContext.request.contextPath}/board/editForm.go?num=${vo.num}'">수정</button>
</c:if>

<jsp:include page="../../include/footer.jsp"></jsp:include>

<c:if test="${sessionScope.loginuser != null and sessionScope.loginuser.userid == 'admin'}">	
	<button onclick="javascript:location.href='${pageContext.request.contextPath}/board/deleteForm.go?num=${vo.num}'">삭제</button>
</c:if>

<!--  <a href="${pageContext.request.contextPath}/board/editForm.go?num=${vo.num}"><button>수정</button></a>-->
<!-- <a href="${pageContext.request.contextPath}/board/deleteForm.go?num=${vo.num}"><button>삭제</button></a>-->
</body>
</html>