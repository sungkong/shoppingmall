<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
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

<form name="pwdFindFrm" id="pwdFindFrm"> 
	<div id="div_PwdFindFrm">
	   <ul style="list-style-type: none">
	         <li style="margin: 25px 0">
	            <label for="userid" style="display: inline-block; width: 90px">아이디</label>
	            <input type="text" name="userid" id="userid" size="25" placeholder="ID" autocomplete="off" required />
	         </li>
	         <li style="margin: 25px 0">
	            <label for="userid" style="display: inline-block; width: 90px">이메일</label>
	            <input type="text" name="email" id="email" size="25" placeholder="abc@def.com" autocomplete="off" required />
	         </li>
	   </ul>
	</div>   
   <div class="my-3" id="div_btnFind">
        <p class="text-center">
           <button type="button" class="btn btn-success" id="btnFind">찾기</button>
        </p>   
   </div>
   
   <div class="my-3" id="div_findResult">
        <p class="text-center">         
            <span style="font-size: 10pt;">인증코드를 입력해주세요.</span><br>
            <input type="text" name="input_confirmCode" id="input_confirmCode" required />
            <br><br>
            <button type="button" class="btn btn-info" id="btnConfirmCode">인증하기</button>      
      </p>
   </div>
</form>

<form name="verifyCertificationFrm">
	<input type="hidden" name ="userid" id="useridV" value =""/>
	<input type="hidden" name ="userCertificationCode" id="userCertificationCode"/>
</form>
<script>
$(function(){

	$("div#div_findResult").hide();
	/* var method = "${requestScope.method}";
	
	if(method == "GET" || method == "get"){
		$("div#div_findResult").hide();
	} else {
		$("input#userid").val("${requestScope.userid}");
		$("input#email").val("${requestScope.email}");
		$("div#div_findResult").show();
		
		if(${requestScope.sendMailSuccess == true}){
			$("div#div_btnFind").hide();
		} else{
			
		}
	} */
		
	$("button#btnFind").click(function(){
		
		var useridVal = $("input#userid").val().trim();
		var emailVal = $("input#email").val().trim();
		
		if(useridVal != "" && emailVal != ""){
			
			// 이메일 형식 검사
			var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			var bool = regExp.test(emailVal);
			if(!bool){
				alert("이메일에 맞는 형식을 입력해주세요.");
				return;
			} else {
				
				$.ajax({
					type : "post",
					url : "/member/findPw.go",
					data : $("#pwdFindFrm").serialize(),
					dataType:"json",
					success : function(json){						
						if(json.result != '0'){
							alert('이메일로 인증코드가 발송되었습니다.');		
							$("#div_PwdFindFrm").hide();
							$("#div_btnFind").hide();
							$("div#div_findResult").show();
							$("#useridV").val("${sessionScope.userid}");
						} else {
							alert('일치하는 계정이없습니다.');						
						}
					
					},
					error : function(request,status,error){
						//alert("인증에 실패하였습니다.");
						alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					}
				});
			}
		} else{
			alert("아이디와 이메일 입력하세요");
			return;
		}
	});
	$("#btnConfirmCode").click(function(){
		
		var frm = document.verifyCertificationFrm;
		frm.userCertificationCode.value = $("input#input_confirmCode").val();
		
		frm.action = "/member/verifyCertification.go";
		frm.method = "POST";
		frm.submit();		
	});
	
	
});
</script> 
<script type="text/javascript" src="/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script>
</body>
</html>
