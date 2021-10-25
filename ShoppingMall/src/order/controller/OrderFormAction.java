package order.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.AddressVO;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class OrderFormAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if(super.checkLogin(request)) {
					
			InterOrderDAO odao = new OrderDAO();
			InterMemberDAO mdao = new MemberDAO();
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			String userid = loginuser.getUserid();
			
			// 배송지 목록 가져오기
			AddressVO defaultAddr = mdao.getAddressL(userid);
			session.setAttribute("defaultAddr", defaultAddr);

			String orderType = request.getParameter("orderType");
			
		    //장바구니에서 주문페이지로 넘겨지는 경우
			if("basket".equalsIgnoreCase(orderType)) {
				
				// 장바구니에서 선택한 상품 목록 가져오기
				String[] basket_no_arr = request.getParameter("basket_no").split(",");
				System.out.println(basket_no_arr.toString());
				List<Map<String, Object>> basketList = odao.getBasketByBno(basket_no_arr, userid);
				
				request.setAttribute("basketList", basketList);
				super.setViewPage("/WEB-INF/views/order/orderForm.jsp");
			// 상품페이지에서 구매하기로 넘기는 경우	
			} else if("direct".equalsIgnoreCase(orderType)){// 상품페이지에서 바로 구매하기 버튼눌렀을 경우
				
				String prod_code = request.getParameter("prod_code");					
				String[] arrProd_code = prod_code.split(",");					
			
				String goods_qy = request.getParameter("goods_qy");						
				String[] goods_qyAmount = goods_qy.split(",");
				
				List<Map<String, Object>> basketList = odao.getProdInfoByPno(arrProd_code, goods_qyAmount);
				
				request.setAttribute("basketList", basketList);
				super.setViewPage("/WEB-INF/views/order/orderForm.jsp");
				
			} else {
				
				request.setAttribute("message", "비정상적인 접근입니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setViewPage("/WEB-INF/msg.jsp");
			}
					
		} else {
			
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/member/login.go");
			
			super.setViewPage("/WEB-INF/msg.jsp");
		}
	}

}
