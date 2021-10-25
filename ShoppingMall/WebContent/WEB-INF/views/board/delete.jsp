<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="board.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  %>
<jsp:useBean id="dao" class="board.member.BoardDAO" />

<%
	int num = Integer.parseInt(request.getParameter("num"));
	dao.delete(num);
%>
<c:redirect url="${pageContext.request.contextPath}/board/boardWrite.go" />
