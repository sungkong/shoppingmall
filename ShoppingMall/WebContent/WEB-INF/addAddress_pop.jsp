<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<title>:::HOMEPAGE:::</title>

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="/css/style.css" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<style>
	
   table#tblMemberRegister {
          width: 80%;
          
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
   #caution{
   		margin-top:50px;
   }
   
</style>
</head>
<body>
<div class="row" id="divRegisterFrm">		
   <div class="col-md-12" align="center">
   <div id="caution">
		<h2>배송주소록 유의사항</h2>
				<div>
					<ul>
						<li>배송 주소록은 최대 5개까지 등록할 수 있습니다.</li>
						<li>기본 배송지는 1개만 저장됩니다. 다른 배송지를 기본 배송지로 설정하시면 기본 배송지가 변경됩니다.</li>
					</ul>
				</div>
			</div>			
	<form name="registerFrm">
   <table id="tblMemberRegister">
      <thead>
      <tr>
      </tr>
      </thead>
      <tbody>
      <tr>
         <td style="width: 20%; font-weight: bold;">배송지명&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;">
             <input type="text" name="name" id="name" class="requiredInfo form-control form-control-sm" /> 
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">성명&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;">
             <input type="text" name="name" id="name" class="requiredInfo form-control form-control-sm" /> 
            <span class="error">성명은 한글만 입력 가능합니다.</span>
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">우편번호&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;">
            <input type="text" id="postcode" name="postcode" size="6" maxlength="5" />&nbsp;&nbsp;
            <%-- 우편번호 찾기 --%>
            <img id="zipcodeSearch" src="../images/b_zipcode.gif" style="vertical-align: middle;" />
            <span class="error">우편번호 형식이 아닙니다.</span>
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">주소&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;">
            <input type="text" id="address" name="address" size="40" placeholder="주소" /><br/>
            <input type="text" id="detailAddress" name="detailAddress" size="40" placeholder="상세주소" />&nbsp;<input type="text" id="extraAddress" name="extraAddress" size="40" placeholder="참고항목" /> 
            <span class="error">주소를 입력하세요</span>
         </td>
      </tr>
      <tr>
         <td style="width: 20%; font-weight: bold;">연락처&nbsp;<span class="star">*</span></td>
         <td style="width: 80%; text-align: left;">
             <input class="requiredInfo form-control form-control-sm2" type="text" id="hp1" name="hp1" size="6" maxlength="3" />&nbsp;-&nbsp;
             <input class="requiredInfo form-control form-control-sm2" type="text" id="hp2" name="hp2" size="6" maxlength="4" />&nbsp;-&nbsp;
             <input class="requiredInfo form-control form-control-sm2" type="text" id="hp3" name="hp3" size="6" maxlength="4" />
             <span class="error">휴대폰 형식이 아닙니다.</span>
         </td>
      </tr>
      
      <tr>
         <td style="width: 20%; font-weight: bold;">일반전화</td>
         <td style="width: 80%; text-align: left;">
             <input type="text" id="ht1" name="ht1" size="6" maxlength="4" readonly />&nbsp;-&nbsp;
             <input type="text" id="ht2" name="ht2" size="6" maxlength="4" />&nbsp;-&nbsp;
             <input type="text" id="ht3" name="ht3" size="6" maxlength="4" />
             <span class="error">일반전화 형식이 아닙니다.</span>
         </td>
      </tr>
         
         <td colspan="2" style="line-height: 90px;" class="text-center">
            <button type="button" id="btnRegister" class="btn btn-dark btn" onClick="goRegister();">가입하기</button>
            <button type="button" id="btnRegister" class="btn btn" onClick="goRegister();">취소</button>
         </td>
      </tr>
      </tbody>
   </table>
   </form>
   </div>
</div>
<script>
</script>
</body>
</html>