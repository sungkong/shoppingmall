<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="board.member.*, java.util.List"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
   

<!DOCTYPE html>

<html>
<head>


<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/include/header.jsp"/>

<style type="text/css">

  table {
    width: 100%;
    border-top: 1px solid #444444;
    border-collapse: collapse;
  }
  th, td {
    border-bottom: 1px solid #444444;
    border-left: 1px solid #444444;
    padding: 10px;
  }
  th:first-child, td:first-child {
    border-left: none;
  }
  .a {
  	font-size : 40px;
  	color: blue;
  	text-align: center;
  }
  
  
  
</style>


<script type="text/javascript">
	
	$(document).ready(function(){
		
		$("select#sizePerPage").bind("change", function(){
			goSearch();
	    });
		
		if("${requestScope.sizePerPage}" != "") {
		   $("select#sizePerPage").val("${requestScope.sizePerPage}");
	    }
	   
	    
	    
		
	}); // end of $(document).ready(function()

	// Function Declaration
	function goSearch() {
		var frm = document.boardFrm;
		frm.action = "boardWrite.go";
		frm.method = "GET";
		frm.submit();
	}
			
			
			
</script>



</head>
<body>



<div class= "a">공지사항입니다</div>

	
<form name="boardFrm">
		<select id="searchType" name="searchType">
		<option value="writer">이름</option>
		</select>
		<input type="text" id="searchWord" name="searchWord" />
		
		<button type="button" onclick="goSearch();" style="margin-right: 30px;">검색</button>
		
		<span style="color: red; font-weight: bold; font-size: 12pt;">페이지당 게시글수-</span>
      	<select id="sizePerPage" name="sizePerPage">
         <option value="10">10</option>
         <option value="5">5</option>
         <option value="3">3</option>
      </select>
</form>

<table id="boardTbl" class="table table-bordered" style="width: 90%; margin-top: 20px;">
<thead>
	<tr>
		<th>번호</th>
		<th>제목</th>
		<th>작성자</th>
		<th>등록일</th>
		<th>조회수</th>
	</tr>
</thead>

<tbody>
	<c:forEach var="board" items="${requestScope.boardList}">
		<tr class="boardInfo">
			<td>${board.num}</td>
			<td><a href="${pageContext.request.contextPath}/board/boardDetail.go?num=${board.num}">${board.title}</a></td>
			<td>${board.writer}</td>
			<td>${board.regdate}</td>
			<td>${board.cnt}</td>
			
		</tr>
	</c:forEach>
</tbody>



</table>




<nav class ="my-5">
   	<div style="display:flex; width: 80%;">
   		<ul class="pagination" style="margin:auto;">${requestScope.pageBar}</ul>
   	</div>
</nav>

<%-- <c:if test="${sessionScope.loginuser != null and sessionScope.loginuser.userid == 'admin'}">
	<div class="button">
	<input type="button" value="글 등록 버튼" /></a>
	</div> --%>

<c:if test="${sessionScope.loginuser != null and sessionScope.loginuser.userid == 'admin'}">	
	<button onclick="javascript:location.href='${pageContext.request.contextPath}/board/registForm.go'">글 등록 버튼</button>
</c:if>

<jsp:include page="/WEB-INF/include/footer.jsp"/>
</body>
</html>