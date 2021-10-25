package product.model;

public class ProductVO {
   
   private int sort_code;
   private String sort_name;
   private String prod_name;
   private String prod_exp;
   private int prod_price;
   private int discount_price = -9999;   
   private String prod_code;
   private int prod_ice;
   private int prod_plus;
   private int prod_select;
   private int prod_sale;
   private int prod_stock;
   
   public int getDiscount_price() {
	   return discount_price;
   }
   public void setDiscount_price(int discount_price) {
	   this.discount_price = discount_price;
   }
   public int getProd_stock() {
      return prod_stock;
   }
   public void setProd_stock(int prod_stock) {
      this.prod_stock = prod_stock;
   }
   public String getProd_code() {
      return prod_code;
   }
   public void setProd_code(String prod_code) {
      this.prod_code = prod_code;
   }
   public int getProd_ice() {
      return prod_ice;
   }
   public void setProd_ice(int prod_ice) {
      this.prod_ice = prod_ice;
   }
   public int getProd_plus() {
      return prod_plus;
   }
   public void setProd_plus(int prod_plus) {
      this.prod_plus = prod_plus;
   }
   public int getProd_select() {
      return prod_select;
   }
   public void setProd_select(int prod_select) {
      this.prod_select = prod_select;
   }
   public int getProd_sale() {
      return prod_sale;
   }
   public void setProd_sale(int prod_sale) {
      this.prod_sale = prod_sale;
   }
   public String getProd_name() {
      return prod_name;
   }
   public void setProd_name(String prod_name) {
      this.prod_name = prod_name;
   }
   public String getProd_exp() {
      return prod_exp;
   }
   public void setProd_exp(String prod_exp) {
      this.prod_exp = prod_exp;
   }
   public int getProd_price() {
      return prod_price;
   }
   public void setProd_price(int prod_price) {
      this.prod_price = prod_price;
   }
   public int getSort_code() {
      return sort_code;
   }
   public void setSort_code(int sort_code) {
      this.sort_code = sort_code;
   }
   public String getSort_name() {
      return sort_name;
   }
   public void setSort_name(String sort_name) {
      this.sort_name = sort_name;
   }
   
}
