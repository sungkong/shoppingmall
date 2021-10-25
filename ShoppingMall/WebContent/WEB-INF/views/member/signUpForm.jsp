<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/include/header.jsp"/>
<style>
	
   table#tblMemberRegister {
          width: 60%;
          
          /* 선을 숨기는 것 */
          border: hidden;
          
          margin: 10px;
   }  
   
   table#tblMemberRegister #th {
         height: 30px;
         text-align: center;
         font-size: 15pt;
   }
   
   table#tblMemberRegister td {
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
<div class="row" id="divRegisterFrm">
   <div class="col-md-12" align="center">
   <form name="registerFrm">
   
   <table id="tblMemberRegister">
      <thead>
      <tr>
          <%-- 아래의 ${name_scope_request}&nbsp; 은 <c:set var="변수명" value="${값}" scope="" /> 를 테스트 하기 위해서 사용하는 것임. --%> 
           <th colspan="2" id="th">&nbsp;회원가입 (<span style="font-size: 10pt; font-style: italic;"><span class="star">*</span>표시는 필수입력사항</span>)</th>
      </tr>
      </thead>
      <tbody>
      <tr>
         <td style="width: 20%; font-weight: bold;">성명&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;">
             <input type="text" name="name" id="name" class="requiredInfo form-control form-control-sm" /> 
            <span class="error">성명은 한글만 입력 가능합니다.</span>
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">아이디&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;">
             <input type="text" name="userid" id="userid" class="requiredInfo form-control form-control-sm" />&nbsp;&nbsp;
             <!-- 아이디중복체크 -->
    	     <span id="idcheck" style="display: inline-block; width: 80px; height: 30px; border: solid 1px gray; border-radius: 5px; font-size: 8pt; text-align: center; margin-left: 10px; cursor: pointer;">아이디중복확인</span> 
             <span id="idcheckResult"></span>
             <span class="error">아이디는 영어소문자, 숫자가 혼합된 3~15 글자로 입력하세요.</span>
         </td> 
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">비밀번호&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;"><input type="password" name="pwd" id="pwd" class="requiredInfo form-control form-control-sm" />
            <span class="error">암호는 영문자,숫자,특수기호가 혼합된 8~15 글자로 입력하세요.</span>
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">비밀번호확인&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;"><input type="password" id="pwdcheck" class="requiredInfo form-control form-control-sm" /> 
            <span class="error">암호가 일치하지 않습니다.</span>
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">이메일&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;"><input type="text" name="email" id="email" class="requiredInfo form-control form-control-sm" placeholder="abc@def.com" /> 
             <span class="error">이메일 형식에 맞지 않습니다.</span>
             
             <%-- ==== 퀴즈 시작 ==== --%>
             <span style="display: inline-block; width: 80px; height: 30px; border: solid 1px gray; border-radius: 5px; font-size: 8pt; text-align: center; margin-left: 10px; cursor: pointer;" onclick="isExistEmailCheck();">이메일중복확인</span> 
             <span id="emailCheckResult"></span>
             <%-- ==== 퀴즈 끝 ==== --%>
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">연락처</td>
         <td style="width: 80%; text-align: left;">
             <input class="requiredInfo form-control form-control-sm2" type="text" id="hp1" name="hp1" size="6" maxlength="3" value="010" readonly />&nbsp;-&nbsp;
             <input class="requiredInfo form-control form-control-sm2" type="text" id="hp2" name="hp2" size="6" maxlength="4" />&nbsp;-&nbsp;
             <input class="requiredInfo form-control form-control-sm2" type="text" id="hp3" name="hp3" size="6" maxlength="4" />
             <span class="error">휴대폰 형식이 아닙니다.</span>
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">성별</td>
         <td style="width: 80%; text-align: left;">
            <input type="radio" id="male" name="gender" value="1" /><label for="male" style="margin-left: 2%;">남자</label>
            <input type="radio" id="female" name="gender" value="2" style="margin-left: 10%;" /><label for="female" style="margin-left: 2%;">여자</label>
         </td>
      </tr>
      
      <tr>
         <td style="width: 20%; font-weight: bold;">생년월일</td>
         <td style="width: 80%; text-align: left;">
            <input type="number" id="birthyyyy" name="birthyyyy" min="1950" max="2050" step="1" value="1995" style="width: 80px;" required />
            
            <select id="birthmm" name="birthmm" style="margin-left: 2%; width: 60px; padding: 8px;">
               
            </select> 
            
            <select id="birthdd" name="birthdd" style="margin-left: 2%; width: 60px; padding: 8px;">
               <%-- 
              
               <option value ="31">31</option>
               --%>
            </select> 
         </td>
      </tr>
      
    
      
    
         
      <tr>
         <td colspan="2">
            <label for="agree">[필수]이용약관에 동의합니다</label>&nbsp;&nbsp;<input type="checkbox" id="agree" />
         </td>
      </tr>
      <tr>
         <td colspan="2" style="text-align: center; vertical-align: middle;">
            <iframe src="/iframe/agree.html" width="85%" height="150px" class="box" ></iframe>
         </td>
      </tr>
      <tr>
         <td colspan="2" style="line-height: 90px;" class="text-center">
            <!-- 
            <button type="button" id="btnRegister" style="background-image:url('/images/join.png'); border:none; width: 135px; height: 34px;" onClick="goRegister();"></button> 
             -->
            <button type="button" id="btnRegister" class="btn btn-dark btn-lg" onClick="goRegister();">가입하기</button>
         </td>
      </tr>
      </tbody>
   </table>
   </form>
   </div>
</div>
<script>
var b_flagIdDuplicateClick = false;
var b_flagEmailDuplicateClick = false;

function isExistEmailCheck(){
	 
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
// 이메일 수정시 중복확인 초기화 
$("#email").on("propertychange change keyup paste input", function(){
	b_flagEmailDuplicateClick = false;
});  

function goRegister(){
	
	var arr_requiredInfo = document.getElementsByClassName("requiredInfo");
	
	var boolFlag = false;
	for(var i=0; i<arr_requiredInfo.length; i++){
		var value = arr_requiredInfo[i].value;
		if(value == "" || value == null){
			alert("필수사항 입력");
			boolFlag = true;
			break;
		}
	}
	if(boolFlag) return false;
	
	
	var radioCheckedLength = $("input:radio[name=gender]:checked").length;
	
	if(radioCheckedLength == 0){
		alert("성별 입력하세요!");
		return false;
	}
		
	if(!$('#agree').is(':checked')){
		alert("이용약관에 동의하세요");
		return false;
	}
	
	if(!b_flagIdDuplicateClick){
		alert("아이디 중복확인을 하십시오.")
		$("#idcheck").focus();
		return;
	}
	if(!b_flagEmailDuplicateClick){
		alert("이메일 중복확인을 하십시오.")
		return;
	}
	
	var frm = document.registerFrm;
	frm.action = "/member/signUp.go";
	frm.method = "post";
	frm.submit();
}

function showError(event){
	
	$("table#tblMemberRegister :input").prop("disabled", true);
	$(event).prop("disabled", false);
	
	$(event).parent().find(".error").show();
	$(event).focus();
}

function nextStep(event){
	$("table#tblMemberRegister :input").prop("disabled", false);
	$(event).parent().find(".error").hide();
}

$(function(){
		$("span.error").hide();
		$("input#name").focus();
		
		$("input#name").blur(function(){			
			var name = $(this).val().trim();
			if(name == ""){
				showError($(this));
			} else{
				var regExp = /^[가-힣]+$/
				var bool = regExp.test(name);
				if(!bool){
					showError($(this));
				} else{
					nextStep($(this));
				}
			} 
		}); 
		
		$("input#userid").blur(function(){
			var userid = $(this).val().trim();
			if(userid == ""){
				// 입력하지 않거나 공백인 경우
				showError($(this));
			} else{
				var regExp = /^[a-z0-9+]{3,15}$/;
				var bool = regExp.test(userid);
				if(!bool){
					showError($(this));
				} else{
					nextStep($(this));
				}
			} 
		}); // ID체킹
		
		$("input#pwd").blur(function(){
			// 숫자/문자/특수문자/ 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
			var regExp = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
			var pwd = $(this).val().trim();
			if(pwd == ""){
				// 입력하지 않거나 공백인 경우
				showError($(this));
				
			} else{
				
				var bool = regExp.test(pwd);
				if(!bool){
					showError($(this));
				} else{
					nextStep($(this));
				}
			} 
		}); // 비번 체킹
		
		$("input#pwdcheck").blur(function(){
			
			var pwd = $("input#pwd").val();
			var pwdcheck = $(this).val().trim();
			
			if(pwd != pwdcheck){
				showError($(this));
			} else{
				nextStep($(this));
			}
			
		}); // 비번확인 체킹
		
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
		
		
	      // 생년월일 입력항목 생성
	      var mmhtml = "";
	      for(var i=1; i<=12; i++){
	    	  if(i<10){
	    		  mmhtml += "<option>0"+i+"</option>";
	    	  } else{
	    		  mmhtml += "<option>"+i+"</option>";
	    	  }
	      }
	      $("select#birthmm").html(mmhtml);
	      
	      var ddhtml = "";
	      for(var i=1; i<=31; i++){
	    	  if(i<10){
	    		  ddhtml += "<option>0"+i+"</option>";
	    	  } else{
	    		  ddhtml += "<option>"+i+"</option>";
	    	  }
	      }
	      $("select#birthdd").html(ddhtml);
		 
	      $("#idcheck").click(function(){
	    	  console.log('아이디 중복 검사');
	    	  $.ajax({
					type : "post",
					url : '/member/idDuplicateCheck.go',
					data : {"userid":$("input#userid").val()},
					dataType:"json",
					success : function(json){
				
						if(json.idExists){
							// 중복인 경우
							$("span#idcheckResult").html( $("input#userid").val() + " 은 이미 사용중입니다.").css("color", "orange");
							b_flagIdDuplicateClick = false; // 중복 체크 초기화
						} else{
							$("span#idcheckResult").html("사용가능합니다.").css("color", "green");
							b_flagIdDuplicateClick = true;
							currentId = $("input#userid").val();
						}						
					},
					error: function(request, status, error){
		                   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		                }
				});
	      });
	      // 아이디 수정시 중복확인 초기화 
	    	$("#userid").on("propertychange change keyup paste input", function(){
	    		b_flagIdDuplicateClick = false;
	    	});     	
	});
</script>
<jsp:include page="/WEB-INF/include/footer.jsp"/>