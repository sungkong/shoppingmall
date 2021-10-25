package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.*;
import product.model.*;

public class ProductManageAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
		// 관리자로 로그인했을 경우에만 조회가능	
		 HttpSession session = request.getSession();
		
		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		 if(loginuser != null && "admin".equals(loginuser.getUserid())) {
			
			InterProductDAO_JDH pdao = new ProductDAO_JDH();
			
			Map<String, String> searchMap = new HashMap<>();
			
			String searchType = request.getParameter("searchType"); // 카테고리랑 상품명으로 검색가능
			String searchWord = request.getParameter("searchWord"); // 찾을 상품 검색어
			
			if(searchType == null || searchType == "") {
				searchType = "";
			}
			if(searchWord == null || searchWord == "") {
				searchWord = "";
			}
						
			searchMap.put("searchType", searchType);
			searchMap.put("searchWord", searchWord);
			System.out.println(searchType +","+searchWord);
			String orderbyType = request.getParameter("orderbyType");
			
			if(orderbyType == null || orderbyType == ""  ) {
				orderbyType = "prod_date";
			}			
			
			searchMap.put("orderbyType", orderbyType);
						
			
			List<HashMap<String, Object>> sProductList = pdao.selectOrderbyProd(searchMap);
			
			// System.out.println(sProductList.size());
			
			request.setAttribute("sProductList", sProductList);
			request.setAttribute("orderbyType", orderbyType);
			
			request.setAttribute("searchType", searchType);
			request.setAttribute("searchWord", searchWord);
			
			
			super.getCategory(request);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/product/prodManage.jsp");
			
			
			
			
		 }
			
		
		 else {
			// 로그인을 안한 경우 또는 일반사용자로 로그인 한 경우
			String message = "관계자 외 출입금지";
	        String loc = "javascript:history.back()";
	         
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	         
	        // super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
		}
		
			
			/////////////////////////////
			
		}	
	}// end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {}
		
			
			
		
		
			
			
			
			
			
			
			
			
			
		
		

