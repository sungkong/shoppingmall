<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/include/header.jsp"/>
<jsp:include page="/WEB-INF/views/mypage/navbar.jsp"/>

<link rel="stylesheet" type="text/css" href="/css/mypage/mypageStyle.css" />
<title>마이페이지 - 배송지 등록</title>
<style type="text/css">
/* 표 가운데 정렬 , 글자색, 글자크기*/
table td {
	text-align: left;
	color:#616161;
	font-size: 15px;
}

/* 표 첫번째열 가로넓이, 색, 정렬 등 */
table td:nth-child(1) {
	width:15%;
	background-color: #f9f9f9;
	text-align: left;
	font-weight: bold;
	font-size: 10pt;
	padding-left: 3%;
}   
</style>
<div style="width:100%; height:60px; text-align:center; padding-top:60px;"></div>
<%-- ////내용 시작//// --%>	
<div class="container p-5" >	
	<p style="margin-bottom:8px; font-weight: bold; color: black; text-align: center; font-size: 14pt;">배송 주소록 관리</p>
	<p class="text-secondary" style="margin-bottom:25px; text-align: center; font-size: 9pt;">자주 쓰는 배송지를 등록 관리하실 수 있습니다.</p>
	<%-- 배송 주소록 관리 표 --%>
	<form name="addAddressFrm">
	<input type="hidden" name="userid" value="${sessionScope.loginuser.userid}"/>
		<table class="table">	 
		    <tr>
		      <td>배송지명 *</td>
		      <td><input id='delivername' name="delivername" maxlength = "15" class="form-control col-sm-3" type='text'/></td>
		    </tr>
			<tr>
		      <td>성명 *</td>
		      <td><input id='name' name="name" maxlength ="10" class="form-control col-sm-3" type='text'/></td>
		    </tr>
			<tr>
		      <td>주소 *</td>
		      <td>
	
		      <div class="form-inline pb-1"><input id="postcode" name="postcode"  class="form-control col-sm-2 required" type='text'/>&nbsp;&nbsp;<button type="button" onclick="execDaumPostcode()" class="btn btn-light" style="font-size: 9pt; padding: 3px 8px;">우편번호</button></div>
		      <div class="form-inline pb-1"><input id="address" name="address" class="form-control col-sm-4 required" type='text' placeholder="기본주소(필수)"/></div>
		      <div class="form-inline pb-1">
			      <input id="detailaddress" name="detailaddress" class="form-control col-sm-4" type='text' placeholder="상세주소"/> 
			      <input type="text" class="form-control col-sm-4" id="extraaddress" name="extraaddress" placeholder="참고항목" >
		      </div>
		     
		      </td>
		      
		    </tr>
		    <tr>
		      <td>일반전화</td>
		      <td class="form-inline">
		      
		       <select class="selectpicker" id="hp1" name="hp1">
			    <option>02</option>
			    <option>031</option>
			    <option>033</option>
			    <option>041</option>
			    <option>042</option>
			    <option>043</option>
			    <option>044</option>
			    <option>051</option>
			    <option>052</option>
			    <option>053</option>
			    <option>054</option>
			    <option>055</option>
			    <option>061</option>
			    <option>062</option>
			    <option>063</option>
			    <option>064</option>
			    <option>0502</option>
			    <option>0503</option>
			    <option>0504</option>
			    <option>0505</option>
			    <option>0506</option>
			    <option>0507</option>
			    <option>0508</option>
			    <option>070</option>
			    <option>010</option>
			    <option>011</option>
			    <option>016</option>
			    <option>017</option>
			    <option>018</option>
			    <option>019</option>
			   </select>
			   &nbsp;-&nbsp;
			      <input id="hp2" name="hp2" class="form-control col-sm-1" type='text' maxlength = "4"/>&nbsp;-&nbsp;
			      <input id="hp3" name="hp3" class="form-control col-sm-1" type='text' maxlength = "4"/>
		      </td>
		      
		    </tr>
		    <tr>
		      <td>휴대전화 *</td>
		       <td class="form-inline">
			   <select class="selectpicker required" id="mo1" name="mo1">
				    <option>010</option>
				    <option>011</option>
				    <option>016</option>
				    <option>017</option>
				    <option>018</option>
				    <option>019</option>
			   </select>
			   &nbsp;-&nbsp;
			      <input id="mo2" name="mo2" maxlength = "4" class="form-control col-sm-1 required" type='text'/>&nbsp;-&nbsp;
			      <input id="mo3" name="mo3" maxlength = "4" class="form-control col-sm-1 required" type='text'/>
		      </td>
		    </tr>
		    
		</table>
	
		
		
		<div class="form-row float-right">
			<input type='checkbox' id="default_yn" name="default_yn" value="y" style="position: relative; top:12px;"/>&nbsp;<span class="text-secondary" style="font-size: 11pt; position: relative; top: 7px;">기본배송지로 저장</span>
			&emsp;&emsp;
			<input type="hidden" id="default_yn_hidden" name="default_yn" value='n'/>
      		<button type="button" onclick = "addAddress();" class="btn btn-dark" style="font-size: 11pt;">등록하기</button>
      		&nbsp; &nbsp;
      		<button type="button" onclick = "javascript:history.go(-1);" class="btn btn-light" style="font-size: 11pt;">취소</button>
  		</div>
  	</form>	
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>	
<script>
function addAddress(){
	
	var frm = document.addAddressFrm;
	frm.method = "POST";
	frm.action = "/member/addAddress.go";
	
	var arr_requiredList = document.getElementsByClassName("required");
	
	var boolFlag = false;
	for(var i=0; i<arr_requiredList.length; i++){
		var value = arr_requiredList[i].value;
		if(value == "" || value == null){
			alert("필수사항 입력");
			boolFlag = true;
			break;
		}
	}
	if(boolFlag) return false;
	
	if($("#hp2").val().trim() == ""){
		$("#hp1").val("");
	}
	
	if($("#mo2").val().length != 4 || $("#mo3").val().length != 4){
		alert("핸드폰 번호를 확안하세요.");
		return false;
	}
	
	if($("#default_yn").is(":checked")){
		$("#default_yn_hidden").attr("disabled", true);
	} else {
		$("#default_yn_hidden").attr("disabled", false);
	}
	frm.submit();
	
}


// 다음 주소 API
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("extraaddress").value = extraAddr;
            
            } else {
                document.getElementById("extraaddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("detailaddress").focus();
        }
    }).open();
}
</script>				 
<jsp:include page="/WEB-INF/include/footer.jsp"/>