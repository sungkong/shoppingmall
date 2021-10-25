package member.controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;

public class SignUpAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
		if(method.equalsIgnoreCase("GET")) {
			super.setViewPage("/WEB-INF/views/member/signUpForm.jsp");
		} else {
			
			 String name = request.getParameter("name"); 
	         String userid = request.getParameter("userid"); 
	         String pwd = request.getParameter("pwd"); 
	         String email = request.getParameter("email"); 
	         String hp1 = request.getParameter("hp1"); 
	         String hp2 = request.getParameter("hp2"); 
	         String hp3 = request.getParameter("hp3");
	         String mobile = hp1+hp2+hp3;
	         String gender = request.getParameter("gender"); 
	         String birthyyyy = request.getParameter("birthyyyy"); 
	         String birthmm = request.getParameter("birthmm"); 
	         String birthdd = request.getParameter("birthdd");
	         
	         String birthday = birthyyyy+"-"+birthmm+"-"+birthdd;
	         
	         MemberVO member = new MemberVO(userid, pwd, name, email, mobile, gender, birthday);
	         String message = "";
	         String loc = "";
	         
	         try {
	        	 
	        	 InterMemberDAO mdao = new MemberDAO();
		         int n = mdao.registerMember(member, "normal"); // 2번째 파라미터로 일반 회원가입임을 명시
		         
		         if(n==1) {
		        	 message += "회원가입이 완료되었습니다.";
		        	 loc = "/"; 
		         } 
		         
	         } catch(SQLException e) {
	        	 message += "SQL구문 에러발생";
	        	 loc = "javascript:history.back()"; 
	         }
	         
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setViewPage("/WEB-INF/msg.jsp");
			
		}
	}

}
