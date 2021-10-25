<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/include/header.jsp"/>
<link rel="stylesheet" type="text/css" href="/css/mypage/mypageStyle.css" />
<title>주문서 작성</title>
<style type="text/css">
/* 표 첫번째열 가로넓이, 색, 정렬 등 */
table td:nth-child(1) {
	width:15%;
	background-color: #f9f9f9;
	text-align: left;
	font-weight: bold;
	font-size: 10pt;
	padding-left: 3%;
}

/* 표 항목 */
.tdTitle{
	width:15%;
	background-color: #f9f9f9;
	text-align: left;
	font-weight: bold;
	font-size: 10pt;
	padding-left: 3%;
}
		
/* 폼 입력칸 */
  .form-control {
  		height: 25px;
  		border-radius: 0;
  		font-size : 13px;
  }
  
  /* 전화번호select */
  .selectpicker {
  		width: 57px;
  		height: 25px;
  		border-color: gray;
  }
 ::placeholder {
  color: black;
  font-size: 0.8em;
  font-weight: 200;
  opacity: 1; /* Firefox */
} 
  input {
  margin-left: 3px;
  }
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
.spinner {
	width: 30px;
	height: 18px;
}
.pmButton {
	font-size:8px; 
	padding:2px 2px;
}
</style>
<div style="width:100%; height:10px; text-align:center; padding-top:10px;"></div>

<%-- ////내용 시작//// --%>	
<section>
    <div class="container p-5">
    <form id="orderForm">
    	<input type="hidden" id="order_totalAmount" value="">
    </form>
	<p style="margin-bottom:8px; font-weight: bold; color: black; text-align: center; font-size: 14pt;">주문서 작성</p>
	<p class="text-secondary" style="margin-bottom:2px; text-align: center; font-size: 9pt;">*상품의 옵션 및 수량 변경은 상품상세 또는 장바구니에서 가능합니다.</p>
	<p class="text-secondary" style="margin-bottom:25px; text-align: center; font-size: 9pt;">*할인된 제품은 적립금이 없습니다.</p>
	<%-- 장바구니 표 --%>
		<table class="table btable" id="table">			
		    <tr style="background-color: #f9f9f9;">
		      <td></td>
		      <td>이미지</td>
		      <td>상품정보</td>
		      <td>판매가</td>
		      <td>수량</td>
		      <td>적립금</td>
		      <td>합계</td>
		    </tr>	 
		  <tbody>
		  <%-- 장바구니에서 주문페이지로 정보가 담긴 경우 --%>
		  	<c:forEach var="basketList" items="${requestScope.basketList}" varStatus="status">
			  	<tr>
	  	  		  <td>
					 <button type="button" class="btn btn-secondary btn-sm" style="font-size: 8pt; padding: 5px;" onclick ="deleteBasket(this)">삭제</button>
				  </td>
			      <td><a href="/product/prodDetail.go?prod_code=${basketList.prod_code}" ><img src="/img_prod/${basketList.prod_img_url}" width=60px;/></a>
			      		<input type="hidden" value="${basketList.prod_code}" class="prod_code" /> <%-- 상품번호값알아오려고 추가해봄 --%>
			      		<input type="hidden" value="${basketList.basket_no}" class="basket_no" /> <%-- 장바구니값알아오려고 추가해봄 --%>
			      </td>
			      <td class="prod_name">${basketList.prod_name}</td>
			      <td>
			       <span class="price">
			        <c:choose>
			        	<c:when test="${basketList.discount_price eq -9999}"><fmt:formatNumber value="${basketList.prod_price}" type="number"></fmt:formatNumber>
			        		<input type="hidden" value="${basketList.prod_price}" class="price_comma_del" />
			        	</c:when>
			        	<c:otherwise><fmt:formatNumber value="${basketList.discount_price}" type="number"></fmt:formatNumber>
			        	    <input type="hidden" value="${basketList.discount_price}" class="price_comma_del" />
			        	</c:otherwise>
			        </c:choose>
			        </span>원		       
			      </td>
			      <td>			       	
	  				<input type="text" class="goods_qy" id="goods_qy${status.index}" name="goods_qy" value="${basketList.goods_qy}" style="border:none; width:20px;" readOnly/>
			      <td>
			       <span class="point" id="point${status.index}">
			      	<c:choose>					        	
			        	<c:when test="${basketList.discount_price eq -9999}">
			        		<fmt:formatNumber value="${basketList.prod_price*basketList.goods_qy/100}" type="number"></fmt:formatNumber>
			        	</c:when>
			        	<c:otherwise>0</c:otherwise>
			        </c:choose>
			        </span>원
			      </td>
			      <td>
			      <span class="priceToT" id="priceTot${status.index}">
			      	<c:choose>					        	
			        	<c:when test="${basketList.discount_price eq -9999}">
			        		<fmt:formatNumber value="${basketList.prod_price*basketList.goods_qy}" type="number"></fmt:formatNumber>
			        	</c:when>
			        	<c:otherwise><fmt:formatNumber value="${basketList.discount_price*basketList.goods_qy}" type="number"></fmt:formatNumber></c:otherwise>
			        </c:choose>
			        </span>원
			      </td>					      	      		      
			    </tr>
			   </c:forEach>
		    </tbody>
		</table>
		
	<%-- 배송 주소록 관리 표 --%>
	<div style="float:left; padding-bottom:15px; font-weight: bold; font-size:20px;">배송정보</div>
	<div style="float:right; padding-bottom:15px;">*필수입력사항</div>
	<table class="table">
		<tr>
			<td>배송지 선택</td>
			<td>
				<div style="font-size:12px;">
					<input id="defaultAddr" name="addr" value="T" type="checkbox">&nbsp;<label for="defaultAddr">기본 배송지</label>&nbsp;
					<input id="newAddr" name="addr" value="F" type="checkbox">&nbsp;<label for="newAddr">새로운 배송지</label>&nbsp;                             
					&nbsp;<button type="button" onclick="AddrPop()">주소록 보기</button>				
                   </div>
               </td>
		</tr>
	</table>
	<form id="addressFrm" name="addressFrm">
	<input type="hidden" name="userid" value="${sessionScope.loginuser.userid}"/>
	<input type="hidden" name="ano" value="${addressVo.ano}"/>		
		<table class="table">			
		    <tr>
		      <td>배송지명 *</td>
		      <td><input id='delivername' name="delivername" maxlength = "15" class="form-control col-sm-3 required" type='text' value = "${defaultAddr.delivername}"/></td>
		    </tr>
			<tr>
		      <td>성명 *</td>
		      <td><input id='name' name="name" maxlength ="10" class="form-control col-sm-3" type='text' value = "${defaultAddr.name}"/></td>
		    </tr>
			<tr>
		      <td>주소 *</td>
		      <td>
		      <div class="form-inline pb-1"><input id="postcode" name="postcode"  class="form-control col-sm-2 required" type='text' value = "${defaultAddr.postcode}" />&nbsp;&nbsp;
		      	<button type="button" onclick="execDaumPostcode()" class="btn btn-light" style="font-size: 9pt; padding: 3px 8px;">우편번호</button>
		      </div>
		      <div class="form-inline pb-1"><input id="address" name="address" class="form-control col-sm-4 required" type='text' placeholder="기본주소(필수)" value = "${defaultAddr.address}"/></div>
		      <div class="form-inline pb-1">
			      <input id="detailaddress" name="detailaddress" class="form-control col-sm-4" type='text' placeholder="상세주소" value = "${defaultAddr.detailaddress}"/> 
			      <input type="text" class="form-control col-sm-4" id="extraaddress" name="extraaddress" placeholder="참고항목" value = "${defaultAddr.extraaddress}"/>
		      </div>
		     
		      </td>
		      
		    </tr>
		    <tr>
		      <td>일반전화</td>
		      <td class="form-inline">
		      
		       <select class="selectpicker" id="hp1" name="hp1">
			    <option>02</option>
			    <option>031</option>
			    <option>033</option>
			    <option>041</option>
			    <option>042</option>
			    <option>043</option>
			    <option>044</option>
			    <option>051</option>
			    <option>052</option>
			    <option>053</option>
			    <option>054</option>
			    <option>055</option>
			    <option>061</option>
			    <option>062</option>
			    <option>063</option>
			    <option>064</option>
			    <option>0502</option>
			    <option>0503</option>
			    <option>0504</option>
			    <option>0505</option>
			    <option>0506</option>
			    <option>0507</option>
			    <option>0508</option>
			    <option>070</option>
			    <option>010</option>
			    <option>011</option>
			    <option>016</option>
			    <option>017</option>
			    <option>018</option>
			    <option>019</option>
			   </select>
			   &nbsp;-&nbsp;
			      <input id="hp2" name="hp2" class="form-control col-sm-1" type='text' maxlength = "4" />&nbsp;-&nbsp;
			      <input id="hp3" name="hp3" class="form-control col-sm-1" type='text' maxlength = "4" />
		      </td>		      
		    </tr>
		    <tr>
		      <td>휴대전화 *</td>
		       <td class="form-inline">
			   <select class="selectpicker required" id="mo1" name="mo1" value="${fn:substring(defaultAddr.mobile, 0, 3)}">
				    <option>010</option>
				    <option>011</option>
				    <option>016</option>
				    <option>017</option>
				    <option>018</option>
				    <option>019</option>
			   </select>
			   &nbsp;-&nbsp;
			      <input id="mo2" name="mo2" maxlength = "4" class="form-control col-sm-1 required" type='text' value="${fn:substring(defaultAddr.mobile, 3, 7)}" />&nbsp;-&nbsp;
			      <input id="mo3" name="mo3" maxlength = "4" class="form-control col-sm-1 required" type='text' value="${fn:substring(defaultAddr.mobile, 7, 11)}" />
		      </td>
		    </tr>
		    <tr>	
		    	<td>배송메세지</td>	    
		    	<td><textarea id="omessage" class="omessage" name="omessage" maxlength="255" cols="70"></textarea></td>
		    </tr>    
		</table>		
  	</form>
  	<div class="title">
        <p style="font-weight: bold; font-size:20px;">결제 예정 금액</p>
    </div>
	<div class="totalArea">
		<table class="table">			
			<thead style="text-align:center;">
				<tr>
					<th class="col-md-4"><strong>총 주문 금액</strong>						</th>
					<th class="col-md-4"><strong>배송비</strong></th>
					<th class="col-md-4"><strong>총 결제예정 금액</strong></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="text-align:center;">
						<div>
							<strong><span id="totalPrice"></span>원</strong>		
						</div>
					</td>
					<td style="text-align:center;">
						<div>							
							<strong><span id="fee"></span>원</strong> 
						</div>
					</td>
					<td style="text-align:center;">
						<div>
							<strong><span id="totalAmount"></span>원</strong>
						</div>
					</td>
				</tr>
			</tbody>
			</table>
			<table class="table">
			<tbody>
				<tr>
					<td class="col-md-2">적립금
						<p style="font-size:11px">(보유 적립금 : <span id="point">${sessionScope.loginuser.point}</span>원)</p>
					</td>					
					<td class="col-md-5">
					<div class="form-inline pb-1">					
						<input id="inputPoint" name="inputPoint" class="form-control col-sm-2" placeholder="" size="10" value="" type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"/>
						<button type="button" class="btn btn-light  btn-sm" id="usePoint" style="margin-left:5px">사용</button>
					</div>
						<ul style="list-style: none; padding-left: 5px; font-size:12px;">
							<li id="mileage_max_unlimit" class="displaynone">최대 사용금액은 제한이 없습니다.</li>
							<li>적립금으로만 결제할 경우, 결제금액이 0으로 보여지는 것은 정상이며 [결제하기] 버튼을 누르면 주문이 완료됩니다.</li>								
						</ul>
					</td>
					<td class="tdTitle col-md-1" style="font-size:11px;">총 적립금</td>
					<td style="text-align:center;" class="col-md-3"><span class="totalPoint" id="totalPoint"></span>원</td>
					<td class="col-md-1"><a href="javascript:pay();" id="btn_payment" class="btn btn-secondary" style="font-size:16px; font-weight:700; padding:10px 20px;width:170px;">결제하기</a></td>
				</tr>
			</tbody>
		</table>
	</div>		
	</div>
	<%-- goORDER_SETLE_INSERT함수를 실행해서 OrderSetleEndAction로 보낼 폼 --%>
	<form name="frm_order_setle">
		<input type="hidden" name="prod_name" />
		<input type="hidden" name="price" />
		<input type="hidden" name="goods_qy" /> 
		
		<input type="hidden" name="fk_prod_code" /> <%-- 결제내역에 insert하기 위한 상품번호 문자열--%>
		
		<input type="hidden" name="user_name" value="${sessionScope.loginuser.name}" />
		<input type="hidden" name="fk_user_id" value="${sessionScope.loginuser.userid}" />
		<input type="hidden" name="totalAmount" /> <%-- 결제내역에 insert하기 위한 총결제액 --%>
		<input type="hidden" name="omessage" /> <%-- 결제내역에 insert하기 위한 배송메세지 --%>
		
		<input type="hidden" name="totalPoint" /> <%-- 회원테이블에 update하기 위한 총point --%>
		<input type="hidden" name="basket_no" /> <%-- 장바구니에서 delet하기 위한 장바구니번호 문자열. 그런데 바로주문하기를할때는 장바구니번호가 없다.--%>
												<%-- 결제내역에 insert하기 위한 payment_type 아임포트 문자열--%>
		
										<%-- TBL_STOCK테이블에서에서 재고량을 감소시킬때는 상품코드를 where에 잡아서 재고량 컬럼인 prod_stock에서 goods_qy를 빼면 될까요?--%>
												
		<input type="hidden" id="usedPoint" name="usedPoint" value="0"/>										
	</form>
	
	
</section>	

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>	
<script>
$(function(){
	
	// 주소록 
	$('input[name="addr"]').click(function(){
		 
		  if($(this).prop('checked')){
		 
		     $('input[name="addr"]').prop('checked',false);
		 
		     $(this).prop('checked',true);
		 	 console.log('클릭');
		    }
		  
		   if($(this)[0].id == "newAddr") {		
			   
			    $("#delivername").val("");
				$("#name").val("");
				$("#postcode").val("");
				$("#address").val("");
				$("#detailaddress").val("");
				$("#extraaddress").val("");
				$("#mo1").val("");
				$("#mo2").val("");
				$("#mo3").val("");
				
		   } else {
		    	
		    	$("#delivername").val("${defaultAddr.delivername}");
				$("#name").val("${defaultAddr.name}");
				$("#postcode").val("${defaultAddr.postcode}");
				$("#address").val("${defaultAddr.address}");
				$("#detailaddress").val("${defaultAddr.detailaddress}");
				$("#extraaddress").val("${defaultAddr.extraaddress}");
				$("#mo1").val("${fn:substring(defaultAddr.mobile, 0, 3)}")
				$("#mo2").val("${fn:substring(defaultAddr.mobile, 3, 7)}")
				$("#mo3").val("${fn:substring(defaultAddr.mobile, 7, 11)}")
		   } 
	});
	
	// 총 결제금액 불러오기
	calTotalAmount();
}); 
// 다음 주소 API
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("extraaddress").value = extraAddr;
            
            } else {
                document.getElementById("extraaddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("detailaddress").focus();
        }
    }).open();
}

// 주소록 보기 팝업
function AddrPop(){
	var url = "/mypage/deliveraddr.go?type=orderForm";
	
	var pop_width = 1000;
	var pop_height = 500;
	var pop_left = Math.ceil((window.screen.width - pop_width)/2 );
	var pop_top = Math.ceil((window.screen.height - pop_height)/2 );
	
	window.open(url, "memberUpdate",
    "left="+pop_width+", top="+pop_top+", width="+pop_width+", height="+pop_height);
}

// 전체 선택
function selectAll(selectAll)  {
	 
	const checkboxes = document.getElementsByName('select');
	 
	checkboxes.forEach((checkbox) => {
		checkbox.checked = selectAll.checked;
	})
}
//장바구니 삭제
function deleteBasket(obj){
	
	
	var tr = obj.parentNode.parentNode;
    tr.parentNode.removeChild(tr);

    calTotalAmount();
}
// 총 값 계산
function calTotalAmount(){
	
	let totalPoint = 0;
	//총 적립금
	$(".point").each((index, item) => {
				
		var point = parseInt($(item).text().replace(/,/g , ''));
		totalPoint = totalPoint + point;
	
	});
	
	$("#totalPoint").text(totalPoint);
	
	// 총 주문 금액
	let totalPrice = 0;
	$(".priceToT").each((index, item) => {
		
		var priceToT = parseInt($(item).text().replace(/,/g , ''));
		totalPrice = totalPrice + priceToT;
		
	});
	
	
	$("#totalPrice").text(totalPrice);
	
	// 배송비 설정하기
	let fee = ${sessionScope.deliverFeeSet.fee};
	if(totalPrice >= parseInt(${sessionScope.deliverFeeSet.freeline})){
		fee = 0;
	} 
	$("#fee").text(fee);
	$("#totalAmount").text(totalPrice + fee);

}

// 적립금 사용
$("#usePoint").click(function() {
	
	var point = parseInt($("#point").text());
	var inputPoint = Math.floor(parseInt($("#inputPoint").val()));
	
	if(inputPoint > point){
		alert('적립금이 부족합니다.');
		$("#inputPoint").val("");
		return;
	}
	
	$("#totalAmount").text(parseInt($("#totalAmount").text()) -  inputPoint);
	$("#point").text(point-inputPoint);

    var usedPoint = document.getElementById('usedPoint');
    usedPoint.value = parseInt(usedPoint.value) + inputPoint;
   
});

function pay(){
	
	if( ${empty sessionScope.loginuser} ) {
		alert("결제를 하시려면 먼저 로그인 부터 하세요!!");
		return false;;
	}
	
	var arr_requiredInfo = document.getElementsByClassName("required");
	
	for(var i=0; i<arr_requiredInfo.length; i++){
		var value = arr_requiredInfo[i].value;
		
		if(value == "" || value == null){
			alert("필수사항 입력");
		    return false;
		}
	}
	// orderForm . PG사에 보낼 폼데이터 설정하기
	// alert("결제!" + $("#order_totalAmount").val());
	var email = '${sessionScope.loginuser.email}';
	var name = '${sessionScope.loginuser.name}';
	var mobile = '${sessionScope.loginuser.mobile}';
	var totalAmount = $("#totalAmount").text();
	
	var url = "/order/purchaseEnd.go?email="+email+"&name="+name+"&mobile="+mobile+"&totalAmount="+totalAmount; 
    
    //window.open은 팝업창 띄우기임
    window.open(url, "purchaseEnd",
    			"left=350px, top=100px, width=850px, height=600px");
    //goORDER_SETLE_INSERT(); //확인용
}


function goORDER_SETLE_INSERT() { /* OrderSetleEndAction로 frm_order_setle폼을 전송시키기 위한 함수 */
	
	/* 태그에서 class이름을 잡기 */
	var class_prod_name = document.getElementsByClassName("prod_name"); 
	var class_price_comma_del = document.getElementsByClassName("price_comma_del");
	var class_goods_qy = document.getElementsByClassName("goods_qy");
	var class_prod_code = document.getElementsByClassName("prod_code");//문자열
	var class_basket_no = document.getElementsByClassName("basket_no");//문자열
	
	
	
	
	/* 태그에서 class이름을 잡은 위치에 있는 값들을 각각 태그의 value값이나 텍스트를 쓰는 위치에 넣어주고 배열에 넣기 */
	var arr_prod_name = new Array(); 
    var arr_price = new Array(); 
    var arr_goods_qy = new Array();
    var arr_prod_code = new Array();
    var arr_basket_no = new Array();
	
    for(var i=0; i<class_prod_name.length; i++) {
	console.log("상품명 : " + class_prod_name[i].innerText + ", 판매가 : " + class_price_comma_del[i].innerText + ", 주문개수 : " + class_goods_qy[i].value +", 상품번호 : " + class_prod_code[i].value);
    
	    arr_prod_name.push(class_prod_name[i].innerText);
    	arr_price.push(class_price_comma_del[i].value);
    	arr_goods_qy.push(class_goods_qy[i].value);
    	arr_prod_code.push(class_prod_code[i].value);//문자열을 배열에 넣음
    	arr_basket_no.push(class_basket_no[i].value);//문자열을 배열에 넣음
    	
	}// end of for---------------------------------------
	
	
	//var user_req = class_user_req.value;
	//var user_req = $('#textarea').val()
	//var user_req = $(tag_name[name=omessage]).text();
	//var omessage = $(".omessage").val();
	
	var omessage = $("#omessage").val();
	
	
	var totalPoint = $("#totalPoint").text();
	totalPoint = parseInt(totalPoint);
	
	var totalAmount = $("#totalAmount").text(); 
	
	
	
	console.log('arr_prod_code',arr_prod_code);
	console.log("배송메세지 : " , omessage);
	console.log("총결제액 : " , totalAmount); 
	
    for(var i=0; i<arr_prod_name.length; i++) {
    	console.log("상품명 : " + arr_prod_name[i] + ", 판매가 : " + arr_price[i] + ", 주문개수 : " + arr_goods_qy[i] + ", 상품코드 : " + arr_prod_code[i] + ", 배송메세지 : " + omessage + ", 총적립금 : " + totalPoint+ ", 장바구니번호 : " + arr_basket_no[i] );      
	}
 
   
    
	/* 배열을 문자열로 바꿔주고 변수에 넣기 */
	var prod_name_join = arr_prod_name.join();	
	var price_join = arr_price.join();
	var goods_qy_join = arr_goods_qy.join();
	var prod_code_join = arr_prod_code.join();//prod_code_join는 문자열
	var basket_no_join = arr_basket_no.join();
	
	
	console.log('prod_code_join', prod_code_join);
	console.log('basket_no_join', basket_no_join);
	
	
	/* 변수를 폼에 넣기 */
    var frm = document.frm_order_setle;
    frm.prod_name.value = prod_name_join;
    frm.price.value = price_join;
    frm.goods_qy.value = goods_qy_join;
    frm.fk_prod_code.value = prod_code_join;
    frm.basket_no.value = basket_no_join;
    frm.totalAmount.value = totalAmount;
    frm.totalPoint.value = totalPoint;
    frm.omessage.value = omessage; // 배송메세지
        
    frm.action = "/order/orderSetleEnd.go";
    frm.method = "POST"; 
	frm.submit();
}



function changeAddress(ano){
	console.log('ca실행 -> ', ano);
	$.ajax({
		type : 'POST',
		data : {"ano": ano},
		dataType :'json',
		url : '/order/changeAddress.go',
		success : function(json){
			console.log(json);
			$("#delivername").val(json.delivername);
			$("#name").val(json.name);
			$("#postcode").val(json.postcode);
			$("#address").val(json.address);
			$("#detailaddress").val(json.detailaddress);
			$("#extraaddress").val(json.extraaddress);
			$("#mo1").val(json.mobile.substring(0,3));
			$("#mo2").val(json.mobile.substring(3,7));
			$("#mo3").val(json.mobile.substring(7,11));
		},
		error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
		
	});
	
}
</script>				 
<jsp:include page="/WEB-INF/include/footer.jsp"/>