package mypage.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class DeliverRegisterController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String type = request.getParameter("type");
		
		if("orderForm".equalsIgnoreCase(type)) {
			super.checkLoginAuth(request, "/WEB-INF/views/order/deliverRegister.jsp");
		} else {
			super.checkLoginAuth(request, "/WEB-INF/views/mypage/deliverRegister.jsp");
		}
		
		
	}

}
