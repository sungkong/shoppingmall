package order.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;

import order.model.*;

public class OrderSetleEndAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//String method = request.getMethod();
		
		
		
		//if(super.checkLogin(request)) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String userid = loginuser.getUserid();
			
		//if("POST".equalsIgnoreCase(method)) {
			
		
		String fk_user_id = request.getParameter("fk_user_id");
		String user_name = request.getParameter("user_name");
		String totalAmount = request.getParameter("totalAmount");
		String totalPoint = request.getParameter("totalPoint");
		String user_req = request.getParameter("omessage");
		//paymenttype은 아직 미완성
		
		
		String prod_name_join = request.getParameter("prod_name");
		String price_join = request.getParameter("price");
		String goods_qy_join = request.getParameter("goods_qy");
		String fk_prod_code_join = request.getParameter("fk_prod_code");
		String basket_no_join = request.getParameter("basket_no");
		
		///////////////////////////////////////////
		String[] prod_name_Arr = prod_name_join.split(",");
		String[] price_Arr = price_join.split(",");
		String[] goods_qy_Arr = goods_qy_join.split(",");
		String[] fk_prod_code_Arr = fk_prod_code_join.split(",");
		//String[] basket_no_Arr = basket_no_join.split(",");
		String usedPoint = request.getParameter("usedPoint");
		
		for(int i=0; i<prod_name_Arr.length; i++) {
			System.out.println("~~~~ 확인용 prod_name : " + prod_name_Arr[i] + ", price : " + price_Arr[i] + ", goods_qy : " + goods_qy_Arr[i]+ ", fk_prod_code : " + fk_prod_code_Arr[i]);   
		}
		
		System.out.println("~~~~ 확인용 user_name : " + user_name + ", fk_user_id : " + fk_user_id+ totalAmount+ totalPoint+ user_name+ user_req);
		
		///////////////////////////////////////////////////////////////////////////
		
		// 1. 주문 테이블에 insert 하기(수동커밋처리)					

        // 2. 제품잔고? 테이블에서 제품번호에 해당하는 잔고량을 주문량 만큼 감하기(수동커밋처리) 

        // 3. 장바구니 테이블에서 주문한 행들을 삭제(delete OR update)하기(수동커밋처리) 

        // 4. 회원 테이블에서 로그인한 사용자의 총 적립금 point 를 더하기(update)(수동커밋처리)	 

        // 5. **** 모든처리가 성공되었을시 commit 하기(commit) **** 

        // 6. **** SQL 장애 발생시 rollback 하기(rollback) **** 
		
		
		 InterOrderDAO odao = new OrderDAO();
         HashMap<String, Object> paraMap = new HashMap<>();
		
		
         
         // 주문 테이블에 insert
         paraMap.put("fk_user_id", fk_user_id);
         paraMap.put("user_name", user_name); 
         paraMap.put("totalAmount", totalAmount);//총 가격
         paraMap.put("totalPoint", totalPoint); //총 적립금
         paraMap.put("user_req ", user_req);
         
         paraMap.put("prod_name_Arr", prod_name_Arr); //상품명이 들어간 배열
         paraMap.put("price_Arr", price_Arr); // 상품별 가격이 들어간 배열
         paraMap.put("goods_qy_Arr", goods_qy_Arr); //주문량들이 들어간 배열
         paraMap.put("fk_prod_code_Arr", fk_prod_code_Arr); //상품코드들이 들어간 배열
                 
         // 장바구니 테이블에 delete
          paraMap.put("basket_no_join", basket_no_join);
         // 특정제품을 바로주문하기를 한 경우라면 basket_no_join 의 값은 null 이 된다. 
       
         // 주문 테이블에 insert
         paraMap.put("userid", loginuser.getUserid()); //파라맵에 로그인한 유저 아이디를 넣음 //누가 주문했는지 알아오기위해서 로그인한 유저 아이디를 알아온 것이다
         paraMap.put("usedPoint", usedPoint);
         
		
         // !!!! Transaction 처리를 해주는 메소드 !!!! 
         int isSuccess = odao.orderSetleAdd(paraMap); // Transaction 처리를 해주는 메소드  //성공하면 isSuccess에 1값을 줄 것이다.
        
         if(isSuccess == 1) {       	 
        	 super.setRedirect(true);       	 
        	 super.setViewPage("/mypage/orderlist.go");
         }
         else {
        	// 주문이 실패할 경우
             String message = "주문이 실패되었습니다.";
             String loc = "javascript:history.back()";
              
             request.setAttribute("message", message);
             request.setAttribute("loc", loc);
             
          // super.setRedirect(false);   
             super.setViewPage("/WEB-INF/msg.jsp");
         }
         
   	 
	}

}
