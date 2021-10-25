<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/include/header_admin.jsp"/>
<link rel="stylesheet" type="text/css" href="/css/mypage/mypageStyle.css" />
<title>배송관리</title>
<style type="text/css">
/* 주문상품정보 표 가운데 정렬 , 글자색, 글자크기*/
table td {
	text-align: center;
	color:#616161;
	font-size: 15px;
}
section{
 	width : 70%;
 	margin-left : 300px;
 	margin-top : 100px;
 }
#modal {
    display: none;
    width: 500px;
    height:150px;
    padding: 20px 60px;
    background-color: #fefefe;
    border: 1px solid #888;
    border-radius: 3px;
}

#modal .modal_close_btn {
    position: absolute;
    top: 10px;
    right: 10px;
}
.btn{
	margin-top : 15px;
	margin-left : 10px;
}
</style>
<section>
<%-- ////내용 시작//// --%>	
<div class="container p-5" >
     <h3>배송관리</h3>	
     <br>
     
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
			<%-- 아이디, 이름 검색 --%>
			<select style="font-size: 11pt;" id="searchType" name="searchType">
					<option value="all">전체사용자</option>
			    	<option value="userid">아이디</option>
			        <option value="name">이름</option>
			 </select>
			 <input type="text" id="keyword" name="keyword" style="height: 25px; width: 105px; font-size: 11pt;" autocomplete='off'>	
			<button type="button" id="searchBtn" onclick="search()" style="border: solid 1px gray; border-radius: 5px; font-size: 10pt; padding: 3px 8px;">조회</button>	
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
		      <td>사용자</td>
		      <td>이미지</td>
		      <td>상품정보</td>
		      <td>수량</td>
		      <td>상품구매금액</td>
		      <td>주문처리상태</td>
		    </tr>
		  </thead>
		  <tbody>
	    	<c:forEach items="${requestScope.orderrSetleListAll}" var ="orderrSetleListAll" varStatus="stat">
		    	<tr>
		    		 <td>${orderrSetleListAll.order_dt}(${orderrSetleListAll.order_no})</td>
		    		 <td>${orderrSetleListAll.name}(${orderrSetleListAll.userid})</td>
				     <td><a href="/product/prodDetail.go?prod_code=${orderrSetleListAll.prod_code}"><img src="/img_prod/${orderrSetleListAll.prod_img_url}" alt="상품사진" width=60px;/></a></td>
				     <td>${orderrSetleListAll.prod_name}</td>
				     <td>${orderrSetleListAll.goods_qy}</td>
				     <td><fmt:formatNumber value="${orderrSetleListAll.tot_amount}" type="number"></fmt:formatNumber>원</td>
				     <td id="status${stat.index}">
				     	<c:choose>
				     		<c:when test="${orderrSetleListAll.status == 'beforedeposit'}">입금전</c:when>
				     		<c:when test="${orderrSetleListAll.status == 'readydelivery'}">배송준비중</c:when>
				     		<c:when test="${orderrSetleListAll.status == 'beingdelivered'}">배송중</c:when>
				     		<c:when test="${orderrSetleListAll.status == 'deliverycompleted'}">배송완료</c:when>
				     		<c:when test="${orderrSetleListAll.status == 'cancel'}">취소</c:when>
				     		<c:when test="${orderrSetleListAll.status == 'exchange'}">교환</c:when>
				     		<c:when test="${orderrSetleListAll.status == 'return'}">환불</c:when>
				     		<c:otherwise>그 외&nbsp;</c:otherwise>
				     	</c:choose>
				     	<button class="changeStatus" type="button" onclick="modal(event,'${orderrSetleListAll.order_no}')">변경</button>			     
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
<div id="modal">
    <button type="button" class="btn btn-primary change"  value="beforedeposit">입금전</button>
	<button type="button" class="btn btn-secondary change" value="readydelivery">배송준비중</button>
	<button type="button" class="btn btn-success change" value="beingdelivered">배송중</button>
	<button type="button" class="btn btn-danger change" value="deliverycompleted">배송완료</button>
	<button type="button" class="btn btn-warning change" value="cancel">취소</button>
	<button type="button" class="btn btn-info change" value="exchange">교환</button>
	<button type="button" class="btn btn-dark change" value="return">환불</button>
    <a class="modal_close_btn btn btn-secondary" id="modal_close_btn">닫기</a>
</div>
<form id="changeStatusFrm" name="changeStatusFrm">
	<input type="hidden" id="order_no" name="order_no" >
	<input type="hidden" id="status" name="status" >
	<input type="hidden" id="parent" name="parent" >
</form>
</section>
<script type="text/javascript">

// 모달로 배송상태 변경창만들기
function modal(event, order_no) {

	var parentId = event.target.parentNode.id;
	
    var zIndex = 9999;
    var modal = document.getElementById('modal');

    // 모달 div 뒤에 희끄무레한 레이어
    var bg = document.createElement('div');
    bg.setStyle({
        position: 'fixed',
        zIndex: zIndex,
        left: '0px',
        top: '0px',
        width: '100%',
        height: '100%',
        overflow: 'auto',
        // 레이어 색갈은 여기서 바꾸면 됨
        backgroundColor: 'rgba(0,0,0,0.4)'
    });
    document.body.append(bg);
    
    // 닫기 버튼 처리, 시꺼먼 레이어와 모달 div 지우기
    modal.querySelector('.modal_close_btn').addEventListener('click', function() {
        bg.remove();
        modal.style.display = 'none';       
    });

    modal.setStyle({
        position: 'fixed',
        display: 'block',
        boxShadow: '0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19)',

        // 시꺼먼 레이어 보다 한칸 위에 보이기
        zIndex: zIndex + 1,

        // div center 정렬
        top: '50%',
        left: '50%',
        transform: 'translate(-50%, -50%)',
        msTransform: 'translate(-50%, -50%)',
        webkitTransform: 'translate(-50%, -50%)'
    });
    var input_order_no = document.querySelector("#order_no");
    input_order_no.value = order_no;
    var parent = document.querySelector("#parent");
    parent.value = parentId;
}

Element.prototype.setStyle = function(styles) {
    for (var k in styles) this.style[k] = styles[k];
    return this;
};

// 모델 버튼 입력시 주문처리상태 변경하기
$(".change").click(function(){
	
	var order_no = $("#order_no").val();
	var status = $(this).val();
	$.ajax({
		url:"/admin/deliverManage.go",
        type:"POST",
        data:{"order_no":order_no, "status":$(this).val()},
        dataType:"json",
        success:function(json){
          	
	    	if(json.success == '1') {
	    		
	    		var id = $("#parent").val();
	    		var statusKR = ''; // 상태 한글명
	    		if(status == 'beforedeposit'){
	    			statusKR = '입금전';
	    			$("#"+id).html(statusKR + "&nbsp;<button class='changeStatus' type='button' onclick='modal(event, "+order_no+")'>변경</button>");	    			
	    		} else if(status == 'readydelivery') {
	    			statusKR = '배송준비중';
	    			$("#"+id).html(statusKR + "&nbsp;<button class='changeStatus' type='button' onclick='modal(event, "+order_no+")'>변경</button>");
	    		} else if(status == 'beingdelivered'){
	    			statusKR = '배송중';
	    			$("#"+id).html(statusKR + "&nbsp;<button class='changeStatus' type='button' onclick='modal(event, "+order_no+")'>변경</button>");
	    		} else if(status == 'deliverycompleted'){
	    			statusKR = '배송완료';
	    			$("#"+id).html(statusKR + "&nbsp;<button class='changeStatus' type='button' onclick='modal(event, "+order_no+")'>변경</button>");
	    		} else if(status == 'cancel'){
	    			statusKR = '취소';
	    			$("#"+id).html(statusKR + "&nbsp;<button class='changeStatus' type='button' onclick='modal(event, "+order_no+")'>변경</button>");
	    		} else if(status == 'exchange'){
	    			statusKR = '교환';
	    			$("#"+id).html(statusKR + "&nbsp;<button class='changeStatus' type='button' onclick='modal(event, "+order_no+")'>변경</button>");
	    		} else if(status == 'return'){
	    			statusKR = '환불';
	    			$("#"+id).html(statusKR + "&nbsp;<button class='changeStatus' type='button' onclick='modal(event, "+order_no+")'>변경</button>");
	    		}	    		
	    			    		
    			$.ajax({
    				url:"/message/sendMessage.go",
    		        type:"POST",
    		        data:{"statusKR":statusKR,
    		        	 "order_no":order_no}, 
    		        dataType:"json",
    		        success:function(json){
    			    	
    			    	if(json.error_count != 0) {
    			    		alert('문자 전송에 실패했습니다.');
    			    	}
    		        },
    		        error: function(request, status, error){
    		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    		         }
    			});	    			
	    		
	    	} else{
	    		alert('변경에 실패했습니다.');
	    	}
        },
        error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
         }
	});
});

//이전 버튼
function fn_prev(currPageNo, range, pageSize) {

	var currPageNo = (range - 1) * pageSize;
	var range = range - 1;

	var url = "/admin/deliverManage.go";
	url = url + "?currPageNo=" + currPageNo;
	url = url + "&range=" + range;
	url = url + "&status=" + $("#status").val();
	url = url + "&fromDate=" + $("#fromDate").val();
	url = url + "&toDate=" + $("#toDate").val();
	url = url + "&searchType=" + $("#searchType").val();
	url = url + "&keyword=" + $("#keyword").val();
	location.href = url;

}

//페이지 번호 클릭

function fn_pagination(currPageNo, range) {

	var url = "/admin/deliverManage.go";
	url = url + "?currPageNo=" + currPageNo;
	url = url + "&range=" + range;
	url = url + "&status=" + $("#status").val();
	url = url + "&fromDate=" + $("#fromDate").val();
	url = url + "&toDate=" + $("#toDate").val();
	url = url + "&searchType=" + $("#searchType").val();
	url = url + "&keyword=" + $("#keyword").val();
	location.href = url;	

}
//다음 버튼 이벤트
function fn_next(currPageNo, range, pageSize) {

	var currPageNo = (range * pageSize) + 1;
	var range = parseInt(range) + 1;	

	var url = "/admin/deliverManage.go";
	url = url + "?currPageNo=" + currPageNo;
	url = url + "&range=" + range;
	url = url + "&status=" + $("#status").val();
	url = url + "&fromDate=" + $("#fromDate").val();
	url = url + "&toDate=" + $("#toDate").val();
	url = url + "&searchType=" + $("#searchType").val();
	url = url + "&keyword=" + $("#keyword").val();
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
	frm.action = '/admin/deliverManage.go';
	
	frm.submit();
}
$(function() {
	
		if("${status}" == ""){
			$("#status").val("all");
		} else {
			$("#status").val("${status}");
		}
		if("${searchType}" == ""){
			$("#searchType").val("all");
		} else {
			$("#searchType").val("${searchType}");
		}
	
		$("#keyword").val("${keyword}");	
		$("#fromDate").val("${fromDate}");
		$("#toDate").val("${toDate}");
					
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
<jsp:include page="/WEB-INF/include/footer_admin.jsp"/>