package member.controller;

import java.sql.SQLException;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;

public class KakaoSignUpAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if("GET".equalsIgnoreCase(request.getMethod())) {

			request.setAttribute("message", "잘못된 요청입니다.");
	        request.setAttribute("loc", "/");
	        
			super.setViewPage("/WEB-INF/msg.jsp");
		} else {
			// 비밀번호 난수 생성
			 Random r = new Random();
			 StringBuilder sb = new StringBuilder();
			 
			 for(int i=0; i<4; i++) {
				 char tmp = (char) ('a' + r.nextInt('z' - 'a'));
				 sb.append(tmp);
				 char tmp2 = (char) r.nextInt();
				 sb.append(tmp2);
			 }
			 
			 String name = request.getParameter("name"); 
	         String userid = request.getParameter("userid"); 
	         String pwd = sb.toString();
	         String email = request.getParameter("email"); 
	
	         
	         MemberVO member = new MemberVO();
	         member.setName(name);
	         member.setUserid(userid);
	         member.setPwd(pwd);
	         member.setEmail(email);	        	
	         
	         try {
	        	 
	        	 InterMemberDAO mdao = new MemberDAO();
		         int n = mdao.registerMember(member, "kakao");	
		         boolean success = false;
	        	 JSONObject jsonObj = new JSONObject();	        	 
		         if(n==1) {
		        	 success = true;		        
		         } 		         
		         jsonObj.put("success", success);
		         String json = jsonObj.toString();
		         request.setAttribute("json", json);
		         super.setViewPage("/WEB-INF/jsonview.jsp");
		         
	         } catch(SQLException e) {

	        	 request.setAttribute("message", "회원가입 실패");
	 	         request.setAttribute("loc", "javascript:history.back()");
	 	        
	 	         super.setViewPage("/WEB-INF/msg.jsp");
	         }			
		}
	}

}
