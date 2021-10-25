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
<div id="sms" align="left">
        <span id="smsTitle">&gt;&gt;휴대폰 SMS(문자) 보내기 내용 설정&lt;&lt;</span>
        <div style="margin: 10px 0 20px 0"></div>
        <form id="frm" name="frm" action="/admin/messageManage.go" method="post">
        	<textarea rows="6" cols="50" class="smsContent" id="smsContent" name="smsContent"></textarea>&nbsp;<span id="checkLength">(0 / 최대 200자)</span>
        </form>
        <button type="button" id="btnSend">저장</button>
</div>
</section>
<script type="text/javascript">
$(function(){

	$("#smsContent").val("${smsContent}");	
	$('#checkLength').text("(" + $("#smsContent").val().length + "/ 150자)");
	
	$("#smsContent").keyup(function(e) {
	  
		var content = $(this).val();
		$("#checkLength").text("(" + content.length + "/ 150자)"); //실시간 글자수 카운팅
		if (content.length > 200) {
			alert("최대 200자까지 입력 가능합니다.");
			$(this).val(content.substring(0, 200));
			$('#checkLength').text("(200 / 최대 150자)");
		}
	});
	$("#btnSend").click(()=>{ $("#frm").submit(); })
});

</script>
<jsp:include page="/WEB-INF/include/footer_admin.jsp"/>