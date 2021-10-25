package admin.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class MessageManageAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		InterOrderDAO odao = new OrderDAO();
		
		if("POST".equalsIgnoreCase(request.getMethod())) {
			
			String smsContent = request.getParameter("smsContent");
		    smsContent = smsContent.replaceAll("\r\n", "<br>");
		    
			int result = odao.updateMessageForm(smsContent);
			
			if(result == 1) {
				request.setAttribute("message", "메세지 형식이 저장되었습니다.");
				request.setAttribute("loc", "/admin/messageManage.go");
			} else {
				request.setAttribute("message", "메세지 형식 저장이 실패했습니다.");
				request.setAttribute("loc", "/admin/messageManage.go");
			}
			super.setViewPage("/WEB-INF/msg.jsp");
			
		} else {
			
			String smsContent = odao.getMessageFrom();
			request.setAttribute("smsContent", smsContent);
			
			super.setViewPage("/WEB-INF/views/admin/messageManage.jsp");
		}
	}

}
