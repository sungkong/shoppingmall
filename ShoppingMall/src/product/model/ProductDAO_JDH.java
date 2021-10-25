package product.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ProductDAO_JDH implements InterProductDAO_JDH {

	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 기본 생성자
	public ProductDAO_JDH() {
		
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
	
	// 상품리스트
	@Override
	   public List<HashMap<String, Object>> productList(String sort_code) throws SQLException {
	      
	      List<HashMap<String, Object>> productList = new ArrayList<>();
	            
	      try {
	         
	         conn = ds.getConnection();
	         
	          System.out.println("상품목록");
	         
	          String sql = "select prod_code, prod_name, prod_exp, prod_price, prod_img_url, discount_price "+
	                "    from "+
	                "    ( "+
	                "        select prod_code, prod_name, prod_exp, prod_price, nvl(discount_price, -9999) as discount_price "+
	                "        from "+
	                "        ( "+
	                "            select prod_code "+
	                "            from tbl_prod where fk_sort_code != -9999 ";
	                
	                
	          if(sort_code != null && sort_code.trim() != "") 
	                sql += "            and fk_sort_code = ? ";
	          
	          sql += "        ) M "+
	                 "        join tbl_prod_info I "+
	                 "        on M.prod_code = I.fk_prod_code "+
	                 "        where prod_sale != 0 "+
	                 "        order by fk_prod_code desc "+
	                 "    ) A "+
	                 "    join "+
	                 "    ( "+
	                 "    select distinct fk_prod_code, first_value(prod_img_url) over(partition by fk_prod_code order by prod_img_code) AS prod_img_url "+
	                 "    from tbl_prod_img "+
	                 "    ) G "+
	                 "    on A.prod_code = G.fk_prod_code ";
	          
	                pstmt = conn.prepareStatement(sql);
	                
	          if(sort_code != null && sort_code.trim() != "") 
	                pstmt.setString(1, sort_code);
	                
	                rs = pstmt.executeQuery();
	                
	                while(rs.next()) {   
	                   
	                   HashMap<String, Object> prodmap = new HashMap<>();
	                   ProductVO pvo = new ProductVO();
	                   
	                   pvo.setProd_code(rs.getString(1));
	                   pvo.setProd_name(rs.getString(2));
	                   pvo.setProd_exp(rs.getString(3));
	                   pvo.setProd_price(rs.getInt(4));
	                   pvo.setDiscount_price(rs.getInt(6));
	                   
	                   prodmap.put("pvo", pvo);
	                   
	                   ImageVO ivo = new ImageVO();
	                   ivo.setProd_img_url(rs.getString(5));
	                   
	                   prodmap.put("ivo", ivo);
	                   
	                   productList.add(prodmap);
	                   
	                }
	          
	         
	      } finally {
	         close();
	      }
	      
	      return productList;
	   }// end of public List<HashMap<String, Object>> productList(String sort_code) throws SQLException {}------------------------------------------------------------

	
	// 상품관리 리스트 가져오기(검색어 처리)
	@Override
	public List<HashMap<String, Object>> mProductList(Map<String,String> searchMap) throws SQLException{
		
		List<HashMap<String, Object>> mProductList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
						
			String sql = " select M.fk_prod_code, prod_name, prod_img_url, prod_stock, prod_sale, fk_sort_code "
					+ " from "
					+ " ("
					+ "	 select A.fk_prod_code, prod_name, prod_img_url, prod_stock, prod_sale " + 
					"    from " + 
					"    ( " + 
					"        select S.fk_prod_code, prod_name, prod_sale, prod_stock " + 
					"        from " + 
					"        ( " + 
					"            select fk_prod_code, prod_stock " + 
					"            from tbl_stock " + 
					"        ) S " + 
					"        join tbl_prod_info I " + 
					"        on S.fk_prod_code = I.fk_prod_code "; 
					
			
			String colname = searchMap.get("searchType");
			String searchWord = searchMap.get("searchWord");
			
			if(searchWord != null && !searchWord.trim().isEmpty()) {
				sql += " where " +colname+" like '%'||?||'%' ";
			}
			
			sql +=  "        order by fk_prod_code desc " + 
					"    ) A " + 
					"    join " + 
					"    ( " + 
					"        select distinct fk_prod_code, first_value(prod_img_url) over(partition by fk_prod_code order by prod_img_code) AS prod_img_url " + 
					"        from tbl_prod_img " + 
					"    ) G " + 
					"    on A.fk_prod_code = G.fk_prod_code) M "
					+ "  join tbl_prod N "
					+ "  on M.fk_prod_code = N.prod_code ";
	
			pstmt = conn.prepareStatement(sql);
			
			// System.out.println(searchWord);
			
			if(searchWord != null && !searchWord.trim().isEmpty()) {
				pstmt.setString(1, searchWord);
			}
			
			// System.out.println(colname);
			// System.out.println(searchWord);
            
			rs = pstmt.executeQuery();
            
            while(rs.next()) {   
                
                HashMap<String, Object> mprodmap = new HashMap<>();
                ProductVO mpvo = new ProductVO();
                
                mpvo.setProd_code(rs.getString(1));
                mpvo.setProd_name(rs.getString(2));
                mpvo.setProd_stock(rs.getInt(4));
                mpvo.setProd_sale(rs.getInt(5));
                mpvo.setSort_code(rs.getInt(6));
                
                mprodmap.put("mpvo", mpvo);
                
                ImageVO mivo = new ImageVO();
                mivo.setProd_img_url(rs.getString(3));
                
                mprodmap.put("mivo", mivo);
                
                mProductList.add(mprodmap);
            }
            
			
		} finally {
			close();
		}
		
		// System.out.println("내용물 확인");
		
		
		return mProductList;
	
	}

	// 상품 입고하기
	@Override
	public int PlusProduct(Map<String, String> pmMap) throws SQLException {
		
		int PlusProduct = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " insert into tbl_inout_stock(inout_code,fk_prod_code,status,inout_qty) "
					+ " values (seq_inout_code.nextval, ?,?,?) ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, pmMap.get("prod_code"));
			pstmt.setInt(2, Integer.parseInt(pmMap.get("status")));
			pstmt.setInt(3, Integer.parseInt(pmMap.get("inout_qty")));
			
			PlusProduct = pstmt.executeUpdate();
			
			if(PlusProduct != 0) {
				
				sql = " update tbl_stock set prod_stock = prod_stock + ? " + 
						"where fk_prod_code = ?  ";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setInt(1, Integer.parseInt(pmMap.get("inout_qty")));
				pstmt.setString(2, pmMap.get("prod_code"));
				
				pstmt.executeUpdate();
			}
			
		} finally {
			close();
		}
		
		return PlusProduct;
	}

	
	// 상품 폐기하기 
	@Override
	public int MinusProduct(Map<String, String> mmMap) throws SQLException {
		
		int MinusProduct = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " insert into tbl_inout_stock(inout_code,fk_prod_code,inout_exp,status,inout_qty) "
					+ " values (seq_inout_code.nextval, ?,?,?,?)  ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, mmMap.get("prod_code"));
			pstmt.setString(2, mmMap.get("inout_exp"));
			pstmt.setInt(3, Integer.parseInt(mmMap.get("status")));
			pstmt.setInt(4, Integer.parseInt(mmMap.get("inout_qty")));
			
			MinusProduct = pstmt.executeUpdate();
			
			if(MinusProduct != 0) {
				
				sql = " update tbl_stock set prod_stock = prod_stock - ? " + 
						"where fk_prod_code = ?  ";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setInt(1, Integer.parseInt(mmMap.get("inout_qty")));
				pstmt.setString(2, mmMap.get("prod_code"));
				
				pstmt.executeUpdate();
			}
			
		} finally {
			close();
		}
		
		return MinusProduct;
	}

	
	// 검색결과 보여주기 
	@Override
	public List<HashMap<String, Object>> cProductList(Map<String,String> cSearchMap) throws SQLException {
		
		List<HashMap<String, Object>> cProductList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
						
			String sql = " select M.fk_prod_code, prod_name, prod_img_url, prod_stock, prod_sale, fk_sort_code "
					+ " from "
					+ " ("
					+ "	 select A.fk_prod_code, prod_name, prod_img_url, prod_stock, prod_sale " + 
					"    from " + 
					"    ( " + 
					"        select S.fk_prod_code, prod_name, prod_sale, prod_stock " + 
					"        from " + 
					"        ( " + 
					"            select fk_prod_code, prod_stock " + 
					"            from tbl_stock " + 
					"        ) S " + 
					"        join tbl_prod_info I " + 
					"        on S.fk_prod_code = I.fk_prod_code "; 
					
			
			String colname = cSearchMap.get("cSearchType");
			String searchWord = cSearchMap.get("cSearchWord");
			
			if(searchWord != null && ! searchWord.trim().isEmpty()) {
				sql += " where " +colname+" like '%'||?||'%' ";
			}
			
			sql +=  "        order by fk_prod_code desc " + 
					"    ) A " + 
					"    join " + 
					"    ( " + 
					"        select distinct fk_prod_code, first_value(prod_img_url) over(partition by fk_prod_code order by prod_img_code) AS prod_img_url " + 
					"        from tbl_prod_img " + 
					"    ) G " + 
					"    on A.fk_prod_code = G.fk_prod_code) M "
					+ "  join tbl_prod N "
					+ "  on M.fk_prod_code = N.prod_code ";
					
			
			pstmt = conn.prepareStatement(sql);
			
			// System.out.println(searchWord);
			
			if(searchWord != null && !searchWord.trim().isEmpty()) {
				pstmt.setString(1, searchWord);
			}
			
			// System.out.println(colname);
			// System.out.println(searchWord);
            
			rs = pstmt.executeQuery();
            
            while(rs.next()) {   
                
                HashMap<String, Object> cprodmap = new HashMap<>();
                ProductVO cpvo = new ProductVO();
                
                cpvo.setProd_code(rs.getString(1));
                cpvo.setProd_name(rs.getString(2));
                cpvo.setProd_stock(rs.getInt(4));
                cpvo.setProd_sale(rs.getInt(5));
                cpvo.setSort_code(rs.getInt(6));
                
                cprodmap.put("cpvo", cpvo);
                
                ImageVO civo = new ImageVO();
                civo.setProd_img_url(rs.getString(3));
                
                cprodmap.put("mivo", civo);
                
                cProductList.add(cprodmap);
            }
            
			
		} finally {
			close();
		}
		
		// System.out.println("내용물 확인");
		
		
		return cProductList;
		
		
		
	}

	// 상품관리 정렬방식 보여주기
	@Override
	public List<HashMap<String, Object>> selectOrderbyProd(Map<String, String> searchMap) throws SQLException {
		
		List<HashMap<String, Object>> sProductList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = " select M.fk_prod_code AS fk_prod_code, prod_name, prod_img_url, prod_stock, prod_sale, fk_sort_code, prod_date "
					+ " from "
					+ " ("
					+ "	 select A.fk_prod_code, prod_name, prod_img_url, prod_stock, prod_sale, prod_date " + 
					"    from " + 
					"    ( " + 
					"        select S.fk_prod_code, prod_name, prod_sale, prod_stock, prod_date " + 
					"        from " + 
					"        ( " + 
					"            select fk_prod_code, prod_stock " + 
					"            from tbl_stock " + 
					"        ) S " + 
					"        join tbl_prod_info I " + 
					"        on S.fk_prod_code = I.fk_prod_code "; 
					
			
			String colname = searchMap.get("searchType");
			String searchWord = searchMap.get("searchWord");
			String colname2 = searchMap.get("orderbyType");
			
			if(searchWord != null && searchWord.trim() != "") {				
				
				if("fk_prod_code".equalsIgnoreCase(colname))
					colname = "S." + colname;
				
				sql += " where " +colname+" like '%'||?||'%' ";	
			}
			
			sql +=  "        order by fk_prod_code desc " + 
					"    ) A " + 
					"    join " + 
					"    ( " + 
					"        select distinct fk_prod_code, first_value(prod_img_url) over(partition by fk_prod_code order by prod_img_code) AS prod_img_url " + 
					"        from tbl_prod_img " + 
					"    ) G " + 
					"    on A.fk_prod_code = G.fk_prod_code) M "
					+ "  join tbl_prod N "
					+ "  on M.fk_prod_code = N.prod_code "
					+ " order by "+colname2+" ";
					
			
		
					
			pstmt = conn.prepareStatement(sql);
			
			// System.out.println(searchWord);
			
			if(searchWord != null && !searchWord.trim().isEmpty()) {
				pstmt.setString(1, searchWord);
			}
			
			// System.out.println(colname);
			// System.out.println(searchWord);
			// System.out.println("colname2");
            
			rs = pstmt.executeQuery();
            
            while(rs.next()) {   
                
                HashMap<String, Object> cprodmap = new HashMap<>();
                ProductVO cpvo = new ProductVO();
                
                cpvo.setProd_code(rs.getString(1));
                cpvo.setProd_name(rs.getString(2));
                cpvo.setProd_stock(rs.getInt(4));
                cpvo.setProd_sale(rs.getInt(5));
                cpvo.setSort_code(rs.getInt(6));
                
                cprodmap.put("mpvo", cpvo);
                
                ImageVO civo = new ImageVO();
                civo.setProd_img_url(rs.getString(3));
                
                cprodmap.put("mivo", civo);
                
                sProductList.add(cprodmap);
            }
            
			
		} finally {
			close();
		}
		
		// System.out.println("내용물 확인");
		
		
		return sProductList;
	}

	// 카테고리 삭제
	@Override
	public int deleteCategory(Map<String, String> sortMap) throws SQLException {

		int result = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " delete from tbl_sort where sort_code = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, sortMap.get("sort_code"));
						
			result = pstmt.executeUpdate();
			
			
		} finally {
			close();
		}
		
		return result;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	
	

}
