package order.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class PurchaseEndAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String email = request.getParameter("email");
		String name = request.getParameter("name");
		String mobile = request.getParameter("mobile");
		String totalAmount = request.getParameter("totalAmount");
		
		request.setAttribute("email", email);
		request.setAttribute("name", name);
		request.setAttribute("mobile", mobile);
		request.setAttribute("totalAmount", totalAmount);
		
//		super.setRedirect(false);
		super.setViewPage("/WEB-INF/views/order/paymentGateway.jsp"); 
		//paymentGateway.jsp"뷰단으로 포워드. 정보 보낸다. 뷰단은 아임포트사에서 준 것이다.
		
	}

}