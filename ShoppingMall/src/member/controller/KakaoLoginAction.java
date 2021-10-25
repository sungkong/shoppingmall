package member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class KakaoLoginAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if("POST".equalsIgnoreCase(request.getMethod())) {
			
			String userid = request.getParameter("userid");		
			String clientip = request.getRemoteAddr(); // 클라이언트의 IP 주소를 알아오기
			
			Map<String, String> paraMap = new HashMap<>();	
			paraMap.put("userid", userid);
			paraMap.put("clientip", clientip);
			
			InterMemberDAO mdao = new MemberDAO();
			MemberVO loginuser = mdao.selectOneMember(paraMap, "kakao"); // 위 정보로된 유저가 존재하는지 확인
			
			if(loginuser != null) {
				
				if(loginuser.getIdle() == 1) {
					
					 String message = "로그인을 한지 1년이 지나서 휴먼상태로 되었습니다.";
			         String loc = "/";
			         
			         request.setAttribute("message", message);
			         request.setAttribute("loc", loc);
			         
			         super.setViewPage("/WEB-INF/msg.jsp");
			         
			         return;
				} else {
										
					HttpSession session = request.getSession();
					loginuser.setLoginType("kakao");
					session.setAttribute("loginuser", loginuser);

					InterOrderDAO odao = new OrderDAO();
					
					List<Map<String, Object>> basketList = odao.getBasketList(loginuser.getUserid());
					session.setAttribute("basketList", basketList);
					
					request.setAttribute("loc", "/");
					super.setViewPage("/WEB-INF/msgNoAlert.jsp");
											        
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
