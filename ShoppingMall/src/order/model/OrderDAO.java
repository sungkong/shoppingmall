package order.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import util.paging.Pagination;

public class OrderDAO implements InterOrderDAO {

	
	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 기본 생성자
	public OrderDAO() {
		
		// ++++++++++++++++++++ 커넥션 풀 가져오기 ++++++++++++++++++++ //
		try {
			
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/semioracle");
		 /*   
		    if(ds == null) 
		    	System.out.println("아이구 null이네~~~~");
		    else
		    	System.out.println("휴 null이 아니네~~~~");
		 */
		    
		} catch (NamingException e) {
			e.printStackTrace();
		} 
		
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	
	// 사용한 자원을 반납하는 close() 메소드 생성하기 
	private void close() {
		try {
			
			if(rs != null)    {rs.close();    rs=null;}
			if(pstmt != null) {pstmt.close(); pstmt=null;}
			if(conn != null)  {conn.close();  conn=null;}
			
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	// 장바구니 테이블  insert
	   @Override
	   public int insertBasket(Map<String, Object> paraMap) throws SQLException {
	      
	      int result = 0;
	      
	      try {
	         
	         conn = ds.getConnection();
	                  
	         String[] arrProd_code = (String[]) paraMap.get("arrProd_code");
	         String[] goods_qyAmount = (String[]) paraMap.get("goods_qyAmount");
	         String userid = (String) paraMap.get("userid");
	         
	         for(int i=0; i<arrProd_code.length; i++) {            

	            String sql = " insert into tbl_basket(BASKET_NO, FK_USER_ID, FK_PROD_CODE, GOODS_QY) " + 
	                      " values(BASKET_NO.nextval, ?, ?, ?) ";
	            
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setString(1, userid);
	            pstmt.setString(2, arrProd_code[i]);
	            pstmt.setString(3, goods_qyAmount[i]);
	            
	            result = pstmt.executeUpdate();            
	            
	         }
	         
	      } catch (Exception e){
	    	  e.printStackTrace();
	      } finally {
	         close();
	      }
	      
	      return result;
	      
	   }

	@Override
	public List<Map<String, Object>> getBasketList(String userid) throws SQLException {
		
		List<Map<String, Object>> basketList = new ArrayList<>();
	      
	      try {
	    	  
	    	  conn = ds.getConnection();
	    	  
	    	  String sql = "select b.basket_no, v.prod_img_url, v.prod_exp, v.prod_price, v.discount_price, b.goods_qy, v.prod_stock, v.prod_code, v.prod_name "
	    		  	  	+ "from view_prodonedetail v, tbl_basket b "
	    	  			+ "where b.fk_user_id=? and b.fk_prod_code = v.prod_code";	                
	    	 
	    	  pstmt = conn.prepareStatement(sql);
	            
	          pstmt.setString(1, userid);
	    	  rs = pstmt.executeQuery();
	          
	    	  while(rs.next()) {
	        	Map<String, Object> basket = new HashMap<>();	        	
	            basket.put("basket_no", rs.getInt(1));
	            basket.put("prod_img_url", rs.getString(2));
	            basket.put("prod_exp", rs.getString(3));	            
	            basket.put("prod_price", rs.getInt(4));
	            basket.put("discount_price", rs.getInt(5));
	            basket.put("goods_qy", rs.getInt(6));
	            basket.put("prod_stock", rs.getInt(7));
	            basket.put("prod_code", rs.getString(8));
	            basket.put("prod_name", rs.getString(9));
	            
	            basketList.add(basket);
	         }
	         
	      } catch (Exception e){
	    	  e.printStackTrace();
	      } finally {
	         close();
	      }
	      
	      return basketList;
	}

	// 재고 가져오기
	@Override
	public int getProdStock(String prod_code) throws SQLException {
	
		int prod_stock = 0;
	      
	      try {
	         
 	          conn = ds.getConnection();
	            
              String sql = "SELECT prod_stock " 
                        + "FROM view_prodonedetail WHERE prod_code = ? ";
             
              pstmt = conn.prepareStatement(sql);
             
              pstmt.setString(1, prod_code);
       
            
              rs = pstmt.executeQuery();            
	          while(rs.next()) {
	         	 prod_stock = rs.getInt(1);
	          }
	        
	         
	         
	       } catch (Exception e){
		    	  e.printStackTrace();
		   } finally {
	          close();
	       }
	      
	       return prod_stock;
	}

	@Override
	public int deleteBasket(int basket_no) throws SQLException {
		
		int result = 0;
	      
	      try {
	         
	         conn = ds.getConnection();
	                  
	              
            String sql = "DELETE FROM tbl_basket " 
                       + "WHERE basket_no = ? ";
           
            pstmt = conn.prepareStatement(sql);         
            pstmt.setInt(1, basket_no);
      
         
            result = pstmt.executeUpdate();            
	                 
	      } catch (Exception e){
	    	  e.printStackTrace();
	      } finally {
	         close();
	      }
	      
	      return result;
	}

	@Override
	public int updateBasket(Map<String, Object> paraMap) throws SQLException {
		
		int result = 0;
	      
	      try {
	         
	         conn = ds.getConnection();
	                  
	         String[] basket_no_arr = (String[]) paraMap.get("basket_no_arr");
	         String[] goods_qy_arr = (String[]) paraMap.get("goods_qy_arr");
	         String userid = (String) paraMap.get("userid");
	         
	         for(int i=0; i<basket_no_arr.length; i++) {            

	            String sql = "UPDATE tbl_basket SET GOODS_QY = ? " 
	            		   + "WHERE BASKET_NO = ? and FK_USER_ID = ? ";
	                      	            
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setInt(1, Integer.parseInt(goods_qy_arr[i]));
	            pstmt.setInt(2, Integer.parseInt(basket_no_arr[i]));	            
	            pstmt.setString(3, userid);
	            
	            result = result + pstmt.executeUpdate();            
	            
	         }
	         
	      } catch (Exception e){
	    	  e.printStackTrace();
	      } finally {
	         close();
	      }
	      
	      return result;
	}

	@Override
	public List<Map<String, Object>> getBasketByBno(String[] basket_no_arr, String userid) throws SQLException {
		
		List<Map<String, Object>> basketList = new ArrayList<>();
	      
	      try {
	    	  
	    	  conn = ds.getConnection();
	    	  
	    	  for(int i=0; i<basket_no_arr.length; i++) {
	    		  
	    		  String sql = "select b.basket_no, v.prod_img_url, v.prod_exp, v.prod_price, v.discount_price, b.goods_qy, v.prod_stock, v.prod_name, v.prod_code "
		    		  	     + "from view_prodonedetail v, tbl_basket b "
		    	  			 + "where b.basket_no = ? and b.fk_user_id = ? and b.fk_prod_code = v.prod_code";	               
		    	 
		    	  pstmt = conn.prepareStatement(sql);
		            
		          pstmt.setInt(1, Integer.parseInt(basket_no_arr[i]));
		          pstmt.setString(2, userid);
		    	  rs = pstmt.executeQuery();
		          
		    	  while(rs.next()) {
		        	Map<String, Object> basket = new HashMap<>();	        	
		            basket.put("basket_no", rs.getInt(1));
		            basket.put("prod_img_url", rs.getString(2));
		            basket.put("prod_exp", rs.getString(3));	            
		            basket.put("prod_price", rs.getInt(4));
		            basket.put("discount_price", rs.getInt(5));
		            basket.put("goods_qy", rs.getInt(6));
		            basket.put("prod_stock", rs.getInt(7));
		            basket.put("prod_name", rs.getString(8));
		            basket.put("prod_code", rs.getString(9));
		            
		            basketList.add(basket);
		         }
		    	  
	    	  }
	    	           
	      } catch (Exception e){
	    	  e.printStackTrace();
	      } finally {
	         close();
	      }
	      
	      return basketList;
	}

	@Override
	public List<Map<String, Object>> getProdInfoByPno(String[] arrProd_code, String[] goods_qyAmount) throws SQLException {
		
		List<Map<String, Object>> prodList = new ArrayList<>();
	      
	      try {
	    	  
	    	  conn = ds.getConnection();
	    	  
	    	  for(int i=0; i<arrProd_code.length; i++) {
	    		  
	    		  String sql = "select prod_img_url, prod_exp, prod_price, discount_price, prod_stock, prod_name, prod_code "
	    		  			 + "from view_prodonedetail "
	    		  			 + "where prod_code = ? ";             
		    	 
		    	  pstmt = conn.prepareStatement(sql);
		            
		          pstmt.setString(1, arrProd_code[i]);
		    	  rs = pstmt.executeQuery();
		          
		    	  while(rs.next()) {
		    		  
		        	Map<String, Object> product = new HashMap<>();	        	
		            product.put("prod_img_url", rs.getString(1));
		            product.put("prod_exp", rs.getString(2));	            
		            product.put("prod_price", rs.getInt(3));
		            product.put("discount_price", rs.getInt(4));
		            product.put("prod_stock", rs.getInt(5));
		            product.put("goods_qy", Integer.parseInt(goods_qyAmount[i]));
		            product.put("prod_name", rs.getString(6));
		            product.put("prod_code", rs.getString(7));
		            
		            prodList.add(product);
		         }
		    	  
	    	  }
	    	           
	      } catch (Exception e){
	    	  e.printStackTrace();
	      } finally {
	         close();
	      }
	      
	      return prodList;
	}

	@Override
	public int updateBasketByProdCode(Map<String, Object> paraMap) throws SQLException {
		
		  int result = 0;
	      
	      try {
	         
	         conn = ds.getConnection();
	                  
	         String[] prod_code_arr = (String[]) paraMap.get("prod_code_arr");
	         String[] goods_qy_arr = (String[]) paraMap.get("goods_qy_arr");
	         String userid = (String) paraMap.get("userid");
	         
	         for(int i=0; i<prod_code_arr.length; i++) {            

	            String sql = "UPDATE tbl_basket SET GOODS_QY = GOODS_QY + ? " 
	            		   + "WHERE FK_PROD_CODE = ? and FK_USER_ID = ? ";
	                      	            
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setInt(1, Integer.parseInt(goods_qy_arr[i]));
	            pstmt.setString(2, prod_code_arr[i]);	            
	            pstmt.setString(3, userid);
	            
	            result = result + pstmt.executeUpdate();            
	            
	         }
	         
	      } catch (Exception e){
	    	  e.printStackTrace();
	      } finally {
	         close();
	      }
	      
	      return result;
	      
	}
	
	//주문목록 테이블에 insert하는 메소드
		@Override
		public int insertOrderSetle(OrderSetleVO ovo) throws SQLException {
			int n = 0;
			
			try {
				
		         conn = ds.getConnection();
		         
		         String sql = " insert into order_setle(order_no, fk_user_id , user_name " + 
		         			  "                       , fk_prod_code, prod_name, prod_price  " + 
		         			  "                       , goods_qy, dscnt_amount , tot_amount " + 
		         			  "                       , order_dt, user_req, payment_type) " +  
		                      " values(order_no.nextval,?,?,?,?,?,?,?,?,default,?,?)";
		         
		         pstmt = conn.prepareStatement(sql);
		         
		         pstmt.setString(1, ovo.getFk_user_id()); 
		         pstmt.setString(2, ovo.getUser_name());
		         pstmt.setString(3, ovo.getFk_prod_code());
		         pstmt.setString(4, ovo.getProd_name());
		         pstmt.setInt(5, ovo.getProd_price());
		         pstmt.setInt(6, ovo.getGoods_qy());
		         pstmt.setInt(7, ovo.getDscnt_amount());
		         pstmt.setInt(8, ovo.getTot_amount());
		         pstmt.setString(9, ovo.getOrder_dt());
		         pstmt.setString(10, ovo.getUser_req());
		         pstmt.setString(11, ovo.getPayment_type());
		         
		         n = pstmt.executeUpdate();
		         
		      } finally {
		         close();
		      }
		      		
			return n;
		}

		@Override
		public List<Map<String, Object>> getOrderSetleList(Pagination pg) throws SQLException {
			
			List<Map<String, Object>> orderSetleList = new ArrayList<>();
			
			String userid = pg.getUserid();
		    String status = pg.getStatus();
		    String fromDate = pg.getFromDate();
		    String toDate = pg.getToDate();
						
			try {
				conn = ds.getConnection();
				String sql = "select order_dt, PROD_IMG_URL, PROD_EXP, GOODS_QY, TOT_AMOUNT, status, prod_code, order_no, prod_name "
						   + "from "
						   + "    ( "
						   + "    select rownum as RNUM, t.* "
						   + "    from "
					   	   + "        ( "
						   + "        select o.order_dt, v.PROD_IMG_URL, v.PROD_EXP, o.GOODS_QY, o.TOT_AMOUNT, o.status, v.prod_code, o.order_no, o.prod_name "
						   + "        from ORDER_SETLE o, VIEW_PRODONEDETAIL v "
						   + "        where o.fk_user_id = ? "
						   + "        and o.fk_prod_code = v.prod_code ";
				if(status != null) {
					   sql += "and status = ? ";
				}
				if(fromDate != null && toDate != null) {
			    	   sql += "and o.order_dt between to_date(?,'YYYY-MM-DD') and to_date(?,'YYYY-MM-DD') ";
			    }	   
					   sql += "        order by order_dt desc "
						   + "        ) t "
						   + "    where rownum <= ? "
						   + "    ) "
						   + "where ? <= RNUM";
				
				pstmt = conn.prepareStatement(sql);
				
		
				int currPageNo = pg.getCurrPageNo();
				int sizePerPage = pg.getSizePerPage();
							
				pstmt.setString(1, userid);
				// 검색타입이 존재하는 경우
				if(status != null) {
					pstmt.setString(2, status);
					// 검색 기한이 존재하는 경우
					if(fromDate != null && toDate != null) {
						pstmt.setString(3, fromDate);
						pstmt.setString(4, toDate);
						pstmt.setInt(5, currPageNo * sizePerPage );
						pstmt.setInt(6, pg.getStartList() );
				    } else {
				    	pstmt.setInt(3, currPageNo * sizePerPage );
						pstmt.setInt(4, pg.getStartList() );
				    }
				} else { // 검색타입이 없는 경우
					// 검색타입은 없지만 검색기간은 있는 경우
					if(fromDate != null && toDate != null) {
						pstmt.setString(2, fromDate);
						pstmt.setString(3, toDate);
						pstmt.setInt(4, currPageNo * sizePerPage );
						pstmt.setInt(5, pg.getStartList() );
				    } else {
				    	pstmt.setInt(2, currPageNo * sizePerPage );
						pstmt.setInt(3, pg.getStartList() );
				    }
				}
		
							
				rs = pstmt.executeQuery();					
				while(rs.next()) {
					Map<String, Object> order = new HashMap<>();
					order.put("order_dt", rs.getDate(1));
					order.put("prod_img_url", rs.getString(2));
					order.put("prod_exp", rs.getString(3));
					order.put("goods_qy", rs.getInt(4));
					order.put("tot_amount", rs.getInt(5));
					order.put("status", rs.getString(6));
					order.put("prod_code", rs.getString(7));
					order.put("order_no", rs.getString(8));
					order.put("prod_name", rs.getString(9));
					
					orderSetleList.add(order);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				close();
			}
			
			return orderSetleList;
		}

		@Override
		public int getOrderSetleListCount(Pagination pg) throws SQLException {
			
			int result = 0;
		    String userid = pg.getUserid();
		    String status = pg.getSearchType();
		    String fromDate = pg.getFromDate();
		    String toDate = pg.getToDate();
			
			try {
				conn = ds.getConnection();
				String sql = "select count(*)  "
						   + "from ORDER_SETLE o, VIEW_PRODONEDETAIL v "
						   + "where o.fk_user_id = ? ";
				if(status != null) {
					   sql += "and status = ? ";
				}					  
					   sql += "and o.fk_prod_code = v.prod_code ";
					   
			    if(fromDate != null && toDate != null) {
			    	   sql += "and o.order_dt between to_date(?,'YYYY-MM-DD') and to_date(?,'YYYY-MM-DD') ";
			    }
						   
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, userid);
				
				// 검색타입이 존재하는 경우
				if(status != null) {
					pstmt.setString(2, status);
					// 검색 기한이 존재하는 경우
					if(fromDate != null && toDate != null) {
						pstmt.setString(3, fromDate);
						pstmt.setString(4, toDate);
				    } 
				} else { // 검색타입이 없는 경우
					// 검색타입은 없지만 검색기간은 있는 경우
					if(fromDate != null && toDate != null) {
						pstmt.setString(2, fromDate);
						pstmt.setString(3, toDate);
				    }
				}
									
				rs = pstmt.executeQuery();
				rs.next();
				result = rs.getInt(1);
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				close();
			}
			
			return result;
		}

		@Override
		public Map<String, Object> getDeliverFee() throws SQLException {
			
			Map<String, Object> paraMap = new HashMap<>();
		      
		    try {
		         
	 	        conn = ds.getConnection();
	 	        String sql = "SELECT fee, freeline from tbl_deliverfee ";
	 	        
	 	        pstmt = conn.prepareStatement(sql);
	 	        rs = pstmt.executeQuery();
	 	        rs.next();
	 	        paraMap.put("fee", rs.getInt(1));
	 	        paraMap.put("freeline", rs.getInt(2));
	 	        	 	    
		    } catch (Exception e) {
				e.printStackTrace();
			} finally {
				close();
			}
		    
		    return paraMap;
		}

		@Override
		public int updateDeliverFee(int fee, int freeline) throws SQLException {
			
			int result = 0;
		      
		    try {
		         
	 	        conn = ds.getConnection();
	 	        String sql = "UPDATE tbl_deliverfee SET fee = ?, freeline = ? ";
	 	        
	 	        pstmt = conn.prepareStatement(sql);
	 	        pstmt.setInt(1, fee);
	 	        pstmt.setInt(2, freeline);
	 	        
	 	        result = pstmt.executeUpdate();
	 	        
		    } catch (Exception e) {
				e.printStackTrace();
			} finally {
				close();
			}
		    
		    return result;
		}

		@Override
		public List<Map<String, Object>> getOrderSetleListAll(Pagination pg) throws SQLException {
			
			List<Map<String, Object>> orderSetleListAll = new ArrayList<>();
			String searchType = pg.getSearchType();
		    String keyword = pg.getKeyword();
		    String status = pg.getStatus();
		    String fromDate = pg.getFromDate();
		    String toDate = pg.getToDate();
		    		    
		    int currPageNo = pg.getCurrPageNo();
			int sizePerPage = pg.getSizePerPage();
			
			if("userid".equals(searchType)) {
				searchType = "o.fk_user_id";
			} else if("name".equals(searchType)) {
				searchType = "o.user_name";
			}
			
			try {
				conn = ds.getConnection();
				String sql = "select order_dt, PROD_IMG_URL, PROD_EXP, GOODS_QY, TOT_AMOUNT, status, prod_code, fk_user_id, user_name, order_no, prod_name  "
						   + "from "
						   + "    ( "
						   + "    select rownum as RNUM, t.* "
						   + "    from "
					   	   + "        ( "
						   + "			select o.order_dt, v.PROD_IMG_URL, v.PROD_EXP, o.GOODS_QY, o.TOT_AMOUNT, o.status, v.prod_code, o.fk_user_id, o.user_name, o.order_no, o.prod_name "	
						   + "			from ORDER_SETLE o, VIEW_PRODONEDETAIL v "
						   + "			where 1=1 ";
								
				if(searchType != null && keyword != "" && !keyword.trim().isEmpty()) {
					   sql += "			and " + searchType + " like '%'|| ? ||'%' ";
				}
				if(status != null) {
					   sql += "			and status = ? ";
				}					  
					   sql += "			and o.fk_prod_code = v.prod_code ";
					   
			    if(fromDate != null && toDate != null) {
			    	   sql += "			and o.order_dt between to_date(?,'YYYY-MM-DD') and to_date(?,'YYYY-MM-DD') ";
			    }
			    	   sql += "        order by order_dt desc "
						   + "        ) t "
						   + "    where rownum <= ? "
						   + "    ) "
						   + "where ? <= RNUM";
						    
				pstmt = conn.prepareStatement(sql);
				// 아이디 및 사용자로 검색하는 경우
				if(keyword != "" && !keyword.trim().isEmpty()) {
					pstmt.setString(1, keyword);
					
					// 배송상태 검색값이 존재하는 경우
					if(status != null) {
						pstmt.setString(2, status);
						// 검색 기한이 존재하는 경우
						if(fromDate != null && toDate != null) {
							pstmt.setString(3, fromDate);
							pstmt.setString(4, toDate);
							pstmt.setInt(5, currPageNo * sizePerPage );
							pstmt.setInt(6, pg.getStartList() );
					    } else {
					    	//검색 기한이 없는 경우
					    	pstmt.setInt(3, currPageNo * sizePerPage );
							pstmt.setInt(4, pg.getStartList() );
					    } 
					} else { 
						// 배송상태 검색값은 없지만 검색기간은 있는 경우
						if(fromDate != null && toDate != null) {
							pstmt.setString(2, fromDate);
							pstmt.setString(3, toDate);
							pstmt.setInt(4, currPageNo * sizePerPage );
							pstmt.setInt(5, pg.getStartList() );
					    } else {
					    	pstmt.setInt(2, currPageNo * sizePerPage );
							pstmt.setInt(3, pg.getStartList() );
					    }
					}
					
				} else {
					
					// 배송상태 검색값이 존재하는 경우
					if(status != null) {
						pstmt.setString(1, status);
						// 검색 기한이 존재하는 경우
						if(fromDate != null && toDate != null) {
							pstmt.setString(2, fromDate);
							pstmt.setString(3, toDate);
							pstmt.setInt(4, currPageNo * sizePerPage );
							pstmt.setInt(5, pg.getStartList() );
					    } else {
					    	//검색 기한이 없는 경우
					    	pstmt.setInt(2, currPageNo * sizePerPage );
							pstmt.setInt(3, pg.getStartList() );
					    }
					} else { 
						// 배송상태 검색값은 없지만 검색기간은 있는 경우
						if(fromDate != null && toDate != null) {
							pstmt.setString(1, fromDate);
							pstmt.setString(2, toDate);
							pstmt.setInt(3, currPageNo * sizePerPage );
							pstmt.setInt(4, pg.getStartList() );
					    } else {					    	
					    	pstmt.setInt(1, currPageNo * sizePerPage );
							pstmt.setInt(2, pg.getStartList() );
					    }
					}
					
				}											
									
				rs = pstmt.executeQuery();
				while(rs.next()) {
					
					Map<String, Object> order = new HashMap<>();
					order.put("order_dt", rs.getDate(1));
					order.put("prod_img_url", rs.getString(2));
					order.put("prod_exp", rs.getString(3));
					order.put("goods_qy", rs.getInt(4));
					order.put("tot_amount", rs.getInt(5));
					order.put("status", rs.getString(6));
					order.put("prod_code", rs.getString(7));
					order.put("userid", rs.getString(8));
					order.put("name", rs.getString(9));
					order.put("order_no", rs.getString(10));
					order.put("prod_name", rs.getString(11));
					
					orderSetleListAll.add(order);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				close();
			}
			
			return orderSetleListAll;
		}

		@Override
		public int getOrderSetleListCountAll(Pagination pg) throws SQLException {
			
			int result = 0;
			String searchType = pg.getSearchType();
		    String keyword = pg.getKeyword();
		    String status = pg.getStatus();
		    String fromDate = pg.getFromDate();
		    String toDate = pg.getToDate();
			
			try {
				conn = ds.getConnection();
				String sql = "select count(*)  "
						   + "from ORDER_SETLE o, VIEW_PRODONEDETAIL v "
						   + "where 1=1 ";
				
				if("userid".equals(searchType)) {
					searchType = "o.fk_user_id";
				} else if("name".equals(searchType)) {
					searchType = "o.user_name";
				}				
				if(searchType != null && keyword != null && !keyword.trim().isEmpty()) {
					sql += "and " + searchType + " like '%'|| ? ||'%' ";
				}
				if(status != null) {
					   sql += "and status = ? ";
				}					  
					   sql += "and o.fk_prod_code = v.prod_code ";
					   
			    if(fromDate != null && toDate != null) {
			    	   sql += "and o.order_dt between to_date(?,'YYYY-MM-DD') and to_date(?,'YYYY-MM-DD') ";
			    }
						    
				pstmt = conn.prepareStatement(sql);				
				if(keyword != "" && !keyword.trim().isEmpty()) {
					pstmt.setString(1, keyword);
					
					// 배송상태 검색값이 존재하는 경우
					if(status != null) {
						pstmt.setString(2, status);
						// 검색 기한이 존재하는 경우
						if(fromDate != null && toDate != null) {
							pstmt.setString(3, fromDate);
							pstmt.setString(4, toDate);
					    } 
					} else { 
						// 배송상태 검색값은 없지만 검색기간은 있는 경우
						if(fromDate != null && toDate != null) {
							pstmt.setString(2, fromDate);
							pstmt.setString(3, toDate);
					    }
					}
					
				} else {
					
					// 배송상태 검색값이 존재하는 경우
					if(status != null) {
						pstmt.setString(1, status);
						// 검색 기한이 존재하는 경우
						if(fromDate != null && toDate != null) {
							pstmt.setString(2, fromDate);
							pstmt.setString(3, toDate);
					    } 
					} else { 
						// 배송상태 검색값은 없지만 검색기간은 있는 경우
						if(fromDate != null && toDate != null) {
							pstmt.setString(1, fromDate);
							pstmt.setString(2, toDate);
					    }
					}
					
				}											
									
				rs = pstmt.executeQuery();
				rs.next();
				result = rs.getInt(1);
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				close();
			}
			
			return result;
		}

		@Override
		public int updateDeliverStatus(String order_no, String status) {
			
			int result = 0;
		      
		    try {
		         
		        conn = ds.getConnection();
		                  
	            String sql = "UPDATE ORDER_SETLE SET status = ? " 
	            		   + "WHERE order_no = ? ";
	                      	            
	            pstmt = conn.prepareStatement(sql);	                    
	            pstmt.setString(1, status);
	            pstmt.setString(2, order_no);
	            
	            result = pstmt.executeUpdate();            
         
		      } catch (Exception e){
		    	  e.printStackTrace();
		      } finally {
		         close();
		      }
		      
		      return result;
		}

		@Override
		public int updateMessageForm(String smsContent) throws SQLException {
			
			int result = 0;
		      
		      try {
		         
		         conn = ds.getConnection();
	     
	             String sql = "UPDATE tbl_message SET SMSCONTENT = ? ";
	           
	             pstmt = conn.prepareStatement(sql);
	            
	             pstmt.setString(1, smsContent);            
	             result = pstmt.executeUpdate();            
	         
		      } catch (Exception e){
		    	  e.printStackTrace();
		      } finally {
		         close();
		      }
		      
		    return result;
		}

		@Override
		public String getMessageFrom() throws SQLException {
			
			String smsContent = "";
			
			try {
		         
		         conn = ds.getConnection();
	     
	             String sql = "SELECT smscontent FROM tbl_message ";
	           
	             pstmt = conn.prepareStatement(sql);
	            
	             rs = pstmt.executeQuery();
	             while(rs.next()) {
	            	 smsContent = rs.getString(1);
	             }
	         
		      } catch (Exception e){
		    	  e.printStackTrace();
		      } finally {
		         close();
		      }
			
			return smsContent;
		}

		@Override
		public OrderSetleVO getOrderByOno(String order_no) throws SQLException {
			
			OrderSetleVO orderSetle = new OrderSetleVO();
			
			try {
		         
		         conn = ds.getConnection();
	     
	             String sql = "SELECT FK_USER_ID, USER_NAME, FK_PROD_CODE, PROD_NAME, PROD_PRICE, GOODS_QY, DSCNT_AMOUNT, TOT_AMOUNT, ORDER_DT, USER_REQ, PAYMENT_TYPE, STATUS "
	             	     	+ "FROM order_setle "
	             	     	+ "where order_no = ? ";
	           
	             pstmt = conn.prepareStatement(sql);
	             pstmt.setString(1, order_no);
	             
	             rs = pstmt.executeQuery();
	             
	             while(rs.next()) {
	            	 
	            	 orderSetle.setFk_user_id(rs.getString(1));
	            	 orderSetle.setUser_name(rs.getString(2));
	            	 orderSetle.setFk_prod_code(rs.getString(3));
	            	 orderSetle.setProd_name(rs.getString(4));
	            	 orderSetle.setProd_price(rs.getInt(5));
	            	 
	            	 orderSetle.setGoods_qy(rs.getInt(6));
	            	 orderSetle.setDscnt_amount(rs.getInt(7));
	            	 orderSetle.setTot_amount(rs.getInt(8));
	            	 orderSetle.setOrder_dt(rs.getString(9));
	            	 orderSetle.setUser_req(rs.getString(10));
	            	 
	            	 orderSetle.setPayment_type(rs.getString(11));
	            	 orderSetle.setStatus(rs.getString(12));
	             }
	         
		      } catch (Exception e){
		    	  e.printStackTrace();
		      } finally {
		         close();
		      }
			
			return orderSetle;
		}

		@Override
		public int orderSetleAdd(HashMap<String, Object> paraMap) throws SQLException {
			//paraMap은 이 메소드를 호출하는 곳 즉, OrderSetleEndAction에서 넣어놨었다. 실제로 스트링타입이나 인트타입이더라도 맵에 오브젝트 타입으로 넣어뒀기에 여기에서 끄집어내올때는 원래 타입으로 형변환해준다.
			int isSuccess = 0;
			int n1=0, n2=0, n3=0, n4=0, n5=0;;
			try {
				
				 conn = ds.getConnection();
				 
				 conn.setAutoCommit(false); //수동커밋
				 
				 
				 // 1. 주문 테이블에 insert 하기(수동커밋처리)	 
				
				//맵에 오브젝트 타입이라고 넣었기때문에 형변환해준다. 스트링 배열 타입이다. 제품번호, 주문량, 주문가격 배열 등은 모두 배열에 들어간 개수가 같으니 아무거나 잡아서 그 갯수만큼 for문을 돌려도 된다. 반복문을 돌릴 것이다.
				 if(true) {
					
				 	String[] prod_name_Arr = (String[]) paraMap.get("prod_name_Arr");
					String[] price_Arr = (String[]) paraMap.get("price_Arr");
					String[] goods_qy_Arr = (String[]) paraMap.get("goods_qy_Arr");
					String[] fk_prod_code_Arr = (String[]) paraMap.get("fk_prod_code_Arr");
					
					
					
					
					int cnt = 0;
					for(int i=0; i<prod_name_Arr.length; i++) {
						
						 String sql =  " insert into order_setle(order_no, fk_user_id , user_name " + 
			         			  "                       , fk_prod_code, prod_name, prod_price  " + 
			         			  "                       , goods_qy, tot_amount " + 
			         			  "                       , order_dt, user_req, payment_type, status) " +  
			                      " values(order_no.nextval, ?, ?, ?, ?, ?, ?, ?, default, ?, 'kp', 'readydelivery') ";
						
						pstmt = conn.prepareStatement(sql); 
						
						//위치홀더에 값넣기
						pstmt.setString(1, (String)paraMap.get("fk_user_id")); 
						pstmt.setString(2, (String)paraMap.get("user_name"));
						pstmt.setString(3, fk_prod_code_Arr[i]);
						pstmt.setString(4, prod_name_Arr[i]); 
						pstmt.setString(5, price_Arr[i]); 
						pstmt.setString(6, goods_qy_Arr[i]); 
						pstmt.setInt(7, Integer.parseInt((String)paraMap.get("totalAmount")));//totalAmount   setInt Integer.parseInt((String)paraMap.get("sumtotalPrice"))
						pstmt.setString(8, (String)paraMap.get("user_req"));
						
						pstmt.executeUpdate();
						cnt++; // 이 배열의 개수만큼 cnt가 늘어난다. 3개의 상품이 들어가있다면 cnt는 3이다.
					}// end of for -----------------
					
					if(cnt == prod_name_Arr.length) {//위가 정상적으로 실행될 경우이다. // pnumArr.length이 배열의 개수만큼 cnt가 늘어난다. 3개의 상품이 들어가있다면 cnt는 3이다. 정상적으로 위가 실행되면 둘의 값이 같을 것이다.
						n1=1; //올바르게 sql문이 실행되었다면 1값을 n1에 넣어준다.
					}
					System.out.println("~~~~~~ 확인용 n1 : " + n1);
					
				 }// end of if ----------------------
				 
					// 2. 제품잔고 테이블에서 제품번호에 해당하는 잔고량을 주문량 만큼 감하기(수동커밋처리) 
					if(n1 == 1) {
						String[] goods_qy_Arr = (String[]) paraMap.get("goods_qy_Arr");
						String[] fk_prod_code_Arr = (String[]) paraMap.get("fk_prod_code_Arr");
						
						int cnt = 0;
						for(int i=0; i<fk_prod_code_Arr.length; i++) {
							
							String sql = " update tbl_stock set prod_stock = prod_stock - ? "
					                   + " where fk_prod_code = ? ";

							 
							pstmt = conn.prepareStatement(sql);
							pstmt.setInt(1, Integer.parseInt(goods_qy_Arr[i]));
							pstmt.setString(2, fk_prod_code_Arr[i]);
							
							pstmt.executeUpdate();
							cnt++;
						
						}// end of for------------------------
						
						if(cnt == fk_prod_code_Arr.length) {
							n2=1;
						}
						System.out.println("~~~~~~ 확인용 n2 : " + n2);
					}// end of if ----------------------
				
				
					 // 3. 장바구니 테이블에서 주문한 행들을 삭제(delete OR update)하기(수동커밋처리) 
					
					// >> 장바구니에서 주문을 한 것이 아니라 특정제품을 바로주문하기를 한 경우에는 장바구니 테이블에서 행들 삭제할 작업은 없다. <<
					  if( !"".equals(paraMap.get("basket_no_join")) && n2==1 ) {
					  //if( paraMap.get("basket_no_join") != null && n2==1 ) {
						  //for문 쓸 필요없이 in을 쓰면된다. 장바구니번호가 5번, 7번 , 10번인걸 삭제하력 한다면 왼쪽처럼 하면 될 것이다.where cartno in(5, 7, 10) 
						  String sql = " delete from tbl_basket "
						  	  + " where basket_no in("+ (String)paraMap.get("basket_no_join") +") ";
						  
						
						  
						  pstmt = conn.prepareStatement(sql);
						  
						  n3 = pstmt.executeUpdate();
						  
						  System.out.println("~~~~~~ 확인용 n3 : " + n3);
						  // ~~~~~~ 확인용 n3 : 3 //장바구니번호가 배열에 3개 들어있었다면 3개행을 삭제하게 되니까 n4에는 3값이 나온다.
						  
						  
					  }// end of if------------------------------------------------
				         
					  if( "".equals(paraMap.get("basket_no_join")) && n2==1 ) { //장바구니번호가 없을 경우니 null일 경우이다.
					 
					  //if( paraMap.get("basket_no_join") == null && n2==1 ) { 
					  // "제품 상세 정보" 페이지에서 "바로주문하기" 를 한 경우 
			         // 장바구니 번호인 basket_no_join 이 없는 것이다.
						  n3 = 1;
						  
						  System.out.println("~~~~~~ 바로주문하기인 경우 확인용 n3 : " + n3);
						  // ~~~~~~ 확인용 n3 : 1 //행을 삭제할 필요가 없다. 그냥 1값을 주었다.
						  
					  }// end of if ------------------------------------------------------
				
				
					
					// 4. 회원 테이블에서 로그인한 사용자의 point 를 더하기(update)(수동커밋처리)	 

					  
					  if(n3 > 0) {
					    	
					    	String sql = " update tbl_member set point = point + ? "
					    			   + " where userid = ? ";
					             
					             pstmt = conn.prepareStatement(sql);
					             
					             pstmt.setInt(1, Integer.parseInt((String)paraMap.get("totalPoint")) );
					             pstmt.setString(2, (String)paraMap.get("fk_user_id") );
					              
					             
								 n4 = pstmt.executeUpdate();
								  
								 System.out.println("~~~~~~ 확인용 n4 : " + n4);
								 // ~~~~~~ 확인용 n4 : 1 //유저아이디가 고유하니까 업데이트된 행은 하나라서 1값이 나올 것이다.
					    	
					    }// end of if-----------------------------------------------
					  
					
					  if(n4 > 0 ) {
						  
						  String sql = "update tbl_member set point = point - ? "
						  			 + "where userid = ? ";
						  			 
			  			  pstmt = conn.prepareStatement(sql);
			             
			              pstmt.setInt(1, Integer.parseInt((String)paraMap.get("usedPoint")) );
			              pstmt.setString(2, (String)paraMap.get("fk_user_id") );
			              
			              n5 = pstmt.executeUpdate();
						  			 
					  }
					  // 5. **** 모든처리가 성공되었을시 commit 하기(commit) **** 
					
					  if(n1*n2*n3*n4*n5 > 0) {
					    	
					    	conn.commit();
					    	
					    	conn.setAutoCommit(true);
					    	// 자동커밋으로 전환
					    	
					    	System.out.println("~~~~~~ 확인용 n1*n2*n3*n4 : " + (n1*n2*n3*n4) );
					    	 
					    	isSuccess = 1;
					    	
					    }
					    
				
			} catch(SQLException e) {
				
				// 6. **** SQL 장애 발생시 rollback 하기(rollback) **** 
				conn.rollback();
				
				conn.setAutoCommit(true);
				
				isSuccess = 0;//꼭쓸필요는 없다. 디폴트를 0으로 해두었었기때문에 여기에서도 0값을 준다.
				
			} finally {
				close();
			}
			
			return isSuccess;
			
		}

}
