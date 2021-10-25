<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/include/header_admin.jsp"/>
<link rel="stylesheet" type="text/css" href="/css/mypage/mypageStyle.css" />
<title>주문내역 조회</title>
<style type="text/css">
input[type="number"]::-webkit-outer-spin-button,
input[type="number"]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
.form-control {
   		width:100px;
   		height:30px;
}
section{
 	width : 70%;
 	margin-left : 300px;
 	margin-top : 100px;
 }
</style>
<section>	
<div class="container p-5" >
     <form id="deliverFeeFrm" name="deliverFeeFrm" action="/admin/deliverFee.go" method="post">
     	<p>배송비</p>
     	<input class="form-control" type="number" id="fee" name="fee"/>
     	<p>배송비 무료금액 범위 설정</p>
     	<input class="form-control" type="number" id="freeline" name="freeline"/>
     </form>
     <br>
     <br>
     <button type="button" class="btn btn-secondary" id="btn" name="btn">변경</button>
</div>
</section>
<script type="text/javascript">
$(function(){
	$("#fee").val("${deliverFee.fee}");
	$("#freeline").val("${deliverFee.freeline}");
});

$("#btn").click(function(){
	
	var fee = $("#fee").val().trim();
	var freeline = $("#freeline").val().trim();
	

	if(fee == "" || freeline == ""){
		alert("입력란을 확인해주세요. 공백이 입력되면 안됩니다.")
		return;
	}
	var regex = /[0-9]/g;
	if(regex.test(fee) && regex.test(freeline)){
		
		$("#deliverFeeFrm").submit();
		
	} else {
		alert('숫자만 입력 가능합니다.');
		return;
	}
});
</script>
<jsp:include page="/WEB-INF/include/footer_admin.jsp"/>