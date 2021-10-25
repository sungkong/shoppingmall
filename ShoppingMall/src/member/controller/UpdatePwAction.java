package member.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;

public class UpdatePwAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		String userid = "";
				
		if("POST".equalsIgnoreCase(method)) {
			
			String pwd = request.getParameter("pwd");
			userid = (String) request.getSession().getAttribute("userid");
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("userid", userid);
			paraMap.put("pwd", pwd);
			InterMemberDAO mdao = new MemberDAO();
			
			int success = mdao.updatePw(paraMap);
			if(success == 1) {
				request.setAttribute("message", "비밀번호가 변경되었습니다.");	
			} else {
				request.setAttribute("message", "비밀번호가 변경이 실패하였습니다.");			
			}
			
			request.getSession().removeAttribute("userid");
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("success", success);
			String json = jsonObj.toString();
			request.setAttribute("json", json);
			super.setViewPage("/WEB-INF/jsonview.jsp");
			
		} else {			
						
			super.setViewPage("/WEB-INF/views/member/updatePw.jsp");
		}
	}

}
