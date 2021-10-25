package member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;

public class IdDuplicateCheckAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		if(method.equalsIgnoreCase("POST")) {
			
			String userid = request.getParameter("userid");
			
			InterMemberDAO mdao = new MemberDAO();
			boolean idExists = mdao.idDuplicateCheck(userid);
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("idExists", idExists);
			
			String json = jsonObj.toString(); 
		
			request.setAttribute("json", json);
			super.setViewPage("/WEB-INF/jsonview.jsp");
			
		}
		
	}

}
