<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 
<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="/css/style.css" />
<!-- jquery UI -->
<link rel="stylesheet" type="text/css" href="/jquery-ui-1.12.1.custom/jquery-ui.css" />
<script type="text/javascript" src="/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<!-- Optional JavaScript -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<title>Insert title here</title>
<style type="text/css">

   div#mvoInfo {
      width: 60%; 
      text-align: left;
      border: solid 0px red;
      margin-top: 30px; 
      font-size: 13pt;
      line-height: 200%;
   }
   
   span.myli {
      display: inline-block;
      width: 90px;
      border: solid 0px blue;
   }
   
/* ============================================= */
   div#sms {
      margin: 0 auto; 
      /* border: solid 1px red; */ 
      overflow: hidden; 
      width: 50%;
      padding: 10px 0 10px 80px;
   }
   
   span#smsTitle {
      display: block;
      font-size: 13pt;
      font-weight: bold;
      margin-bottom: 10px;
   }
   
   textarea#smsContent {
      float: left;
      height: 100px;
   }
   
   button#btnSend {
      float: left;
      border: none;
      width: 50px;
      height: 100px;
      background-color: navy;
      color: white;
   }
   
   div#smsResult {
      clear: both;
      color: red;
      padding: 20px;
   }   

</style>    
</head>
<body>
문자 메세지 전송
<%-- ==== 휴대폰 SMS(문자) 보내기 ==== --%>
   <div id="sms" align="left">
        <span id="smsTitle">&gt;&gt;휴대폰 SMS(문자) 보내기 내용 입력란&lt;&lt;</span>
        <div style="margin: 10px 0 20px 0">
           발송예약일&nbsp;<input type="date" id="reservedate" />&nbsp;<input type="time" id="reservetime" />
        </div>
        <textarea rows="4" cols="40" id="smsContent"></textarea>
        <button id="btnSend">전송</button>
        <div id="smsResult"></div>
</div>
<script>
$(function(){
	console.log( $("input#reservedate").val() + " " + $("input#reservetime").val() );
	
});
$("#btnSend").click(function(){
	
	var reservedate = $("input#reservedate").val();
	reservedate = reservedate.split("-").join("");
	// [2021, 10, 06] ==> 20211006
	
	var reservetime = $("input#reservetime").val();
	reservetime = reservetime.split(":").join("");
	// [13,00] ==> 1300
	var datetime = reservedate + reservetime;
	
	var dataObj;
	
	if(reservedate == "" || reservetime == ""){
		dataObj = {"mobile" : "010-2614-6217",
					"smsContent" : $("textarea#smsContent").val()};
	} else {
		dataObj = {"mobile" : "010-2614-6217",
				"smsContent" : $("textarea#smsContent").val(),
				"datetime":datetime };
	}
	
	
	$.ajax({
		url:"/message/sendMessage.go",
        type:"POST",
        data:dataObj,
        dataType:"json",
        success:function(json){
	    	
	    	if(json.success_count == 1) {
	    		$("div#smsResult").html("문자전송이 성공되었습니다"); 
	    	}
	    	else if(json.error_count != 0) {
	    		$("div#smsResult").html("문자전송이 실패되었습니다"); 
	    	}
        },
        error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
         }
	});
	
});
</script>
 <!-- Bootstrap core JS-->
<script src="/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script>	
</body>
</html>