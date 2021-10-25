package member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;

public class EmailDuplicateCheckAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		if(method.equalsIgnoreCase("POST")) {
			
			String email = request.getParameter("email");		
			InterMemberDAO mdao = new MemberDAO();
			boolean emailExists = mdao.emailDuplicateCheck(email);
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("emailExists", emailExists);
			
			String json = jsonObj.toString(); 	
			
			request.setAttribute("json", json);
			super.setViewPage("/WEB-INF/jsonview.jsp");
			
		}
	}

}
