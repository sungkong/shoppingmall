package product.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.InterProductDAO_KJH;
import product.model.ProductDAO_KJH;

public class DeleteProdAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String view = "checkAdmin";
		
		super.checkAdministration(request, view);
		
		if(view.equals(super.getViewPage())) {
		
			String prod_code = request.getParameter("del_prod_code");
			
			InterProductDAO_KJH pdao = new ProductDAO_KJH();
			
			int result = pdao.deleteProduct(prod_code);
			
			if(result == 0) {
				request.setAttribute("message", "상품삭제에 실패하였습니다. 다시 진행해주세요.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			
			else {			
				request.setAttribute("message", "상품삭제가 완료되었습니다.");
				request.setAttribute("loc", "/product/prodManage.go");
				super.setViewPage("/WEB-INF/msg.jsp");
			}
		
		}
		
	}

}
