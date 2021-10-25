<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- ★탑부분에 리뷰평점부분 수정 필요, 탭 중에 리뷰랑 Q&A 아직 못했음!!! 구매하기 버튼 클릭 시 폼 작성할 것!! (결제페이지랑 연동시키기) --%>

<jsp:include page="../include/header.jsp"/>

<style type="text/css">

	div.container {	width: 90%;	}
	
	div#top {margin: 0 auto;}
	
	div#main {margin: 0 auto;}
	
	div#prod_img {
		display: inline-block;
		/* border: solid 1px red;	 */
	}
	
	div#prod_info {
		display: inline-block;
		/* border: solid 1px blue; */
	}
	
	table#tbl_info td {
		vertical-align: top;
		padding-right: 10px;
	}
	
	li.myli {
		background-color: #ffffff;	
		font-weight: bold;	
	}
	
	div#btn li.myli:hover {cursor: pointer;}
 	
 	button.btn_select {background-color: fff; border: solid 1px #a6a6a6;}
 	
 	button.btn_select:hover {background-color: #a6a6a6; border: none; color: #fff;}
 	
 	button#buy {background-color: #4d4d4d; color: #fff;}
 	
 	button#buy:hover {background-color: #a6a6a6;}

	nav.mynavbar {width: 20%; margin: 0 auto; opacity: 0.5; height: 50px;}
	
	nav.mynavbar:hover {opacity: 1; cursor: pointer;}
	
	a.mynavbar-brand {text-align: center; margin: 0 auto; font-size: 11pt; width:50%;}
		
	a.mynavbar-brand:hover {font-weight: bold; text-decoration: underline;}
	
</style>

<title>[소녀떡집]리뷰등록</title>



    
<!-- Font Awesome 5 Icons --> <!-- 아이콘을 사용하려면 헤드에서 미리 링크를 걸어줘야한당 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath %>/css/style.css" />




<script type="text/javascript">
	
	var photoFlag = false;
	
	$(document).ready(function() {
		
		$("#photo").change(function() {
			
			if($(this).val() == "") {
				photoFlag = false;
			//	console.log("비워짐" +$(this).val())
			}
			
			else {
				photoFlag = true;
			//	console.log( $(this).val())
			}
			
		});
		
	});
	
	function reviewRegister() {
		
		var frm = document.reviewFrm;
		
		// 리뷰내용
		if(frm.content.value.trim() == "") {
			alert("확인용");
		}
		
		else {
			frm.content.value = frm.content.value.trim();
		}
		
		// 리뷰이미지
		if(photoFlag) {
			
			if(window.FileReader){			
				
	            frm.review_img.value = $("#photo")[0].files[0].name;
			//	console.log(frm.review_img.value);
				
				var fileArr = frm.review_img.value.toLowerCase().split(".");
				
			//	console.log(fileArr[1]);
				
				if(fileArr[1] != "jpg" && fileArr[1] != "bmp" && fileArr[1] != "png" && fileArr[1] != "jpeg") {
			   		alert("포토리뷰는 이미지만 등록 가능합니다. (jpg, jpeg, bmp, png)");
			   		return;
				}
				
	        }
			
		}
		
		frm.action = "/product/insertReview.go";
		frm.method = "POST";
		frm.submit();
		
	}
	
</script>
		
	<div class="container my-5">	
		
		<h4>리뷰등록</h4>
		<hr>
		
		<form name="reviewFrm" enctype="multipart/form-data">
			
			<table class="tbl w-100">
				
				<tr class="row w-100 mx-0 px-0">
					<td class="col-3 table-secondary border">주문번호</td>
					<td class="col-3 text-center border"><input type="text" name="orderno" value="${orderno}" readonly="readonly" class="w-100" style="border: none;"></td>
					<td class="col-3 table-secondary border">상품명</td>
					<td class="col-3 text-center border">${prod_name}<input type="hidden" name="prod_code" value="${prod_code}"></td>
				</tr>
				
				<tr class="row w-100 mx-0 px-0">
					<td class="col-3 table-secondary border">별점</td>
					<td class="col-3 text-center border">
						<select name="score" class="w-100">
							<option value="5.0" selected="selected">5.0</option>
							<option value="4.5">4.5</option>
							<option value="4.0">4.0</option>
							<option value="3.5">3.5</option>
							<option value="3.0">3.0</option>
							<option value="2.5">2.5</option>
							<option value="2.0">2.0</option>
							<option value="1.5">1.5</option>
							<option value="1.0">1.0</option>
							<option value="0.5">0.5</option>
							<option value="0.0">0.0</option>
						</select>
					</td>
					<td class="col-3 table-secondary border">작성자</td>
					<td class="col-3 text-center border">${sessionScope.loginuser.name}&nbsp;님<input type="hidden" name="userid" value="${sessionScope.loginuser.userid}"></td>
				</tr>
				
				<tr class="row w-100 mx-0 px-0">
					<td colspan="4" class="text-center col border table-secondary">review</td>
				</tr>
				
				<tr class="row w-100 mx-0 px-0">
					<td colspan="4" class="text-center col border"><textarea name="content" maxlength="500" class="w-100 my-1" style="border: none; height: 300px;"></textarea></td>
				</tr>
				
				<tr class="row w-100 mx-0 px-0">
					<td class="col-3 border pt-2 border"><label class="title" for="photo">포토리뷰</label></td>
					<td colspan="3" class="text-center col-9 pt-1 border"><input id="photo" type="file" class="form-control-file mx-0 px-0" name="photo"><input type="hidden" name="review_img"></td>
				</tr>
				
				<tr class="row w-100 mx-0 px-0 borderless">
					<td colspan="4" class="col">
						<p class="small pt-1" style="color: red;">* 일반리뷰 작성 시 100 POINT, 포토리뷰 작성 시 200 POINT 적립</p>
					</td>
				</tr>
				
				<tr class="row w-100 mx-0 px-0 borderless pt-3">
					<td colspan="4" class="text-center col">
						<button type="button" class="btn btn-sm btn-success mx-1" onClick="reviewRegister();">등록</button>
						<button type="button" class="btn btn-sm btn-danger mx-1" onClick="history.back();">취소</button>
					</td>
				</tr>
				
			</table>
			
		</form>

	</div>

<jsp:include page="../include/footer.jsp"/>			
