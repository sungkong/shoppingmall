<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<jsp:include page="../include/header.jsp"/>

<style type="text/css">

	div.container {	width: 90%;	}
	
	div#top {margin: 0 auto;}
	
	div#main {margin: 0 auto;}
	
	div#prod_img {
		display: inline-block;
		/* border: solid 1px red;	 */
	}
	
	div#prod_info {
		display: inline-block;
		/* border: solid 1px blue; */
	}
	
	table#tbl_info td {
		vertical-align: top;
		padding-right: 10px;
	}
	
	li.myli {
		background-color: #ffffff;	
		font-weight: bold;	
	}
	
	div#btn li.myli:hover {cursor: pointer;}
 	
 	button.btn_select {background-color: fff; border: solid 1px #a6a6a6;}
 	
 	button.btn_select:hover {background-color: #a6a6a6; border: none; color: #fff;}
 	
 	button#buy {background-color: #4d4d4d; color: #fff;}
 	
 	button#buy:hover {background-color: #a6a6a6;}
	
	div.reviewcard:hover { /* border: solid 1px #bfbfbf; */ background-color: #f2f2f2;}
	
</style>

<title>[소녀떡집]상품상세</title>



    
<!-- Font Awesome 5 Icons --> <!-- 아이콘을 사용하려면 헤드에서 미리 링크를 걸어줘야한당 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath %>/css/style.css" />




<script type="text/javascript">
	
	$(document).ready(function() {
		
		var price = 0;
		var total_price = 0;
		var total = 0;
				
		if("${cart}" == "y") {			
			$("#cartModal_btn").trigger('click');
		}
		
		if("${prodMap.pvo.discount_price}" == -9999 ) {
			price = Number("${prodMap.pvo.prod_price}");
			total_price = Number(price);
			$("#total_price").html(total_price.toLocaleString('en'));
		}
		
		else {
			price = Number("${prodMap.pvo.discount_price}");
			total_price = Number(price);
			$("#total_price").html(total_price.toLocaleString('en'));
		}
		
		// 리뷰 별점 이미지 넣기
		if("${reviewList}" != null && "${reviewList}".length != 0) {
			
			var avg_score = Math.round(Number("${avg_score}"));
			var html = "";
			
			if(5 == avg_score) {
				html = "<img src='../images_product/starYellow50.png' class='img-fluid' alt='Responsive image'>";
			}
						
			else if(avg_score == 4) {
				html = "<img src='../images_product/starYellow40.png' class='img-fluid' alt='Responsive image'>";
			}
			
			else if(avg_score == 3) {
				html = "<img src='../images_product/starYellow30.png' class='img-fluid' alt='Responsive image'>";
			}
			
			else if(avg_score == 2) {
				html = "<img src='../images_product/starYellow20.png' class='img-fluid' alt='Responsive image'>";
			}
			
			else if(avg_score == 1) {
				html = "<img src='../images_product/starYellow10.png' class='img-fluid' alt='Responsive image'>";
			}
			
			else {
				html = "<img src='../images_product/starYellow00.png' class='img-fluid' alt='Responsive image'>";
			}
			
			$("#starimg").prepend(html);
		}
		
		/* >>> === 클릭한 탭(버튼)만 보이도록 하는 첫번째 방법 === <<< */
		$("li.tablinks").click(function(event) {
			
			var $target = $(event.target);
		
			var i = $("li.tablinks").index($target);
		
			$("div.content").css("display","none"); 
			
			$("div.content:eq(" + i + ")").css('display','block'); 
			
			$("li.tablinks").removeClass("myli");
			
			$("li.tablinks:eq(" + i + ")").addClass('myli');
		
			if(i != 0) {$(".sidenav").hide();}
			else {$(".sidenav").show();}
						
		});// end of $("button.tablinks").click(function(event) {}-------------------
			
		if("${currentShowPageNo}" == null || "${currentShowPageNo}" == "")		
			$("li.tablinks:eq(0)").trigger('click');
		
		else
			$("li.tablinks:eq(2)").trigger('click');
		
		///////////////////////////////////////////////////////////////////
		
		$("button.minus").click(function(){
			
			if(Number($("input[name=howmany]").val()) > 1) {	
				
				$("input[name=howmany]").val(Number($("input[name=howmany]").val()) - 1);
				
				$("#total").text( Number($("#total").text()) - 1);
				
				total_price -= price;
				$("#total_price").html(total_price.toLocaleString('en'));
								
			}
			else
				alert("수량은 1 이상이어야 합니다.");
			
		});// end of $("button.minus").click()---------------------------------------
		
		$("button.plus").click(function(){
			
			$("input[name=howmany]").val(Number($("input[name=howmany]").val()) + 1);
			
			$("#total").text( Number($("#total").text()) + 1);
			
			total_price += price;
			$("#total_price").html(total_price.toLocaleString('en'));
						
		});// end of $("button.plus").click()---------------------------------------
		
		if("${prodMap.pvo.prod_plus}" != "1") {
			
			$(document).on('click', ".pick_del", function() {
				
				if($(this).val() == "important") {
					alert("필수 구매 옵션입니다.");
				}
				
			});
			
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////
		
		// 추가구성상품이 있으면
		if("${prodMap.pvo.prod_plus}" == "1") {
			
			var click_plus = 0;
			
			var click_plus_modal = 0;
			
			$("a#switch_plus").click(function(event) {
				
				click_plus += 1;
				
				if(click_plus%2 == 0) {
					$(this).text("▼");
				}
				
				else {
					$(this).text("▲");
				}			
				
			});
			
			$("a#switch_plus").trigger('click');
			
			/////////////////////////////////////////////////////////////////////////			
			
			var listsize = $("span#listsize").text();
						
			$("select[name=myplus]").change(function() {
								
				if(this.selectedIndex != 0) {
										
					var plus_price = Number($(this).parent().find("#plus_price").text());
					var plus_value = $(this).val();
					
					var html = 	"<div class='row mx-0 px-0 my-2 pt-3' style='border-top: solid 1px #d9d9d9;'>"+
									"<div class='col-3 col-md-4'><p>" + $(this).find("option:selected").text() + "</div>"+
									"<div class='col-5 col-md-4 text-center'>"+
										"<div class='text-left pl-1 btn-group'>"+
				          					"<button type='button' class='btn btn-sm minus-p border'><i class='fas fa-minus'></i></button>"+      					
				          					"<span class='howmany-p form-control-small text-center border pt-1'style='width: 40px;'>1</span>"+          					
				          					"<button type='button' class='btn btn-sm plus-p border'><i class='fas fa-plus'></i></button>"+
				  							"<span id='myprice' style='display: none;'>"+plus_price+"</span>"+
				          				"</div>"+
									"</div>"+
									"<div class='col-4 col-md-4'>"+
										"<span>" +plus_price.toLocaleString('en')+ "원</span>"+
										"<button type='button' class='close pick_del'>&times;</button>"+
										"<span class='plus_value' style='display: none;'>"+plus_value+"</span>"+
									"</div>"+
								"</div>";					
					
					$("#tr_pick").append(html);
					
					$("#total").text( Number($("#total").text()) + 1);
					
					total_price = Number(total_price) + plus_price;
					$("#total_price").html(total_price.toLocaleString('en'));
					
				}
				
				else {
					alert("이미 선택하신 옵션입니다.");
					this.selectedIndex = 1;
				}
				
			});
			
			///////////////////////////////////////////////////////////////////
			
			$(document).on('click', "button.minus-p", function() {
				
				var howmany_p = Number($(this).parent().find(".howmany-p").text());
				
				var myprice = Number($(this).parent().find("#myprice").text());
				
				if( howmany_p > 1) {	
					
					$(this).parent().find(".howmany-p").text(howmany_p - 1);
					
					$("#total").text( Number($("#total").text()) - 1);
					
					total_price -= myprice;
					$("#total_price").html(total_price.toLocaleString('en'));
					
				}
				else
					alert("수량은 1 이상이어야 합니다.");
				
			});// end of $("button.minus").click()---------------------------------------
			
			$(document).on('click', "button.plus-p", function() {
				
				var howmany_p = Number($(this).parent().find(".howmany-p").text());
				
				var myprice = Number($(this).parent().find("#myprice").text());
				
				$(this).parent().find(".howmany-p").text(howmany_p + 1);
				
				$("#total").text( Number($("#total").text()) + 1);
			//	console.log($("#total").text())
				total_price += myprice;
				$("#total_price").html(total_price.toLocaleString('en'));
								
			});// end of $("button.plus").click()---------------------------------------
						
			/////////////////////////////////////////////////////////////////////////
			
			$(document).on('click', ".pick_del", function() {
				
			//	console.log("확인용");
				
				if($(this).val() == "important") {
					alert("필수 구매 옵션입니다.");
				}
				
				else {
					
					plus_value = $(this).parent().find(".plus_value").text();
					
				//	console.log($("select[name=myplus]"));
					
				//	console.log(plus_value)
					
					var howmany_minus = $(this).parent().parent().find(".howmany-p").text();
					
				//	console.log(howmany_minus);
				
					var arrPlus = $("select[name=myplus]");
				
					arrPlus.each(function(index,item) {						
						
						if($(item).val() == plus_value) {
							item.selectedIndex = 0;
							
							plus_price = Number($(item).parent().find("#plus_price").text());
							
							$("#total").text( Number($("#total").text()) - howmany_minus);
							
							total_price = Number(total_price) - Number(plus_price)*Number(howmany_minus);
							$("#total_price").html(total_price.toLocaleString('en'));
							
							return false;
						}
						
					});
					
					$(this).parent().parent().remove();
				}
				
			});
			
			/////////////////////////////////////////////////////////////////////////			
			
		}
		
		///////////////////////////////////////////////////////////////////////////////
		
		// 골라담기 상품일 경우
		if("${prodMap.pvo.prod_select}" != "0") {
			
			var selectCnt = Number($("span#selectCnt").text());
						
			$("select.myselect").change(function() {
					
				if(this.selectedIndex != 0 && selectCnt == 0) {
					alert("골라담기 개수가 초과되었습니다.");
					this.selectedIndex = 0;
				}
				
				else if(this.selectedIndex != 0 && selectCnt != 0) {					
					
					selectCnt -= 1;
										
					var select_price = Number($(this).next().val());
					var select_value = $(this).val();
										
					var arrSelect = $("select.myselect");
					
				//	console.log(arrSelect);
					
					var html = 	"<div class='row mx-0 px-0 my-2 pt-3' style='border-top: solid 1px #d9d9d9;'>"+
									"<div class='col-3 col-md-4'><p>" + $(this).find("option:selected").text() + "</div>"+
									"<div class='col-5 col-md-4 text-center'>"+
										"<div class='text-left pl-1 btn-group'>"+
				          					"<button type='button' class='btn btn-sm minus-p border'><i class='fas fa-minus'></i></button>"+      					
				          					"<span class='howmany-p form-control-small text-center border pt-1'style='width: 40px;'>1</span>"+          					
				          					"<button type='button' class='btn btn-sm plus-p border'><i class='fas fa-plus'></i></button>"+
				          					"<span id='myprice' style='display: none;'>"+select_price+"</span>"+
			          					"</div>"+
									"</div>"+
									"<div class='col-4 col-md-4'>"+
										"<span>" +select_price.toLocaleString('en') + "원</span>"+
										"<button type='button' class='close pick_del'>&times;</button>"+
										"<span class='select_value' style='display: none;'>"+select_value+"</span>"+
									"</div>"+
								"</div>";					
					
					$("#select_pick").append(html);
					
					if(selectCnt == Number($("span#selectCnt").text())-1) {
						
						total_price = select_price;
						$("#total_price").html(total_price.toLocaleString('en'));
					}
					
					else {
						$("#total").text( Number($("#total").text()) + 1);
						
						total_price = Number(total_price) + select_price;
						$("#total_price").html(total_price.toLocaleString('en'));
					}
					
				}
				
				else {
					alert("이미 선택하신 옵션입니다.");
					this.selectedIndex = 1;
				}
				
			});
			
			/////////////////////////////////////////////////////////////////////////
			
			$(document).on('click', "button.minus-p", function() {
				
				var howmany_p = Number($(this).parent().find(".howmany-p").text());
				
				var myprice = Number($(this).parent().find("#myprice").text());
				
				if( howmany_p > 1) {	
					
					$(this).parent().find(".howmany-p").text(howmany_p - 1);
					
					$("#total").text( Number($("#total").text()) - 1);
					
					total_price -= myprice;
					$("#total_price").html(total_price.toLocaleString('en'));
					
					selectCnt += 1;
					
				}
				else
					alert("수량은 1 이상이어야 합니다.");
				
			});// end of $("button.minus").click()---------------------------------------
			
			$(document).on('click', "button.plus-p", function() {
								
				if(Number($("span#selectCnt").text()) == Number($("#total").text())) {
					alert("골라담기 개수가 초과되었습니다.");
				}
				
				else {
					var howmany_p = Number($(this).parent().find(".howmany-p").text());
					
					var myprice = Number($(this).parent().find("#myprice").text());
					
					$(this).parent().find(".howmany-p").text(howmany_p + 1);
					
					$("#total").text( Number($("#total").text()) + 1);
								
					total_price += myprice;
					$("#total_price").html(total_price.toLocaleString('en'));
					
					selectCnt -= 1;
				}	
				
			});// end of $("button.plus").click()---------------------------------------
						
			/////////////////////////////////////////////////////////////////////////
			
			$(document).on('click', ".pick_del", function() {
				
			//	console.log("확인용");
				
				if($(this).val() == "important") {
					alert("필수 구매 옵션입니다.");
				}
				
				else {
					
					select_value = $(this).parent().find(".select_value").text();
					
				//	console.log($("select[name=myplus]"));
					
				//	console.log(plus_value)
					
					var howmany_minus = $(this).parent().parent().find(".howmany-p").text();
					
				//	console.log(howmany_minus);
				
					var arrSelect = $("select.myselect");
					
					var myprice = Number($(this).parent().parent().find("#myprice").text());
					
				//	console.log(myprice);
					
					arrSelect.each(function(index,item) {						
						
						if($(item).val() == select_value) {
							item.selectedIndex = 0;											
							
							return false;
						}
						
					});
					
					$("#total").text( Number($("#total").text()) - howmany_minus);
					total_price = Number(total_price) - Number(myprice)*Number(howmany_minus);
					$("#total_price").html(total_price.toLocaleString('en'));
					
					selectCnt += howmany_minus;
					
					$(this).parent().parent().remove();
				}
				
			});			
			
		}
		
		////////////////////////////////////////////////////////////////////////////////
		
		$(".reviewcard").click(function() {
			
			var img = $(this).find(".this-img").text();	
			var content = $(this).find(".this-content").text();
			var username = $(this).find(".this-username").text();
			var score = $(this).find(".this-score").text();
			var date = $(this).find(".this-date").text();
			
			if(img != "사진없음")  {
				$("#re-img").html("<img src='../img_review/"+ img +"' style='object-fit: cover; max-height: 150px;'><hr>")
			}
			
			else {
				$("#re-img").empty();
			}
			
			$("#re-content").text(content);
			$("#re-username").text(username);
			$("#re-score").text(score);
			$("#re-date").text(date);
		
		});
		
		
	})// end of $(document).ready(function() {})-------------------------------------------
	
	// Function Declaration
	
	// 장바구니 버튼 클릭시
	function goBasket() {
		
		var frm = document.whatbuy;
		
		var prod_code_arr = [];
		var goods_qy_arr = [];
		
		// 골라담기 상품인 경우
		if("${prodMap.pvo.prod_select}" != "0") {			
			
			var prod_code = ""; // 선택한 상품들의 prod_code
			
			$(".select_value").each(function(index,item) {
				prod_code_arr.push($(item).text());
			});
			
			var goods_qy = ""; // 선택한 상품들의 개수
			
			var n_goods_qy = 0;
			
			$(".howmany-p").each(function(index,item) {				
				goods_qy_arr.push($(item).text());				
				n_goods_qy += Number($(item).text());				
			});
	
			if(n_goods_qy < Number("${prodMap.pvo.prod_select}")) {
				alert("상품을 총 " + "${prodMap.pvo.prod_select}" + "개 선택해주세요.");
				return;
			}					
		}
		
		// 골라담기 상품이 아닐 경우(단품 또는 추가선택옵션이 있는 경우)
		else {
			
			// 추가선택옵션이 없을 경우
			prod_code_arr.push($("input[name=my_value]").val());
			goods_qy_arr.push($("input[name=howmany]").val());
			
			// 추가선택옵션이 있을 경우
			if("${prodMap.pvo.prod_plus}" != "0") {
				
				var prod_code = ""; // 선택한 상품들의 prod_code
				
				$(".plus_value").each(function(index,item) {
					prod_code_arr.push($(item).text());
				});
				
				var goods_qy = ""; // 선택한 상품들의 개수
				
				$(".howmany-p").each(function(index,item) {
					goods_qy_arr.push($(item).text());
				});
							
			}

		}
				
		var presentProdCode_arr = [];
		
		$.ajax({
			  
			type : "post",
			url : '/order/getBasketProdCode.go',
			dataType:"JSON",
			async:false,
			success : function(json){			
					$.each(json, function(index, item){
						presentProdCode_arr.push(item.prod_code);		
					});							
			},
			error: function(request, status, error){
                   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
                }
		});
		console.log('presentProdCode_arr',presentProdCode_arr);

		//장바구니랑 중복되는지
		var duplicateBasket = false;
		var update_prod_code_arr = [];
		var update_goods_qy_arr = [];
		
		var tmp_goods_qy_arr = goods_qy_arr.slice();
		
		for(var i=0; i<prod_code_arr.length; i++){			
			if(presentProdCode_arr.includes(prod_code_arr[i])){
				 
				 update_prod_code_arr.push(prod_code_arr[i]);			
				 update_goods_qy_arr.push(tmp_goods_qy_arr[i]);;
				 
				 delete goods_qy_arr[i];
				 
				 duplicateBasket = true;
			}
		}

		prod_code_arr = prod_code_arr.filter(item => !presentProdCode_arr.includes(item));
		goods_qy_arr = goods_qy_arr.filter(item => item !== null && item !== undefined && item !== '');
		
		// 장바구니에 중복된게 없으면 
		if(update_prod_code_arr.length == 0){
			
			$("#update_prod_code_arr").attr("disabled",true);
			$("#update_goods_qy_arr").attr("disabled",true);
			
		} else {
			$("#update_prod_code").val(update_prod_code_arr);
			$("#update_goods_qy").val(update_goods_qy_arr);
		}
		
		$("#prod_code").val(prod_code_arr);
		$("#goods_qy").val(goods_qy_arr);		
		
		frm.action = "/order/goBasket.go";
		frm.method = "POST";		
		frm.submit();
		
	}
	
	////////////////////////////////////////////////////////////////////////////////////////
	
	// 구매하기 버튼 클릭
	function buyNow() {
			
		var frm = document.whatbuy;
		
		// 골라담기 상품인 경우
		if("${prodMap.pvo.prod_select}" != "0") {			
			
			var prod_code = ""; // 선택한 상품들의 prod_code
			
			$(".select_value").each(function(index,item) {
				
				if(index != 0) {prod_code += ","}
				prod_code += $(item).text();
			});
			
			var goods_qy = ""; // 선택한 상품들의 개수
			
			var n_goods_qy = 0;
			
			$(".howmany-p").each(function(index,item) {
				
				if(index != 0) {goods_qy += ","}
				goods_qy += $(item).text();
				
				n_goods_qy += Number($(item).text());
				
			});
					
			if(n_goods_qy < Number("${prodMap.pvo.prod_select}")) {
				alert("상품을 총 " + "${prodMap.pvo.prod_select}" + "개 선택해주세요.");
				return;
			}
			
			else {
				frm.prod_code.value = prod_code;				
				frm.goods_qy.value = goods_qy;			
			}
			
		}
		
		// 골라담기 상품이 아닐 경우(단품 또는 추가선택옵션이 있는 경우)
		else {
			
			// 추가선택옵션이 없을 경우
			frm.prod_code.value = $("input[name=my_value]").val();
			frm.goods_qy.value = $("input[name=howmany]").val();
			
			// 추가선택옵션이 있을 경우
			if("${prodMap.pvo.prod_plus}" != "0") {
			
				var prod_code = ""; // 선택한 상품들의 prod_code
				
				$(".plus_value").each(function(index,item) {
					
					if(index != 0) {prod_code += ","}
					prod_code += $(item).text();
				});
				
				var goods_qy = ""; // 선택한 상품들의 개수
				
				$(".howmany-p").each(function(index,item) {
					
					if(index != 0) {goods_qy += ","}
					goods_qy += $(item).text();
				});			
				
				frm.prod_code.value = $("input[name=my_value]").val() + "," + prod_code;				
				frm.goods_qy.value = $("input[name=howmany]").val() + "," + goods_qy;
								
			}			
		}
		
		frm.action = "/order/orderForm.go";
		frm.method = "POST";
		// 상품페이지에서 구매하기 버튼으로 바로 주문페이지로 전달하는 경우
		var hiddenInput = document.createElement('input');
		hiddenInput.setAttribute('type','hidden');
		hiddenInput.setAttribute('name','orderType');
		hiddenInput.setAttribute('value', 'direct');
		frm.appendChild(hiddenInput);
		
		frm.submit();
		
	}
	
	// 리뷰 등록하기 버튼 클릭 
	function registerReview() {
		location.href = "/product/registerReview.go?prod_code=" + "${prodMap.pvo.prod_code}" + "&prod_name=" + "${prodMap.pvo.prod_name}";
	}
	
</script>
		
	<div class="container mt-5">
	
	<button type="button" id="cartModal_btn" data-toggle="modal" data-target="#cartModal" style="display: none;"></button>
	
	<%-- 장바구니 모달 --%>
		<div class="modal fade" id="cartModal">
			  <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">
			  
			    <div class="modal-content">			      
			      	
		      		<!-- Modal body -->
			      	<div class="modal-body row text-center">
			        	<h6 class="modal-title text-center col">장바구니로 이동하시겠습니까?</h6>
			      	</div>
			      	
			     	<!-- Modal footer -->
			      	<div class="modal-footer row">
			      		<p class="text-center col">		      		
				      		<button type="button" class="btn btn-sm btn-dark mx-1" onclick="location.href='/mypage/basket.go'"><i class="fas fa-shopping-cart" style="color: white;"></i>&nbsp;이동</button>
				      		<button type="button" class="btn btn-sm btn-light mx-1" data-dismiss="modal">닫기</button>
				      	</p>													
					</div>
			     				      
			    </div>
			  </div>
		</div>
	
	<%-- 리뷰카드 모달 --%>
		<div class="modal fade" id="reviewModal">
			  <div class="modal-dialog modal-dialog-scrollable modal modal-dialog-centered">
			  
			    <div class="modal-content">			      
			      	
			      	<!-- Modal header -->
			      <div class="modal-header">
			        	<h5 class="modal-title">고객리뷰</h5>
			        	<button type="button" class="close thisclose" data-dismiss="modal">&times;</button>
			      </div>
			      	
			     <!-- Modal body -->
			      <div class="modal-body">
						
						<div class="modal-card">
				             <div class="card-body px-1">
				                 <div align="center" id="re-img"></div>
				                 <p class="ml-3" style="min-height: 100px;" id="re-content"></p>
				                 <hr>
				                 <p class="ml-3" style="color: gray;" id="re-username"></p>
				                 <p class="ml-3" style="color: gray;" id="re-score"></p>								                 
				                 <p class="ml-3" style="color: gray;" id="re-date"></p>				                 
				             </div>
				    	</div>
				      	
												
				  </div>
			     	         							
			      
			      <!-- Modal footer -->
			      <div class="modal-footer">
			      	<button type="button" class="btn btn-sm btn-danger thisclose" data-dismiss="modal">닫기</button>
			      </div>
			      
			    </div>
			  </div>
		</div>	
		
		<div style="position: fixed; z-index: 5; cursor: pointer; bottom: 30px; left: 25px;">
			<p>
				<a class="sidenav" href="#buypage" style="display: scroll;" onfocus="this.blur()" rel="nofollow">
					<i class="fas fa-shopping-cart" style="font-size: 25pt; color: black;"></i>
				</a>
			</p>
		</div>
		
					
			<%-- 상품페이지 탑부분 시작 --%>	
			
			<h6>${prodMap.pvo.sort_name}</h6>
			<hr class="mt-1 mb-4">
			
			<div id="top" class="w-100">
				
				<%-- 좌측 제품이미지: 반드시 하나가 아니라 여럿일 수 있음. DB에서 이미지 등 경로 가져와서 넣어야 함 --%>
				<div id="prod_img" class="col-lg-6 px-0 text-center carousel slide float-left" data-ride="carousel">
					
					<ol class="carousel-indicators">
						<c:forEach items="${prodMap.titleImgList}" varStatus="status">
							<c:if test="${status.index == 0}">
								<li data-target="#prod_img" data-slide-to="${status.index}" class="active"></li>
							</c:if>
							<c:if test="${status.index > 0}">
					  			<li data-target="#prod_img" data-slide-to="${status.index}"></li>
					  		</c:if>
						</c:forEach>
					</ol>
					
					<div class="carousel-inner">
						
						<c:forEach var="titleImg" items="${prodMap.titleImgList}" varStatus="status">
					  		<c:if test="${status.index == 0}">
					  			<div class="carousel-item active">
							      	<img src="../img_prod/${titleImg}" class="d-block w-100">
							    </div>					    
					  		</c:if>
					  		<c:if test="${status.index > 0}">
					  			<div class="carousel-item">
					  				<img src="../img_prod/${titleImg}" class="d-block w-100">
					  			</div>			  			
					  		</c:if>		  		
					  	</c:forEach>
						
					</div>
					
					<a class="carousel-control-prev" href="#prod_img" role="button" data-slide="prev">
						<span class="carousel-control-prev-icon" aria-hidden="true"></span>
						<span class="sr-only">Previous</span>
					</a>
					<a class="carousel-control-next" href="#prod_img" role="button" data-slide="next">
						<span class="carousel-control-next-icon" aria-hidden="true"></span>
						<span class="sr-only">Next</span>
					</a>
					
				</div>
				

				<div id="prod_info" class="col-lg-6 float-left">
				
					<table id="tbl_prod_info" class="ml-3 table table-borderless">
						
						<tr>
							<td colspan="2"><h4 class="mt-2">${prodMap.pvo.prod_name}</h4></td>
						</tr>
						
						<tr>
							<td colspan="2">
								<h5>
									<fmt:parseNumber var="prod_price" value="${prodMap.pvo.prod_price}" integerOnly="true" />
									
									<c:if test="${prodMap.pvo.discount_price eq '-9999'}">									
										<span><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
									</c:if>									
									<c:if test="${prodMap.pvo.discount_price ne '-9999'}">									
										<span style="text-decoration: line-through;"><fmt:formatNumber value="${prod_price}" pattern="###,###" />원</span>
									</c:if>
									
									<c:set var="calc_point" value="${prodMap.pvo.prod_price*0.01}" />
									<fmt:parseNumber var="point" value="${calc_point}" integerOnly="true" />
									<span class="ml-2" style="font-size: 12pt;">(적립금&nbsp;<fmt:formatNumber value="${point}" pattern="###,###" />원)</span>
								</h5>
							</td>
						</tr>
						
						<c:if test="${prodMap.pvo.discount_price ne '-9999'}">									
							<tr>
								<td><span class="ml-1">특별가</span></td>
								<fmt:parseNumber var="sale_p" value="${prodMap.pvo.discount_price}" integerOnly="true" />
								<fmt:parseNumber var="p" value="${prodMap.pvo.prod_price}" integerOnly="true" />
								<td class=""><h5><fmt:formatNumber value="${prodMap.pvo.discount_price}" pattern="###,###" />원&nbsp;<small style="color:red;">(<fmt:formatNumber value="${100 - (sale_p * 100) / p}" pattern="#"/>% 할인)</small></h5></td>
							</tr>
						</c:if>
					
						<tr>
							<td><span class="ml-1">리뷰평점</span></td>
							<td id="starimg">
								
								<c:if test="${not empty reviewList}">									
									&nbsp;&nbsp;<span class="small"><fmt:formatNumber value="${avg_score}" pattern="#0.00" />&nbsp;&nbsp;리뷰 개수 : ${reviewTotalCnt}</span>
								</c:if>
						 		
								<c:if test="${empty reviewList or reviewList eq null}">
									<img src='../images_product/starYellow00.png' class='img-fluid' alt='Responsive image'>
									&nbsp;&nbsp;<span class="small">리뷰없음</span>
								</c:if>				
							
							</td>
						</tr>
						
						<c:if test="${prodMap.pvo.prod_ice eq '1'}">
							<tr>
								<td><span class="ml-1">배송방법</span></td>
								<td class="">택배(롯데택배/아이스박스)</td>
							</tr>
						</c:if>
						
						<tr>
							<td><span class="ml-1">배송비</span></td>
							<td class="">
								<fmt:formatNumber value="${sessionScope.deliverFeeSet.fee}" type="number"></fmt:formatNumber>원&nbsp;
								(<fmt:formatNumber value="${sessionScope.deliverFeeSet.freeline}" type="number"></fmt:formatNumber>원 이상 구매 시 무료)
							</td>
						</tr>
						
					</table>
				<div  id="buypage"></div>
				
					<c:if test="${prodMap.pvo.prod_stock ne '0'}">	
						<div class="ml-3 px-0">
						<%-- 골라담기X --%>	
							<c:if test="${prodMap.pvo.prod_select eq '0'}">
								
								<%-- 추가구성상품O --%>
								<c:if test="${prodMap.pvo.prod_plus eq '1'}">
									<div class="row mx-0 px-0 pt-3" style="border-top: solid 1px #d9d9d9;">
										<div class="col-6">
											추가구성상품
										</div>
										<div class=" col-6 text-right px-0">
											<a class="btn btn-light btn-sm" id="switch_plus" href=".plus_list" data-toggle="collapse" style="color:black;"></a>
										</div>
										
									</div>
								
									<c:forEach var="plusvo" items="${prodMap.plusList}">
										<div class="row collapse plus_list mx-0 px-0">
											<div class="col-3"><img src="../img_prod/${plusvo.imgvo.prod_img_url}" class="img-fluid my-2" style="max-height: 80px;"></div>
											<div class="col-9">
												<p class="my-2">${plusvo.prod_name}</p>
												<c:if test="${plusvo.discount_price ne '-9999'}">
													<p class="mb-2">
														<span style="text-decoration: line-through;" class="small mr-2">
															<fmt:formatNumber value="${plusvo.prod_price}" pattern="###,###" />원
														</span>
														<fmt:formatNumber value="${plusvo.discount_price}" pattern="###,###" />원													
													</p>
												</c:if>
												<c:if test="${plusvo.discount_price eq '-9999'}">
													<p class="mb-2"><fmt:formatNumber value="${plusvo.prod_price}" pattern="###,###" />원</p>
												</c:if>
												<p>
													<select name="myplus">
														<option>- [선택옵션] 추가 구성 선택 하기 -</option>
														<c:if test="${plusvo.prod_stock eq 0}">													
															<option value="${plusvo.prod_code}" disabled="disabled">
																${plusvo.prod_name}&nbsp;[품절]
															</option>													
														</c:if>
														<c:if test="${plusvo.prod_stock ne 0}">													
															<option value="${plusvo.prod_code}">
																${plusvo.prod_name}
															</option>													
														</c:if>
													</select>
													<span id="plus_price" style="display: none;">
														<c:if test="${plusvo.discount_price eq -9999}">${plusvo.prod_price}</c:if>
														<c:if test="${plusvo.discount_price ne -9999}">${plusvo.discount_price}</c:if>												
													</span>
													<span id="plus_stock" style="display: none;">
														${plusvo.prod_stock}											
													</span>
												</p>											
											</div>
										</div>
									</c:forEach>
									<c:set var="plusList" value="${prodMap.plusList}"/>
									<span id="listsize" style="display: none;">${fn:length(plusList)}</span>
																	
								</c:if>								
								
								<div id="tr_pick">
									<div class="row mx-0 px-0 my-2 pt-3" style="border-top: solid 1px #d9d9d9;">
										<div class="col-3 col-md-4">${prodMap.pvo.prod_name}</div>
										<div class="col-5 col-md-4 text-center">
											<div class="text-left pl-1 btn-group">
					          					<button type="button" class="btn btn-sm minus border"><i class="fas fa-minus"></i></button>	          					
					          					<input type="text" name="howmany" class="form-control-small text-center border" value="1" style="width: 40px;" readonly="readonly">	          					
					          					<button type="button" class="btn btn-sm plus border"><i class="fas fa-plus"></i></button>						          					
					          					<input type='hidden' name="my_value" value="${prodMap.pvo.prod_code}">
			          						</div>
										</div>
										<div class="col-4 col-md-4">
											<span><c:if test="${prodMap.pvo.discount_price eq -9999}"><fmt:formatNumber value="${prodMap.pvo.prod_price}" pattern="###,###" /></c:if>
											<c:if test="${prodMap.pvo.discount_price ne -9999}"><fmt:formatNumber value="${prodMap.pvo.discount_price}" pattern="###,###" /></c:if>원</span>
											<button type="button" class="close pick_del" value="important">&times;</button>
										</div>
									</div>							
								</div>
								
							</c:if>
						
						<%-- 골라담기O --%>	
							<c:if test="${prodMap.pvo.prod_select ne 0}">
								<div class="row mx-0 px-0 my-2 pt-3" style="border-top: solid 1px #d9d9d9;">
									<div class="col-3 col-md-4">골라담기</div>
									<div class="col-9 col-md-8">
										
										<c:forEach var="selectvo" items="${prodMap.selectList}" varStatus="status">
										<c:if test="${selectvo.discount_price eq -9999}">
											<select name="myselect${status.index}" class="form-control form-control-sm w-80 mb-1 myselect">
												<option>- [필수] 옵션을 선택해 주세요 -</option>												
												<c:if test="${selectvo.prod_stock eq 0}">
													<option value="${selectvo.prod_code}" disabled="disabled">
														${selectvo.prod_name}&nbsp;[품절]
													</option>
												</c:if>
												<c:if test="${selectvo.prod_stock ne 0}">
													<option value="${selectvo.prod_code}">
														${selectvo.prod_name}												
													</option>												
												</c:if>																					
											</select>
											<input type="hidden" value="${selectvo.prod_price}">
											<span class="select_stock" style="display: none;">
												${selectvo.prod_stock}											
											</span>
										</c:if>
										
										<c:if test="${selectvo.discount_price ne -9999}">
											<select name="myselect${status.index}" class="form-control form-control-sm w-80 mb-1 myselect">
												<option>- [필수] 옵션을 선택해 주세요 -</option>												
												<c:if test="${selectvo.prod_stock eq 0}">
													<option value="${selectvo.prod_code}" disabled="disabled">
														${selectvo.prod_name}&nbsp;[품절]
													</option>
												</c:if>
												<c:if test="${selectvo.prod_stock ne 0}">
													<option value="${selectvo.prod_code}">
														${selectvo.prod_name}												
													</option>												
												</c:if>																					
											</select>
											<input type="hidden" value="${selectvo.discount_price}">
											<span class="select_stock" style="display: none;">
												${selectvo.prod_stock}											
											</span>
										</c:if>
										</c:forEach>
										
										<span id="selectCnt" style="display: none;">${prodMap.pvo.prod_select}</span>
									</div>
								</div>
								
								<div id="select_pick"></div>
							</c:if>
													
							<div class="row mx-0 px-0 my-2 pt-3" style="border-top: solid 1px #d9d9d9;">
								<div class="col-5">총 상품금액(수량)</div>
								<c:if test="${prodMap.pvo.discount_price eq '-9999'}">
									<div class="col-7" style="text-align: right;">
										<h3><span id="total_price"></span>원<small>(</small><span class="small" id="total">1</span><small>개)</small></h3>
									</div>
								</c:if>
								<c:if test="${prodMap.pvo.discount_price ne '-9999'}">
									<div class="col-7" style="text-align: right;">
										<h3><span id="total_price"></span>원<small>(</small><span class="small" id="total">1</span><small>개)</small></h3>
									</div>
								</c:if>
							</div>
								
							<div class="text-center mb-5">
								<div class="col-2"></div>
								<button type="button" class="btn col-3 mx-auto btn_select" id="cart" onclick="goBasket();">장바구니</button>
								<button type="button" class="btn col-5 mx-auto" id="buy" onclick="buyNow();">구매하기</button>
								<div class="col-2"></div>							
							</div>
							
							<form name="whatbuy">
								<input type="hidden" name="prod_code" id="prod_code"/>
								<input type="hidden" name="goods_qy" id="goods_qy"/>
								<input type="hidden" name="real_prod_code" value="${prodMap.pvo.prod_code}"/>
								<input type="hidden" name="update_prod_code" id="update_prod_code"/>
								<input type="hidden" name="update_goods_qy" id="update_goods_qy"/>
							</form>
													
						</div>
					</c:if>
					
					<c:if test="${prodMap.pvo.prod_stock eq '0'}">
						<div class="ml-3 px-0">
							<h1 class="mb-5 text-center" style="color:red;">일시품절</h1>
							<div class="text-center mb-5">
								<div class="col-2"></div>
								<button type="button" class="btn col-3 mx-auto btn_select" id="cart" disabled="disabled">장바구니</button>
								<button type="button" class="btn col-5 mx-auto" id="buy" disabled="disabled">SOLD OUT</button>
								<div class="col-2"></div>							
							</div>
						</div>						
					</c:if>
					
				</div>
			</div>
			<%-- 상품페이지 탑부분 끝 --%>	
			
			
			
			<%-- 상품페이지 메인부분 시작 --%>
			
			<div id="main" class="row w-100">
				<div id="btn" class="col-12">
				<hr>
					<ul class="list-group list-group-horizontal row text-center">
						<li class="list-group-item list-group-item-secondary col tablinks myli">상세정보</li>
						<li class="list-group-item list-group-item-secondary col tablinks myli">상품정보</li>
						<li class="list-group-item list-group-item-secondary col tablinks myli">고객리뷰(${reviewTotalCnt})</li>
						<li class="list-group-item list-group-item-secondary col tablinks myli">Q&amp;A</li>
					</ul>
				</div>	   
								   
				<div id="detail_info" class="content my-5 text-center mx-auto">
					
					<c:forEach var="detailImg" items="${prodMap.detailImgList}">
						
						<c:choose>							
							<c:when test="${fn:substringAfter(detailImg, '.') eq 'mp4'}">
								<video src="../img_prod/${detailImg}" autoplay="autoplay" class="detailmp4 w-100" loop="loop" muted="muted"></video>
							</c:when>
							<c:otherwise>
								<img src="../img_prod/${detailImg}" class="img-fluid" alt="Responsive image">
							</c:otherwise>							
						</c:choose>
						
						
						
					</c:forEach>
					
										
				</div>
				   
				<div id="prod_info" class="content my-5 mx-auto">			
					<table id="tbl_info">
						<tr>
							<td>
								<h6>상품결제정보<br><br>
									<span class="small">
										고액결제의 경우 안전을 위해 카드사에서 확인전화를 드릴 수도 있습니다. 
										확인과정에서 도난 카드의 사용이나 타인 명의의 주문등 정상적인 주문이 아니라고 판단될 경우 임의로 주문을 보류 또는 취소할 수 있습니다.   
										<br>			
										무통장 입금은 상품 구매 대금은 PC뱅킹, 인터넷뱅킹, 텔레뱅킹 혹은 가까운 은행에서 직접 입금하시면 됩니다.  
										주문시 입력한 입금자명과 실제입금자의 성명이 반드시 일치하여야 하며, 7일 이내로 입금을 하셔야 하며 입금되지 않은 주문은 자동취소 됩니다. 
									</span>
								</h6>
								<br><br>
								<h6>배송정보<br><br>
									<span class="small">
										배송 방법 : 택배<br>
								                  배송 지역 : 전국지역(도서산간 및 제주도 제외)<br>
									         배송 비용 : 3,500원<br>
									         배송 기간 : 1일 ~ 3일<br>
									         배송 안내 : - 산간벽지나 도서지방은 냉동상품 특성상 배송이 불가합니다. <br>
								      	- 고객님께서 주문하신 상품은 입금 확인후 배송해 드립니다. 다만, 상품종류에 따라서 상품의 배송이 다소 지연될 수 있습니다.
						    		</span>
								</h6>
								
							</td>
							<td>
								<h6>교환 및 반품정보<br><br>
									<span class="small">
										<span style="font-weight: bold; text-decoration: underline;">교환 및 반품 주소</span><br> 
										-경기도 화성시 동탄물류로 48 CJ대한통운
										<br><br>
										<span style="font-weight: bold; text-decoration: underline;">교환 및 반품이 가능한 경우</span><br>
										- 제품의 하자가 있을 시, 상품을 공급 받으신 날로부터 7일이내
										  단,식품의 경우, 상품 출고 이후 상품의 변질 및 유통기한 단축 등으로 인해 재판매가 어려운 경우는 교환/반품이 불가할 수 있습니다.
										  가전제품의 경우 포장을 개봉하였거나 포장이 훼손되어 상품가치가 상실된 경우에는 교환/반품이 불가능합니다.<br>
										- 공급받으신 상품 및 용역의 내용이 표시.광고 내용과
										 다르거나 다르게 이행된 경우에는 공급받은 날로부터 3월이내, 그사실을 알게 된 날로부터 30일이내
										<br><br>
										<span style="font-weight: bold; text-decoration: underline;">교환 및 반품이 불가능한 경우</span><br> 
										- 냉동 식품 특성상 배송이 시작되면 취소/반품이 불가합니다. (단, 상품 불량인 경우 제외)<br>
										- 고객님의 책임 있는 사유로 상품등이 멸실 또는 훼손된 경우. 단, 상품의 내용을 확인하기 위하여
										 포장 등을 훼손한 경우는 제외<br>
										- 포장을 개봉하였거나 포장이 훼손되어 상품가치가 상실된 경우
										 (예 : 가전제품, 식품, 음반 등, 단 액정화면이 부착된 노트북, LCD모니터, 디지털 카메라 등의 불량화소에
										 따른 반품/교환은 제조사 기준에 따릅니다.)<br>
										- 고객님의 사용 또는 일부 소비에 의하여 상품의 가치가 현저히 감소한 경우 단, 화장품등의 경우 시용제품을
										 제공한 경우에 한 합니다.<br>
										- 시간의 경과에 의하여 재판매가 곤란할 정도로 상품등의 가치가 현저히 감소한 경우<br>
										- 복제가 가능한 상품등의 포장을 훼손한 경우
										 (자세한 내용은 고객만족센터 1:1 게시판 상담을 이용해 주시기 바랍니다.)<br>
										<br>
										※ 고객님의 마음이 바뀌어 교환, 반품을 하실 경우 상품반송 비용은 고객님께서 부담하셔야 합니다.<br>
										 (색상 교환, 사이즈 교환 등 포함)<br>
										  단, 냉동 식품 특성상 배송이 시작되면 단순변심으로 인한 취소/반품이 불가합니다.
									</span>
								</h6>
							</td>
						</tr>
					</table>
				</div>
				   
				<div id="review"  class="content my-5 w-100 mx-0">
					<div id="stars" class="row w-100 py-0 text-center px-0 mx-0" style="border: solid 1px #e6e6e6;">
						<div class="col-md-3 pl-5 mt-2">
							<p style="font-weight: bold; font-size: 30pt;">
								<c:if test="${reviewList ne null}"><fmt:formatNumber value="${avg_score}" pattern="#0.00" /><span style="font-weight: normal; font-size: 20pt;">&nbsp;/5</span></c:if>
								<c:if test="${reviewList eq null}">-<span style="font-weight: normal; font-size: 20pt;">&nbsp;/5</span></c:if>
							</p>
									
							<p>리뷰<span style="font-weight: bold;">&nbsp;${reviewTotalCnt}</span></p>
						</div>
						
						<div class="col-md-9 mt-2 pr-5" style="font-size: 10pt;">
							
							<c:forEach var="scoreCntMap" items="${scoreCntList}" varStatus="status">
								
								<fmt:parseNumber var="cnt" value="${scoreCntMap.cnt}" integerOnly="true" />
								<c:set var="percent" value="${cnt/fn:length(reviewList)*100}"/>
								<div class="row mb-1">    
									<div class="col-2 px-2" style="text-align: right;">${scoreCntMap.score} Stars</div>                		
									<div class="progress col-10 mx-0 px-0">
						            	<div class="progress-bar" style="width: ${percent}%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="${percent}" role="progressbar"></div>
						            </div>
				            	</div>								
								
							</c:forEach>
								            
						</div>
						
					</div>
					
					<div class="row w-100 my-0 py-0 px-0 mx-0" id="btn_review" style="border: solid 1px #e6e6e6; border-top: none;">
						<table class="w-100 mx-0 px-0">
							<tr>
								<td colspan="3" class="row w-100 mx-0 px-0">
									<div style="font-weight: bold; font-size: 14pt;" class="col-12 col-md-3 col-lg-3 pl-4 pt-1 col-xl-2">리뷰 작성시</div>
									<div class="col-12 col-md-9 col-lg-9 pt-2 pl-4 col-xl-10">일반리뷰 100 POINT, 포토리뷰 200 POINT 적립!</div>
								</td>
								<td><button type="button" class="btn btn-secondary w-100 px-0 mx-0" style="border-radius: 0% 0%;" onclick="registerReview()">리뷰 등록하기</button></td>
							</tr>
						</table>						
					</div>
					
					<p class="mt-3 mb-1 px-0 mx-0"style="font-weight: bold;"><br>&nbsp;최신순(${reviewTotalCnt})</p>
					<hr>
<%-- --%>					
					
						
						<c:if test="${reviewList ne null}">
						
							<div id="img_row" class="row gx-4 gx-lg-5 row-cols-2 row-cols-lg-4">                	
	                	
			                	<c:forEach var="rvo" items="${reviewList}">
			                		
				                    <div class="col mb-5">
				                        <div class="card h-100 reviewcard" data-toggle="modal" data-target="#reviewModal">
				                            <%-- Review image--%>
				                            <c:choose>
												<c:when test="${rvo.review_img ne '-9999'}">
													<img class="card-img-top" src="../img_review/${rvo.review_img}" alt="..." style="height: 180px;"/>
													<span class="this-img" style="display: none;">${rvo.review_img}</span>
												</c:when>
										    	<c:otherwise>
										    		<img class="card-img-top" src="../img_review/리뷰사진이없오3.png" alt="..." style="height: 180px;"/>
										    		<span class="this-img" style="display: none;">사진없음</span>
										    	</c:otherwise>
									    	</c:choose>
				                            
				                            <%-- Review details--%>
				                            <div class="card-body p-4">
				                                <div class="text-center">	  
													<p class="ml-3" style="min-height: 100px;">${fn:substring(rvo.content, 0, 50)}
									                	<span class="this-content" style="display: none;">${rvo.content}</span>
									                	<c:if test="${fn:length(rvo.content) > 50}">...</c:if>
									                </p>
													<br>
													<p class="ml-3 this-username text-left" style="color: gray; font-size: 8pt;">작성자    : ${fn:substring(rvo.username, 0, 1)}<c:forEach begin="1" end="${fn:length(rvo.username) - 1}">*</c:forEach>&nbsp;님</p>
									                <p class="ml-3 this-score text-left" style="color: gray; font-size: 8pt;">평점       : ${rvo.score}</p>								                 
									                <p class="ml-3 this-date text-left" style="color: gray; font-size: 8pt;">작성일자 : ${rvo.review_date}</p>																				
				                                </div>
				                            </div>	                               
				                        </div>
				                    </div>
			                    </c:forEach>
			                    
			             	</div>  						
						
						</c:if>
						
						<c:if test="${reviewList eq null}">
							
							<div class="row w-100 px-0 mx-0 text-center">
								<p class="text-center col-8 offset-2">등록된 리뷰가 존재하지 않습니다.</p>
							</div>
							
						</c:if>
						
					
<%-- --%>			
					<nav class="nav-light">
					  <ul class="pagination justify-content-center" style="margin:20px 0">
					    ${requestScope.pageBar}
					  </ul>
					</nav>
					
										
				</div>
				
				<div id="qna"  class="content my-5 col-12">
					
					<h5>Q&amp;A</h5>
					<hr>
					
					<div class="table-responsive">
						<table class="table table-hover text-center">
							
							<thead class="thead-light">
								<tr>
									<th>번호</th>
									<th>제목</th>
									<th>작성자</th>
									<th>작성일</th>
									<th>조회</th>
								</tr>
							</thead>
							
							<tbody>
								<tr>
									<td>113</td>
									<td>상품문의</td>
									<td>엄****</td>
									<td>2021-08-26</td>
									<td>0</td>
								</tr>
								<tr>
									<td>113</td>
									<td>상품문의</td>
									<td>엄****</td>
									<td>2021-08-26</td>
									<td>0</td>
								</tr>
								<tr>
									<td>113</td>
									<td>상품문의</td>
									<td>엄****</td>
									<td>2021-08-26</td>
									<td>0</td>
								</tr>
								<tr>
									<td>113</td>
									<td>상품문의</td>
									<td>엄****</td>
									<td>2021-08-26</td>
									<td>0</td>
								</tr>
							</tbody>
							
						</table>
					</div>
					
					<div class="mx-0 px-0 my-2 row justify-content-end">
						<button type="button" class="btn btn-sm btn-dark mr-1">문의하기</button>						
						<button type="button" class="btn btn-sm btn-light" style="border: solid 1px #d9d9d9">모두보기</button>
					</div>
					
					<nav>
					  <ul class="pagination justify-content-center" style="margin:20px 0">
					    <li class="page-item disabled"><a class="page-link" href="#">이전</a></li>
					    <li class="page-item"><a class="page-link" href="#">1</a></li>
					    <li class="page-item active"><a class="page-link" href="#">2</a></li>
					    <li class="page-item"><a class="page-link" href="#">3</a></li>
					    <li class="page-item"><a class="page-link" href="#">다음</a>
					  </ul>
					</nav>
					
				</div>
			   
			</div>			
			<%-- 상품페이지 메인부분 끝 --%>
			
			<%-- 최상단, 최하단 이동 버튼 시작 --%>
			<div style="position: fixed; z-index: 5; cursor: pointer; bottom: 30px; right: 15px;">
				<p>
					<a class="sidenav" href="#" style="display: scroll;" onfocus="this.blur()" rel="nofollow">
						<i class="fas fa-caret-square-up" style="font-size: 25pt; color: black;"></i>
					</a>
				</p>
				<p>
					<a class="sidenav" href="#pagebottom" style="display: scroll;" onfocus="this.blur()" rel="nofollow">
						<i class="fas fa-caret-square-down" style="font-size: 25pt; color: black;"></i>
					</a>
				</p>
			</div>
			
			<div id="pagebottom"></div>
			<%-- 최상단, 최하단 이동 버튼 끝 --%>

	</div>

<jsp:include page="../include/footer.jsp"/>			
