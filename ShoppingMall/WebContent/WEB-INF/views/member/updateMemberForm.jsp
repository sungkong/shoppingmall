<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/include/header.jsp"/>
<jsp:include page="/WEB-INF/views/mypage/navbar.jsp"/>

<link rel="stylesheet" type="text/css" href="/css/mypage/mypageStyle.css" />

<style>
table#tblMemberUpdate {
       width: 60%;
     
       /* 선을 숨기는 것 */
       border: hidden;
       
       margin: 10px;
}  

table#tblMemberUpdate #th {
      height: 30px;
      text-align: center;
      font-size: 15pt;
}

table#tblMemberUpdate td {
      /* border: solid 1px gray;  */
      line-height: 30px;
      padding-top: 8px;
      padding-bottom: 8px;
}

.star { color: red;
        font-weight: bold;
        font-size: 13pt;
}
.form-control-sm {
		width:200px;
		height:30px;
		display:inline;
}
.form-control-sm2 {
		width:100px;
		height:30px;
		display:inline;
}
</style>
<div class="row" id="updateFrm">
   <div class="col-md-12" align="center">
   <form name="updateFrm">
   
   <table id="tblMemberUpdate">
      <thead>
      <tr>
          <%-- 아래의 ${name_scope_request}&nbsp; 은 <c:set var="변수명" value="${값}" scope="" /> 를 테스트 하기 위해서 사용하는 것임. --%> 
           <th colspan="2" id="th">&nbsp;회원정보 수정</th>
      </tr>
      </thead>
      <tbody>
      <tr>
         <td style="width: 20%; font-weight: bold;">성명&nbsp;</td>
         <td style="width: 80%; text-align: left;">
             <input type="text" name="name" id="name" class="requiredInfo form-control form-control-sm" value="${sessionScope.loginuser.name}" readonly/> 
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">아이디&nbsp;</td>
         <td style="width: 80%; text-align: left;">
             <input type="text" name="userid" id="userid" class="requiredInfo form-control form-control-sm" value="${sessionScope.loginuser.userid}" readonly />&nbsp;&nbsp;
         </td> 
      </tr>
      <c:choose>
      <c:when test="${sessionScope.loginuser.loginType == 'normal'}">     
	      <tr>
	         <td style="width: 20%; font-weight: bold;">비밀번호&nbsp;</td>
	         <td style="width: 80%; text-align: left;"><input type="password" name="pwd" id="pwd" class="requiredInfo form-control form-control-sm" />
	         	<span>(숫자/문자/특수문자/ 포함 형태의 8~15자리 이내)</span>
	         </td>
	      </tr>
	      <tr>
	         <td style="width: 20%; font-weight: bold;">비밀번호확인&nbsp;</td>
	         <td style="width: 80%; text-align: left;"><input type="password" id="pwdcheck" class="requiredInfo form-control form-control-sm" /> 
	            <span class="error">암호가 일치하지 않습니다.</span>
	         </td>
	      </tr>
	      <tr>
	         <td style="width: 20%; font-weight: bold;">이메일&nbsp;</td>
	         <td style="width: 80%; text-align: left;"><input type="text" name="email" id="email" class="requiredInfo form-control form-control-sm" value="${sessionScope.loginuser.email}" /> 
	             <span class="error">이메일 형식에 맞지 않습니다.</span>           
	             <button type="button" id="emailCheck" style="display: inline-block; width: 100px; height: 30px; border: solid 1px gray; border-radius: 5px; font-size: 8pt; text-align: center; margin-left: 10px; cursor: pointer;" onclick="isExistEmailCheck();">이메일중복확인</button> 
	             <span id="emailCheckResult"></span>
	         </td>
      	 </tr>
	  </c:when>
	  <c:otherwise>
	  	  <tr>
	         <td style="width: 20%; font-weight: bold;">비밀번호&nbsp;</td>
	         <td style="width: 80%; text-align: left;"><input type="password" name="pwd" id="pwd" class="form-control form-control-sm" disabled/>
	         	<span>(카카오 계정은 비밀번호를 변경할 수 없습니다.)</span>
	         </td>
	      </tr>	      
	      <tr>
         <td style="width: 20%; font-weight: bold;">이메일&nbsp;</td>
         <td style="width: 80%; text-align: left;"><input type="text" name="email" id="email" class="requiredInfo form-control form-control-sm" value="${sessionScope.loginuser.email}" disabled/>
         (카카오 사용자는 이메일을 변경할 수 없습니다.)                           
         </td>
      	 </tr>
	  </c:otherwise>     
      </c:choose>    
      <tr>
         <td style="width: 20%; font-weight: bold;">연락처</td>
         <td style="width: 80%; text-align: left;">
             <input class="requiredInfo form-control form-control-sm2" type="text" id="hp1" name="hp1" size="6" maxlength="3" value="010" readonly />&nbsp;-&nbsp;
             <input class="requiredInfo form-control form-control-sm2" type="text" id="hp2" name="hp2" size="6" maxlength="4" value="${fn:substring(sessionScope.loginuser.mobile, 3, 7)}"/>&nbsp;-&nbsp;
             <input class="requiredInfo form-control form-control-sm2" type="text" id="hp3" name="hp3" size="6" maxlength="4" value="${fn:substring(sessionScope.loginuser.mobile, 7, 11)}" />
             <span class="error">휴대폰 형식이 아닙니다.</span>
         </td>
      </tr>
      <tr>
         <td colspan="2" style="line-height: 90px;" class="text-center">
            <button type="button" id="btnUpdate" class="btn btn-dark btn-lg mt-3" onClick="goUpdate()">수정하기</button>
            <button type="button" class="btn btn-dark btn-lg mt-3" onClick="javascript:history.back()">이전</button>
         </td>
      </tr>
      </tbody>
   </table>
   </form>
   </div>
</div>
<script>

var b_flagEmailDuplicateClick = true; // 이메일 중복검사
var pwdCheck = false; // 비밀번호 검사
var pwdConfirmCheck = false; // 비밀번호 확인 검사

function isExistEmailCheck(){
	
	if($("#email").val() == '${sessionScope.loginuser.email}'){
		b_flagEmailDuplicateClick = true;
		return;
	}
	 
  	  $.ajax({
				type : "post",
				url : '/member/emailDuplicateCheck.go',
				data : {"email":$("input#email").val()},
				dataType:"json",
				success : function(json){
			
					if(json.emailExists){
						// 중복인 경우
						$("span#emailCheckResult").html( $("input#email").val() + " 은 이미 사용중입니다.").css("color", "orange");
						$("input#email").val()
						b_flagEmailDuplicateClick = false; // 중복 체크 초기화
					} else{
						$("span#emailCheckResult").html("사용가능합니다.").css("color", "green");
						b_flagEmailDuplicateClick = true;
					}
				},
				error: function(request, status, error){
	                   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	                }
			});
   
}
function goUpdate(){
	
	var pwd = $("input#pwd").val().trim();
	if(pwd == ""){
		pwdCheck = true;
		pwdConfirmCheck = true;
	}
	
	if(!b_flagEmailDuplicateClick){
		alert("이메일 중복확인을 하십시오.")
		return;
	}
	
	if(pwdCheck == false || pwdConfirmCheck == false){
		alert("비밀번호 및 비밀번호확인을 확인하시기 바랍니다.");
		return;
	}
	
	var frm = document.updateFrm;
	frm.action = "/member/updateMember.go";
	frm.method = "post";
	frm.submit();
}

function showError(event){
	
	$(event).parent().find(".error").show();
	
}

function nextStep(event){

	$(event).parent().find(".error").hide();
}

$(function(){
	
	$("span.error").hide();
	
	$("input#pwd").blur(function(){
		
		// 숫자/문자/특수문자/ 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
		var regExp = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
		var pwd = $(this).val().trim();
		
		var bool = regExp.test(pwd);
		if(!bool){
			pwdCheck = false;
		} else{
			pwdCheck = true;
		}
		
	});
		$("input#pwdcheck").blur(function(){
			
			var pwd = $("input#pwd").val();
			var pwdcheck = $(this).val().trim();
			
			if(pwd != pwdcheck){
				showError($(this));
				pwdConfirmCheck = false;
			} else{
				nextStep($(this));
				pwdConfirmCheck = true;
			}
			
		}); // 비번확인 체킹
		
		$("input#email").blur(function(){
			// 이메일 정규표현식 확인
			emailCheck();
		}); // 이메일
		
		
		
		$("input#hp2").blur(function(){
			// 숫자 4자리만 들어오도록 검사해주는 정규표현식
			var regExp = /^[1-9][0-9]{3}$/i;
			var hp2 = $(this).val().trim();
			if(hp2 == ""){
				showError($(this));			
			} else{
				
				var bool = regExp.test(hp2);
				if(!bool){
					showError($(this));
				} else{
					nextStep($(this));
				}
			} 
		}); // 핸드폰 중간
		
		$("input#hp3").blur(function(){
			// 숫자 4자리만 들어오도록 검사해주는 정규표현식
			var regExp = /^\d{4}$/i;
			var hp3 = $(this).val().trim();
			if(hp3 == ""){
				showError($(this));
			} else{
				
				var bool = regExp.test(hp3);
				if(!bool){
					showError($(this));
				} else{
					nextStep($(this));
				}
			} 
		}); // 핸드폰 마지막
	   	
});

//이메일 수정시 중복확인 초기화 [기존과 동일한 경우 스킵]
$("#email").on("propertychange change keyup paste input", function(){
	
	if($("#email").val() == '${sessionScope.loginuser.email}'){
		b_flagEmailDuplicateClick = true;
		return false;;
	}
	b_flagEmailDuplicateClick = false;
	emailCheck();	
	
});

function emailCheck(){
		
	var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	var email = $("#email").val().trim();
	if(email == ""){
		showError(this);
		b_flagEmailDuplicateClick = false;
		$("#emailCheck").attr("disabled",true);
	} else{
		
		var bool = regExp.test(email);
		if(!bool){
			showError($("#email"));
			b_flagEmailDuplicateClick = false;
			$("#emailCheck").attr("disabled",true);
		} else{
			nextStep($("#email"));
			$("#emailCheck").attr("disabled",false);
		}
	} 
	
}	
</script>
<jsp:include page="/WEB-INF/include/footer.jsp"/>