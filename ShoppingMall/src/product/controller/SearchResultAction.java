package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class SearchResultAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String searchWord = request.getParameter("searchWord");
		
		if(searchWord == null) {
			searchWord = "";
		}
		
		InterProductDAO_KJH pdao = new ProductDAO_KJH();
		
		List<ProductVO_KJH> productList = pdao.getSearchResult(searchWord);
		
		request.setAttribute("searchWord", searchWord);
		request.setAttribute("productList", productList);
		
		super.setViewPage("/WEB-INF/product/searchResult.jsp");
		
	}

}
