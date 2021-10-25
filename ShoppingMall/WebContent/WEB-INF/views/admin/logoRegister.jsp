<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/include/header_admin.jsp"/>
<style>
table#logoRegisterTable tr,td {
      /* border: solid 1px gray;  */
      line-height: 30px;
      padding:15px;
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
#th{
	font-size : 20px;
	text-align: center;
}
</style>
<section class="section">
	<div class="container-fluid px-4">
		<form name="logoRegisterFrm" id="logoRegisterFrm">
			<table id="logoRegisterTable">
				<thead>
					<tr>
						<th colspan="2" id="th">배너 등록</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%; font-weight: bold;">배너명</td>
						<td style="width: 80%; text-align: left;">
							<input type="text" name="name" id="name" class="requiredInfo form-control form-control-sm"/>
						</td>
					</tr>
					<tr>
						<td style="width: 20%; font-weight: bold;">파일 업로드</td>
						<td style="width: 80%; text-align: left;">
							<input type="file" name="filename" id="filename" class="requiredInfo form-control"/>
							<!-- &nbsp;<button type="button" id="fileUpload" class="btn btn-dark">파일 업로드</button> -->							
						</td>						
					</tr>
					<tr>
						<td colspan="2" class="select_img"><img src="" /></td>
						<%= request.getRealPath("/") %>
					</tr>
					<tr>
						<td style="width: 20%; font-weight: bold;">바로 적용 여부</td>
						<td style="width: 80%; text-align: left;">
							<label>사용&nbsp;</label><input type="radio" name="status" value="0"/>
							<label>미사용&nbsp;</label><input type="radio" name="status" value="1"/>
						</td>
					</tr>									
					<tr>
						<td colspan="2" style="line-height: 90px;" class="text-center">
							<button type="button" id="btnUpdate" class="btn btn-dark btn-sm mt-3" onClick="goUpdate()">등록하기</button>
							<button type="button" class="btn btn-dark btn-sm mt-3" onClick="javascript:history.back()">이전</button>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</section>
<script>

$("#filename").change(function(){
	   if(this.files && this.files[0]) {
	    var reader = new FileReader;
	    reader.onload = function(data) {
	    	 $(".select_img img").attr("src", data.target.result).width(300);        
	    }
	    reader.readAsDataURL(this.files[0]);
	   }
});	    
</script>
<jsp:include page="/WEB-INF/include/footer_admin.jsp"/>