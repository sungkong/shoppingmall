<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="board.member.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<jsp:useBean id="mdao" class="board.member.MypageDAO"/>
<%
	int no = Integer.parseInt(request.getParameter("no"));
	MypageVO mvo = mdao.selectpageOne(no);
	pageContext.setAttribute("mvo", mvo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글내용 보기</title>
</head>
<body>
<jsp:include page="/WEB-INF/include/header.jsp"/>

<p>번호:${mvo.myno}</p>
<p>제목:${mvo.mytitle}</p>
<p>작성일:${mvo.myday}</p>
<p>작성자:${mvo.fk_userid}</p>
<p>조회수:${mvo.myview}</p>
<p>글 내용:${mvo.mycontent}</p>
<jsp:include page="/WEB-INF/include/footer.jsp"/>
</body>
</html>