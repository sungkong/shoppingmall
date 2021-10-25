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

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" type="text/css" href="/css/style.css" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 

<!-- jquery UI -->
<link rel="stylesheet" type="text/css" href="/jquery-ui-1.12.1.custom/jquery-ui.css" />
<script type="text/javascript" src="/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
</head>

<!-- Navigation-->

	<nav class="navbar navbar-expand-lg navbar-light bg-light">
	    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
	    	<span class="navbar-toggler-icon"></span>
	    </button>
		
		<div class="collapse navbar-collapse" id="navbarSupportedContent">
		<div class="col-md-3 offset-md-1">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
           		 <li class="nav-item"><a class="nav-link" href="/board/boardWrite.go">공지사항</a></li>
           		 <li class="nav-item"><a class="nav-link" href="/board/boardQA.go">상품 Q&A</a></li>
           		 <li class="nav-item"><a class="nav-link" href="/board/boardIntro.go">소녀떡집 소개</a></li>
           		 <li class="nav-item"><a class="nav-link" href="/location.go">오시는길</a></li>
				 <li class="nav-item dropdown">
			       <a class="nav-link dropdown-toggle menufont_size text-secondary" href="#" id="navbarDropdown" data-toggle="dropdown"> 
			           	카테고리          				        
			       </a>
			       <div class="dropdown-menu" aria-labelledby="navbarDropdown" style="min-width:250px;">
			       	   <c:forEach var="sort" items="${sortList}">
			       	   	  <c:if test="${sort.sort_code ne '-9999'}">
			           		 <a class="dropdown-item text-secondary" href="/product/prodList.go?sort_code=${sort.sort_code}" style="font-size: 10pt;">${sort.sort_name}</a>
			           	  </c:if>
			           </c:forEach>
			           <a class="dropdown-item text-secondary" href="/product/prodList.go" style="font-size: 10pt;">[ALL]</a><%-- prodListAction에서 수정할 부분! 파라미터 값이 없으면 전체 상품 보여주는 걸로 --%>	
			           <div class="dropdown-divider"></div>      		           
			       	   
			       	   <form name="searchForm" action="/product/searchResult.go" method="GET">
				            <div class="dropdown-item input-group">								            	            
					          <input class="form-control" type="text" name="searchWord" placeholder="Search" style="font-size: 10pt;" value="${searchWord}">
					          <div class="input-group-append">
						          <button class="btn btn-sm btn-secondary" type="submit" style="font-size: 10pt;">
						          	<i class="fas fa-search"></i>
						          </button>
					          </div>							    
						   </div>
					   </form>
			       
			       </div>
			    </li>
			 </ul>
			 </div>
			  <div class="col-md-3 offset-md-5">
			 <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
				 <c:choose>
					<c:when test="${empty sessionScope.loginuser}">
						<li class="nav-item"><a class="nav-link" href="/member/login.go">로그인</a></li>
						<li class="nav-item"><a class="nav-link" href="/member/signUp.go">회원가입</a></li>						 
					</c:when>
					<c:otherwise>
						<c:if test="${sessionScope.loginuser.grade == 1}">
							<li class="nav-item"><a class="nav-link" href="/admin/deliverManage.go">관리자 모드</a></li>
						</c:if>
						<li class="nav-item"><a class="nav-link" href="#">${sessionScope.loginuer.userid}</a></li>
						<li class="nav-item"><a class="nav-link" href="/mypage/orderlist.go">마이페이지</a></li>
						<c:choose>
							<c:when test="${sessionScope.loginuser.loginType == 'kakao'}">
								<li class="nav-item"><a class="nav-link" onclick="kakaoLogout();">로그아웃!</a></li>
								<!-- <li class="nav-item"><a class="nav-link" onclick="unlinkApp();">연결끊기.테스트용</a></li> -->
							</c:when>
							<c:otherwise>
								<li class="nav-item"><a class="nav-link" href="/member/logout.go">로그아웃</a></li>						
							</c:otherwise>
						</c:choose>																
					</c:otherwise>
				</c:choose>							                                       
            </ul>            
            </div>
        </div>
    </nav>
    
	<div style="text-align: center;">
		<a href="/"><img id="logo" src="/images/소떡로고2.png" alt="logo"/></a>
	</div>
		
<body>
<script type="text/javascript">
$(function(){
	// 카카오 초기화
	Kakao.init('825e56e17bd334ca86670e481b45954e');
});
function kakaoLogout() {
    if (!Kakao.Auth.getAccessToken()) {
      alert('로그인을 해주세요.');
      return
    }
    Kakao.Auth.logout(function() {
      location.href = "/member/logout.go";
	})
}
// 카카오 연결끊기. 테스트 할때만 사용  
function unlinkApp() {
    Kakao.API.request({
      url: '/v1/user/unlink',
      success: function(res) {
        alert('success: ' + JSON.stringify(res))
      },
      fail: function(err) {
        alert('fail: ' + JSON.stringify(err))
      },
    })
}  
</script>
