<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="/css/style.css" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>
<body>

	<form name="idFindFrm">
   
   <ul style="list-style-type: none">
         <li style="margin: 25px 0">
            <label for="userid" style="display: inline-block; width: 90px">성명</label>
            <input type="text" name="name" id="name" size="25" placeholder="홍길동" autocomplete="off" required />
         </li>
         <li style="margin: 25px 0">
            <label for="userid" style="display: inline-block; width: 90px">이메일</label>
            <input type="text" name="email" id="email" size="25" placeholder="abc@def.com" autocomplete="off" required />
         </li>
   </ul>
   
   <div class="my-3">
    <p class="text-center">
       <button type="button" class="btn btn-success" id="btnFind">찾기</button>
    </p>
   </div>
   
   <div class="my-3" id="div_findResult">
        <p class="text-center">
        	<c:if test="${not empty requestScope.userid}">
        		<span style="color: black; font-size: 11pt;">아이디 : ${requestScope.userid}</span> 
        	</c:if>
     	 </p>
   </div>
   
</form>
<script>
$(function(){
	
	$("input#name").val("${requestScope.name}");
	$("input#email").val("${requestScope.email}");
		
	$("button#btnFind").click(function(){
			
		var name = $("input#name").val().trim();
		var email = $("input#email").val().trim();
		if(name == "" || email == ""){
			alert("성명 또는 이메일을 입력해주세요.");
			return;
		}
		
		//이메일 형식 검사.
		var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		var bool = regExp.test(email);
		if(!bool){
			alert("이메일에 맞는 형식을 입력해주세요.");
			return;
		} 
		
		const frm = document.idFindFrm;
		frm.action = "/member/findId.go";
		frm.method = "post";
		frm.submit();
	});
	
	$("input#email").blur(function(){
		// 이메일 정규표현식 확인
		var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		var email = $(this).val().trim();
		if(email == ""){
			showError($(this));
		} else{
			
			var bool = regExp.test(email);
			if(!bool){
				showError($(this));
			} else{
				nextStep($(this));
			}
		} 
	}); // 이메일
});
</script> 
<script type="text/javascript" src="/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 
</body>
</html>