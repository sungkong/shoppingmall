<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/include/header.jsp"/>
<jsp:include page="/WEB-INF/views/mypage/navbar.jsp"/>

<link rel="stylesheet" type="text/css" href="/css/mypage/mypageStyle.css" />
<title>마이페이지 - 주문내역 조회</title>
<style type="text/css">
/* 주문상품정보 표 가운데 정렬 , 글자색, 글자크기*/
table td {
	text-align: center;
	color:#616161;
	font-size: 15px;
}		
</style>
<div style="width:100%; height:60px; text-align:center; padding-top:60px;"></div>
<%-- ////내용 시작//// --%>	
<div class="container p-5" >	
	<%-- 탭 --%>
	<ul class="nav nav-tabs">
	  <li class="nav-item">
	    <a class="nav-link active text-secondary" href="/mypage/orderlist.go">주문내역조회</a>
	  </li>
	</ul>	
	<div class="pt-4 pb-5">	
	  <div class="card">
	    <div class="card-body">
	    <form id="searchFrm" name="searchFrm">	      
		      <select style="font-size: 11pt;" id="status" name="status">
			    	<option value="all">전체 주문처리상태</option>
			        <option value="beforedeposit">입금전</option>
			        <option value="readydelivery">배송준비중</option>
			        <option value="beingdelivered">배송중</option>
			        <option value="deliverycompleted">배송완료</option>
			        <option value="cancel">취소</option>
			        <option value="exchange">교환</option>
			        <option value="return">반품</option>
			</select>	
			&emsp;&nbsp;	
			<%-- 날짜로 조회하기 --%>	 
		           <input type="text" id="fromDate" name="fromDate" style="height: 25px; width: 105px; font-size: 11pt;" autocomplete='off'>&ensp;~
		           <input type="text" id="toDate" name="toDate" style="height: 25px; width: 105px; font-size: 11pt;" autocomplete='off'>	         
			&ensp; 
			<button type="button" onclick="search()" style="border: solid 1px gray; border-radius: 5px; font-size: 10pt; padding: 3px 8px;">조회</button>	
		</form>
	    </div>
	  </div>
	</div>

	<p style="font-weight: bold; color: #666666;">주문 상품 정보</p>
	<%-- 주문 상품 정보 표 --%>
		<table class="table table-bordered">
		  <thead>
		    <tr style="background-color: #f9f9f9;">
		      <td>주문일자[주문번호]</td>
		      <td>이미지</td>
		      <td>상품정보</td>
		      <td>수량</td>
		      <td>상품구매금액</td>
		      <td>주문처리상태</td>
		    </tr>
		  </thead>
		  <tbody>
	    	<c:forEach items="${requestScope.orderList}" var ="orderList">
		    	<tr>
		    		 <td>${orderList.order_dt}(${orderList.order_no})</td>
				     <td><a href="/product/prodDetail.go?prod_code=${orderList.prod_code}"><img src="/img_prod/${orderList.prod_img_url}" alt="상품사진" width=60px;/></a></td>
				     <td>${orderList.prod_name}</td>
				     <td>${orderList.goods_qy}</td>
				     <td><fmt:formatNumber value="${orderList.tot_amount}" type="number"></fmt:formatNumber>원</td>
				     <td>
				     	<c:choose>
				     		<c:when test="${orderList.status == 'beforedeposit'}">입금전</c:when>
				     		<c:when test="${orderList.status == 'readydelivery'}">배송준비중</c:when>
				     		<c:when test="${orderList.status == 'beingdelivered'}">배송중</c:when>
				     		<c:when test="${orderList.status == 'deliverycompleted'}">배송완료</c:when>
				     		<c:when test="${orderList.status == 'cancel'}">취소</c:when>
				     		<c:when test="${orderList.status == 'exchange'}">교환</c:when>
				     		<c:when test="${orderList.status == 'return'}">환불</c:when>
				     		<c:otherwise>그 외</c:otherwise>
				     	</c:choose>			     
				     </td>	
				  </tr>   
	    	</c:forEach>		           	    		    
		  </tbody>
		</table>
		
		<br>	
		
	<%-- 페이지네이션 --%>	
	<nav aria-label="Page navigation example" style="margin: auto;">
		<ul class="pagination justify-content-center">
			<c:if test="${pagination.prev}">
				<li class="page-item"><a class="page-link" href="#" onClick="fn_prev('${pagination.currPageNo}', '${pagination.range}', '${pagination.pageSize}')" >이전</a></li>
			</c:if>
			<c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="idx">
				<li class="page-item <c:out value="${pagination.currPageNo == idx ? 'active' : ''}"/> "><a class="page-link" href="#" onClick="fn_pagination('${idx}', '${pagination.range}')"> ${idx} </a></li>
			</c:forEach>
			<c:if test="${pagination.next}">
				<li class="page-item"><a class="page-link" href="#" onClick="fn_next('${pagination.currPageNo}', '${pagination.range}', '${pagination.pageSize}')" >다음</a></li>
			</c:if>
		</ul>
	</nav>	
</div>
<script type="text/javascript">

//이전 버튼
function fn_prev(currPageNo, range, pageSize) {

	var currPageNo = (range - 1) * pageSize;
	var range = range - 1;

	var url = "/mypage/orderlist.go";
	url = url + "?currPageNo=" + currPageNo;
	url = url + "&range=" + range;
	url = url + "&status=" + $("#status").val();
	url = url + "&fromDate=" + $("#fromDate").val();
	url = url + "&toDate=" + $("#toDate").val();
	location.href = url;

}

//페이지 번호 클릭

function fn_pagination(currPageNo, range) {

	var url = "/mypage/orderlist.go";
	url = url + "?currPageNo=" + currPageNo;
	url = url + "&range=" + range;
	url = url + "&status=" + $("#status").val();
	url = url + "&fromDate=" + $("#fromDate").val();
	url = url + "&toDate=" + $("#toDate").val();
	location.href = url;	

}
//다음 버튼 이벤트
function fn_next(currPageNo, range, pageSize) {

	var currPageNo = (range * pageSize) + 1;
	var range = parseInt(range) + 1;	

	var url = "/mypage/orderlist.go";
	url = url + "?currPageNo=" + currPageNo;
	url = url + "&range=" + range;
	url = url + "&searchType=" + $("#searchType").val();
	url = url + "&fromDate=" + $("#fromDate").val();
	url = url + "&toDate=" + $("#toDate").val();
	location.href = url;
}

function search(){
	
	var fromDate = document.querySelector('#fromDate').value;
	var toDate = document.querySelector('#toDate').value;
	
	if(fromDate != ""){
		if(toDate == ""){
			alert('검색 날짜를 확인하세요');
			return;
		}
	}
	if(toDate != ""){
		if(fromDate == ""){
			alert('검색 날짜를 확인하세요');
			return;
		}
	}
	
	var frm = document.searchFrm;
	frm.action = '/mypage/orderlist.go';
	
	frm.submit();
}
$(function() {
	
		if("${requestScope.status}" == ""){
			$("#status").val("all");
		} else {
			$("#status").val("${requestScope.status}");
		}
		$("#fromDate").val("${requestScope.fromDate}");
		$("#toDate").val("${requestScope.toDate}");
		
		
       //모든 datepicker에 대한 공통 옵션 설정
       $.datepicker.setDefaults({
           dateFormat: 'yy-mm-dd' //Input Display Format 변경
           ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
           ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
           ,changeYear: true //콤보박스에서 년 선택 가능
           ,changeMonth: true //콤보박스에서 월 선택 가능                
        // ,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시  
        // ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
        // ,buttonImageOnly: true //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
        // ,buttonText: "선택" //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
           ,yearSuffix: "년" //달력의 년도 부분 뒤에 붙는 텍스트
           ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
           ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
           ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
           ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
        // ,minDate: "-1M" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
        // ,maxDate: "+1M" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)                    
       });

       //input을 datepicker로 선언
       $("input#fromDate").datepicker({
    	   maxDate: 0,
    	   onClose : function(selectedDate){   		   
    		   $("input#toDate").datepicker("option", "minDate", selectedDate);
    	   }
       });                    
       $("input#toDate").datepicker({  	
    	   maxDate: 1,
    	   onClose : function(selectedDate){   		   
    		   $("input#fromDate").datepicker("option", "maxDate", selectedDate);
    	   }
       });
       
       //From의 초기값을 오늘 날짜로 설정
       //$('input#fromDate').datepicker('setDate', '-2M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
      
       //To의 초기값을 3일후로 설정
       //$('input#toDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
   });
</script>
<jsp:include page="/WEB-INF/include/footer.jsp"/>