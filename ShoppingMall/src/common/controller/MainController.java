package common.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import order.model.InterOrderDAO;
import order.model.OrderDAO;
import product.model.InterProductDAO_KJH;
import product.model.ProductDAO_KJH;
import product.model.ProductVO_KJH;
import product.model.ReviewVO;

public class MainController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		InterProductDAO_KJH pdao = new ProductDAO_KJH();
		InterOrderDAO odao = new OrderDAO();
		
		// 배송비 설정
		Map<String, Object> deliverFeeSet = odao.getDeliverFee();
		request.getSession().setAttribute("deliverFeeSet", deliverFeeSet);
		// 배너리스트 파일명 select
		List<Map<String, String>> bannerList = pdao.getBannerList();
		
		request.setAttribute("bannerList", bannerList);
		
		// NEW 상품 4개 select
		List<ProductVO_KJH> newList = pdao.getNewList();
		
		request.setAttribute("newList", newList);
		
		// HIT 상품 4개 select
		List<ProductVO_KJH> hitList = pdao.getHitList();
		
		request.setAttribute("hitList", hitList);
		
		// BEST 상품 4개 select
		List<ProductVO_KJH> bestList = pdao.getBestList();
		
		request.setAttribute("bestList", bestList);
		
		// SALE 상품 4개 select
		List<ProductVO_KJH> saleList = pdao.getSaleList();
		
		request.setAttribute("saleList", saleList);
		
		// 최신 리뷰 4개 select
		List<ReviewVO> reviewList = pdao.getReviewList();
		
		request.setAttribute("reviewList", reviewList);
		
		super.setViewPage("/WEB-INF/views/main.jsp");
	}

}
