<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>	
/* 상단 네비게이션바 간격 */
.mypageNav > li{ 
  	padding-left:30px;
  	padding-right:30px;
}	
/* 호버, 클릭, 방문한 링크 굵게하기 */
a:visited, a:hover, a:active {
	font-weight: bold;
}
table > tbody:nth-child(1) > tr > td {
	font-weight: bold;
	color:#616161;
	font-size: 14px;
}
</style>

<div style="width:100%; height:60px; text-align:center; padding-top:20px;"></div>
<nav class="navbar navbar-expand-sm bg-white text-secondary" style="border-top: 1px solid #d9d9d9; border-bottom: 1px solid #d9d9d9; text-align:center;">
<!-- Links -->
  <ul class="navbar-nav ml-auto mr-auto mypageNav">
	    <li class="nav-item">
	    	<a class="nav-link text-secondary" id="navcolor" href="/mypage/basket.go">장바구니</a>
	     </li>
	    <li class="nav-item">
	      <a class="nav-link text-secondary" href="/mypage/orderlist.go">주문/배송</a>
	    </li>
	    <li class="nav-item">
	      <a id="updateMemberLink" class="nav-link text-secondary" href="/member/updateMember.go">회원 정보 수정</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link text-secondary" href="/mypage/point.go">적립금</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link text-secondary" href="/mypage/postmanage.go">게시물 관리</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link text-secondary" href="/mypage/deliveraddr.go">배송 주소록 관리</a>
	    </li>
  </ul>
</nav>
<script>
$("#updateMemberLink").click(function(){
	if(${sessionScope.loginuser.loginType == 'kakao'}){
		alert('카카오 회원은 회원정보를 수정할 수 없습니다.');
		return false;;
	}
});
</script>