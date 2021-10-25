package product.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class ProductListAction_JDH extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		InterProductDAO_JDH pdao = new ProductDAO_JDH();
		
		String sort_code = request.getParameter("sort_code");
		
		List<HashMap<String, Object>> productList = pdao.productList(sort_code);
		
	//	ProductVO pvo = (ProductVO)productList.get(0).get("pvo");
		
	//	System.out.println(pvo.getDiscount_price());
		
		//int discount_price = pdao.discount_price();
		
		request.setAttribute("productList", productList);
		
		// System.out.println("확인용");
		
		InterProductDAO pdao2 = new ProductDAO();
		
		String adimg = pdao2.adimg(sort_code);
		
		request.setAttribute("adimg", adimg);
		
		String categoryName = pdao2.categoryName(sort_code);
		
		request.setAttribute("categoryName", categoryName);
						
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product/prodList.jsp");
		
	}

}
