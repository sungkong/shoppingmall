package order.model;

import java.util.Date;

public class OrderSetleVO {
	
	   private String order_no;             // 주문번호
	   private String fk_user_id;           // 아이디
	   private String user_name;            // 회원명
	   private String fk_prod_code;         // 상품코드
	   private String prod_name;            // 상품명
	   private int prod_price;              // 상품가격
	   private int goods_qy;                // 주문량
	   private int dscnt_amount;            // 할인금액
	   private int tot_amount;				// 총 결제 금액
	   private String order_dt;				// 주문날짜
	   private String user_req;				// 배송 메세지
	   private String payment_type;			// 결제방식
	   private String status; 				// 상태
	   
	   
	   public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public OrderSetleVO() {}
	   
	   public OrderSetleVO(String order_no, String fk_user_id, String user_name,
			   			   String fk_prod_code, String prod_name, int prod_price,
			   			   int goods_qy, int dscnt_amount, int tot_amount,
			   			   String order_dt, String user_req, String payment_type) {
		   
		   this.order_no = order_no;
		   this.fk_user_id = fk_user_id;
		   this.user_name = user_name;
		   this.fk_prod_code = fk_prod_code;
		   this.prod_name = prod_name;
		   this.prod_price = prod_price;
		   this.goods_qy = goods_qy;
		   this.dscnt_amount = dscnt_amount;
		   this.tot_amount = tot_amount;
		   this.order_dt = order_dt;
		   this.user_req = user_req;
		   this.payment_type = payment_type;
		   
	   }
	   
	   
	   
	public String getOrder_no() {
		return order_no;
	}
	
	public void setOrder_no(String order_no) {
		this.order_no = order_no;
	}
	
	public String getFk_user_id() {
		return fk_user_id;
	}
	
	public void setFk_user_id(String fk_user_id) {
		this.fk_user_id = fk_user_id;
	}
	
	public String getUser_name() {
		return user_name;
	}
	
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	
	public String getFk_prod_code() {
		return fk_prod_code;
	}
	
	public void setFk_prod_code(String fk_prod_code) {
		this.fk_prod_code = fk_prod_code;
	}
	
	public String getProd_name() {
		return prod_name;
	}
	
	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
	
	public int getProd_price() {
		return prod_price;
	}
	
	public void setProd_price(int prod_price) {
		this.prod_price = prod_price;
	}
	
	public int getGoods_qy() {
		return goods_qy;
	}
	
	public void setGoods_qy(int goods_qy) {
		this.goods_qy = goods_qy;
	}
	
	public int getDscnt_amount() {
		return dscnt_amount;
	}
	
	public void setDscnt_amount(int dscnt_amount) {
		this.dscnt_amount = dscnt_amount;
	}
	
	public int getTot_amount() {
		return tot_amount;
	}
	
	public void setTot_amount(int tot_amount) {
		this.tot_amount = tot_amount;
	}
	
	public String getOrder_dt() {
		return order_dt;
	}
	
	public void setOrder_dt(String order_dt) {
		this.order_dt = order_dt;
	}
	
	public String getUser_req() {
		return user_req;
	}
	
	public void setUser_req(String user_req) {
		this.user_req = user_req;
	}
	
	public String getPayment_type() {
		return payment_type;
	}
	
	public void setPayment_type(String payment_type) {
		this.payment_type = payment_type;
	}
	   
	///////////////////////////////////////////////
	/* 상품 하나당 적립되는 적립금 구하기 (페이징 처리를 한 회원 한명의 적립금 내역 보여주기 메소드에서 사용함)*/
	private int addpoint;         // 상품가격의 1%

	public void setAddpoint(int prod_price) {
		addpoint = (int) (prod_price*0.01);
	}
	   
	public int getAddpoint() {
		return addpoint;
	}
	////////////////////////////////////////////// 
	   
}
