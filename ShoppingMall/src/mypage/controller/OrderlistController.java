package mypage.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;
import util.paging.Pagination;

public class OrderlistController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
		   if(super.checkLogin(request)) {
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			
			InterOrderDAO odao = new OrderDAO();
			
			String userid = loginuser.getUserid();
			String status = request.getParameter("status");
			String fromDate = request.getParameter("fromDate");
			String toDate = request.getParameter("toDate");
			
			int currPageNo = 0;				
			int sizePerPage = 0;
			int range = 0;
			
			// 주소창에 GET 문자열 입력 방지
			try {
				currPageNo = Integer.parseInt(request.getParameter("currPageNo"));		
			} catch(Exception e) {
				currPageNo = 1;			
			}
			try {
				range = Integer.parseInt(request.getParameter("range"));		
			} catch(Exception e) {
				range = 1;			
			}
			
			// 처음 페이지 접속시 페이지번호와 페이지 범위 초기화
			if(currPageNo == 0) {
				currPageNo = 1;
			}
			if(range == 0) {
				range = 1;
			}
						
			if(sizePerPage == 0 || !(sizePerPage == 3 || sizePerPage == 5 || sizePerPage == 10  )) {
				sizePerPage = 5;
			}
			
			Pagination pg = new Pagination();
			
			pg.setSizePerPage(sizePerPage);
			
			// 전체 검색인 경우 where절 삭제를 위함
			if("all".equals(status)) {
				status = null;
			}
			if("".equals(fromDate)) {
				fromDate = null;
			}
			if("".equals(toDate)) {
				toDate = null;
			}
			
			pg.setStatus(status);
			pg.setCurrPageNo(currPageNo);			
			pg.setFromDate(fromDate);
			pg.setToDate(toDate);
			pg.setUserid(userid);
			
			
			int totalCnt = odao.getOrderSetleListCount(pg);
			pg.pageInfo(currPageNo, range, totalCnt);
			System.out.println("totalCnt" +  totalCnt);
			
			List<Map<String, Object>> orderList = odao.getOrderSetleList(pg);
			
			request.setAttribute("pagination", pg);
			request.setAttribute("orderList", orderList);
			request.setAttribute("status", status);
			request.setAttribute("fromDate", fromDate);
			request.setAttribute("toDate", toDate);
			super.setViewPage("/WEB-INF/views/mypage/orderlist.jsp");
			
		} else {
			
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/member/login.go");
			super.setViewPage("/WEB-INF/msg.jsp");
			return;
		}
		
		
	}

}
