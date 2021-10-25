<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/include/header_admin.jsp"/>
<style>
</style>
<section class="section">
<div id="logoList" style="width:50%; text-align:center;">
	<div class="container-fluid px-4">
		<div class="card-body">
			<table class="table table-hover" style="text-align:center;">
				<thead>
					<tr>
						<th>번호</th>
						<th>배너명</th>
						<th>배너 이미지</th>
						<th>상태</th>
						<th>관리</th>				
					</tr>
			</thead>
				<tbody>
					<c:forEach var="logoList" items="${requestScope.logoList}">
						<tr>
							<td>${logoList.lno}</td>
							<td>${logoList.name}</td>
							<td><img src="/images/mainLogo/${logoList.filename}" style="width:130px;"/></td>
							<td>
								<c:choose>
									<c:when test="${logoList.status == '1'}">미사용</c:when>
									<c:otherwise>사용</c:otherwise>
								</c:choose>
							</td>
							<td>
								<button type="button" onclick="" class="btn btn-light" style="font-size: 8pt; padding: 2px 6px;">수정</button>
								<button type="button" onclick="" class="btn btn-light" style="font-size: 8pt; padding: 2px 6px;">삭제</button>
								<c:if test="${logoList.status == '1'}"><button type="button" onclick="" class="btn btn-light" style="font-size: 8pt; padding: 2px 6px;">적용</button></c:if>			
							</td>	      			    
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<button style="float:right;" type="button" onclick="javascript:location.href='/display/logoRegister.go'" class="btn btn-light" style="font-size: 12pt; padding: 2px 6px;">등록</button>			
		</div>                        
	</div>
</div>
</section>
<script>
</script>
<jsp:include page="/WEB-INF/include/footer_admin.jsp"/>