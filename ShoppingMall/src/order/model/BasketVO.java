package order.model;

import product.model.ProductVO;

public class BasketVO {

	private int basketNo;
	private String userid;
	private String prod_code;
	private int goods_qy;
	
	private ProductVO productVo;
	
	public int getBasketNo() {
		return basketNo;
	}
	public void setBasketNo(int basketNo) {
		this.basketNo = basketNo;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getProd_code() {
		return prod_code;
	}
	public void setProd_code(String prod_code) {
		this.prod_code = prod_code;
	}
	public int getGoods_qy() {
		return goods_qy;
	}
	public void setGoods_qy(int goods_qy) {
		this.goods_qy = goods_qy;
	}
	
	
}
