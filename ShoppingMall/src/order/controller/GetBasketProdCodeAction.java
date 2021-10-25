package order.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class GetBasketProdCodeAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if(super.checkLogin(request)) {
			
			if("POST".equalsIgnoreCase(request.getMethod())) {
				
				
				HttpSession session = request.getSession();
				MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

				InterOrderDAO odao = new OrderDAO();
				
				List<Map<String, Object>> basketList = odao.getBasketList(loginuser.getUserid());
				
								
				JSONArray jsonArr = new JSONArray();							
				
					
				for(Map<String, Object> basket : basketList) {
				
					JSONObject jsonObj = new JSONObject();	
					jsonObj.put("prod_code", basket.get("prod_code"));    
		            jsonArr.put(jsonObj);
		            
				}	
					
				String json = jsonArr.toString();
				request.setAttribute("json", json);
				super.setViewPage("/WEB-INF/jsonview.jsp");
				
				
			} else {
				
				request.setAttribute("message", "비정상적인 접근입니다.");
				request.setAttribute("loc", "/");
				
				super.setViewPage("/WEB-INF/msg.jsp");
				
			}
		} else {
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/member/login.go");
			
			super.setViewPage("/WEB-INF/msg.jsp");
		}
	}

}
