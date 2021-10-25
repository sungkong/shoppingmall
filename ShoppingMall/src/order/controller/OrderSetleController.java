package order.controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;
import order.model.*;

public class OrderSetleController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		

		// ===== Transaction 처리하기 ===== // 
        // 1. 주문 테이블에 입력되어야할 주문전표를 채번(select)하기 
         // 2. 주문 테이블에 채번해온 주문전표, 로그인한 사용자, 현재시각을 insert 하기(수동커밋처리)
        // 3. 주문상세 테이블에 채번해온 주문전표, 제품번호, 주문량, 주문금액을 insert 하기(수동커밋처리)
         // 4. 제품 테이블에서 제품번호에 해당하는 잔고량을 주문량 만큼 감하기(수동커밋처리) 
         // 5. 장바구니 테이블에서 cartnojoin 값에 해당하는 행들을 삭제(delete OR update)하기(수동커밋처리) 
         // 6. 회원 테이블에서 로그인한 사용자의 coin 액을 sumtotalPrice 만큼 감하고, point 를 sumtotalPoint 만큼 더하기(update)(수동커밋처리) 
        // 7. **** 모든처리가 성공되었을시 commit 하기(commit) **** 
        // 8. **** SQL 장애 발생시 rollback 하기(rollback) **** 
    
        // === Transaction 처리가 성공시 세션에 저장되어져 있는 loginuser 정보를 새로이 갱신하기 ===
        // === 주문이 완료되었을시 주문이 완료되었다라는 email 보내주기  === // 
		
		String method = request.getMethod();
		
		if(super.checkLogin(request)) {
		
		if("POST".equalsIgnoreCase(method)) {
		
			//input태그의 name들을 가져온다.
			 String order_no = request.getParameter("order_no"); 
	         String fk_user_id = request.getParameter("fk_user_id"); 
	         String user_name = request.getParameter("user_name"); 
	         String fk_prod_code = request.getParameter("fk_prod_code"); 
	         String prod_name = request.getParameter("prod_name"); 
	         String prod_price = request.getParameter("prod_price"); 
	         String goods_qy = request.getParameter("goods_qy"); 
	         String dscnt_amount = request.getParameter("dscnt_amount");
	         String tot_amount = request.getParameter("tot_amount"); 
	         String order_dt = request.getParameter("order_dt"); 
	         String user_req = request.getParameter("user_req"); 
	         String payment_type = request.getParameter("payment_type"); 
	        
	       
	         
	         OrderSetleVO ovo = new OrderSetleVO();
	         ovo.setOrder_no(order_no);
	         ovo.setFk_user_id(fk_user_id);
	         ovo.setUser_name(user_name);
	         ovo.setFk_prod_code(fk_prod_code);
	         ovo.setProd_name(prod_name);
	         ovo.setProd_price(Integer.parseInt(prod_price));
	         ovo.setGoods_qy(Integer.parseInt(goods_qy));
	         ovo.setDscnt_amount(Integer.parseInt(dscnt_amount));
	         ovo.setTot_amount(Integer.parseInt(tot_amount));
	         ovo.setOrder_dt(order_dt);
	         ovo.setUser_req(user_req);
	         ovo.setPayment_type(payment_type);
	         
	         
	         InterOrderDAO odao = new OrderDAO(); 
	         int n = odao.insertOrderSetle(ovo); // 메소드
		         
		     
		
		    if(n==1) { // 결제내역 테이블에 담기가 성공하면 주문내역페이지로 이동할 것이다.
   			   request.setAttribute("message", "결제가 성공되었습니다.");
               request.setAttribute("loc", "/mypage/orderlist.go");
               
               
	   		}
		    
	   		else { //실패하면 이전페이지로 이동
	                request.setAttribute("message", "결제가 실패되었습니다.");
	                request.setAttribute("loc", "javascript:history.back()"); 
	             }
	   		 
	   		//  super.setRedirect(false);   
	   			super.setViewPage("/WEB-INF/msg.jsp");
	   			
		}
		
		else {
    		
    		// GET 방식이라면 
              String message = "비정상적인 경로로 들어왔습니다";
              String loc = "javascript:history.back()";
               
              request.setAttribute("message", message);
              request.setAttribute("loc", loc);
              
           //  super.setRedirect(false);   
              super.setViewPage("/WEB-INF/msg.jsp");
    		
    		
    	}
		
		
		
		}  else {
			
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/member/login.go");
			setViewPage("/WEB-INF/msg.jsp");
			
		}
		
		
		
		
	}

}
