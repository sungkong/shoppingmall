package member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class LoginAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
		if(method.equalsIgnoreCase("GET")) {
			if(super.checkLogin(request)) {
				// 로그인이 되어있는 경우
		        request.setAttribute("loc", request.getHeader("referer"));
		         
		        super.setViewPage("/WEB-INF/msgNoAlert.jsp");
			} else {
				super.setViewPage("/WEB-INF/views/member/loginForm.jsp");
			}
			
		} else {
			String userid = request.getParameter("userid");
			String pwd = request.getParameter("pwd");			
			String clientip = request.getRemoteAddr(); // 클라이언트의 IP 주소를 알아오기
			
			Map<String, String> paraMap = new HashMap<>();	
			paraMap.put("userid", userid);
			paraMap.put("pwd", pwd);
			paraMap.put("clientip", clientip);
			
			InterMemberDAO mdao = new MemberDAO();
			MemberVO loginuser = mdao.selectOneMember(paraMap, "normal"); // 위 정보로된 유저가 존재하는지 확인
			
			if(loginuser != null) {
				
				if(loginuser.getIdle() == 1) {
					
					 String message = "로그인을 한지 1년이 지나서 휴먼상태로 되었습니다.";
			         String loc = "/";
			         // 원래는 위와 같이 초기화면이 아닌 휴면 계정을 풀어주는 페이지로 잡아야 한다.
			         request.setAttribute("message", message);
			         request.setAttribute("loc", loc);
			         
			         super.setViewPage("/WEB-INF/msg.jsp");
			         
			         return;
				} else {
										
					HttpSession session = request.getSession();
					session.setAttribute("loginuser", loginuser);

					InterOrderDAO odao = new OrderDAO();
					
					List<Map<String, Object>> basketList = odao.getBasketList(loginuser.getUserid());
					session.setAttribute("basketList", basketList);
									

					
					if(loginuser.isRequirePwdChange()) {
						 String message = "비밀번호를 변경한지 3개월이 지났습니다. 암호를 변경하세요";
				         String loc = "/";
				         // 비밀번호 변경 페이지
				         request.setAttribute("message", message);
				         request.setAttribute("loc", loc);
				         
				         super.setViewPage("/WEB-INF/msg.jsp");
					} else {
						// 비밀번호를 변경한지 3개월 이내인 경우
						
						request.setAttribute("loc", "javascript:history.back()");
						super.setViewPage("/WEB-INF/msgNoAlert.jsp");
						
					}
			        
				}
			} else {
				
		         String message = "로그인 실패";
		         String loc = "javascript:history.back()";
		         
		         request.setAttribute("message", message);
		         request.setAttribute("loc", loc);
		         
		         super.setRedirect(false);
		         super.setViewPage("/WEB-INF/msg.jsp");
			}
			
		} 
	}
		
		
}


