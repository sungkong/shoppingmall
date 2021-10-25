package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class InsertBannerAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
		if("POST".equalsIgnoreCase(method)) {
		
			String view = "checkAdmin";
			
			super.checkAdministration(request, view);
			
			if(view.equals(super.getViewPage())) {
			
				String sort_code = request.getParameter("sort_code_plus");
				
				String ad_img_url = request.getParameter("ad_img");
				
				Map<String, String> paraMap = new HashMap<>();
				
				paraMap.put("sort_code", sort_code);
				paraMap.put("ad_img_url", ad_img_url);
				
				InterProductDAO_KJH pdao = new ProductDAO_KJH();
				
				int result = pdao.insertBanner(paraMap);
				
				if(result == 0) {
					request.setAttribute("message", "배너등록에 실패하였습니다. 다시 진행해주세요.");
					request.setAttribute("loc", "/product/adManage.go");
					setViewPage("/WEB-INF/msg.jsp");
				}
				
				else {
					request.setAttribute("message", "배너등록이 완료되었습니다.");
					request.setAttribute("loc", "/product/adManage.go");
					setViewPage("/WEB-INF/msg.jsp");
				}
			
			}
			
		}
		
		else {
			request.setAttribute("message", "비정상적인 접근 경로입니다");
			request.setAttribute("loc", "/");
	        
	        super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
