package order.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class SendOrderAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if("POST".equalsIgnoreCase(request.getMethod())) {
			
			if(super.checkLogin(request)) {
				
				HttpSession session = request.getSession();				
				MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
				
				Map<String, Object> paraMap = new HashMap<>();
							
				String basket_no = request.getParameter("basket_no_arr");			
				String goods_qy = request.getParameter("goods_qy_arrI");
				
				String[] basket_no_arr = basket_no.split(",");
				String[] goods_qy_arr = goods_qy.split(",");
										
				paraMap.put("basket_no_arr", basket_no_arr);
				paraMap.put("goods_qy_arr", goods_qy_arr);
				paraMap.put("userid", loginuser.getUserid());
				
				InterOrderDAO odao = new OrderDAO();
				// 주문폼으로 넘기기전 장바구니 갱신하기
				try {
					
					int result = odao.updateBasket(paraMap);
					if(result != 0) {
						
						//request.setAttribute("basket_no", basket_no);
						// 장바구니에서 주문폼으로 넘겨지는경우 orderType="basket"으로 구분하기. 구매하기 버튼일 경우 orderType="direct"
						//request.setAttribute("orderType", "basket");
						super.setViewPage("/order/orderForm.go?orderType=basket&basket_no=" + basket_no);
						
					} else {
						
						request.setAttribute("message", "장바구니 담기에 실패했습니다.");
						request.setAttribute("loc", "javascript:history.back()");
						super.setViewPage("/WEB-INF/msg.jsp");
						
					}
					
				} catch (Exception e) {
					e.printStackTrace();
					request.setAttribute("message", "에러가 발생했습니다. 관리자에게 문의 바랍니다.");
					request.setAttribute("loc", "javascript:history.back()");
					super.setViewPage("/WEB-INF/msg.jsp");
				}
				
				
			} else {
				
				request.setAttribute("message", "로그인이 필요합니다.");
				request.setAttribute("loc", "/member/login.go");
				super.setViewPage("/WEB-INF/msg.jsp");
				
			}
			
						
		} else {
			
			request.setAttribute("message", "잘못된 접근입니다.");
			request.setAttribute("loc", "/");
			super.setViewPage("/WEB-INF/msg.jsp");
			
		}
	}

}
