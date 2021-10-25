package admin.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class DeliverFeeAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if(checkLogin(request)) {
			
			InterOrderDAO odao = new OrderDAO();
			
			if("GET".equalsIgnoreCase(request.getMethod())) {
				
				HttpSession session = request.getSession();
				MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
				int grade = loginuser.getGrade();
				
				if(grade == 1) {
													
					Map<String, Object> deliverFee = odao.getDeliverFee();
					
					request.setAttribute("deliverFee", deliverFee);
					super.setViewPage("/WEB-INF/views/admin/deliverFee.jsp");
					
				} else {		
					request.setAttribute("message", "관리자 전용 페이지입니다.");
					request.setAttribute("loc", "/");				
					setViewPage("/WEB-INF/msg.jsp");
				}
				
			} else {
				
				int fee = Integer.parseInt(request.getParameter("fee"));
				int freeline = Integer.parseInt(request.getParameter("freeline"));
				int result = odao.updateDeliverFee(fee, freeline);
				
				if(result != 0) {
					request.setAttribute("message", "배송비 설정이 수정되었습니다.");
				} else {
					request.setAttribute("message", "배송비 설정이 실패하였습니다.");					
				}
				
				request.setAttribute("loc", "/admin/deliverFee.go");
				super.setViewPage("/WEB-INF/msgRedirect.jsp");
			}
			
			
		} else {
			
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/");
			super.setViewPage("/WEB-INF/msg.jsp");
		}

	}

}
