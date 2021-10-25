package member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;

public class UpdateMemberAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		String message = "";
		
		if(method.equalsIgnoreCase("GET")) {
			
			super.checkLoginAuth(request, "/WEB-INF/views/member/updateMemberForm.jsp");
			
		} else {
			
			InterMemberDAO mdao = new MemberDAO();
			
			String name = request.getParameter("name"); 
	        String userid = request.getParameter("userid"); 
	        String pwd = request.getParameter("pwd"); 
	        String email = request.getParameter("email"); 
	        String hp1 = request.getParameter("hp1"); 
	        String hp2 = request.getParameter("hp2"); 
	        String hp3 = request.getParameter("hp3");
	        String mobile = hp1+hp2+hp3;
	         
	        MemberVO member = new MemberVO(userid, pwd, name, email, mobile);
	        
			int n = mdao.updateMember(member);
			
			if(n == 1) {
						
				HttpSession session = request.getSession();
				MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
				
				loginuser.setPwd(pwd);
				loginuser.setEmail(email);
				loginuser.setMobile(mobile);

				message = "회원정보를 수정하였습니다.";
				
			} else {
				message = "회원정보 수정이 실패하였습니다.";
			}
			
			request.setAttribute("message", message);
			request.setAttribute("loc", "/");
			
			super.setViewPage("/WEB-INF/msg.jsp");
		}
	
	}

}
