package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class ProductDetailAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String prod_code = request.getParameter("prod_code");
		
		InterProductDAO_KJH pdao = new ProductDAO_KJH();
		
		Map<String,Object> prodMap = pdao.getProdDetail(prod_code); 
		
		if("y".equalsIgnoreCase(request.getParameter("cart"))) {
			request.setAttribute("cart", "y");
		}
		
		if(prodMap.size() != 0) {
			
			request.setAttribute("prodMap", prodMap);
			
			String currentShowPageNo = request.getParameter("currentShowPageNo"); // 페이지번호
			
			if(currentShowPageNo == null) {				
				currentShowPageNo = "1";
			}
			
			else {
				request.setAttribute("currentShowPageNo", currentShowPageNo);
			}
			
			try {				
				Integer.parseInt(currentShowPageNo); // int로 변환되는지 먼저 확인한다				
			} catch (NumberFormatException e) {
				currentShowPageNo = "1";
			}
						
			Map<String, String> reviewTotalMap = pdao.getReviewTotal(prod_code);
			
			int reviewTotalCnt = Integer.parseInt(reviewTotalMap.get("reviewTotalCnt"));
			
			request.setAttribute("reviewTotalCnt", reviewTotalCnt);
			
			int reviewTotalPage = Integer.parseInt(reviewTotalMap.get("reviewTotalPage"));
			
			if(reviewTotalCnt != 0) {				
				
				List<ReviewVO> reviewList = pdao.getReviewList(prod_code, currentShowPageNo);
				
				request.setAttribute("reviewList", reviewList);	
				
				// 리뷰 페이징 처리를 위한 페이지바 만들기 -------------------------------------
				String pageBar = "";
							
				int blockSize = 5;
				
				int loop = 1;
				
				int pageNo = ( (Integer.parseInt(currentShowPageNo) - 1)/blockSize ) * blockSize + 1;
								
				if(pageNo != 1) {
					pageBar += "<li class='page-item'>"
					 			+ "<a class='page-link' href='/product/prodDetail.go?prod_code=" + prod_code + "&currentShowPageNo=1'>[맨처음]</a>"
					 		 + "</li>";
				
					pageBar += "<li class='page-item'>"
				 				+ "<a class='page-link' href='/product/prodDetail.go?prod_code=" + prod_code + "&currentShowPageNo=" + (pageNo-1) + "'>[이전]</a>"
				 			 + "</li>";
				}
				
				while( !(loop > blockSize || pageNo > reviewTotalPage) ) {
					
					if(pageNo == Integer.parseInt(currentShowPageNo)) {
						pageBar += "<li class='page-item active'>"
							     	+ "<a class='page-link' href='#'>" + pageNo + "</a>"
							     + "</li>";
					}
					
					else {
						pageBar += "<li class='page-item'>"
								 	+ "<a class='page-link' href='/product/prodDetail.go?prod_code=" + prod_code + "&currentShowPageNo=" + pageNo + "'>" + pageNo + "</a>"
								 + "</li>";
					}
					
					loop++;
					
					pageNo++;
					
				}// end of while-------------------------------------
				
				if(pageNo <= reviewTotalPage) {
					pageBar += "<li class='page-item'>"
						 		+ "<a class='page-link' href='/product/prodDetail.go?prod_code=" + prod_code + "&currentShowPageNo=" + pageNo + "'>[다음]</a>"
						 	 + "</li>";
					
					pageBar += "<li class='page-item'>"
					 			+ "<a class='page-link' href='/product/prodDetail.go?prod_code=" + prod_code + "&currentShowPageNo=" + reviewTotalPage + "'>[마지막]</a>"
					 		 + "</li>";
				}
				
				request.setAttribute("pageBar", pageBar);
				
				////////////////////////////////////////////////////////////
				
			}
			
			else {
				request.setAttribute("reviewList", null);
			}
			
			String avg_score = pdao.getAvgScore(prod_code);
			
			request.setAttribute("avg_score", avg_score);
			
			List<Map<String, String>> scoreCntList = pdao.getScoreCnt(prod_code);
			
			request.setAttribute("scoreCntList", scoreCntList);
						
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/product/prodDetail.jsp");
			
		}
		
		else {
			
			String message = "존재하지 않는 상품입니다.";
	        String loc = "javascript:history.back()";
	         
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	         
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
		}
		
	}

}
