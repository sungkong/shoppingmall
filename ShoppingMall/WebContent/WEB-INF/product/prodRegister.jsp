<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
   String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<jsp:include page="../include/header_admin.jsp"></jsp:include>

<title>[관리자메뉴]상품등록</title>


<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath %>/css/style.css" />
<script type="text/javascript" src="<%= ctxPath %>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script>

<style type="text/css">

	body {
      word-break: break-all; /* 공백없이 영어로만 되어질 경우 해당구역을 빠져나가므로 이것을 막기위해서 사용한다. */
    }
	
	div.container {	width: 70%;}
		
	div#main {margin: 0 auto;}	
	
	label.title {font-weight: bold; font-size: 10pt;}
		
	div#inputCategory {
		display: inline-block;
	}
	
	input[type='text'] { height: 38px;}
		
		
</style>

<script type="text/javascript">		
	
	$(document).ready(function() {
		
		$("div#plus").hide();
		$("div#select").hide();
		$("div#discount").hide();
		
		$("select[name=sort_code]").bind('change', function() {
			
		//	console.log(this.selectedIndex);
			
			if(this.selectedIndex == 0) {
				
				var html = "<label id='inputCategory'><input type='text' class='myinput form-control' name='add_sort_name' id='addCategory' required placeholder='카테고리명을 입력하세요'/></label>"
				
				$("span#inputCategory").html(html);
			} 
			
			else {
				$("span#inputCategory").html("");
			//	console.log($(this).val());
			}
			
		});// end of $("select#select1").bind('change', function() {})-------------
		
		///////////////////////////////////////////////////////////////////////////
		
		$("input[name=prod_plus]").bind('click', function() {
			
			if($(this).val() == 1) {				
				$("div#plus").show();
			}
			
			else {
				$("div#plus").hide();
			}
			
		});// end of $("input[name=prod_plus]").bind('click', function() {})--------
		
		//////////////////////////////////////////////////////////////////////////
		
		$("input[name=prod_select]").bind('click', function() {
			
			if($(this).val() == 1) {
				$("div#select").show();
			}
			
			else {
				$("div#select").hide();
			}
			
		});// end of $("input[name=prod_select]").bind('click', function() {})-------
		
		/////////////////////////////////////////////////////////////////////////
		
		$("#addTitleFile").on('change',function(){
			
			var val_titlefilename = "";
			
			for(var i=0; i<$(this)[0].files.length; i++) {
				
				if(val_titlefilename != "") {
					val_titlefilename += ",";
				}
				
				if(window.FileReader){
		            val_titlefilename += $(this)[0].files[i].name;
		          //  console.log(filename);
		        } else {
		            val_titlefilename += $(this).val.split('/').pop().split('\\').pop();
		        }
				
			}	
			
	        //filename insert
	        $('#titlefile').val(val_titlefilename);
	        
	    });
		
		/////////////////////////////////////////////////////////////////////////
		
		$("#addDetailFile").on('change',function(){
			
			var val_detailfilename = "";
			
		//	console.log($(this)[0].files.length + "임");
			
			for(var i=0; i<$(this)[0].files.length; i++) {
				
				if(val_detailfilename != "") {
					val_detailfilename += ",";
				}
				
				if(window.FileReader){
		            val_detailfilename += $(this)[0].files[i].name;
		        //  console.log($(this)[0].files[0]);
		        } else {
		            val_detailfilename += $(this).val().split('/').pop().split('\\').pop();
		        }
				
			}			

	        //filename insert
	        $('#detailfile').val(val_detailfilename);
	        
	    });
		
		//////////////////////////////////////////////////////////////////////////
		
		$("input[name=add_sort_name]").blur(function() {
			
		//	console.log("확인용");
			
			if($(this).val().trim() == "") {
				alert("카테고리명을 입력하셔야 합니다.");
				$(this).val("");
			}
						
		});
		
		//////////////////////////////////////////////////////////////////////////
		
		$("input[name=prod_name]").blur(function() {
			
		//	console.log("확인용");
			
			if($(this).val().trim() == "") {
				alert("상품명을 입력하셔야 합니다.");
				$(this).val("");
			}
			
		});
		
		//////////////////////////////////////////////////////////////////////////
		
		$("input[name=prod_price]").blur(function() {
			
		//	console.log("확인용");
			
			if(isNaN($(this).val())) {
				alert("가격은 숫자만 입력하셔야 합니다.");
				$(this).val("");
				return;
			}
			
			else if(Number($(this).val()) < 0) {				
				alert("가격은 최소 0원 이상이어야 합니다.");
				$(this).val("");
				return;
			}
			
			else if($(this).val().trim() == "") {
				alert("가격을 입력하셔야 합니다.");
				$(this).val("");
				return;
			}
			
			var arrVal = $(this).val().split(".");
			
			if(arrVal.length != 1) {
				alert("정수만 입력하셔야 합니다.");
				$(this).val("");
				return;
			}
			
		});
		
		//////////////////////////////////////////////////////////////////////////
			
		$("input[name=discount_price]").blur(function() {
			
		//	console.log("확인용");
			
			if(isNaN($(this).val())) {
				alert("할인가격은 숫자만 입력하셔야 합니다.");
				$(this).val("");
				return;
			}
			
			else if($("input[name=prod_price]").val().trim() == "") {				
				alert("가격을 먼저 입력하셔야 합니다.");
				$(this).val("");
				return;
			}
			
			else if(Number($(this).val()) >= Number($("input[name=prod_price]").val())) {				
				alert("할인가격은 정가 이하이어야 합니다.");
				$(this).val("");	
				return;
			}
			
			else if(Number($(this).val()) < 0) {				
				alert("할인가격은 최소 0원 이상이어야 합니다.");
				$(this).val("");
				return;
			}
			
			else if($(this).val().trim() == "") {
				alert("할인적용시 할인가격을 입력하셔야 합니다.");
				$(this).val("");
				return;
			}
			
			var arrVal = $(this).val().split(".");
			
			if(arrVal.length != 1) {
				alert("정수만 입력하셔야 합니다.");
				$(this).val("");
				return;
			}
			
		});

		//////////////////////////////////////////////////////////////////////////
		
		$("input[name=prod_stock]").blur(function() {
			
		//	console.log("확인용");
			
			if(isNaN($(this).val())) {
				alert("재고는 숫자만 입력하셔야 합니다.");
				$(this).val("");
				return;
			}
			
			else if(Number($(this).val()) < 0) {				
				alert("재고는 최소 0개 이상이어야 합니다.");
				$(this).val("");
				return;
			}
			
			else if($(this).val().trim() == "") {
				$(this).val("");
				return;
			}

			var arrVal = $(this).val().split(".");
			
			if(arrVal.length != 1) {
				alert("정수만 입력하셔야 합니다.");
				$(this).val("");
				return;
			}
			
		});
		
		///////////////////////////////////////////////////////////////////////////
		
		$("textarea[name=prod_exp]").bind('keyup', function() {
			
			$("span#howlong").html($(this).val().length + "자");
			
		});

		///////////////////////////////////////////////////////////////////////////
		
		$("textarea[name=prod_exp]").blur(function() {			
			
			if($(this).val().trim().length == 0) {
				$("span#howlong").html("");
				$(this).val("");
			}
			
			else {
				$("span#howlong").html($(this).val().length + "자");
			}
			
		});
		
		///////////////////////////////////////////////////////////////////////////
		
		$(".discount").click(function() {
			
			if($("input[name=prod_discount]:checked").length == 1) {
				$("div#discount").show();
			}
			
			else {
				$("input[name=discount_price]").val("");
				$("div#discount").hide();
			}
			
		});
		
		/////////////////////////////////////////////////////////////////////////
		
		$("#selectCnt").blur(function() {
			
			if(isNaN($(this).val())) {
				alert("골라담기 개수는 숫자만 입력하셔야 합니다.");
				$(this).val("");
			}
			
			else if(Number($(this).val()) < 1) {				
				alert("골라담기 개수는 최소 1개 이상이어야 합니다.");
				$(this).val("");				
			}
			
		});
		
				
	})// end of $(document).ready(function() {})------------------------------------------
	
	// Function Declaration
	
	function goRegister() {
		
		var frm = document.registerFrm;

		// 유효성 검사하기
		
		// 1. 카테고리 검사
	//	console.log(frm.sort_code.value);
		
		if(frm.sort_code.value == 0) {
			
			if(frm.add_sort_name.value.trim().length == 0) {
			//	console.log("안돼안돼");
				alert("신규 카테고리 추가 시, 카테고리명을 입력하셔야 합니다.");
				return;
			}
			
			else {
				frm.add_sort_name.value = frm.add_sort_name.value.trim(); 
			}
			
		}
		
		// 2. 상품명 검사		
		if(frm.prod_name.value.trim().length == 0) {
			alert("상품명을 입력하셔야 합니다.");
			return;			
		}
		
		else {
			frm.prod_name.value = frm.prod_name.value.trim();
		}
		
		// 3. 상품설명 검사 --> 얘는 없어도 상관없다
		if(frm.prod_exp.value.trim().length != 0) {
			frm.prod_exp.value = frm.prod_exp.value.trim();			
		}		
		
		// 4. 가격 검사
		if(frm.prod_price.value.trim().length == 0) {
			alert("가격을 입력하셔야 합니다.");
			return;			
		}
		
		else {
			frm.prod_price.value = frm.prod_price.value.trim();
		}
		
		// 4-#. 할인 가격 검사
		if($("input[name=prod_discount]:checked").length == 1) {
		//	console.log("확인용이야");
			
			if(frm.discount_price.value.trim().length == 0) {
				alert("할인적용시 할인가격을 입력하셔야 합니다.");
				return;			
			}
			
			else {
				frm.discount_price.value = frm.discount_price.value.trim();
			}
			
		}
		
		// 5. 재고 검사 --> 얘는 없을 경우 재고가 0인 상태로 입력될 것이므로 상관없다
		if(frm.prod_stock.value.trim().length != 0) {
			frm.prod_stock.value = frm.prod_stock.value.trim();			
		}
		
		// 6. 타이틀이미지 검사
		if(frm.titlefile.value.trim().length == 0) {
			alert("상품 타이틀이미지는 반드시 입력하셔야 합니다.");
			return;			
		}
		
		// 7. 상세이미지 검사
		if(frm.detailfile.value.trim().length == 0) {
			alert("상품 상세이미지는 반드시 입력하셔야 합니다.");
			return;			
		}
		
		// 8. 추가구성상품 검사
		if(frm.prod_plus.value == 1 && frm.prod_plus_code.value.length == 0) {
			alert("추가구성상품을 반드시 선택하셔야 합니다.");
			return;			
		}
		
		// 9. 골라담기 검사
		if(frm.prod_select.value == 1 && frm.prod_select_code.value.length == 0) {
			
		//	console.log(frm.prod_select_code.value);
			alert("골라담기상품을 반드시 선택하셔야 합니다.");
			return;			
		}
		
		if(frm.prod_select.value == 1 && frm.selectCnt.value.trim().length == 0) {
			
		//	console.log(frm.prod_select_code.value);
			alert("골라담기개수를 반드시 입력하셔야 합니다.");
			return;			
		}
		
		if(frm.prod_select.value == 1 && frm.selectCnt.value.trim().length != 0) {
			frm.selectCnt.value = frm.selectCnt.value.trim();
		}
		
		frm.titlefile.disabled = false;
		frm.detailfile.disabled = false;
		
		frm.action = "prodInsert.go";
		frm.method = "post";
		frm.submit();
		
		
	}// end of function goRegister()------------------------------------------------------
	
</script>

		
	   <div class="container mt-5 pt-5 px-0 offset-lg-3 col-lg-9"> 	
		
		<h4>상품등록</h4>
		<hr>
							
		<div id="main" class="w-100 mx-0 px-0">
		
		   <form name="registerFrm" class="was-validated">
			   
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="select1">카테고리</label>
					</div>
					<div class="col form-inline form-group">
						<select class="form-control col-md-5 col-9 mr-2 mt-1" name="sort_code" required>
							<option value="0">[신규 카테고리 등록]</option>
							
							<c:if test="${not empty requestScope.sortList}">
								<c:forEach var="sort" items="${requestScope.sortList}">	
									<option value="${sort.sort_code}">${sort.sort_name}</option>								
								</c:forEach>							
							</c:if>	
										      
						</select>
						<span id="inputCategory" class="mt-1"><label id='inputCategory'><input type='text' class='myinput form-control' name='add_sort_name' id='addCategory' required placeholder='카테고리명을 입력하세요' maxlength="15"/></label></span>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="prodName">상품명</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<input type="text" class="productname form-control" id="box" name="prod_name" maxlength="200" required>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="expalin">상품설명</label>
					</div>
					<div class="col-9 col-md-5 form-group">						
						<textarea class="form-control form-control-sm" name="prod_exp" maxlength="500"></textarea>						
						<span class='small' style="color: red;">*상품설명은 500자까지만 가능합니다.</span>
						<span class='small ml-5' id='howlong'></span>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="price">가격</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<input type="text" class="price form-control mb-1" id="price" name="prod_price" required>				
						<input type="checkbox" class="discount" id="discount" name="prod_discount"><label for="discount" class="discount">&nbsp;할인적용</label>
					</div>
				</div>
								
				<div class="row w-100 mx-0 px-0 mb-3" id="discount">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="price">할인가격</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<input type="text" class="discount_price form-control" id="discount_price" name="discount_price" required>				
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="inventory">재고</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<input type="text" class="inventory form-control" id="box" name="prod_stock">
						<span class='small' style="color: red;">*재고 미입력 시 품절상태로 노출될 수 있습니다</span>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" for="addFile1">타이틀 이미지</label>
					</div>
					<div class="col-9 col-md-6 form-group">
						<input type="file" class="form-control-file mx-0" multiple="multiple" id="addTitleFile" name="prod_img_url">       					
						<span class='small' style="color: red;">*복수 개의 파일 선택시 반드시 파일명에 넘버링이 되어있어야 합니다</span>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" for="addFile1">타이틀 이미지 목록</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<textarea id="titlefile" class="form-control form-control-sm" name="titlefile" disabled="disabled"></textarea>
					</div>
				</div>
			   
			   <div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" for="addFile2">상세 이미지</label>
					</div>
					<div class="col-9 col-md-6 form-group">
						<input type="file" class="form-control-file mx-0" multiple="multiple" id="addDetailFile" name="prod_img_detail_url">
						<span class='small' style="color: red;">*복수 개의 파일 선택시 반드시 파일명에 넘버링이 되어있어야 합니다</span>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" for="addFile1">상세 이미지 목록</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<textarea id="detailfile" class="form-control form-control-sm" name="detailfile" disabled="disabled"></textarea>						
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" >아이스배송 여부</label>
					</div>
					<div class="col">
						<input type="radio" value="0" name="prod_ice" id="not_prod_ice" checked /><label for="not_prod_ice">&nbsp;아이스배송X&nbsp;</label>	
			            <input type="radio" value="1" name="prod_ice" id="prod_ice" /><label for="prod_ice">&nbsp;아이스배송O</label>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" >추가구성상품 여부</label>
					</div>
					<div class="col">
						<input type="radio" value="0" name="prod_plus" id="not_prod_plus" checked /><label for="not_prod_plus">&nbsp;추가구성X&nbsp;</label>
			            
			            <c:if test="${empty requestScope.prodList}">			            
				            <input type="radio" value="1" name="prod_plus" id="prod_plus" disabled="disabled" /><label for="prod_plus">&nbsp;추가구성O</label>							 
				        </c:if>
			         	
			         	<c:if test="${not empty requestScope.prodList}">			            
				            <input type="radio" value="1" name="prod_plus" id="prod_plus" /><label for="prod_plus">&nbsp;추가구성O</label>							 
				         	<div id="plus" class="mx-0 px-0 col-md-8">
				         		
				         		<select class='form-control' name='prod_plus_code' size='5' multiple required>
								    <c:forEach var="prod" items="${requestScope.prodList}">	
										<option value="${prod.prod_code}">${prod.prod_name}</option>								
									</c:forEach>					      
						 		</select>
						 		
						 		<span class='small' style='color: red;'>*[Ctrl]키를 누르고 선택하세요</span>
				         		 
				         	</div>			         	
			         	</c:if>
			         	
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" >골라담기 여부</label>
					</div>
					<div class="col">
						<input type="radio" value="0" name="prod_select" id="not_prod_select" checked /><label for="not_prod_select">&nbsp;골라담기X&nbsp;</label>
			            
			            
			            <c:if test="${empty requestScope.prodList}">			            
				            <input type="radio" value="1" name="prod_select" id="prod_select" disabled="disabled" /><label for="prod_select">&nbsp;골라담기O</label>							 
				        </c:if>
			         	
			         	<c:if test="${not empty requestScope.prodList}">			            
				            <input type="radio" value="1" name="prod_select" id="prod_select" /><label for="prod_select">&nbsp;골라담기O</label>							 
				         	<div id="select" class="mx-0 px-0 col-md-8">
				         		
				         		<select class='form-control' name='prod_select_code' size='5' multiple required>
								    <c:forEach var="prod" items="${requestScope.prodList}">	
										<option value="${prod.prod_code}">${prod.prod_name}</option>								
									</c:forEach>					      
						 		</select>
						 		<span class='small' style='color: red;'>*[Ctrl]키를 누르고 선택하세요</span>
						 	</div>
						 	
						 	<div id="select" class="mx-0 px-0 col-md-4">	
						 		<input type="text" id="selectCnt" name="selectCnt" class="form-control form-control-sm" placeholder="골라담기 개수를 입력하세요" required> 						 		
				         	</div>	 
				         				         	
			         	</c:if>
			            
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" >상품판매 여부</label>
					</div>
					<div class="col">
						<input type="radio" value="1" name="prod_sale" id="prod_sale" checked /><label for="prod_sale">&nbsp;판매&nbsp;</label>
						<input type="radio" value="0" name="prod_sale" id="not_prod_sale" /><label for="not_prod_sale">&nbsp;미판매</label>
						<p class='small' style="color: red;">*판매 선택 시, 재고가 0일 경우 품절상태로 노출될 수 있습니다</p>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						
					</div>
					<div class="col">
						<button type="button" class="btn btn-sm btn-success mb-3 mr-2" onClick="goRegister();">등록</button>
						<input type="reset"  value="취소" class="btn btn-sm btn-danger mb-3" />
					</div>
				</div>
								
		  	</form>
		  				
		</div>	
			
	</div>

<jsp:include page="../include/footer_admin.jsp"></jsp:include>
