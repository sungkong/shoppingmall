package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class ProductListAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		InterProductDAO pdao = new ProductDAO();
		
		String sort_code = request.getParameter("sort_code");
		
	//	System.out.println(sort_code);
		
		List<HashMap<String, Object>> productList = pdao.productList(sort_code);
		
		request.setAttribute("productList", productList);
		
		// System.out.println("확인용");
		
		String adimg = pdao.adimg(sort_code);
		
		request.setAttribute("adimg", adimg);
		
		String categoryName = pdao.categoryName(sort_code);
		
		request.setAttribute("categoryName", categoryName);
						
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product/prodList.jsp");
		
	}

}
