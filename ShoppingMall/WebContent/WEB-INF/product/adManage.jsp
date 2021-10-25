<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
   String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<jsp:include page="../include/header_admin.jsp"></jsp:include>

<title>[관리자메뉴]배너관리</title>


<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath %>/css/style.css" />
<script type="text/javascript" src="<%= ctxPath %>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script>

<style type="text/css">

   div.container {width: 70%;}
   
   div#top {margin: 0 auto;}
   
   div#main {margin: 0 auto;}
   
   li.myli {
      background-color: #ffffff;   
      font-weight: bold; 
   }
   
   li.myli:hover {cursor: pointer;}
   
</style>

<script type="text/javascript">
   
   $(document).ready(function() {      	
	      
	   $(".updatethis").click(function() {
		  
		   var sort_code = $(this).parent().parent().find(".sort_code").text();
		   var sort_name = $(this).parent().parent().find(".sort_name").text();
		   var img = $(this).parent().parent().find(".img").text();
		   
		//   console.log(sort_code+","+sort_name+","+img);
		   		   
		   $("[name=this_sort_code]").val(sort_code);
		   $("[name=this_sort_name]").val(sort_name);
		   $("[name=ad_img_url]").val(img);	   
		   
	   });
	   
	   $(".deletethis").click(function() {
			  
		   var sort_code = $(this).parent().parent().find(".sort_code").text();
		   var sort_name = $(this).parent().parent().find(".sort_name").text()
		   
		//   console.log(sort_code+","+sort_name+","+img);
		   
		   $("span.what").text("[" + sort_name +"]");
		   $("[name=del_sort_code]").val(sort_code);
		   
	   });
	   
	   $("#updateBanner").click(function() {
		  //	alert("확인용");
		   			  
			var bannerFileName = "";
		   
		    if(window.FileReader){
			   
				   if($("input#ad_img_url_pick")[0].files[0] == null) {
					   alert("수정하실 배너 이미지를 선택해주세요");
					   return;
				   }
				   else {
					   bannerFileName = $("input#ad_img_url_pick")[0].files[0].name;   
				   }
	           
	        } else {
	    	   bannerFileName = $("input#ad_img_url_pick").val().split('/').pop().split('\\').pop();
	        }
		    
			var fileArr = bannerFileName.toLowerCase().split(".");
		    
		    if(fileArr[1] != "jpg" && fileArr[1] != "bmp" && fileArr[1] != "png" && fileArr[1] != "jpeg") {
		    	alert("배너는 이미지만 등록 가능합니다. (jpg, jpeg, bmp, png)");
		    	return;
		    }
		    
		    if($("[name=ad_img_url]").val() == bannerFileName) {
		    	alert("수정된 이미지와 기존의 이미지가 동일합니다.");
		    	return;
		    }
		    
		    else {
		    	
		    	$("[name=ad_img_url_pick]").val(bannerFileName);
		    	
		    	var frm = document.updateBanner;
		    	
		    	frm.action = "/product/updateBanner.go";
		    	frm.method = "POST";
		    	frm.submit();
		    	
		    }
		   
	   });
	   
	   $("button#insertBanner").click(function() {
			insertBanner();
		});
		
	//	console.log("${result}");
		
		if("${result}" != "") {
			alert("${message}");
		}
      
   })// end of $(document).ready(function() {})-------------------------------------------
   
   ////////////////////////////////////////////////////////////
   
   // Function Declaration
   
   function deletethis() {
	   
	   var frm = document.deleteBanner
	   	   
	   frm.action = "/product/deleteBanner.go";
	   frm.method = "POST";
	   frm.submit();
	   
   }
   
	function insertBanner() {
	   
	   var frm = document.insertBanner;
	   
	//   console.log(frm.sort_code_plus.value);
	   
	   var bannerFileName = "";
	   
	   if(window.FileReader){
		   
		   if($("input#ad_img_url_plus")[0].files[0] == null) {
			   alert("배너 이미지를 선택해주세요");
			   return;
		   }
		   else {
			   bannerFileName = $("input#ad_img_url_plus")[0].files[0].name;   
		   }
           
       } else {
    	   bannerFileName = $("input#ad_img_url_plus").val().split('/').pop().split('\\').pop();
       }
	   
	   var fileArr = bannerFileName.toLowerCase().split(".");
	    
	   if(fileArr[1] != "jpg" && fileArr[1] != "bmp" && fileArr[1] != "png" && fileArr[1] != "jpeg") {
	   		alert("배너는 이미지만 등록 가능합니다. (jpg, jpeg, bmp, png)");
	   		return;
	   }
	   
	   frm.ad_img.value = bannerFileName.trim();
	   
	//   console.log(frm.ad_img.value);
	   
	   frm.action = "/product/insertBanner.go"
	   frm.method = "POST"
	   frm.submit();
	   
	}
   
   
</script>
      
   <div class="container mt-5 pt-5 px-0 offset-lg-3 col-lg-9">   
     	
         <h4>배너관리</h4>
         <hr>
                  
         <%-- 배너관리페이지 탑부분 시작 --%>   
         <div id="top">
            
            <form name="memberFrm" class="row w-100">
               
               <div class="col-md-9 mb-2 pl-4">
                  <button type="button" class="btn btn-success btn-sm" data-toggle="modal" data-target="#newModal" data-backdrop="static">신규배너등록</button>
               </div>
               
               <div class="col-md-3 text-right mb-2 px-0 mx-0">
                  
               </div>   
               
            </form>
            
         </div>
         <%-- 배너관리페이지 탑부분 끝 --%>   
         
         
         
         <%-- 배너관리페이지 메인부분 시작 --%>
         
         <div id="main" class="w-100 row mb-5">
            
            <div class="table-responsive content">
               
               <table class="table table-hover text-center">                     
                                                       
                  <tbody>
                  
                     <c:forEach var="bannerMap" items="${bannerList}">
                        
                        
                        	<c:if test="${bannerMap.img ne '-9999' }">
                        		
                        		<tr class="row w-100 px-0 mx-0">
                        			<td class="col-md-2 col-6">
		                               <p class="my-md-5 pt-2 sort_code">${bannerMap.sort.sort_code}</p>
		                            </td>
		                            <td class="col-md-2 col-6">
		                               <p class="my-md-5 pt-2">${bannerMap.sort.sort_name}</p>
		                               <span class="sort_name" style="display: none;">${bannerMap.sort.sort_name}</span>
		                            </td>                        			
                        			<td class="col-md-5 mx-0 px-0">
		                               <img src="../img_prod/${bannerMap.img}" class="img-fluid mx-0 px-0">
		                               <span class="img" style="display: none;">${bannerMap.img}</span>
		                            </td>		                            
		                            <td class="col-md-3">
		                               <button type="button" class="btn btn-sm btn-primary my-1 mx-1 mx-1 my-md-5 updatethis" data-toggle="modal" data-target="#updateModal" data-backdrop="static">수정</button>                  
                                 	   <button type="button" class="btn btn-danger btn-sm deletethis" data-toggle="modal" data-target="#deleteModal" data-backdrop="static">삭제</button>	                            	
		                            </td>                        		
                        		</tr>
                        		
                        	</c:if>
                            
                        
                     </c:forEach>                           
                              
                  </tbody>
                  
               </table>
            </div>   
             <form name="thisInfo"><input type="hidden" name="this_sort_code"></form>     
                      
         </div>         
         <%-- 배너관리페이지 메인부분 끝 --%>
         
         <%-- 신규등록모달 --%>
         <div class="modal fade" id="newModal">
			  <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">
			  
			    <div class="modal-content">			      
			      	
			      	<!-- Modal header -->
			      <div class="modal-header">
			        	<h5 class="modal-title">신규배너등록</h5>
			        	<button type="button" class="close thisclose" data-dismiss="modal">&times;</button>
			      </div>
			      	
			      <!-- Modal body -->
			      <div class="modal-body row">
	
				      	<form name="insertBanner">
				      		<label class="col-3" for="sort_code_plus">카테고리</label>
				      		<select class="col-6" name="sort_code_plus" id="sort_code_plus">
				      			<c:forEach var="bannerMap" items="${bannerList}">
				      				<c:if test="${bannerMap.img eq '-9999' }">
				      					<option value="${bannerMap.sort.sort_code}">${bannerMap.sort.sort_name}</option>
				      				</c:if>
				      				<c:if test="${bannerMap.img ne '-9999' }">
				      					<option value="${bannerMap.sort.sort_code}" disabled="disabled">${bannerMap.sort.sort_name}&nbsp;[선택불가]</option>
				      				</c:if>			      			
				      			</c:forEach>
				      		</select>			      		
				      		<br>
				      		<br>
				        	<label class="col-3" for="ad_img_url_plus">배너이미지</label>	          			
							<input class="col-6 px-0" type="file" id="ad_img_url_plus">
							<input type="hidden" name="ad_img">	
						</form>
					
					</div>          							
			      
			      <!-- Modal footer -->
			      <div class="modal-footer">
			      	<button type="button" class="btn btn-sm btn-success" id="insertBanner">등록</button>
			      	<button type="button" class="btn btn-sm btn-danger thisclose" data-dismiss="modal">취소</button>
			      </div>
			      
			    </div>
			  </div>
		</div>
         
        <%-- 수정모달 --%>
        <div class="modal fade" id="updateModal">
			  <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">
			  
			    <div class="modal-content">			      
			      	
			      	<!-- Modal header -->
			      <div class="modal-header">
			        	<h5 class="modal-title">배너수정</h5>
			        	<button type="button" class="close thisclose" data-dismiss="modal">&times;</button>
			      </div>
			      	
			     <!-- Modal body -->
			      <div class="modal-body row">
	
				      	<form name="updateBanner">
				      		<label class="col-4" for="sort_code">카테고리코드</label>
				      		<input type="text" value="" readonly="readonly" name="this_sort_code">	      		
				      		<br>
				      		<br>
				      		<label class="col-4" for="sort_code">카테고리명</label>
				      		<input type="text" value="" readonly="readonly" name="this_sort_name">	      		
				      		<br>
				      		<br>
				        	<label class="col-4" for="ad_img_url">배너이미지</label>
							<input type="text" name="ad_img_url" value="" readonly="readonly">
							<br>
				      		<br>
				      		<label class="col-4" for="ad_img_url_pick">변경하실이미지</label>	          			
							<input class="col-6 px-0" type="file" id="ad_img_url_pick">
							<input type="hidden" name="ad_img_url_pick">
						</form>
												
					</div>
			     	         							
			      
			      <!-- Modal footer -->
			      <div class="modal-footer">
			      	<button type="button" class="btn btn-sm btn-success" id="updateBanner">수정</button>
			      	<button type="button" class="btn btn-sm btn-danger thisclose" data-dismiss="modal">취소</button>
			      </div>
			      
			    </div>
			  </div>
		</div>
		
		<%-- 삭제모달 --%>
        <div class="modal fade" id="deleteModal">
			  <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">
			  
			    <div class="modal-content">			      
			      	
			      	<!-- Modal header -->
			      <div class="modal-header row text-center">
			        	<h6 class="modal-title"><span class="what"></span>&nbsp;카테고리의 배너를 삭제하시겠습니까?</h6>
			      </div>
			      	
			     <!-- Modal body -->
			      <div class="modal-body row text-center">
	
				      	<form name="deleteBanner">
				      		<input type="hidden" value="" name="del_sort_code">				      		
				      		<button type="button" class="btn btn-sm btn-danger deletethis mx-1" onclick="deletethis()">삭제</button>
				      		<button type="button" class="btn btn-sm btn-success thisclose mx-1" data-dismiss="modal">취소</button>
						</form>
												
					</div>
			     				      
			    </div>
			  </div>
		</div>
		
   </div>

<jsp:include page="../include/footer_admin.jsp"></jsp:include>