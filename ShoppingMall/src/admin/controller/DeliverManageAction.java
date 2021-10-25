package admin.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import member.model.MemberVO;
import order.model.InterOrderDAO;
import order.model.OrderDAO;
import util.paging.Pagination;

public class DeliverManageAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		if(checkLogin(request)) {
			
			InterOrderDAO odao = new OrderDAO();
			
			if("GET".equalsIgnoreCase(request.getMethod())) {
				
				HttpSession session = request.getSession();
				MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
				int grade = loginuser.getGrade();
				
				if(grade == 1) {
													
					// List<Map<String, Object>> orderListAll = odao.getOrderSetleList(null);
							
					String searchType = request.getParameter("searchType");
					String keyword = request.getParameter("keyword");
					String status = request.getParameter("status");
					String fromDate = request.getParameter("fromDate");
					String toDate = request.getParameter("toDate");
					
					int currPageNo = 0;				
					int sizePerPage = 10;
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
															
					Pagination pg = new Pagination();
					
					pg.setSizePerPage(sizePerPage);
					
					
					if(keyword == null) {
						keyword = "";
					}
					// 검색타입이 전체인 경우 검색해도 전체 사용자만 나오게끔
					if("all".equals(searchType) || keyword == "") {
						searchType = null;
						keyword = "";
					}				
					// 배송상태가 전체 검색인 경우 where절 삭제를 위함
					if("all".equals(status)) {
						status = null;
					}
					if("".equals(fromDate)) {
						fromDate = null;
					}
					if("".equals(toDate)) {
						toDate = null;
					}
					
					pg.setSearchType(searchType);
					pg.setKeyword(keyword);
					pg.setStatus(status);
					pg.setCurrPageNo(currPageNo);			
					pg.setFromDate(fromDate);
					pg.setToDate(toDate);
					
					
					int totalCnt = odao.getOrderSetleListCountAll(pg);
					pg.pageInfo(currPageNo, range, totalCnt);
					System.out.println("totalCnt" +  totalCnt);
					
					List<Map<String, Object>> orderrSetleListAll = odao.getOrderSetleListAll(pg);
					
					request.setAttribute("pagination", pg);
					request.setAttribute("orderrSetleListAll", orderrSetleListAll);
					request.setAttribute("searchType", searchType);
					request.setAttribute("keyword", keyword);
					request.setAttribute("status", status);
					request.setAttribute("fromDate", fromDate);
					request.setAttribute("toDate", toDate);
					
					super.setViewPage("/WEB-INF/views/admin/deliverManage.jsp");
					
				} else {		
					request.setAttribute("message", "관리자 전용 페이지입니다.");
					request.setAttribute("loc", "/");				
					setViewPage("/WEB-INF/msg.jsp");
				}
				
			} else {				
				// 배송 변경 처리
				
				String order_no = request.getParameter("order_no");
				String status = request.getParameter("status");
				
				int result = odao.updateDeliverStatus(order_no, status);
				JSONObject jsonObj = new JSONObject();
				
				if(result == 1)  {					
					jsonObj.put("success", "1");										
				} else {
					jsonObj.put("success", "0");
				}
				String json = jsonObj.toString();
				request.setAttribute("json", json);
				super.setViewPage("/WEB-INF/jsonview.jsp");
			}
					
		} else {
			
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/");
			super.setViewPage("/WEB-INF/msg.jsp");
		}

	}
 }

