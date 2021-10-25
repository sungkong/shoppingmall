<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/include/header_admin.jsp"/>
<style>
.section{
 	width : 70%;
 	margin-left : 300px;
 	margin-top : 100px;
 }
a { 
	text-decoration:none 
} 
</style>
<section class="section">
<div class="container-fluid px-4">
<div class="card-header">
	<i class="fas fa-table me-1"></i> 회원 목록
</div>
<div class="card-body">
	<div id="memberFrm" action="/admin/memberList.go" style="text-align: center;">
		<form name="memberFrm">
			<select id="searchType" name="searchType">
				<option value="name">회원명</option>
				<option value="userid">아이디</option>
				<option value="email">이메일</option>
			</select> 
			<input type="text" id="keyword" name="keyword" />
			<button class="btn btn-sm btn-primary" type="button" onclick="goSearch()" id="btnSearch"style="margin-right: 30px;">검색</button>
			<select id="sizePerPage" name="sizePerPage" style="width: 60px; height: 35px;">
				<option value="10">10</option>
				<option value="5">5</option>
				<option value="3">3</option>
			</select>
		</form>
	</div>
	<table class="table table-hover">
		<thead>
			<tr>
				<th>아이디</th>
				<th>이름</th>
				<th>이메일</th>
				<th>핸드폰</th>
				<th>성별</th>
				<th>생년월일</th>
				<th>포인트</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="memberList" items="${requestScope.memberList}">
				<tr>
					<td><a href="/admin/orderList.go?userid=${memberList.userid}">${memberList.userid}</a></td>
					<td>${memberList.name}</td>
					<td>${memberList.email}</td>
					<td>${memberList.mobile}</td>
					<td><c:if test="${memberList.gender == 1}">남자</c:if> <c:if
							test="${memberList.gender == 2}">여자</c:if></td>
					<td>${memberList.birthday}</td>
					<td>${memberList.point}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<nav aria-label="Page navigation example" style="margin: auto;">
		<ul class="pagination justify-content-center">
			<c:if test="${pagination.prev}">
				<li class="page-item"><a class="page-link" href="#" onClick="fn_prev('${pagination.currPageNo}', '${pagination.range}', '${pagination.pageSize}')">이전</a></li>
			</c:if>
			<c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="idx">
				<li class="page-item <c:out value="${pagination.currPageNo == idx ? 'active' : ''}"/> "><a class="page-link" href="#" onClick="fn_pagination('${idx}', '${pagination.range}')"> ${idx} </a></li>
			</c:forEach>
			<c:if test="${pagination.next}">
				<li class="page-item"><a class="page-link" href="#" onClick="fn_next('${pagination.currPageNo}', '${pagination.range}', '${pagination.pageSize}')" >다음</a></li>
			</c:if>
		</ul>
	</nav>
</div>                        
</div>
</section>
<script>
$(function(){	

	if("${requestScope.searchType}" == ""){
		$("#searchType").val("name");
	} else {
		$("#searchType").val("${requestScope.searchType}");
	}
	$("#keyword").val("${requestScope.keyword}");	
	
	$("select#sizePerPage").val(${requestScope.sizePerPage});
	$("select#sizePerPage").change(function(){
		goSearch();	
	});
	
});
		
// 이전 버튼
function fn_prev(currPageNo, range, pageSize) {

	var currPageNo = (range - 1) * pageSize;
	var range = range - 1;

	var url = "/admin/memberList.go";
	url = url + "?currPageNo=" + currPageNo;
	url = url + "&range=" + range;
	url = url + "&searchType=" + $("#searchType").val();
	url = url + "&keyword=" + $("#keyword").val();
	url = url + "&sizePerPage=" + $("select#sizePerPage").val();
	location.href = url;

}

//페이지 번호 클릭

function fn_pagination(currPageNo, range) {

	var url = "/admin/memberList.go";
	url = url + "?currPageNo=" + currPageNo;
	url = url + "&range=" + range;
	url = url + "&searchType=" + $("#searchType").val();
	url = url + "&keyword=" + $("#keyword").val();
	url = url + "&sizePerPage=" + $("select#sizePerPage").val();
	location.href = url;	

}
//다음 버튼 이벤트
function fn_next(currPageNo, range, pageSize) {

	var currPageNo = (range * pageSize) + 1;
	var range = parseInt(range) + 1;	

	var url = "/admin/memberList.go";
	url = url + "?currPageNo=" + currPageNo;
	url = url + "&range=" + range;
	url = url + "&searchType=" + $("#searchType").val();
	url = url + "&keyword=" + $("#keyword").val();
	url = url + "&sizePerPage=" + $("select#sizePerPage").val();
	location.href = url;
}

function goSearch(){
	
	var frm = document.memberFrm;
	frm.submit();
}

</script>
<jsp:include page="/WEB-INF/include/footer_admin.jsp"/>