<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>로그인</title>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- Optional JavaScript -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<style>
body {
	 width: 600px;
	 margin: 0 auto;
	 font-family: Noto Sans KR,sans-serif!important;
	 padding: 0 70px;
}

.shopname img{
    display: block;
 	margin : 0 auto;
 	margin-top : 50px;
}
.contents{
  	position: relative;
    width: 100%;
    padding: 36px 0;
}
.title{
	margin: 0 0 20px;
    font-size: 24px;
    font-weight: bold;
    
}
.text{
	margin-bottom: 24px;
    font-size: 16px;
    font-weight: lighter;
}
.btn {
	margin-top: 10px;
    padding: 0;
    display: inline-block;
    width: 100%;
    height: 45px;
    line-height: 45px;
    border: 1px;
    border-radius: 5px;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    font-size: 12px;
    font-weight: 700;
    text-align: center;
    cursor: pointer;
    
}
.btnkakao{
	margin-top: 12px;
    padding: 0 0 0 20px;
    height: 60px;
    line-height: 60px;
    background-color: #fee500;
    font-size: 15px;
    color: #111;
    background-image: url(//storage.keepgrow.com/admin/campaign/20200611043456590.svg);
    background-repeat: no-repeat;
    background-size: 18px;
    background-position: 15px;
}
  .inputbox{
  	border: 1px solid #e1e1e1;
    border-radius: 5px;
    overflow: hidden;
  }
  .inputbox input{
    padding: 0 15px;
    width: 100%;
    height: 50px;
    line-height: 50px;
    border: none;
    font-size: 14px;
    color: #000;
    box-sizing: border-box;
  }
      
  
  .logincheckbox{
  	margin: 15px 0;
  }
  .loginBtn{
  	padding: 0;
    display: inline-block;
    line-height: 45px;
    border: 1px;
    border-radius: 5px;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    font-size: 12px;
    font-weight: 700;
    text-align: center;
    cursor: pointer;
    
    background: #31363d;
    font-size: 15px;
    color: #fff;
  }
  .utilmenu{
  	float: inherit;
    margin: 24px 0 0;
    border: none;
  }
  .utilmenu a{
    font-size: 12px;
    font-weight: lighter;
    color: #222;
  }
  .after{
    text-align : center;
    padding: 0 10px;
    font-size: 12px;
    color: #b2b2b2;
}
.footer{
    border: none;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
}
.ment{
    padding: 24px 0 10px;
    border-top: 2px solid #333;
    font-size: 14px;
}

  
</style>

    
<!-- Custom styles for this template -->
</head>
<body>
<div class="main">
	<div class="header">
		<h1 class="shopname">
			<a href="/"><img src="/images/소떡로고2.png"></a>
		</h1>
	</div>
	<div class="section">
		<div class="contents">
			<h2 class="title">로그인</h2>
			<p class="text">
				아이디와 비밀번호 입력하기 귀찮으시죠?
				<br>
				카카오로 1초 만에 로그인 하세요.
			</p>	
			<a class="btn btnkakao" id="kakao-login-btn" style="text-align:center;" href="javascript:kakaoLogin()">카카오 1초 로그인/회원가입</a>
		</div>
	</div>
	<p class="after">또는</p>
	<div class="banner">
		<img src="/images/login/loginCoupon.jpg" alt="banner">
	</div>
		<div id="loginForm" style="margin-bottom: 30px;">
			<div class="inputbox">
				<form name="loginFrm">
					<input type="text" class="form-control" id="userid" name="userid"autocomplete="off" placeholder="Id">
					<input type="password" class="form-control" id="pwd" name="pwd" placeholder="Password">
				</form>
			</div>
			<div class="logincheckbox">
				<label style="font-size : 10px;">
		      	  <input type="checkbox" id="saveid"> 아이디 저장
		        </label>
			</div>
			<button class="btn loginBtn" onclick="goLogin()">로그인</button>
			<div class="utilmenu">
				<a style="cursor: pointer;" data-toggle="modal" data-target="#userIdfind" data-dismiss="modal">아이디 찾기</a> /
                <a style="cursor: pointer;" data-toggle="modal" data-target="#passwdFind" data-dismiss="modal" data-backdrop="static">비밀번호 찾기</a>
				<a href="/member/signUp.go" style="float: right;">가입하기</a>
			</div>
		</div>
	<div class="footer">
		<div class="ment">
          <b>카카오 1초 로그인/회원가입 이란?</b>
          <br>
          카카오 싱크를 활용한 간편 로그인/가입 기능입니다.
        </div>
	</div>
</div>

<%-- ****** 아이디 찾기 Modal ****** --%>
  <div class="modal fade" id="userIdfind">
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal header -->
        <div class="modal-header">
          <h4 class="modal-title">아이디 찾기</h4>
          <button type="button" class="close myclose" data-dismiss="modal">&times;</button>
        </div>
        <!-- Modal body -->
        <div class="modal-body">
          <div id="idFind">
             <iframe style="border: none; width: 100%; height: 350px;" src="/member/findId.go">
             </iframe>
          </div>
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-danger myclose" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div>

  <%-- ****** 비밀번호 찾기 Modal ****** --%>
  <div class="modal fade" id="passwdFind">
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal header -->
        <div class="modal-header">
          <h4 class="modal-title">비밀번호 찾기</h4>
          <button type="button" class="close myclose" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
          <div id="pwFind">
             <iframe style="border: none; width: 100%; height: 350px;" src="/member/findPw.go">  
             </iframe>
          </div>
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-danger myclose" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div>
<script>

$(function(){
	
	// 아이디저장 체크 유무
	const saveid = localStorage.getItem("saveid");
	if(saveid != null){
		$("input#userid").val(saveid);
		$("input:checkbox[id=saveid]").prop('checked', true);
	}
			
	$("input#pwd").bind("keyup", function(event){
		if(event.keyCode == 13) { // 키보드로 엔터를 입력했을 경우
			goLogin();
		}
	});
	// 카카오 초기화
	Kakao.init('825e56e17bd334ca86670e481b45954e');
});

function kakaoLogin() {
	
    Kakao.Auth.login({
        success: function(response) {
            Kakao.API.request({ // 사용자 정보 가져오기 
                url: '/v2/user/me',
                success: (response) => {               
                    $.ajax({
    					type : "post",
    					url : '/member/idDuplicateCheck.go',
    					data : {"userid":response.id+"K"},
    					dataType:"json",
    					success : function(json){   				
    						if(json.idExists){
    							// 존재하는 경우 로그인 처리
    							var frm = document.createElement('form');
    							frm.setAttribute('method', 'post');
    							frm.setAttribute('action', '/member/kakaoLogin.go');
    							var hiddenInput = document.createElement('input');
    							hiddenInput.setAttribute('type','hidden');
    							hiddenInput.setAttribute('name','userid');
    							hiddenInput.setAttribute('value',response.id+"K");
    							frm.appendChild(hiddenInput);
    							document.body.appendChild(frm);
    							frm.submit(); 
    							
    						} else{
    							// 회원가입
    							$.ajax({
    								type : "post",
    		    					url : '/member/kakaoSignUp.go',
    		    					data : {"userid":response.id+"K",
    		    						    "name":response.properties.nickname,
    		    						    "email":response.kakao_account.email},
    		    					dataType :"json",
    		    					success : function(json){
    		    						if(json.success){
    		    							// 로그인
    		    							var frm = document.createElement('form');
    		    							frm.setAttribute('method', 'post');
    		    							frm.setAttribute('action', '/member/kakaoLogin.go');
    		    							var hiddenInput = document.createElement('input');
    		    							hiddenInput.setAttribute('type','hidden');
    		    							hiddenInput.setAttribute('name','userid');
    		    							hiddenInput.setAttribute('value',response.id+"K");
    		    							frm.appendChild(hiddenInput);
    		    							document.body.appendChild(frm);
    		    							frm.submit(); 		    							
    		    						} else {
    		    							alert('카카오 회원가입 실패. 일반계정으로 로그인하시기 바랍니다.');
    		    						}
    		    					},
    		    					error: function(request, status, error){
    		    		                   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    		    		                }
    							});
    						}						
    					},
    					error: function(request, status, error){
    		                   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    		                }
    				});
                }
            });
            // window.location.href='/ex/kakao_login.html' //리다이렉트 되는 코드
        },
        fail: function(error) {
            alert(error);
        }
    });
}

function goLogin(){
	
	const loginUserid = $("input#userid").val().trim();
	const loginPwd = $("input#pwd").val().trim();
	
	if(loginUserid == ""){
		alert("아이디를 입력하세요");
		$("input#userid").val("");
		$("input#userid").focus();
		return;
	}
	if(loginPwd == ""){
		alert("비밀번호를 입력하세요");
		$("input#pwd").val("");
		$("input#pwd").focus();
		return;
	}
	
	var frm = document.loginFrm;
	
	if($("input:checkbox[id=saveid]").prop("checked")){
		localStorage.setItem("saveid", loginUserid);
	} else {
		localStorage.clear();
	}
	frm.action = "/member/login.go",
	frm.method = "post";
	frm.submit();
	
}



	

</script>
</body>
</html>
