package member.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;

public class FindIdAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		if("GET".equalsIgnoreCase(method)) {
			super.setViewPage("/WEB-INF/views/member/findIdForm.jsp");
		} else {
			
			InterMemberDAO mdao = new MemberDAO();
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("name", request.getParameter("name"));
			paraMap.put("email", request.getParameter("email"));
			
			request.setAttribute("name", request.getParameter("name"));
			request.setAttribute("email", request.getParameter("email"));
			
			String userid = mdao.findId(paraMap);
			if(userid == "" || userid == null) {
				request.setAttribute("message", "입력하신 정보의 아이디가 존재하지 않습니다.");
				super.setViewPage("/WEB-INF/msg.jsp");
			} else {
				request.setAttribute("userid", userid);
			}
		}
	}

}
