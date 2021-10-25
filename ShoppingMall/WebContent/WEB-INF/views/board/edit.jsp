<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="board.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  %>

<jsp:useBean id="vo" class="board.member.BoardVO" />
<jsp:useBean id="dao" class="board.member.BoardDAO" />
<jsp:setProperty name="vo" property="*" />
<%
	dao.update(vo);
	pageContext.setAttribute("vo", vo);

%>
<c:redirect url="${pageContext.request.contextPath}/board/boardDetail.go?num=${vo.num}" />
