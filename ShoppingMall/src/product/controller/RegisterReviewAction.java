package product.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import product.model.InterProductDAO_KJH;
import product.model.ProductDAO_KJH;

public class RegisterReviewAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if(super.checkLogin(request)) { // 로그인 되어 있을 경우
						
			String prod_code = request.getParameter("prod_code");
			String prod_name = request.getParameter("prod_name");
			
			HttpSession session = request.getSession();
			
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			String userid = loginuser.getUserid();
			
			InterProductDAO_KJH pdao = new ProductDAO_KJH();
			
			String orderno = pdao.getOrdernoforReview(prod_code, userid);
			
			// 해당 상품 구매 기록이 있으면 리뷰등록 페이지로 보내준다.			
			if(!"-9999".equals(orderno)) {
				
				request.setAttribute("prod_code", prod_code);
				request.setAttribute("prod_name", prod_name);
				request.setAttribute("orderno", orderno);
				
				super.setViewPage("/WEB-INF/product/reviewRegister.jsp");
				
			}
			
			else {
				
				request.setAttribute("message", "리뷰 작성이 가능한 주문내역이 존재하지 않습니다");
		        request.setAttribute("loc", "javascript:history.back()");
		        
		        super.setViewPage("/WEB-INF/msg.jsp");
			}
			
		}
		
		else { // 로그인 안 되어 있을 경우 --> 로그인 먼저
			request.setAttribute("message", "로그인이 필요합니다");
			request.setAttribute("loc", "/member/login.go");
			
			setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
