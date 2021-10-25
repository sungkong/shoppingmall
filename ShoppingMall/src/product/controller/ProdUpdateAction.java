package product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import product.model.*;

public class ProdUpdateAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
				
		if("POST".equalsIgnoreCase(request.getMethod())) {
		
			String view = "checkAdmin";
			
			super.checkAdministration(request, view);
			
			if(view.equals(super.getViewPage())) {				
			
				Map<String, Object> paraMap = new HashMap<>();
				
				ProductVO prod = new ProductVO();
				
				String prod_code = request.getParameter("prod_code");
				
				prod.setProd_code(prod_code);
				
				// 카테고리 신규 입력 시 map에 따로 넣어주기
				if(request.getParameter("add_sort_name") != null && 
				   request.getParameter("add_sort_name").trim() != "") {
									
					paraMap.put("sort_name", request.getParameter("add_sort_name"));
					
				}
				
				// 기존에 존재하는 카테고리 선택 시 카테고리 코드만 ProductVO에 넣어주기
				else
					prod.setSort_code(Integer.parseInt(request.getParameter("sort_code")));
							
				prod.setProd_name(request.getParameter("prod_name"));
				
				// 상품설명이 있으면 넣어주기
				if(request.getParameter("prod_exp") != null &&
				   request.getParameter("prod_exp").trim() != "") {
					
					prod.setProd_exp(request.getParameter("prod_exp").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
				}
				
				prod.setProd_price(Integer.parseInt(request.getParameter("prod_price")));
				
				// 할인가격이 있으면 넣어주기
				if(request.getParameter("discount_price") != null &&
				   request.getParameter("discount_price").trim() != "") {
					
					prod.setDiscount_price(Integer.parseInt(request.getParameter("discount_price")));
				}
				
	
				prod.setProd_ice(Integer.parseInt(request.getParameter("prod_ice")));
				
				prod.setProd_plus(Integer.parseInt(request.getParameter("prod_plus")));
				
				// 추가구성상품이 있을 경우 리스트에 담아주기
				if(prod.getProd_plus() == 1) {
					
					String[] arr_prod_plus_code = request.getParameterValues("prod_plus_code");
					
					List<String> prod_plus_list = new ArrayList<> ();
					
					for(String prod_plus_code : arr_prod_plus_code) {
						prod_plus_list.add(prod_plus_code);
					}
					
					paraMap.put("prod_plus_list", prod_plus_list);
					
				}
				
				prod.setProd_select(Integer.parseInt(request.getParameter("prod_select")));
				
				// 골라담기가 있을 경우 리스트에 담아주기
				if(prod.getProd_select() != 0) {
					
					String[] arr_prod_select_code = request.getParameterValues("prod_select_code");
					
					List<String> prod_select_list = new ArrayList<> ();
					
					for(String prod_select_code : arr_prod_select_code) {
						prod_select_list.add(prod_select_code);
					}
					
					paraMap.put("prod_select_list", prod_select_list);
					
					prod.setProd_select(Integer.parseInt(request.getParameter("selectCnt")));
									
				}
				
				prod.setProd_sale(Integer.parseInt(request.getParameter("prod_sale")));
				
				paraMap.put("prod", prod);
				
				InterProductDAO pdao = new ProductDAO();
				
				int result = pdao.updateProd(paraMap);
				
			//	System.out.println(request.getParameter("titlefile") + "////" + request.getParameter("detailfile"));
				
				if(request.getParameter("titlefile").trim() != "") {
	
					// 타이틀이미지가 여러 개일 경우 리스트로 만들어 넣어주기
					String s_titlefile = request.getParameter("titlefile");
								
					String[] arr_titlefile = s_titlefile.split(",");
					
					List<String> titleimglist = new ArrayList<>();
					
					for(String titlefile : arr_titlefile) {				
						titleimglist.add(titlefile);				
					}
					
					result = pdao.updateTitle(titleimglist, prod_code);
					
				}
				
				if(request.getParameter("detailfile").trim() != "") {
					
					// 상세이미지가 여러 개일 경우 리스트로 만들어 넣어주기
					String s_detailfile = request.getParameter("detailfile");
					
					String[] arr_detailfile = s_detailfile.split(",");
					
					List<String> detailimglist = new ArrayList<>();
					
					for(String detailfile : arr_detailfile) {				
						detailimglist.add(detailfile);				
					}
					
					result = pdao.updateDetail(detailimglist, prod_code);
					
				}
							
				if(result == 0) {
					request.setAttribute("message", "SQL구문 오류 발생");
					request.setAttribute("loc", "javascript:history.back()");
					
					super.setViewPage("/WEB-INF/msg.jsp");
				}
				
				else {
					request.setAttribute("message", "변경하신 상품정보가 저장되었습니다.");
					request.setAttribute("loc", "/product/adminOneProd.go?one_prod_code=" + prod_code); 
					
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
