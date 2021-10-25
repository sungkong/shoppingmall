package product.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class DeleteBannerAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String view = "checkAdmin";
		
		super.checkAdministration(request, view);
		
		if(view.equals(super.getViewPage())) {
		
			String this_sort_code = request.getParameter("del_sort_code");
			
			InterProductDAO_KJH pdao = new ProductDAO_KJH();
			
			int result = pdao.deleteBanner(this_sort_code);
					
			if(result == 0) {
				request.setAttribute("message", "배너삭제에 실패하였습니다. 다시 진행해주세요.");
				request.setAttribute("loc", "/product/adManage.go");
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			
			else {			
				request.setAttribute("message", "배너삭제가 완료되었습니다.");
				request.setAttribute("loc", "/product/adManage.go");
				super.setViewPage("/WEB-INF/msg.jsp");
			}
		
		}
		
	}

}
