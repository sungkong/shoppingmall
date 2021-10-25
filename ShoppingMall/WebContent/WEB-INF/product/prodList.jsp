<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   String ctxPath = request.getContextPath();
%>  

<jsp:include page="../include/header.jsp"></jsp:include>

<title>상품목록[소녀떡집]</title>


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

<script type="text/javascript">

	$(document).ready(function() {
					
		$("div.card").click(function(event){
			
			//	var prod_name = $(this).(".card-body").html();
				// console.log($(this).find("#prod_code").val());
				
				
			var prod_code = $(this).children(".prod_code").val();
			
			location.href="/product/prodDetail.go?prod_code="+prod_code;
			
		}); // end of $("div.card").click(function(event){
					
		
	})//------------------------------------------------------------
	

</script>


<div class="container my-5 ">
	<c:if test="${not empty productList}">
		<div id="category" class="top mx-0 px-0">
			<c:if test="${requestScope.categoryName != '' }">
				<h4>${requestScope.categoryName}</h4>
			</c:if>
			<c:if test="${requestScope.categoryName eq '' or categoryName eq  null}">
				<h4>ALL</h4>
			</c:if>			
		</div>
		<hr><br>
		<div id="top_image" class="row w-100 mx-0 px-0">
			<c:if test="${requestScope.adimg != ''}">
				<div class=" col-lg-12 px-0 mx-0 text-center ">
					<img src="../img_prod/${requestScope.adimg}" class="img-fluid">
				</div>
			</c:if>
		</div>
		<br><br>				
		<div class="row gx-4 gx-lg-5 row-cols-2 row-cols-lg-4">  
		   
		  <c:forEach var="prodmap" items="${productList}">
			  <div class="col mb-5">
                 <div class="card h-100 pcard">
                 
                 	<%-- Product image--%>
	                <img class="card-img-top" src="../img_prod/${prodmap.ivo.prod_img_url}" alt="..." />
			        <%-- Product details--%>
                    <div class="card-body p-4">
                        <div class="text-center">
                            <%-- Product name--%>
                            <h6 class="fw-bolder">${prodmap.pvo.prod_name}</h6>
                            <%-- Product price--%>
                            <fmt:parseNumber var="prod_price" value="${prodmap.pvo.prod_price}" integerOnly="true" />
									
							<c:if test="${prodmap.pvo.discount_price eq '-9999'}">									
								<span><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
							</c:if>									
							<c:if test="${prodmap.pvo.discount_price ne '-9999'}">									
								<span style="text-decoration: line-through;"><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
								<br>
								<fmt:parseNumber var="sale_p" value="${prodmap.pvo.discount_price}" integerOnly="true" />
								<span><fmt:formatNumber value="${sale_p}" pattern="###,###" />원</span>
								<br>
								<small style="color:red;">(<fmt:formatNumber value="${100 - (sale_p * 100) / prod_price}" pattern="#"/>% 할인)</small>
							</c:if>						
                        </div>
                    </div>
			    	<input class="prod_code" type="hidden" value="${prodmap.pvo.prod_code}" /> <!-- value에 DB연결하고 prod_code 넣을것 -->
			    </div>
			  </div>
	     </c:forEach>	
	  
		</div>
	</c:if>
	
	<c:if test="${empty productList}">
		<p class="h6 text-center w-100 mx-auto">현재 판매중인 상품이 존재하지 않습니다</p>
	</c:if>
	   
	
</div>

<jsp:include page="../include/footer.jsp"></jsp:include>
