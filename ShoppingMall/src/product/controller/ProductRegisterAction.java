package product.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class ProductRegisterAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		super.checkAdministration(request, "/WEB-INF/product/prodRegister.jsp");
		
		if("/WEB-INF/product/prodRegister.jsp".equals(super.getViewPage())) {
		
			// 모든 카테고리 가져오기
			super.getCategory(request);
			
			// 모든 상품 가져오기
			InterProductDAO pdao = new ProductDAO();
			
			List<ProductVO> prodList = pdao.AllProduct();
			
			request.setAttribute("prodList", prodList);
			
		}
		
	//	super.setRedirect(false);
		
		
	}
	
}
