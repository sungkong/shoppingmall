<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
   String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<jsp:include page="../include/header_admin.jsp"></jsp:include>

<title>[관리자메뉴]상품상세</title>


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
		
	//	$("div#plus").hide();
	//	$("div#select").hide();
	//	$("div#discount").hide();
	
		$(".after").hide();
		
		// 수정버튼 클릭 시
		$("#btn_update").click(function() {
			
			$(".before").hide();
			$(".after").show();
			updateStart();
						
		});
		
		// 취소버튼 클릭 시
		$("#btn_reset").click(function() {
			
			$(".after").hide();
			$(".before").show();
			
		});
		
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
	
	function updateStart() {
		
		$("#tbl_inout").hide();
		$(".small").show();
		$(".img_div").show();
		$(".pickthis").show();
		$(".selthis").show();
		$("#btn_golist").hide();
		
		var frm = document.updateFrm;
		frm.sort_code.disabled = false;
		frm.prod_name.disabled = false;
		frm.prod_exp.disabled = false;
		frm.prod_price.disabled = false;
		frm.prod_discount.disabled = false;
		frm.prod_plus_code.disabled = false;		
		frm.prod_select_code.disabled = false;
		
		if(frm.prod_plus_code.value != 0) {
			$(".div_plus").show();
		}
		
		if(frm.prod_select_code.value != 0) {
			$(".div_select").show();
			$(".div_cnt").show();
			frm.selectCnt.disabled = false;
		}
								
	}
		
	
	function goUpdate() {
		
		var frm = document.updateFrm;

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
		

		// 타이틀 이미지 변경여부 검사
		if("${titleImg}" == frm.titlefile.value.trim()) {			
			frm.titlefile.value = "";
		}

		// 상세이미지 변경여부 검사
		if("${detailImg}" == frm.detailfile.value.trim()) {
			frm.detailfile.value = "";
		}
				
		frm.titlefile.disabled = false;
		frm.detailfile.disabled = false;
		
		frm.action = "/product/prodUpdate.go";
		frm.method = "POST";
		frm.submit();
		
		
	}// end of function goUpdate()------------------------------------------------------
	
	// 상품 삭제
	function deletethis() {

		   var frm = document.deleteProduct
		   	   
		   frm.action = "/product/deleteProd.go";
		   frm.method = "POST";
		   frm.submit();
		   
	}
	
</script>
	
		<%-- 삭제모달 --%>
        <div class="modal fade" id="deleteModal">
			  <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">
			  
			    <div class="modal-content">			      
			      	
			      	<!-- Modal header -->
			      <div class="modal-header row text-center">
			        	<h6 class="modal-title"><span class="what"></span>&nbsp;${prodMap.pvo.prod_name}&nbsp;상품을 삭제하시겠습니까?</h6>
			      </div>
			      	
			     <!-- Modal body -->
			      <div class="modal-body row text-center">
	
				      	<form name="deleteProduct">
				      		<input type="hidden" value="${prodMap.pvo.prod_code}" name="del_prod_code">				      		
				      		<button type="button" class="btn btn-sm btn-danger deletethis mx-1" onclick="deletethis()">삭제</button>
				      		<button type="button" class="btn btn-sm btn-success thisclose mx-1" data-dismiss="modal">취소</button>
						</form>
												
					</div>
			     				      
			    </div>
			  </div>
		</div>
		
	   <div class="container mt-5 pt-5 px-0 offset-lg-3 col-lg-9"> 	
		
		<span class="h4">상품상세</span><span class="float-right mr-1"><button id="btn_golist" type="button" class="btn btn-sm btn-secondary" onclick="location.href='/product/prodManage.go'">목록으로</button></span>
		<hr>
							
		<div id="main" class="w-100 mx-0 px-0">
			
		   <form name="updateFrm" class="was-validated">
			   	<input type="hidden" name="prod_code" value="${prodMap.pvo.prod_code}">
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="select1">카테고리</label>						
					</div>
					<div class="col form-inline form-group">						
						<select class="form-control col-md-5 col-9 mr-2 mt-1" name="sort_code" disabled required>
							<option value="0">[신규 카테고리 등록]</option>
							
							<c:if test="${not empty requestScope.sortList}">
								<c:forEach var="sort" items="${requestScope.sortList}">
									<c:if test="${prodMap.pvo.sort_code eq sort.sort_code}">
										<option value="${sort.sort_code}" selected="selected">${sort.sort_name}</option>
									</c:if>
									<c:if test="${prodMap.pvo.sort_code ne sort.sort_code}">
										<option value="${sort.sort_code}">${sort.sort_name}</option>
									</c:if>																	
								</c:forEach>							
							</c:if>	
										      
						</select>
						<span id="inputCategory" class="mt-1">					
							
						</span>												
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="prodName">상품명</label>						
					</div>
					<div class="col-9 col-md-5 form-group">
						<input type="text" class="productname form-control" id="box" name="prod_name" maxlength="200" value="${prodMap.pvo.prod_name}" disabled required>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="expalin">상품설명</label>
					</div>
					<div class="col-9 col-md-5 form-group">						
						<textarea class="form-control form-control-sm" name="prod_exp" maxlength="500" disabled>${prodMap.pvo.prod_exp}</textarea>						
						<span class='small' style="color: red; display: none;">*상품설명은 500자까지만 가능합니다.</span>
						<span class='small ml-5' id='howlong'></span>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="price">가격</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<input type="text" class="price form-control mb-1" id="price" name="prod_price" value="${prodMap.pvo.prod_price}" disabled required>
						<c:if test="${prodMap.pvo.discount_price eq '-9999'}">									
							<input type="checkbox" class="discount" id="discount" name="prod_discount" disabled><label for="discount" class="discount">&nbsp;할인적용</label>
						</c:if>									
						<c:if test="${prodMap.pvo.discount_price ne '-9999'}">									
							<input type="checkbox" class="discount" id="discount" name="prod_discount" checked="checked" disabled><label for="discount" class="discount">&nbsp;할인적용</label>
						</c:if>						
					</div>
				</div>
			
				
				<c:if test="${prodMap.pvo.discount_price eq '-9999'}">				
					<div class="row w-100 mx-0 px-0 mb-3" id="discount" style="display: none;">
						<div class="col-3 col-md-2 pt-2">
							<label class="title" for="price">할인가격</label>
						</div>
						<div class="col-9 col-md-5 form-group">
							<input type="text" class="discount_price form-control" id="discount_price" name="discount_price" value="" required>				
						</div>
					</div>
				</c:if>
					
				<c:if test="${prodMap.pvo.discount_price ne '-9999'}">				
					<div class="row w-100 mx-0 px-0 mb-3" id="discount">
						<div class="col-3 col-md-2 pt-2">
							<label class="title" for="price">할인가격</label>
						</div>
						<div class="col-9 col-md-5 form-group">
							<input type="text" class="discount_price form-control" id="discount_price" name="discount_price" value="${prodMap.pvo.discount_price}" required disabled>				
						</div>
					</div>
				</c:if>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2 pt-2">
						<label class="title" for="inventory">재고</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<input type="text" class="inventory form-control" id="box" name="prod_stock" value="${prodMap.pvo.prod_stock}" disabled>						
						<span class='small' style="color: red; display: none;">*재고변경은 입고/폐기를 통해 진행해주세요</span>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3 img_div" style="display: none;">
					<div class="col-3 col-md-2">
						<label class="title" for="addFile1">타이틀 이미지</label>						
					</div>
					<div class="col-9 col-md-6 form-group">
						<input type="file" class="form-control-file mx-0 px-0" multiple="multiple" id="addTitleFile" name="prod_img_url">       					
						<span class='small' style="color: red;">*복수 개의 파일 선택시 반드시 파일명에 넘버링이 되어있어야 합니다</span>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" for="addFile1">타이틀 이미지 목록</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<textarea id="titlefile" class="form-control form-control form-control-sm" name="titlefile" disabled="disabled">${titleImg}</textarea>
					</div>
				</div>
			   
			   <div class="row w-100 mx-0 px-0 mb-3 img_div" style="display: none;">		   
					<div class="col-3 col-md-2">
						<label class="title" for="addFile2">상세 이미지</label>
					</div>
					<div class="col-9 col-md-6 form-group ">
						<input type="file" class="form-control-file mx-0 px-0" multiple="multiple" id="addDetailFile" name="prod_img_detail_url">
						<span class='small' style="color: red;">*복수 개의 파일 선택시 반드시 파일명에 넘버링이 되어있어야 합니다</span>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" for="addFile1">상세 이미지 목록</label>
					</div>
					<div class="col-9 col-md-5 form-group">
						<textarea id="detailfile" class="form-control form-control-sm" name="detailfile" disabled="disabled">${detailImg}</textarea>						
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" >아이스배송 여부</label>
					</div>
					<div class="col">
						<c:if test="${prodMap.pvo.prod_ice eq '0'}">
							<input type="radio" value="0" name="prod_ice" id="not_prod_ice" checked /><label for="not_prod_ice">&nbsp;아이스배송X&nbsp;</label>	
				            <input type="radio" value="1" name="prod_ice" id="prod_ice" /><label for="prod_ice">&nbsp;아이스배송O</label>
			            </c:if>
			            <c:if test="${prodMap.pvo.prod_ice ne '0'}">
							<input type="radio" value="0" name="prod_ice" id="not_prod_ice"  /><label for="not_prod_ice">&nbsp;아이스배송X&nbsp;</label>	
				            <input type="radio" value="1" name="prod_ice" id="prod_ice" checked /><label for="prod_ice">&nbsp;아이스배송O</label>
			            </c:if>
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" >추가구성상품 여부</label>
					</div>
					<div class="col">
						<c:if test="${prodMap.pvo.prod_plus eq '0'}">
							<input type="radio" value="0" name="prod_plus" id="not_prod_plus" checked /><label for="not_prod_plus">&nbsp;추가구성X&nbsp;</label>
			            
				            <c:if test="${empty requestScope.prodList}">			            
					            <input type="radio" value="1" name="prod_plus" id="prod_plus" disabled="disabled" /><label for="prod_plus">&nbsp;추가구성O</label>							 
					        </c:if>
				         	
				         	<c:if test="${not empty requestScope.prodList}">			            
					            <input type="radio" value="1" name="prod_plus" id="prod_plus"  /><label for="prod_plus">&nbsp;추가구성O</label>							 
					         	<div id="plus" class="mx-0 px-0 col-md-6 div_plus" style="display: none;"> 		
					         		
					         		<select class='form-control' name='prod_plus_code' size='5' multiple disabled required>
									    <c:forEach var="prod" items="${requestScope.prodList}">	
									    	<c:if test="${prod.prod_code ne prodMap.pvo.prod_code}">
												<option value="${prod.prod_code}">${prod.prod_name}</option>
											</c:if>								
										</c:forEach>					      
							 		</select>
							 		
							 		<span class='small' style='color: red;'>*[Ctrl]키를 누르고 선택하세요</span>
					         		 
					         	</div>			         	
				         	</c:if>
				         	
			            </c:if>
			            <c:if test="${prodMap.pvo.prod_plus ne '0'}">
							<input type="radio" value="0" name="prod_plus" id="not_prod_plus" /><label for="not_prod_plus">&nbsp;추가구성X&nbsp;</label>
				            
				            <c:if test="${empty requestScope.prodList}">			            
					            <input type="radio" value="1" name="prod_plus" id="prod_plus" disabled="disabled" /><label for="prod_plus">&nbsp;추가구성O</label>							 
					        </c:if>
				         	
				         	<c:if test="${not empty requestScope.prodList}">			            
					            <input type="radio" value="1" name="prod_plus" id="prod_plus" checked  /><label for="prod_plus">&nbsp;추가구성O</label>							 
					         	<div id="plus" class="mx-0 px-0 col-md-6 div_plus">
					         		
					         		<select class='form-control' name='prod_plus_code' size='5' multiple disabled required>
									    <c:forEach var="prod" items="${requestScope.prodList}">
									    	<c:forEach var="plusvo" items="${prodMap.plusList}">
									    		<c:if test="${prod.prod_code ne prodMap.pvo.prod_code}">
										    		<c:if test="${prod.prod_code eq plusvo.prod_code}">
														<option value="${prod.prod_code}" selected="selected">${prod.prod_name}</option>
													</c:if>
													<c:if test="${prod.prod_code ne plusvo.prod_code}">
														<option class="pickthis" value="${prod.prod_code}" style="display: none;">${prod.prod_name}</option>
													</c:if>
												</c:if>
											</c:forEach>								
										</c:forEach>					      
							 		</select>
							 		
					         	</div>			         	
				         	</c:if>
			            </c:if>   
			            
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" >골라담기 여부</label>
					</div>
					<div class="col">
						<c:if test="${prodMap.pvo.prod_select eq '0'}">
							<input type="radio" value="0" name="prod_select" id="not_prod_select" checked /><label for="not_prod_select">&nbsp;골라담기X&nbsp;</label>
			            
				            <c:if test="${empty requestScope.prodList}">			            
					            <input type="radio" value="1" name="prod_select" id="prod_select" disabled="disabled" /><label for="prod_select">&nbsp;골라담기O</label>							 
					        </c:if>
				         	
				         	<c:if test="${not empty requestScope.prodList}">			            
					            <input type="radio" value="1" name="prod_select" id="prod_select"  /><label for="prod_select">&nbsp;골라담기O</label>							 
					         	<div id="select" class="mx-0 px-0 col-md-6 div_select" style="display: none;"> 			
					         		
					         		<select class='form-control' name='prod_select_code' size='5' multiple disabled required>
									    <c:forEach var="prod" items="${requestScope.prodList}">	
											<option value="${prod.prod_code}">${prod.prod_name}</option>								
										</c:forEach>					      
							 		</select>
							 		
							 		<span class='small' style='color: red;'>*[Ctrl]키를 누르고 선택하세요</span>
					         		 
					         	</div>
					         	
					         	<div id="select" class="mx-0 px-0 col-md-4 div_cnt mt-1" style="display: none;"> 			
							 		<input type="text" id="selectCnt" name="selectCnt" class="form-control form-control-sm" placeholder="골라담기 개수를 입력하세요"  required> 						 		
					         	</div>			         	
				         	</c:if>
				         	
			            </c:if>
			            
			            <c:if test="${prodMap.pvo.prod_select ne '0'}">
							<input type="radio" value="0" name="prod_select" id="not_prod_select" /><label for="not_prod_select">&nbsp;골라담기X&nbsp;</label>
				            
				            <c:if test="${empty requestScope.prodList}">			            
					            <input type="radio" value="1" name="prod_select" id="prod_select" disabled="disabled" /><label for="prod_select">&nbsp;골라담기O</label>							 
					        </c:if>
				         	
				         	<c:if test="${not empty requestScope.prodList}">			            
					            <input type="radio" value="1" name="prod_select" id="prod_select" checked  /><label for="prod_select">&nbsp;골라담기O</label>							 
					         	<div id="select" class="mx-0 px-0 col-md-6 div_select">
					         		
					         		<select class='form-control' name='prod_select_code' size='5' multiple disabled required>
									    <c:forEach var="prod" items="${requestScope.prodList}">
									    	<c:forEach var="selectvo" items="${prodMap.selectList}">
									    		<c:if test="${prod.prod_code eq selectvo.prod_code}">
													<option value="${prod.prod_code}" selected>${prod.prod_name}</option>
												</c:if>
												<c:if test="${prod.prod_code ne selectvo.prod_code}">
													<option class="selthis" value="${prod.prod_code}" style="display: none;">${prod.prod_name}</option> <%-- display 수정 --%>
												</c:if>
											</c:forEach>								
										</c:forEach>					      
							 		</select>
							 		
					         	</div>
					         	
					         	<div id="select" class="mx-0 px-0 col-md-4 div_cnt mt-1">	
							 		<input type="text" id="selectCnt" name="selectCnt" class="form-control form-control-sm" placeholder="골라담기 개수를 입력하세요" value="${prodMap.pvo.prod_select}" required disabled> 						 		
					         	</div>	
					         			         	
				         	</c:if>
			            </c:if>
								            
					</div>
				</div>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col-3 col-md-2">
						<label class="title" >상품판매 여부</label>
					</div>
					<div class="col">
						<c:if test="${prodMap.pvo.prod_sale eq '0'}">
							<input type="radio" value="1" name="prod_sale" id="prod_sale"  /><label for="prod_sale">&nbsp;판매&nbsp;</label>
							<input type="radio" value="0" name="prod_sale" id="not_prod_sale" checked  /><label for="not_prod_sale">&nbsp;미판매</label>
			            </c:if>
			            <c:if test="${prodMap.pvo.prod_sale ne '0'}">
							<input type="radio" value="1" name="prod_sale" id="prod_sale" checked/><label for="prod_sale">&nbsp;판매&nbsp;</label>
							<input type="radio" value="0" name="prod_sale" id="not_prod_sale" /><label for="not_prod_sale">&nbsp;미판매</label>
			            </c:if>						
					</div>
				</div>
								
			</form>
			
				<div class="table-responsive w-100 mx-0 px-0" style="max-height: 20%;" id="tbl_inout">
					<table class="table table-borderless text-center table-hover" style="height: 100%;">
						
						<thead class="thead-light">
							<tr class="row px-0 mx-0 w-100">
								<th class="col-3">입고일자</th>
								<th class="col-3">상태</th>
								<th class="col-3">수량</th>
								<th class="col-3">사유</th>
							</tr>
						</thead>
						
						<tbody>
							<c:if test="${not empty inoutList}">
								<c:forEach var="iovo" items="${inoutList}">
									<c:if test="${iovo.status eq 1}"><tr class="row px-0 mx-0 w-100" style="color:blue; border-bottom: solid 1px gray;"></c:if>
									<c:if test="${iovo.status ne 1}"><tr class="row px-0 mx-0 w-100" style="color:red; border-bottom: solid 1px gray;"></c:if>
										<td class="col-3">${iovo.inout_date}</td>
										<td class="col-3">
											<c:if test="${iovo.status eq 1}">입고</c:if>
											<c:if test="${iovo.status ne 1}">폐기</c:if>
										</td>
										<td class="col-3">${iovo.inout_qty}</td>
										<c:if test="${iovo.inout_exp ne '-9999'}">
											<td class="col-3">${iovo.inout_exp}</td>
										</c:if>
										<c:if test="${iovo.inout_exp eq '-9999'}">
											<td class="col-3"></td>
										</c:if>
									</tr>
								</c:forEach>
							</c:if>
							
							<c:if test="${empty inoutList}">								
								<tr class="row px-0 mx-0 w-100" style="border-bottom: solid 1px gray;">
									<td colspan="4" class="col-3"></td>										
								</tr>								
							</c:if>
							
						</tbody>
						
					</table>
				</div>
				
				<hr>
				
				<div class="row w-100 mx-0 px-0 mb-3">
					<div class="col text-center before">
						<button type="button" class="btn btn-sm btn-success mb-3 mr-2" id="btn_update">수정</button>
						<button id="btn_delete" type="button" class="btn btn-danger btn-sm deletethis mb-3 mr-2" data-toggle="modal" data-target="#deleteModal" data-backdrop="static">삭제</button>					
					</div>
					<div class="col text-center after">
						<button type="button" class="btn btn-sm btn-success mb-3 mr-2" id="btn_update" onclick="goUpdate()">저장</button>
						<button type="button" class="btn btn-sm btn-danger mb-3 mr-2" id="btn_reset" onclick="location.reload()">취소</button>
					</div>
				</div>
						
		</div>	
			
	</div>

<jsp:include page="../include/footer_admin.jsp"></jsp:include>
