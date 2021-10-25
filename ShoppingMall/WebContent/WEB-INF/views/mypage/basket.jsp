<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/include/header.jsp"/>
<jsp:include page="/WEB-INF/views/mypage/navbar.jsp"/>

<title>마이페이지 - 장바구니</title>
<link rel="stylesheet" type="text/css" href="/css/mypage/mypageStyle.css" />
<style>
/* btable표, mtable표 가운데 정렬 , 글자색, 글자크기*/
table.table.btable td {
	text-align: center;
	
}
table.table.mtable td {
	text-align: center;
	color: black;
	font-size: 22px;
	font-weight: bold;
}
/* btable표 체크박스 칸 가로넓이 줄이기*/
table.table.btable > tbody > tr > td:nth-child(1){
	width: 4%;
}
.goods_qy {
	width: 30px;
	height: 18px;
}
.pmButton {
	font-size:10px; 
}    	
</style>
<%-- ////내용 시작//// --%>	
<div class="container p-5" >			
	<p style="margin-bottom:8px; font-weight: bold; color: black; text-align: center; font-size: 14pt;">장바구니</p>
	<br>
	<%-- 장바구니 표 --%>
	<%-- 장바구니 목록이 존재한다면 --%>
	<c:if test="${not empty sessionScope.basketList}">
		<table class="table btable">	
		    <tr style="background-color: #f9f9f9;">
		      <td><input type='checkbox' value='selectall'onclick='selectAll(this)'/></td>
		      <td>이미지</td>
		      <td>상품정보</td>
		      <td>판매가</td>
		      <td>수량</td>
		      <td>적립금</td>
		      <td>합계</td>
		      <td>선택</td>
		    </tr>	 
		  <tbody>
		  	<c:forEach var="basketList" items="${sessionScope.basketList}" varStatus="status">
			  	<tr>
			  	  <c:choose>
			  	  	<c:when test="${basketList.prod_stock != 0}">
			  	  		<input type="hidden" class="prod_stock" id="prod_stock${status.index}" name="prod_stock" value="${basketList.prod_stock}"/>
			  	  		  <td><input type='checkbox' name='select' value="${basketList.basket_no}"/></td>
					      <td><a href="/product/prodDetail.go?prod_code=${basketList.prod_code}"><img src="/img_prod/${basketList.prod_img_url}" width=60px;/></a></td>
					      <td>${basketList.prod_name}</td>
					      <td>
					       <span class="price">
					        <c:choose>
					        	<c:when test="${basketList.discount_price eq -9999}">${basketList.prod_price}</c:when>
					        	<c:otherwise>${basketList.discount_price}</c:otherwise>
					        </c:choose>
					        </span>원		       
					      </td>
					      <td>			       	
			  				<input type="text" class="goods_qy" id="goods_qy${status.index}" name="goods_qy"  maxlength='3' value="${basketList.goods_qy}" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');">
			  				<button type='button' class="pmButton" value="${basketList.prod_code}">+</button> 
			  				<button type='button' class="pmButton" value="${basketList.prod_code}">-</button>
			  				<div class="btnArea b_center" style="margin:5px auto;">
			  					<button type='button' class="btn btn-outline-danger btn-sm changeCount" value="${basketList.prod_code}">변경</button>
			    			</div>
						  </td>
					      <td>
					      	<c:choose>
					        	<c:when test="${basketList.discount_price eq -9999}"><span class="point" id="point${status.index}"></span></c:when>
					        	<c:otherwise>0</c:otherwise>
					        </c:choose>원
					      </td>
					      <td>
					     	 <span class="priceToT" id="priceTot${status.index}"></span>원
					      </td>
					      <td>
					      <button type="button" class="btn btn-dark" style="font-size: 9pt; padding: 3px 8px;" onclick ="deleteBasket(${basketList.basket_no})">삭제</button>
					      </td>
			  	  	</c:when>
			  	  	<c:otherwise>
			  	  		<input type="hidden" class="prod_stock" id="prod_stock${status.index}" name="prod_stock" value="${basketList.prod_stock}"/>		  	  		
			  	  		  <td>품절</td>
					      <td><a href="#"><img src="/img_prod/${basketList.prod_img_url}" width=60px;/></a></td>
					      <td>${basketList.prod_exp}</td>
					      <td>
					        <span class="price">
					        <c:choose>
					        	<c:when test="${basketList.discount_price eq -9999}">${basketList.prod_price}</c:when>
					        	<c:otherwise>${basketList.discount_price}</c:otherwise>
					        </c:choose>원
					        </span>			       
					      </td>
					      <td style="opacity: 0.5;">
					      	<input type="text" class="goods_qy" id="goods_qy${status.index}" name="goods_qy"  maxlength='3' value="${basketList.goods_qy}" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" disabled>
			  				<button type='button' class="pmButton" value='+' disabled></button> 
			  				<button type='button' class="pmButton" value='-' disabled></button>
			  				<div class="btnArea b_center" style="margin:5px auto;">
			  					<input type='button' class="changeCount" value='변경' disabled/>
			    			</div>
					      </td>
					      <td>
					      	-
					      </td>
					      <td>
					      	-
					      </td>
					      <td>
					      
					      <button  type="button" class="btn btn-dark" style="font-size: 9pt; padding: 3px 8px;" onclick ="deleteBasket(${basketList.basket_no})">삭제</button>
					      </td>
			  	  	</c:otherwise>			  	  	
			  	  </c:choose>		      		      
			    </tr>
			    </c:forEach>
			    </tbody>
			</table>
		  	<br>
			<br>
			<br>
			<table class="table mtable">
				<tr style="background-color: #f9f9f9;">
					<td>총 상품금액</td>
					<td>총 배송비</td>
					<td>결제예정금액</td>
				</tr>
				<tbody>
					<tr>
						<td><span id="totalPrice"></span>원</td>
						<td>+&nbsp;<span id="dliverFee"></span>원
						</td>
						<td><span id="totalAmount"></span>원</td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
			</c:if>
			<%-- 목록이 없다면 --%>
		  	<c:if test="${empty sessionScope.basketList }">
		  	<table class="table btable">	
			    <tr style="background-color: #f9f9f9;">
			      <td><input type='checkbox'name='select'value='selectall'onclick='selectAll(this)'/></td>
			      <td>이미지</td>
			      <td>상품정보</td>
			      <td>판매가</td>
			      <td>수량</td>
			      <td>적립금</td>
			      <td>합계</td>
			      <td>선택</td>
			    </tr>	 
			  <tbody>
		  		<tr><td colspan="8" style="text-align : center;">장바구니 목록이 없습니다.</tr>
		  	   </tbody>
		  	</table>
		  	<br><br><br><br><br><br>
		  	</c:if>		 				
	<%-- 	col-sm-3 text-center --%>		
		<div  class="text-center">
      		<button type="button"  onclick = "selectOrder('all') " class="btn btn-dark" style="font-size: 12pt;">전체상품주문</button>&nbsp;
  			<button type="button" onclick = "selectOrder('select')" class="btn btn-light" style="font-size: 12pt;">선택상품주문</button>&nbsp;
  		</div>
</div>
<form id="sendOrder" action="/order/sendOrder.go" method="post">
	<input type="hidden" id="basket_no_arr" name ="basket_no_arr"/>
	<input type="hidden" id="goods_qy_arrI" name ="goods_qy_arrI"/>
</form>
<%-- ////내용 끝//// --%>
<script type="text/javascript">
//수량 초기값 저장
var goods_qy_arr = $(".goods_qy");
for(var i=0; i<goods_qy_arr.length; i++){
	
	var key = "goods_qy";
	eval("goods_qy" + i + "= goods_qy_arr[i].value");	
}

// 수량 직접 입력감지 변수
var changeFlag = true;
$(document).ready(function() {
	
	// 총 결제금액 불러오기
	calTotal();

});


function calTotal(){
	
	var totalPrice = 0; 
	var countArr = $('input[name=goods_qy]');
	
	$(".price").each(function (index, item){
		
		var goods_qy = countArr[index].value;
		var index = $(".price").index(this); //0,1,2, ..
		
		var prod_stock = document.getElementById("prod_stock"+index).value;	
		if(prod_stock == 0){
			goods_qy = 0;
		}
		var priceToT = $(".priceToT").eq(index);
		// 합계, 적립금 변경
		$(".priceToT").eq(index).text(parseInt($(this).text()) * goods_qy);
		$(".point").eq(index).text(parseInt($(this).text()) * goods_qy/100);
		totalPrice = totalPrice + parseInt($(this).text()) * goods_qy;
		
	});
	
	$("#totalPrice").text(totalPrice);
	// 배송비(변수) 5만원 이상 무료.
	var fee = 0;
	if(totalPrice >= parseInt(${sessionScope.deliverFeeSet.freeline})){
		fee = 0;
		$("#dliverFee").text(fee);
	} else {
		fee = ${sessionScope.deliverFeeSet.fee};
		$("#dliverFee").text(fee);
	}
	$("#totalAmount").text(totalPrice + fee);
	
}
// 전체 체크
function selectAll(selectAll)  {
	 
	const checkboxes = document.getElementsByName('select');
	 
	checkboxes.forEach((checkbox) => {
		checkbox.checked = selectAll.checked;
	})
}

// +,- 버튼 클릭시 goods_qy(수량)의 아이디값 가져오기.
$(".pmButton").click(function(){
		
	var prod_code = $(this).val();
	
	var prev = $(this).prev();
	var type = "plus";
	
	var index =  Math.floor($(".pmButton").index(this)/2 );
	var prod_stock_id = "prod_stock"+index;
		
	if(prev[0].name != "goods_qy"){
		prev = $(this).prev().prev();
		type = "minus";
	}
	var id = prev[0].id;
	count(type, id, prod_stock_id, prod_code);
});

// +,- 버튼으로 수량 변경시 결제금액 변경,  parameter : plus/minus구분자, goods_qy의 input아이디, 제품 코드
function count(type, id, prod_stock_id, prod_code)  {
	  
	  
	  // var prod_stock = document.getElementById(prod_stock_id).value;
	  var prod_stock = 0;
	  var goods_qy = document.getElementById(id);
	  		 
	  $.ajax({
		  
			type : "post",
			url : '/order/changeProdStock.go',
			data : {"prod_code":prod_code},
			dataType:"json",
			async:false,
			success : function(json){
				prod_stock = parseInt(json.prod_stock);
				
			},
			error: function(request, status, error){
                   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
                }
		}); 

	  	  
	  var number = goods_qy.value;
	   
	  
	  // 더하기/빼기	  
	  if(type === 'plus') {
		  
		  // 재고 만큼
		  if(number >= prod_stock){
			  alert('현재 재고보다 많은 수량을 입력할 수 없습니다.');
			  return;
		  }
	      number = parseInt(number) + 1;

	  }else if(type === 'minus')  {
		  
		  if(number == 1){
			  return;
		  }
	      number = parseInt(number) - 1;
	  }
	  
	  if(Number.isNaN(number)){
    	  number = 1;
      }
	  goods_qy.value = number;
	  
	  calTotal();
}

// 변경 버튼 누를 경우 결제금액 다시 계산
$(".changeCount").click(function(){	
	
	var index = $(".changeCount").index(this);
	var prod_code = $(this).val();
	var goods_qy = Math.floor(parseInt($("#goods_qy"+index).val() ));
	var prod_stock = 0;
	
	$.ajax({
		  
		type : "post",
		url : '/order/changeProdStock.go',
		data : {"prod_code":prod_code},
		dataType:"json",
		async:false,
		success : function(json){
			prod_stock = parseInt(json.prod_stock);
			
		},
		error: function(request, status, error){
               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
	}); 
	if(goods_qy > prod_stock){
		alert('현재 재고보다 많은 수량을 입력할 수 없습니다.');
		
		var first_goods_qy = eval('goods_qy' + index);
		
		$("#goods_qy"+index).val(first_goods_qy);
		
	} else {
		$("#goods_qy"+index).val(Math.floor(parseInt($("#goods_qy"+index).val() )));		
	}	
	changeFlag = true;
	calTotal();
});

// 장바구니 삭제
function deleteBasket(basket_no){
	
	var frm = document.createElement('form');
	frm.method = "post";
	frm.action = "/order/deleteBasket.go";
	
	var hiddenInput = document.createElement('input');
	hiddenInput.setAttribute('type','hidden');
	hiddenInput.setAttribute('name','basket_no');
	hiddenInput.setAttribute('value', basket_no);
	frm.appendChild(hiddenInput);
	
	document.body.appendChild(frm);
	frm.submit();
		
}
// 상품 주문
function selectOrder(type){
		
	// 수량을 직접 입력했을 경우 변경버튼을 거쳐야한다.
	if(changeFlag == false){
		alert('변경 버튼을 누르시기 바랍니다.');
		return false;
	}
	
	var basket_no_arr = [];
	var goods_qy_arrI = [];
	
	// 전체 선택한 경우
	if(type == 'all'){		
		$("input[name=select]").prop('checked',true);
	} 
	if($("input[name=select]:checked").length == 0){
		alert("최소 1개의 상품을 선택해야 합니다.");
		return;
	}
	$("input[name=select]:checked").each(function() { 
		
		basket_no_arr.push($(this).val());
		var index = $("input[name=select]").index(this); 
		goods_qy_arrI.push($("input[name=goods_qy]").eq(index).val());
	});
	 $("#basket_no_arr").val(basket_no_arr);
	 $("#goods_qy_arrI").val(goods_qy_arrI);

	 $("#sendOrder").submit(); 
		
}
$(".goods_qy").on("propertychange change keyup paste input", function(){
	
	changeFlag = false;
	
});

</script>
<jsp:include page="/WEB-INF/include/footer.jsp"/>