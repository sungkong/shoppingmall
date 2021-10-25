package mypage.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;

public class DeliverDeleteController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		if(super.checkLogin(request)) {
			
			String method = request.getMethod();
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			String userid = loginuser.getUserid();
			
			if("POST".equalsIgnoreCase(method)) {
				
				InterMemberDAO mdao = new MemberDAO();
				
				String checkBoxArr = request.getParameter("checkBoxArr");
				String[] anoArr = checkBoxArr.split(",");				
				int n = 0;
				
				for(int i=0; i<anoArr.length; i++) {
					
					Long ano = Long.parseLong(anoArr[i]);
					n = n + mdao.deleteAddress(ano, userid);
					if(n == 0) {
						break;
					}
				}
	
				String type = request.getParameter("type");
				
				if(n == 0) {
					
					request.setAttribute("message", "삭제가 취소되었습니다.");
					request.setAttribute("loc", "/mypage/deliveraddr.go?type="+type);
														
					super.setViewPage("/WEB-INF/msg.jsp");
				} else {
					
					super.setRedirect(true);					
					super.setViewPage("/mypage/deliveraddr.go?type="+type);

				}
			}
		}
		
	}

}
