<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<jsp:include page="../include/header_admin.jsp"></jsp:include>

<title>[관리자메뉴]상품관리</title>


<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath %>/css/style.css" />
<script type="text/javascript" src="<%= ctxPath %>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script>

<style type="text/css">

	div.container {	width: 70%;}
	
	div#top {margin: 0 auto;}
	
	div#main {margin: 0 auto;}
	
	li.myli {
      background-color: #ffffff;   
      font-weight: bold; 
   }
   
   	li.myli:hover {cursor: pointer;}
	
</style>

<script type="text/javascript">
	
	$(document).ready(function() {
						
		/* >>> === 클릭한 탭(버튼)만 보이도록 하는 첫번째 방법 === <<< */
		$("li.tablinks").click(function(event) {
			
			var $target = $(event.target);
			
			var i = $("li.tablinks").index($target); // alert(i);
		
			$("div.mycontent").css("display","none"); 
			
			$("div.mycontent:eq(" + i + ")").css('display','block');
			
			$("li.tablinks").removeClass("myli");
			
			$("li.tablinks:eq(" + i + ")").addClass('myli');
		
					
		});
		
		// console.log(orderby);
		
		$("li.tablinks:eq(0)").trigger('click');
		
		$("button#searchbtn").click(function(event){
			goSearch();
		});
			
		
		$("select#orderby").bind("change", function(){
			goSearch();
		});
	
		
		$("input#searchWord").bind("keyup",function(event){
			if(event.keyCode == 13) {
				goSearch();
			}
		});
/*		
		$("button#delThis").bind("click", function(event){
			delete_category();
			
			console.log(sort_name);
			console.log($("sort_name"));
			console.log($("sort.sort_name"));
			console.log(sort.sort_name);
		});
*/		
		// --------------------------모달------------------------------//
		  
		  $("button.stock_plus").click(function() {
			  
			   var prod_code = $(this).parent().parent().find(".prod_code").text();
			   var prod_name = $(this).parent().parent().find(".prod_name").text();
			   
			   
			 // console.log(prod_code+","+prod_name);
			   		   
			   $("[name=prod_code_plus]").val(prod_code);
			   $("[name=prod_name_plus]").val(prod_name);
			   $("[name=plusqty]").val(inout_qty);
			   $("#stock_plus").val($(this).parent().parent().find(".prod_stock").text());
			   
			 // console.log($("#stock_plus").val())
			   
			   $("input#plusqty").val("");
			   
		   });
		
		$("button.stock_minus").click(function() {
			  
			   var prod_code = $(this).parent().parent().find(".prod_code").text();
			   var prod_name = $(this).parent().parent().find(".prod_name").text();
			  			   
			  // console.log(prod_code+","+prod_name);
			   		   
			   $("[name=prod_code_minus]").val(prod_code);
			   $("[name=prod_name_minus]").val(prod_name);
	//		   $("[name=minusqty]").val(inout_qty);
			   $("#stock_minus").val($(this).parent().find(".prod_stock").text());
	//		   $("[name=plus_minus_exp]").val(inout_exp);
			   
			   //console.log($("#stock_minus").val());
			   
			   $("input#minusqty").val("");
			   
		});
		
		
		$("button.stock_plus_do").bind('click', function(){
			stock_plus_do();
		});
		
		$("button.stock_minus_do").bind('click', function(){
			stock_minus_do();
		});
		
		
		
		
		
		$("button.one_prod").click(function() {
			
			//	alert($(this).find(".prod_code").text());
				
				var frm = document.one_prod_frm;
				
				frm.one_prod_code.value = $(this).parent().parent().find(".prod_code").text();
				
			//	alert(frm.one_prod_code.value + "임");
				
				frm.action = "/product/adminOneProd.go";
				frm.method = "POST";
				frm.submit();			
				
		});
				
	})// end of $(document).ready(function() {})-------------------------------------------
	
	// function Declaration
	function goSearch(){
		var frm = document.productFrm;
		
	//	alert(frm.searchType.value);
	//	alert(frm.searchWord.value);
		
		frm.action = "prodManage.go";
		frm.method = "POST";
		frm.submit();
	}
	
	
	function stock_plus_do() {
		var frm = document.plusProduct
		frm.status_plus.value = 1
		// console.log(frm.status_plus.value);
		// console.log(frm.plusqty.value);
		
		if(isNaN(frm.plusqty.value)) {
				alert("숫자만 입력하세요");
				frm.plusqty.value = ""
				return;
		}
			
		if( frm.plusqty.value.trim() == "") {
			alert("입고량을 반드시 입력하세요");	
			frm.plusqty.value =""
			return;
		}
		
		var arrinqty = frm.plusqty.value.split(".");
					
		if(arrinqty.length != 1) {
			alert("정수만 입력하세요");
			frm.plusqty.value = ""
			return;
		}
		
		if(Number(frm.plusqty.value) < 1){
			alert("입고량은 1개 이상이어야 합니다");
			frm.minusqty.value = ""
			return;
		}
		
		
		frm.action = "/product/plusProduct.go";
		frm.method = "POST";
		frm.submit();
	}
	
	function stock_minus_do() {
		var frm = document.minusProduct
		frm.status_minus.value = 0
		
		// console.log(frm.status_minus.value);
		// console.log(frm.minusqty.value);
		// console.log(frm.plus_minus_exp.value);
		
		if(isNaN(frm.minusqty.value)){
			alert("숫자만 입력하세요");
			frm.minusqty.value=""
			return;
		}
		
		if( frm.minusqty.value.trim() == "") {
			alert("폐기량을 반드시 입력하세요");
			frm.minusqty.value=""
			return;
		}
		
		var arrminusqty = frm.minusqty.value.split(".");
		
		if(arrminusqty.length != 1) {
			alert("정수만 입력하세요");
			frm.minusqty.value = ""
			return;
		}
		
		if( Number($("#stock_minus").val()) < Number(frm.minusqty.value) ) {
			alert("폐기량은 재고량을 초과할 수 없습니다");
			frm.minusqty.value=""
			return;
		} 
		if(Number(frm.minusqty.value) < 1){
			alert("폐기량은 1개 이상이어야 합니다");
			frm.minusqty.value = ""
			return;
		}
		
		
		frm.action = "/product/minusProduct.go";
		frm.method = "POST";
		frm.submit();  
	}
	
	 
	
</script>
		
	<div class="container mt-5 pt-5 px-0 offset-lg-3 col-lg-9">	
		
		<div class="modal fade" id="delCateModal">
			  <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">
			  
			    <div class="modal-content">			      
			      <form name="deleteCateory" action="/product/deleteCategory.go" method="POST">	
			      <!-- 카테고리 삭제 Modal header -->
			      <div class="modal-header">
			        	<h5 class="modal-title">카테고리 삭제</h5>
			        	<button type="button" class="close thisclose" data-dismiss="modal">&times;</button>
			      </div>
			      	
			      <!-- 카테고리 삭제  Modal body -->
			      <div class="modal-body row">
	
				      	
				      		
				      		<label class="col-4 text-right" for="delCate" id="del">삭제할 카테고리 :</label>
							    	<select id="delCate" class="mx-0 px-0 col-7" name="sort_code">
							    		<c:forEach var="sort" items="${sortList}">
							    			<option value="${sort.sort_code}">${sort.sort_name}</option>
							    		</c:forEach>
							    	</select>
							    	<br>
							    	<p style="color: red; font-size: 8pt;" class="text-center my-1">*카테고리 삭제 시 해당 카테고리에 속한 상품도 삭제됩니다</p>
								
					</div>			     	         							
			      
			      <!-- 카테고리 삭제 Modal footer -->
			      <div class="modal-footer">
			      	<button type="submit"  class="btn btn-success"  id="delThis">삭제</button>
			      	<button type="button" class="btn btn-danger thisclose" data-dismiss="modal">취소</button>
			      </div>
			      </form>	
			   </div>
			</div>
			      		
		</div>	
	
		
		<!-----------------------------------  -->
		
			
        <%-- 입고모달--%>
        <div class="modal fade" id="plusModal">
			  <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">
			  
			    <div class="modal-content">			      
			      	
			      <!-- 입고 Modal header -->
			      <div class="modal-header">
			        	<h5 class="modal-title">상품 입고</h5>
			        	<button type="button" class="close thisclose" data-dismiss="modal">&times;</button>
			      </div>
			      	
			      <!-- 입고 Modal body -->
			      <div class="modal-body row">
	
				      	<form name="plusProduct">
				      		<input type="hidden" readonly="readonly" name="prod_code_plus">	      		
				      		
				      		<label class="col-4" for="prod_name">상품명</label>
				      		<input type="text" value="" readonly="readonly" name="prod_name_plus">	      		
				      		<br>
				      		<br>
				        	<label class="col-4" for="inout_qty">입고 수량</label>
							<input type="text" class="inventory" name="plusqty" placeholder="1 이상의 숫자 입력"/>
							<br>
				      		<br>
				      									       			
							<input class="col-6 px-0" type="hidden" name="status_plus" value="확인용">
							<input class="col-6 px-0" type="hidden" id="stock_plus">
							
						</form>
												
					</div>			     	         							
			      
			      <!-- 입고 Modal footer -->
			      <div class="modal-footer">
			      	<button type="button"  class="btn stock_plus_do btn-success" id="plusProduct">입고</button>
			      	<button type="button" class="btn btn-danger thisclose" data-dismiss="modal">취소</button>
			      </div>
			      
			   </div>
			</div>
			      		
		</div>	
		
		<%-- 폐기 모달--%>	      
		<div class="modal fade" id="minusModal">
			 <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">   
			      
			      <div class="modal-content">
				      <!-- 폐기 Modal header -->
				      <div class="modal-header">
				        	<h5 class="modal-title">상품 폐기</h5>
				        	<button type="button" class="close thisclose" data-dismiss="modal">&times;</button>
				      </div>
				      	
				      <!-- 폐기 Modal body -->
				      <div class="modal-body row">
		
					      	<form name="minusProduct">
					      		<input type="hidden" readonly="readonly" name="prod_code_minus">	      		
					      		
					      		<label class="col-4" for="prod_name">상품명</label>
					      		<input type="text" value="" readonly="readonly" name="prod_name_minus">	      		
					      		<br>
					      		<br>
					        	<label class="col-4" for="inout_qty">폐기 수량</label>
								<input type="text" class="inventory" name="minusqty" placeholder="1 이상의 숫자 입력"/>
								<br>
					      		<br>
					      		<label class="col-4" for="delWhy">폐기사유</label>
							    	<select id="delWhy" class="mx-0 px-0" name="plus_minus_exp">
							    		<option>유통기한만료</option>
							    		<option>상품판매중단</option>
							    		<option>상품불량</option>
							    		<option>기타</option>
							    	</select>	          			
								
								       			
								<input class="col-6 px-0" type="hidden" name="status_minus">
								<input class="col-6 px-0" type="hidden" id="stock_minus">
							</form>
													
						</div>
				     	         							
				      
				      <!-- 폐기 Modal footer -->
				      <div class="modal-footer">
				      	<button type="button" class="btn stock_minus_do btn-success" id="minusProduct">폐기</button>
				      	<button type="button" class="btn btn-danger thisclose" data-dismiss="modal">취소</button>
				      </div>
			      </div>
		    </div>
		  </div>		
			
			<!-- <form name="확인">
				<input type="hidden" class="status" />
				<input type="hidden" class="prod_code_plus" />
				<input type="hidden" class="plusqty" /> 
			</form>
			<form name="확인">
				<input type="hidden" class="status" />
				<input type="hidden" class="prod_code_minus" />
				<input type="hidden" class="minusqty" /> 
				<input type="hidden" class="plus_minus_exp" /> 
			</form> -->
			
			
			<!----------------------------------------------------------------------- -->
			<!-- 상품관리  -->
			<h4>상품관리</h4>
			<hr>
			
			<%-- 상품페이지 탑부분 시작 --%>	
			<div id="top">
				
				<form name="productFrm" class="row w-100 my-3">
					
					<div class="col-md-3 mb-2 pl-4">
						<button type="button" class="btn categoryDelete btn-sm btn-warning " data-toggle="modal" data-target="#delCateModal">카테고리삭제</button>
					</div>
					
					<div class="col-md-6 mb-2 pl-4" align="center">
						<select id="searchType" name="searchType">
							<c:if test="${'fk_prod_code' eq searchType}">	
								<option value="prod_name">상품명</option>					
								<option value="fk_prod_code" selected>상품코드</option>								
							</c:if>
							<c:if test="${'fk_prod_code' ne searchType}">
								<option value="prod_name" selected>상품명</option>						
								<option value="fk_prod_code">상품코드</option>								
							</c:if>
						</select>
						
						<input type="text" id="searchWord" name="searchWord" value="${searchWord}"/>
						
						
						<button type="button" id="searchbtn" class="btn btn-light btn-sm" style="border: solid 1px #d9d9d9" onclick="goSearch();" style="margin-right: 30px;">검색</button>
					</div>
					
					<div class="col-md-3 text-right mb-2 px-0 mx-0">
						<span style="font-size: 12pt;">정렬방법 : </span>
				
						<select id="orderby" name="orderbyType">
							<c:if test="${'prod_date' eq orderbyType}">
								<option value="prod_date" selected>등록일순</option>
								<option value="prod_name">상품명순</option>
							</c:if>
							<c:if test="${'prod_date' ne orderbyType}">
								<option value="prod_date">등록일순</option>
								<option value="prod_name" selected>상품명순</option>
							</c:if>
						</select>
					</div>	
					
				</form>
				
			</div>
			<%-- 상품페이지 탑부분 끝 --%>	
			
			
			<div id="category_nav">
				<div id="btn" class="col-12 my-2">
					<ul class="list-group list-group-horizontal row text-center" style="font-size: 10pt;">
						<li class="list-group-item list-group-item-secondary col-md-3 col-4 tablinks myli">전체상품</li>						
						<c:forEach var="sort" items="${sortList}">							
							<li class="list-group-item list-group-item-secondary col-md-3 col-4 tablinks myli">${sort.sort_name}</li>	
						</c:forEach>
						
					</ul>
				</div>	   
			</div>
			
			
			<%-- 상품페이지 메인부분 시작 --%>
			
			<div id="main" class="w-100 row">
				
				<div class="table-responsive content mycontent">
					
					<table class="table table-hover text-center">							
													
						<tbody>
						
							<c:forEach var="mprodmap" items="${sProductList}">
								
									<tr class="row w-100 px-0 mx-0 one_prod">
									<form>	
											<td class="col-sm-2 mx-0 px-0">
												<img src="../img_prod/${mprodmap.mivo.prod_img_url}" class="img-fluid mx-0 px-0">
											</td>
											<td class="col-sm-2">
												<p class="prod_code mt-sm-4">${mprodmap.mpvo.prod_code}</p>
											</td>
											<td class="col-sm-2">
												<p class="prod_name mt-sm-4">${mprodmap.mpvo.prod_name}</p>
											</td>
											<td class="col-sm-2">
												<p class="prod_stock mt-sm-4">${mprodmap.mpvo.prod_stock}</p>
												<button type="button" class="btn stock_plus btn-sm btn-success my-1 mx-1 mx-1" data-toggle="modal" data-target="#plusModal">입고</button>						
												<button type="button" class="btn stock_minus btn-sm btn-danger my-1 mx-1 mx-1" data-toggle="modal" data-target="#minusModal">폐기</button>
											</td>
											<td class="col-sm-2">
												<c:if test="${mprodmap.mpvo.prod_sale eq '1'}">
													<input class="mt-sm-4" type="radio" name="sale1" id="sale" checked="checked" disabled="disabled"/><label for="sale">&nbsp;판매&nbsp;&nbsp;&nbsp;</label><br>
													<input class="mt-sm-4" type="radio" name="sale1" id="notsale" disabled="disabled"/><label for="notsale">&nbsp;미판매</label>
												</c:if>
												<br>
												<c:if test="${mprodmap.mpvo.prod_sale ne '1'}">
													<input class="mt-sm-4" type="radio" name="sale1" id="sale"  disabled="disabled"/><label for="sale">&nbsp;판매&nbsp;&nbsp;&nbsp;</label><br>
													<input class="mt-sm-4" type="radio" name="sale1" id="notsale" checked="checked"  disabled="disabled"/><label for="notsale">&nbsp;미판매</label>
												</c:if>
											</td>
											<td class="col-sm-2 pt-sm-4">	
												<button type="button" class="btn one_prod btn-sm btn-info my-1 mx-1 mx-1" >상세정보</button>
											</td>
										</form>	
										
																		
									</tr>
								
							</c:forEach>									
										
						</tbody>
						
					</table>
				</div>	
							
				
				<c:forEach var="categorylist" items="${sortList}">
				
				<div class="table-responsive content mycontent">
					
					<table class="table table-hover text-center">							
													
						<tbody>
									
								<c:forEach var="mprodmap" items="${sProductList}">
									<c:if test="${categorylist.sort_code eq mprodmap.mpvo.sort_code}">
										<tr class="row w-100 px-0 mx-0 one_prod">
											<form>	
												<td class="col-sm-2 mx-0 px-0">
													<img src="../img_prod/${mprodmap.mivo.prod_img_url}" class="img-fluid mx-0 px-0">
												</td>
												<td class="col-sm-2">
													<p class="prod_code mt-sm-4">${mprodmap.mpvo.prod_code}</p>
												</td>
												<td class="col-sm-2">
													<p class="prod_name mt-sm-4">${mprodmap.mpvo.prod_name}</p>
												</td>
												<td class="col-sm-2">
													<p class="prod_stock mt-sm-4">${mprodmap.mpvo.prod_stock}</p>
													<button type="button" class="btn stock_plus btn-sm btn-success my-1 mx-1 mx-1" data-toggle="modal" data-target="#plusModal">입고</button>						
													<button type="button" class="btn stock_minus btn-sm btn-danger my-1 mx-1 mx-1" data-toggle="modal" data-target="#minusModal">폐기</button>
												</td>
												<td class="col-sm-2">
													<c:if test="${mprodmap.mpvo.prod_sale eq '1'}">
														<input class="mt-sm-4" type="radio" name="sale1" id="sale" checked="checked" disabled="disabled"/><label for="sale">&nbsp;판매&nbsp;&nbsp;&nbsp;</label><br>
														<input class="mt-sm-4" type="radio" name="sale1" id="notsale" disabled="disabled"/><label for="notsale">&nbsp;미판매</label>
													</c:if>
													<br>
													<c:if test="${mprodmap.mpvo.prod_sale ne '1'}">
														<input class="mt-sm-4" type="radio" name="sale1" id="sale"  disabled="disabled"/><label for="sale">&nbsp;판매&nbsp;&nbsp;&nbsp;</label><br>
														<input class="mt-sm-4" type="radio" name="sale1" id="notsale" checked="checked"  disabled="disabled"/><label for="notsale">&nbsp;미판매</label>
													</c:if>
												</td>
												<td class="col-sm-2 pt-sm-4">	
													<button type="button" class="btn one_prod btn-sm btn-info my-1 mx-1 mx-1" >상세정보</button>
												</td>
											</form>									
										</tr>
									</c:if>
								</c:forEach>	
								
						</tbody>
									
						
					</table>
				</div>	
			</c:forEach>	
				
			   	</div>
			</div>			
	
	
				<form name="one_prod_frm"><input type="hidden" name="one_prod_code"></form>

<jsp:include page="../include/footer_admin.jsp"></jsp:include>