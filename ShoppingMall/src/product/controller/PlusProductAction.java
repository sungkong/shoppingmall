package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import product.model.*;

public class PlusProductAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null && "admin".equals(loginuser.getUserid())) {
			
			String method = request.getMethod();
			
			if("POST".equalsIgnoreCase(method)) {
				
				String prod_code = request.getParameter("prod_code_plus");
				String status = request.getParameter("status_plus");
				String inout_qty = request.getParameter("plusqty");
				
				Map<String, String> pmMap = new HashMap<>();
				
				pmMap.put("prod_code", prod_code);
				pmMap.put("status", status);
				pmMap.put("inout_qty", inout_qty);
				
				//System.out.println(prod_code);
				//System.out.println(status);
				//System.out.println(inout_qty);
				
				InterProductDAO_JDH pdao = new ProductDAO_JDH();
				
				
				int result = pdao.PlusProduct(pmMap);
				
				if(result == 0) {
					request.setAttribute("message", "입고에 실패하였습니다.");
					request.setAttribute("loc", "/product/prodManage.go");
					setViewPage("/WEB-INF/msg.jsp");
				}
				
				if(result == 1) {
					request.setAttribute("message", "입고에 성공하였습니다.");
					request.setAttribute("loc", "/product/prodManage.go");
					setViewPage("/WEB-INF/msg.jsp");
				}
			
			}
			
			else {
				
				String message = "비정상적인 경로 침입";
				String loc = "javascript:history.back()";
		         
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		         
		        // super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
		        return;
				
			}
		}
		else {
			// 로그인을 안한 경우 또는 일반사용자로 로그인 한 경우
			String message = "관계자 외 출입금지";
	        String loc = "javascript:history.back()";
	         
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	         
	        // super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
		}
		
	}

}
