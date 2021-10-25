package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import product.model.*;

public class DeleteCategoryAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null && "admin".equals(loginuser.getUserid())) {
			
			String method = request.getMethod();
			
			if("POST".equalsIgnoreCase(method)) {
		
				String sort_code = request.getParameter("sort_code");
				
				Map<String, String> sortMap = new HashMap<>();
				
				sortMap.put("sort_code", sort_code);
				
				System.out.println(sort_code);
					
				InterProductDAO_JDH pdao = new ProductDAO_JDH();
				
				int result = pdao.deleteCategory(sortMap);
				
				if(result == 0) {
					request.setAttribute("message", "삭제에 실패하였습니다.");
					request.setAttribute("loc", "/product/prodManage.go");
					setViewPage("/WEB-INF/msg.jsp");
				}
				
				if(result == 1) {
					request.setAttribute("message", "삭제에 성공하였습니다.");
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
