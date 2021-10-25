<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   String ctxPath = request.getContextPath();
%>  

<jsp:include page="../include/header.jsp"></jsp:include>

<title>[소녀떡집]검색결과</title>


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
            
         var prod_code = $(this).find("#prod_code").val();
         
         location.href="/product/prodDetail.go?prod_code="+prod_code;
         
      }); // end of $("div.card").click(function(event){
               
      
   })//------------------------------------------------------------
   

</script>


<div class="container my-5 ">
	
		<div id="category" class="top mx-0 px-0">			
			<h4>[&nbsp;${searchWord}&nbsp;]&nbsp;검색결과</h4>					
		</div>
	
		<hr>
				
		<div class="row gx-4 gx-lg-5 row-cols-2 row-cols-lg-4">  
		   
		  <c:if test="${not empty productList}">  
		         
	        <c:forEach var="pvo" items="${productList}">
			  <div class="col mb-5">
                 <div class="card h-100 pcard">
                 
                 	<%-- Product image--%>
	                <img class="card-img-top" src="../img_prod/${pvo.imgvo.prod_img_url}" alt="..." />
			        <%-- Product details--%>
                    <div class="card-body p-4">
                        <div class="text-center">
                            <%-- Product name--%>
                            <h6 class="fw-bolder">${pvo.prod_name}</h6>
                            <%-- Product price--%>
                            <fmt:parseNumber var="prod_price" value="${pvo.prod_price}" integerOnly="true" />
									
							<c:if test="${pvo.discount_price eq '-9999'}">									
								<span><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
							</c:if>									
							<c:if test="${pvo.discount_price ne '-9999'}">									
								<span style="text-decoration: line-through;"><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
								<br>
								<fmt:parseNumber var="sale_p" value="${pvo.discount_price}" integerOnly="true" />
								<span><fmt:formatNumber value="${sale_p}" pattern="###,###" />원</span>
								<br>
								<small style="color:red;">(<fmt:formatNumber value="${100 - (sale_p * 100) / prod_price}" pattern="#"/>% 할인)</small>
							</c:if>						
                        </div>
                    </div>
			    	<input id="prod_code" type="hidden" value="${pvo.prod_code}" /> <!-- value에 DB연결하고 prod_code 넣을것 -->
			    </div>
			  </div>
	     	</c:forEach>
	     </c:if>
		   
	   	 <c:if test="${empty productList}">
   		  
   		  	<p class="h6 text-center w-100 mx-auto">검색결과가 없습니다</p>
   		
   	   	 </c:if>	
	  
		</div>

	   
</div>

<jsp:include page="../include/footer.jsp"></jsp:include>