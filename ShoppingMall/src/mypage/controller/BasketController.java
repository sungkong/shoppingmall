package mypage.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class BasketController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
				
		if(super.checkLogin(request)) {
			
			InterOrderDAO odao = new OrderDAO();
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			String userid = loginuser.getUserid();
			
			List<Map<String, Object>> basketList = odao.getBasketList(userid);
			session.setAttribute("basketList", basketList);
			
			super.setViewPage("/WEB-INF/views/mypage/basket.jsp");
		} else {
			
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/member/login.go");
			
			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
