<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="/css/style.css" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<style>
   #div_pwd {
      width: 70%;
      height: 15%;
      margin-bottom: 5%;
      margin-left: 10%;
      position: relative;
   }
   
   #div_pwd2 {
      width: 70%;
      height: 15%;
      margin-bottom: 5%;
      margin-left: 10%;
      position: relative;
   }
   
   #div_updateResult {
      width: 90%;
      height: 15%;
      margin-bottom: 5%;
      margin-left: 10%;      
      position: relative;
   }
   
   #div_btnUpdate {
      width: 70%;
      height: 15%;
      margin-bottom: 5%;
      margin-left: 10%;
      position: relative;
   }
</style>
</head>
<body>
<div id="div_pwdFrm">
<form name="pwdUpdateEndFrm" id="pwdUpdateEndFrm" action="/member/updatePw.go" method="post">
   <div id="div_pwd" align="center">
      <span style="color: blue; font-size: 12pt;">새암호</span><br/> 
      <input type="password" name="pwd" id="pwd" size="25" placeholder="PASSWORD" required />
   </div>
   
   <div id="div_pwd2" align="center">
        <span style="color: blue; font-size: 12pt;">새암호확인</span><br/>
      <input type="password" id="pwd2" size="25" placeholder="PASSWORD" required />
   </div>
   
   <input type="hidden" name="userid" value="${userid}" />
   <div id="div_btnUpdate" align="center">
       <button type="button" class="btn btn-success" id="btnUpdate">암호변경하기</button>
   </div>
</form>
</div>
<div>
	<span id="success">비밀번호가 변경되었습니다. 창을 닫아주세요.</span>
</div>
<script>
$(function(){
	
	$("#success").hide();
	
    $("#btnUpdate").click(function(){
    	var pwd = $("input#pwd").val().trim();
   	    var pwd2 = $("input#pwd2").val().trim();
   	    var regExp = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
   	    // 숫자/문자/특수문자/ 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
   	    var bool = regExp.test(pwd);	
        if(!bool){
        	
        	alert("암호는 8글자 이상 15글자 이하에 영문자,숫자,특수기호가 혼합되어야만 합니다.");
            $("input#pwd").val("");
            $("input#pwd2").val("");
            return;
            
        } else {
        	
        	if(pwd != pwd2){
    			alert("비밀번호를 확인해주세요");
    			return;
    		}
        	
        	$.ajax({
				type : "post",
				url : "/member/updatePw.go",
				data : $("#pwdUpdateEndFrm").serialize(),
				dataType:"json",
				success : function(json){						
					if(json.success == '1'){
						alert('비밀번호가 재설정 되었습니다.');
						$("#div_pwdFrm").hide();
						$("#success").show();
					} else {
						alert('비밀번호 변경이 실패하였습니다. 다시 확인하세요');						
					}
					
				},
				error : function(){
					alert("에러가 발생했습니다. 관리자에게 문의 바랍니다.");
				},
			});
        }
    });
  
});
</script>
<script type="text/javascript" src="/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 
</body>
</html>