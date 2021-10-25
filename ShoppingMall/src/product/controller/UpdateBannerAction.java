package product.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class UpdateBannerAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if("POST".equalsIgnoreCase(request.getMethod())) {
			
			String view = "checkAdmin";
			
			super.checkAdministration(request, view);
			
			if(view.equals(super.getViewPage())) {
		
				String this_sort_code = request.getParameter("this_sort_code");
				String ad_img_url_pick = request.getParameter("ad_img_url_pick");
				
				InterProductDAO_KJH pdao = new ProductDAO_KJH();
				
				int result = pdao.updateBanner(this_sort_code, ad_img_url_pick);
						
				if(result == 0) {
					request.setAttribute("message", "배너수정에 실패하였습니다. 다시 진행해주세요.");
					request.setAttribute("loc", "/product/adManage.go");
					super.setViewPage("/WEB-INF/msg.jsp");
				}
				
				else {			
					request.setAttribute("message", "배너수정이 완료되었습니다.");
					request.setAttribute("loc", "/product/adManage.go");
					super.setViewPage("/WEB-INF/msg.jsp");
				}
		
			}
			
		}
		
		else {
			request.setAttribute("message", "비정상적인 접근 경로입니다.");
			request.setAttribute("loc", "/"); 
			
			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
