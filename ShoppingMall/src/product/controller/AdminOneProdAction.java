package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class AdminOneProdAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String view = "/WEB-INF/product/adminOneProd.jsp";
		
		super.checkAdministration(request, view);
		
		if(view.equals(super.getViewPage())) {

			String prod_code = request.getParameter("one_prod_code");
			
			InterProductDAO_KJH pdao = new ProductDAO_KJH();
			
			Map<String,Object> prodMap = pdao.getAdminProdDetail(prod_code);
					
			if(prodMap.size() != 0) {
				
				request.setAttribute("prodMap", prodMap);
				
				ArrayList<String> titleImgList = (ArrayList<String>)prodMap.get("titleImgList");
				
				String titleImg = "";
				
				for(int i=0; i<titleImgList.size(); i++) {
					
					if(i != 0) titleImg += ",";
					
					titleImg += titleImgList.get(i);
					
				}
				
				request.setAttribute("titleImg", titleImg);
				
				ArrayList<String> detailImgList = (ArrayList<String>)prodMap.get("detailImgList");
				
				String detailImg = "";
				
				for(int i=0; i<detailImgList.size(); i++) {
					
					if(i != 0) detailImg += ",";
					
					detailImg += detailImgList.get(i);
					
				}
				
				request.setAttribute("detailImg", detailImg);
							
				// 모든 카테고리 가져오기
				super.getCategory(request);
				
				// 모든 상품 가져오기			
				List<ProductVO> prodList = pdao.AllProduct();
				
				request.setAttribute("prodList", prodList);
				
				// 상품 입고, 폐기 기록 가져오기
				List<InOutVO> inoutList = pdao.getInOutList(prod_code);
				
			//	System.out.println(inoutList.size());
				
				request.setAttribute("inoutList", inoutList);
				
				super.setRedirect(false);
								
			}
			
			else {
				String message = "존재하지 않는 상품입니다.";
		        String loc = "javascript:history.back()";
		         
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		         
		        super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
			}
			
		}
		
	}

}
