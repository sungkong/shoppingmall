<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/include/header.jsp"/>
<title>[소녀떡집]MAIN</title>

<!-- Font Awesome 5 Icons --> <!-- 아이콘을 사용하려면 헤드에서 미리 링크를 걸어줘야한당 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath %>/css/style.css" />

<style type="text/css">
	
	.card:hover {
		background-color: #f2f2f2;
		cursor: pointer;
	}
		
	.goP:link {	color: gray; }
	
	.goP:visited { color: gray; }
	
	.goP:hover { font-weight: bold; color: black; }
	
	.goP:active { color: gray; }
			
</style>
 
<script>

function addAddresForm(){
	var url = "/member/addAddress.go";
	// 너비 800, 높이 650인 팝업창을 화면 가운데에 띄우기 
	var pop_width = 800;
	var pop_height = 600;
	var pop_left = Math.ceil((window.screen.width - pop_width)/2 );
	var pop_top = Math.ceil((window.screen.height - pop_height)/2 );
	
	window.open(url, "배송지 추가",
    "left="+pop_width+", top="+pop_top+", width="+pop_width+", height="+pop_height);
}

$(document).ready(function(){
	
	$(".pcard").click(function() {
		
		var prod_code = $(this).find(".prod_code").text();
		
		location.href = "/product/prodDetail.go?prod_code=" + prod_code;
		
	});
	
	///////////////////////////////////////////////////////////
	
	
	$(".reviewcard").click(function() {
		
		var img = $(this).find(".this-img").text();	
		var content = $(this).find(".this-content").text();
		var username = $(this).find(".this-username").text();
		var score = $(this).find(".this-score").text();
		var date = $(this).find(".this-date").text();
		var prodname = $(this).find(".this-prodname").text();
		var prodcode = $(this).find(".this-prodcode").text();
		
		if(img != "사진없음")  {
			$("#re-img").html("<img src='/img_review/"+ img +"' style='object-fit: cover; max-height: 150px;'><hr>")
		}
		
		else {
			$("#re-img").empty();
		}
		
		var html = "<a class='goP' data-toggle='tooltip' title='Show Info!' href='/product/prodDetail.go?prod_code="+prodcode+"'>" + prodname + "</a>"
		
		$("#re-prodname").html(html);
		$("#re-content").text(content);
		$("#re-username").text(username);
		$("#re-score").text(score);
		$("#re-date").text(date);
	
	});
	
 });

</script>
 
	<!-- Header-->
	<div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
		<ol class="carousel-indicators">
		
			<c:if test="${not empty bannerList}">
				<c:forEach items="${bannerList}" varStatus="status">
					<c:choose>
						<c:when test="${status.index eq 0}">
							<li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
						</c:when>
						<c:otherwise>
							<li data-target="#carouselExampleIndicators" data-slide-to="${status.index}"></li>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:if>
			
			<c:if test="${empty bannerList}">
				<li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
				<li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
				<li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
			</c:if>
			
		</ol>
		<div class="carousel-inner">
		
			<c:if test="${not empty bannerList}">
				<c:forEach var="bannerMap" items="${bannerList}" varStatus="status">
					<c:choose>
						<c:when test="${status.index eq 0}">
							<div class="carousel-item active">
								<img src="../img_prod/${bannerMap.img}" class="d-block w-100" alt="..." style="max-height: 500px;" onclick="location.href='/product/prodList.go?sort_code=${bannerMap.sort_code}'">
							</div>
						</c:when>
						<c:otherwise>
							<div class="carousel-item">
								<img src="../img_prod/${bannerMap.img}" class="d-block w-100" alt="..." style="max-height: 500px;" onclick="location.href='/product/prodList.go?sort_code=${bannerMap.sort_code}'">
							</div>
						</c:otherwise>
					</c:choose>
				</c:forEach>			
			</c:if>
			
			<c:if test="${empty bannerList}">
				<div class="carousel-item active">
					<img src="/images/carousel-bg/carousel-bg1.jpg" class="d-block w-100" alt="..." style="max-height: 450px;">
				</div>
				<div class="carousel-item">
					<img src="/images/carousel-bg/carousel-bg2.jpg" class="d-block w-100" alt="..." style="max-height: 450px;">
				</div>
				<div class="carousel-item">
					<img src="/images/carousel-bg/carousel-bg3.jpg" class="d-block w-100" alt="..." style="max-height: 450px;">
				</div>
			</c:if>
			
		</div>
		<a class="carousel-control-prev w-90" href="#carouselExampleIndicators" role="button" data-slide="prev">
		    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		    <span class="sr-only"></span>
		</a>
		<a class="carousel-control-next w-90" href="#carouselExampleIndicators" role="button" data-slide="next">
		    <span class="carousel-control-next-icon" aria-hidden="true"></span>
		    <span class="sr-only"></span>
		</a>
	</div>
	
	<!-- Section-->
        <section class="py-5">
            <div class="container px-4 px-lg-5 mt-5">
            	
            	<h4 class="text-center">NEW ARRIVAL</h4>
            	<hr>
            	
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-lg-4">                	
                	
                	<c:forEach var="newpvo" items="${newList}">
                		
	                    <div class="col mb-5">
	                        <div class="card h-100 pcard">
	                        	<span style="display: none;" class="prod_code">${newpvo.prod_code}</span>
	                            <div class="badge bg-success text-white position-absolute" style="top: 0.5rem; right: 0.5rem">NEW</div>
	                            <%-- Product image--%>
	                            <img class="card-img-top" src="../img_prod/${newpvo.imgvo.prod_img_url}" alt="..." />
	                            <%-- Product details--%>
	                            <div class="card-body p-4">
	                                <div class="text-center">
	                                    <%-- Product name--%>
	                                    <h6 class="fw-bolder">${newpvo.prod_name}</h6>
	                                    <%-- Product price--%>
	                                    <fmt:parseNumber var="prod_price" value="${newpvo.prod_price}" integerOnly="true" />
									
										<c:if test="${newpvo.discount_price eq '-9999'}">									
											<span><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
										</c:if>									
										<c:if test="${newpvo.discount_price ne '-9999'}">									
											<span style="text-decoration: line-through;"><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
											<br>
											<fmt:parseNumber var="sale_p" value="${newpvo.discount_price}" integerOnly="true" />
											<span><fmt:formatNumber value="${sale_p}" pattern="###,###" />원</span>
											<br>
											<small style="color:red;">(<fmt:formatNumber value="${100 - (sale_p * 100) / prod_price}" pattern="#"/>% 할인)</small>
										</c:if>										
	                                </div>
	                            </div>	                               
	                        </div>
	                    </div>
                    </c:forEach>
                    
             	</div>
             
             <c:if test="${not empty hitList}">
             	
            	<h4 class="text-center">WEEKLY HOT</h4>
            	<hr>
            	
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-lg-4">                	
                	
                	<c:forEach var="hitpvo" items="${hitList}">
                		
	                    <div class="col mb-5">
	                        <div class="card h-100 pcard">
	                        	<span style="display: none;" class="prod_code">${hitpvo.prod_code}</span>
	                            <div class="badge bg-primary text-white position-absolute" style="top: 0.5rem; right: 0.5rem">HOT</div>
	                            <%-- Product image--%>
	                            <img class="card-img-top" src="../img_prod/${hitpvo.imgvo.prod_img_url}" alt="..." />
	                            <%-- Product details--%>
	                            <div class="card-body p-4">
	                                <div class="text-center">
	                                    <%-- Product name--%>
	                                    <h6 class="fw-bolder">${hitpvo.prod_name}</h6>
	                                    <%-- Product price--%>
	                                    <fmt:parseNumber var="prod_price" value="${hitpvo.prod_price}" integerOnly="true" />
									
										<c:if test="${hitpvo.discount_price eq '-9999'}">									
											<span><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
										</c:if>									
										<c:if test="${hitpvo.discount_price ne '-9999'}">									
											<span style="text-decoration: line-through;"><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
											<br>
											<fmt:parseNumber var="sale_p" value="${hitpvo.discount_price}" integerOnly="true" />
											<span><fmt:formatNumber value="${sale_p}" pattern="###,###" />원</span>
											<br>
											<small style="color:red;">(<fmt:formatNumber value="${100 - (sale_p * 100) / prod_price}" pattern="#"/>% 할인)</small>
										</c:if>										
	                                </div>
	                            </div>	                               
	                        </div>
	                    </div>
                    </c:forEach>
                    
             	</div>
             </c:if>
             
             <c:if test="${not empty bestList}">
             	 
            	<h4 class="text-center">BEST</h4>
            	<hr>
            	
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-lg-4">                	
                	
                	<c:forEach var="bestpvo" items="${bestList}">
                		
	                    <div class="col mb-5">
	                        <div class="card h-100 pcard">
	                        	<span style="display: none;" class="prod_code">${bestpvo.prod_code}</span>
	                            <div class="badge bg-warning text-white position-absolute" style="top: 0.5rem; right: 0.5rem">BEST</div>
	                            <%-- Product image--%>
	                            <img class="card-img-top" src="../img_prod/${bestpvo.imgvo.prod_img_url}" alt="..." />
	                            <%-- Product details--%>
	                            <div class="card-body p-4">
	                                <div class="text-center">
	                                    <%-- Product name--%>
	                                    <h6 class="fw-bolder">${bestpvo.prod_name}</h6>
	                                    <%-- Product price--%>
	                                    <fmt:parseNumber var="prod_price" value="${bestpvo.prod_price}" integerOnly="true" />
									
										<c:if test="${bestpvo.discount_price eq '-9999'}">									
											<span><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
										</c:if>									
										<c:if test="${bestpvo.discount_price ne '-9999'}">									
											<span style="text-decoration: line-through;"><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
											<br>
											<fmt:parseNumber var="sale_p" value="${bestpvo.discount_price}" integerOnly="true" />
											<span><fmt:formatNumber value="${sale_p}" pattern="###,###" />원</span>
											<br>
											<small style="color:red;">(<fmt:formatNumber value="${100 - (sale_p * 100) / prod_price}" pattern="#"/>% 할인)</small>
										</c:if>										
	                                </div>
	                            </div>	                               
	                        </div>
	                    </div>
                    </c:forEach>
                    
             	</div> 
             	      
              </c:if>
                
            	<h4 class="text-center">SALE</h4>
            	<hr>
            	
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-lg-4">                	
                	
                	<c:forEach var="salepvo" items="${saleList}">
                		
	                    <div class="col mb-5">
	                        <div class="card h-100 pcard">
	                        	<span style="display: none;" class="prod_code">${salepvo.prod_code}</span>
	                            <div class="badge bg-danger text-white position-absolute" style="top: 0.5rem; right: 0.5rem">SALE</div>
	                            <%-- Product image--%>
	                            <img class="card-img-top" src="../img_prod/${salepvo.imgvo.prod_img_url}" alt="..." />
	                            <%-- Product details--%>
	                            <div class="card-body p-4">
	                                <div class="text-center">
	                                    <%-- Product name--%>
	                                    <h6 class="fw-bolder">${salepvo.prod_name}</h6>
	                                    <%-- Product price--%>
	                                    <fmt:parseNumber var="prod_price" value="${salepvo.prod_price}" integerOnly="true" />																		
										<span style="text-decoration: line-through;"><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
										<br>
										<fmt:parseNumber var="sale_p" value="${salepvo.discount_price}" integerOnly="true" />
										<span><fmt:formatNumber value="${sale_p}" pattern="###,###" />원</span>
										<br>
										<small style="color:red;">(<fmt:formatNumber value="${100 - (sale_p * 100) / prod_price}" pattern="#"/>% 할인)</small>																			
	                                </div>
	                            </div>	                               
	                        </div>
	                    </div>
                    </c:forEach>
                    
             	  </div>
             
             <c:if test="${not empty reviewList}">
             	
            	<h4 class="text-center">REVIEW</h4>
            	<hr>
            	
                <div id="img_row" class="row gx-4 gx-lg-5 row-cols-2 row-cols-lg-4">                	
                	
                	<c:forEach var="rvo" items="${reviewList}">
                		
	                    <div class="col mb-5">
	                        <div class="card h-100 reviewcard" data-toggle="modal" data-target="#reviewModal">
	                        	<div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">REVIEW</div>
	                            <%-- Review image--%>
	                            <c:choose>
									<c:when test="${rvo.review_img ne '-9999'}">
										<img class="card-img-top" src="/img_review/${rvo.review_img}" alt="..." style="height: 180px;"/>
										<span class="this-img" style="display: none;">${rvo.review_img}</span>
									</c:when>
							    	<c:otherwise>
							    		<img class="card-img-top" src="/img_review/리뷰사진이없오3.png" alt="..." style="height: 180px;"/>
							    		<span class="this-img" style="display: none;">사진없음</span>
							    	</c:otherwise>
						    	</c:choose>
	                            
	                            <%-- Review details--%>
	                            <div class="card-body p-4">
	                                <div class="text-center">										
					                	<span class="this-content" style="display: none;">${rvo.content}</span>
					                	<span class="this-prodname" style="display: none;">상품명    : ${rvo.prod_name}</span>	
					                	<span class="this-prodcode" style="display: none;">${rvo.prod_code}</span>					                
										<br>
										<p class="ml-3 this-username text-left" style="color: gray; font-size: 8pt;">작성자    : ${fn:substring(rvo.username, 0, 1)}<c:forEach begin="1" end="${fn:length(rvo.username) - 1}">*</c:forEach>&nbsp;님</p>
						                <p class="ml-3 this-score text-left" style="color: gray; font-size: 8pt;">평점       : ${rvo.score}</p>								                 
						                <p class="ml-3 this-date text-left" style="color: gray; font-size: 8pt;">작성일자 : ${rvo.review_date}</p>																				
	                                </div>
	                            </div>	                               
	                        </div>
	                    </div>
                    </c:forEach>
                    
             	</div>
             	
             </c:if>
             	                
            </div>
        </section>
        
        	
	<%-- 리뷰카드 모달 --%>
		<div class="modal fade" id="reviewModal">
			  <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">
			  
			    <div class="modal-content">			      
			      	
			      	<!-- Modal header -->
			      <div class="modal-header">
			        	<h5 class="modal-title">고객리뷰</h5>
			        	<button type="button" class="close thisclose" data-dismiss="modal">&times;</button>
			      </div>
			      	
			     <!-- Modal body -->
			      <div class="modal-body">
						
						<div class="modal-card">
				             <div class="card-body px-1">
				                 <div align="center" id="re-img"></div>
				                 <p class="ml-3" style="min-height: 100px;" id="re-content"></p>
				                 <hr>
				                 <p class="ml-3" style="color: gray;" id="re-prodname"></p>
				                 <p class="ml-3" style="color: gray;" id="re-username"></p>
				                 <p class="ml-3" style="color: gray;" id="re-score"></p>								                 
				                 <p class="ml-3" style="color: gray;" id="re-date"></p>				                 
				             </div>
				    	</div>
				      	
												
				  </div>
			     	         							
			      
			      <!-- Modal footer -->
			      <div class="modal-footer">
			      	<button type="button" class="btn btn-sm btn-danger thisclose" data-dismiss="modal">닫기</button>
			      </div>
			      
			    </div>
			  </div>
		</div>	
        

<jsp:include page="/WEB-INF/include/footer.jsp"/>