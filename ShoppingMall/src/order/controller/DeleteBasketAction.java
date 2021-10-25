package order.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class DeleteBasketAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if("GET".equalsIgnoreCase(request.getMethod())) {
			request.setAttribute("message", "비정상적인 접근입니다.");
			request.setAttribute("loc", "/");
			
			super.setViewPage("/WEB-INF/msg.jsp");
		} else {
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			if(loginuser != null) {
				
				String userid = loginuser.getUserid();
				
				int basket_no = Integer.parseInt(request.getParameter("basket_no"));
				InterOrderDAO odao = new OrderDAO();
				
				int result = odao.deleteBasket(basket_no);
				
				if(result == 1) {
					request.setAttribute("message", "삭제되었습니다.");
				} else {
					request.setAttribute("message", "삭제를 실패해습니다.");				
				}
				
				session.setAttribute("basketList", odao.getBasketList(userid));
				request.setAttribute("loc", "/mypage/basket.go?userid=" +userid);				
				super.setViewPage("/WEB-INF/msgRedirect.jsp");
				
			} else {
				
				request.setAttribute("message", "로그인이 필요합니다.");
				request.setAttribute("loc", "/member/login.go");
				
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			
			
		}
	}

}
