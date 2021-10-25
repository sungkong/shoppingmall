package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.InterProductDAO_KJH;
import product.model.ProductDAO_KJH;

public class AdManageAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String view = "/WEB-INF/product/adManage.jsp";
		
		super.checkAdministration(request, view);
		
		if(view.equals(super.getViewPage())) {
		
			InterProductDAO_KJH pdao = new ProductDAO_KJH();
			
			List<Map<String, Object>> bannerList =  pdao.allBanner();
			
			request.setAttribute("bannerList", bannerList);
		
		}
		
	}

}
