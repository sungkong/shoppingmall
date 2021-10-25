package product.model;

import java.sql.*;
import java.util.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ProductDAO_KJH implements InterProductDAO_KJH {

	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 기본 생성자
	public ProductDAO_KJH() {
		
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

	//////////////////////////////////////////////////////////////////////////////////////
	
	// 존재하는 카테고리를 모두 받아오는 메소드
	@Override
	public List<SortVO> AllSort() throws SQLException {
		
		List<SortVO> sortList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select sort_code, sort_name from tbl_sort order by sort_code ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				SortVO sort = new SortVO();
				
				sort.setSort_code(rs.getInt(1));
				sort.setSort_name(rs.getString(2));
				
				sortList.add(sort);
				
			}// end of while------------------------------------------------
			
		} finally {
			close();
		}
		
		return sortList;
	
	}// end of public HashMap<String, SortVO> AllCategory()-------------------------------

	//////////////////////////////////////////////////////////////////////////////////////
	
	// 존재하는 모든 상품을 받아오는 메소드
	@Override
	public List<ProductVO> AllProduct() throws SQLException {
		
		List<ProductVO> prodList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select fk_prod_code, prod_name from tbl_prod_info order by fk_prod_code ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				ProductVO prod = new ProductVO();
				
				prod.setProd_code(rs.getString(1));
				prod.setProd_name(rs.getString(2));
				
				prodList.add(prod);
				
			}// end of while------------------------------------------------
			
		} finally {
			close();
		}
		
		return prodList;
		
	}// end of public List<ProductVO> AllProduct()----------------------------------------

	//////////////////////////////////////////////////////////////////////////////////////
	
	// 상품등록하기
	@Override
	public int insertProd(Map<String, Object> paraMap) throws SQLException {
		
		int result = 0;
		
		try {
			
			conn = ds.getConnection();
			
			String sql = "";
			
			int sort_code = 0;
			
			// 신규 카테고리 일 경우 카테고리 테이블에 insert
			if(paraMap.get("sort_name") != null) {
				
				sql = " select seq_sort_code.nextval from dual ";
				
				pstmt = conn.prepareStatement(sql);
				
				rs = pstmt.executeQuery();
				
				rs.next();
				
				sort_code = rs.getInt(1);
				
				sql = " insert into tbl_sort(sort_code, sort_name) "
					+ " values(?, ?) ";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setInt(1, sort_code);
				pstmt.setString(2, (String)paraMap.get("sort_name"));
				
				result = pstmt.executeUpdate();
				
			}
			
			// 상품 테이블에 insert
			sql = " select seq_prod_code.nextval from dual ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			rs.next();
			
			int seq_prod_code = rs.getInt(1);
			
			ProductVO prod = (ProductVO)paraMap.get("prod");
			
			sql = " insert into tbl_prod(prod_code,fk_sort_code) values(?, ?) ";
			
			pstmt = conn.prepareStatement(sql);
			
			String prod_code = "";
			
			if(sort_code == 0) {
				sort_code = prod.getSort_code();
			}
			
			prod_code = sort_code + "-" + seq_prod_code;
			
			
			pstmt.setString(1, prod_code);
			pstmt.setInt(2, sort_code);
			
			result = pstmt.executeUpdate();
			
			// 상품상세테이블에 insert
			sql = " insert into tbl_prod_info(fk_prod_code,prod_name,prod_price,prod_ice,prod_plus,prod_select,prod_sale";
			
			String holder = "?,?,?,?,?,?,?";
			
			if(prod.getDiscount_price() != -9999) {
				sql += " ,discount_price ";
				holder += ",?";
			}
			
			if(prod.getProd_exp() != "") {
				sql += " ,prod_exp ";
				holder += ",?";
			}
			
			sql += " ) values(" + holder + ")";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, prod_code);
			pstmt.setString(2, prod.getProd_name());
			pstmt.setInt(3, prod.getProd_price());
			pstmt.setInt(4, prod.getProd_ice());
			pstmt.setInt(5, prod.getProd_plus());
			pstmt.setInt(6, prod.getProd_select());
			pstmt.setInt(7, prod.getProd_sale());
			
			boolean addFlag = false;
			
			if(prod.getDiscount_price() != -9999) {
				pstmt.setInt(8, prod.getDiscount_price());
				addFlag = true;
			}
			
			if(prod.getProd_exp() != "" && addFlag) {
				pstmt.setString(9, prod.getProd_exp());
			}
			
			else if(prod.getProd_exp() != "" && !addFlag) {
				pstmt.setString(8, prod.getProd_exp());
			}
			
			result = pstmt.executeUpdate();
			
			// 타이틀 이미지 테이블에 insert			
			for(String titleimg : (ArrayList<String>)paraMap.get("titleimglist")) {
				
				sql = " insert into tbl_prod_img(prod_img_code,fk_prod_code,prod_img_url) "
					+ " values (seq_prod_img_code.nextval,?,?) ";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, prod_code);
				pstmt.setString(2, titleimg);
				
				result = pstmt.executeUpdate();
				
			}
			
			// 상세 이미지 테이블에 insert			
			for(String detailimg : (ArrayList<String>)paraMap.get("detailimglist")) {
				
				sql = " insert into tbl_prod_img_detail(prod_img_detail_code,fk_prod_code,prod_img_detail_url) "
					+ " values (seq_prod_img_detail_code.nextval,?,?) ";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, prod_code);
				pstmt.setString(2, detailimg);
				
				result = pstmt.executeUpdate();
				
			}
			
			// 재고 테이블에 insert
			sql = " insert into tbl_stock(fk_prod_code, prod_stock) values (?,?) ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, prod_code);
			pstmt.setInt(2, prod.getProd_stock());
			
			result = pstmt.executeUpdate();
			
			// 재고가 0이 아닐 경우 입고폐기테이블에 insert
			if(prod.getProd_stock() != 0) {
				
				sql = " insert into tbl_inout_stock(inout_code,status,fk_prod_code,inout_qty) " + 
					  " values(seq_inout_code.nextval, 1, ?, ?) ";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, prod_code);
				pstmt.setInt(2, prod.getProd_stock());
				
				result = pstmt.executeUpdate();
				
			}
						
			// 추가상품이 있을 경우 추가상품 테이블에 insert
			if(paraMap.get("prod_plus_list") != null) {
				
				for(String prod_plus_code : (ArrayList<String>)paraMap.get("prod_plus_list")) {
					
					sql = " insert into tbl_prod_plus(plus_code,fk_prod_code,fk_prod_plus_code) "
						+ " values (seq_plus_code.nextval,?,?) ";
					
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setString(1, prod_code);
					pstmt.setString(2, prod_plus_code);
					
					result = pstmt.executeUpdate();
					
				}
				
			}
			
			// 골라담기상품이 있을 경우 추가상품 테이블에 insert
			if(paraMap.get("prod_select_list") != null) {
				
				for(String prod_select_code : (ArrayList<String>)paraMap.get("prod_select_list")) {
					
					sql = " insert into tbl_prod_select(select_code,fk_prod_code,fk_prod_select_code) "
						+ " values (seq_select_code.nextval,?,?) ";
					
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setString(1, prod_code);
					pstmt.setString(2, prod_select_code);
					
					result = pstmt.executeUpdate();
					
				}
				
			}
			
			
		} finally {
			close();
		}
		
		return result;
		
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	
   // 상품 리스트
   @Override
   public List<HashMap<String, Object>> productList(String sort_code) throws SQLException {
      
      List<HashMap<String, Object>> productList = new ArrayList<>();
            
      try {
         
         conn = ds.getConnection();
         
         // System.out.println("제발점~");
         
          String sql = "select prod_code, prod_name, prod_exp, prod_price, prod_img_url "+
                "    from "+
                "    ( "+
                "        select prod_code, prod_name, prod_exp, prod_price "+
                "        from "+
                "        ( "+
                "            select prod_code "+
                "            from tbl_prod "+
                "            where fk_sort_code = ? "+
                "        ) M "+
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
                pstmt.setString(1, sort_code);
                
                rs = pstmt.executeQuery();
                
                while(rs.next()) {   
                   
                   HashMap<String, Object> prodmap = new HashMap<>();
                   ProductVO pvo = new ProductVO();
                   
                   pvo.setProd_code(rs.getString(1));
                   pvo.setProd_name(rs.getString(2));
                   pvo.setProd_exp(rs.getString(3));
                   pvo.setProd_price(rs.getInt(4));
                   
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
   
   //////////////////////////////////////////////////////////////////////////////////////////
   
   // 광고(배너) 이미지 (카테고리 메인화면 top_image)
   @Override
   public String adimg(String sort_code) throws SQLException {
      
      String adimg = "";
      
      try {
         
         conn = ds.getConnection();
         
         String sql = " select ad_img_url " + 
               " from tbl_prod_ad " +
               " where fk_sort_code = ? ";
         
         pstmt = conn.prepareStatement(sql);
          pstmt.setString(1, sort_code);
          
          rs = pstmt.executeQuery();
          
          if(rs.next()) {
             adimg = rs.getString(1);
          }
         
      } finally {
         close();
      }
      
      return adimg;
   }

   //////////////////////////////////////////////////////////////////////////////////////////
   
   // 카테고리 이름(중간 카테고리 이름설정)
   @Override
   public String categoryName(String sort_code) throws SQLException {
      
      String categoryName = "";
      
      try {
         
         conn = ds.getConnection();
         
         String sql = " select sort_name " + 
               " from tbl_sort " + 
               " where sort_code = ? ";
         
         pstmt = conn.prepareStatement(sql);
          pstmt.setString(1, sort_code);
          
          rs = pstmt.executeQuery();
          
          if(rs.next()) {
             categoryName = rs.getString(1);
          }
         
      } finally {
         close();
      }
      
      
      return categoryName;
   }

   /////////////////////////////////////////////////////////////////////////////////////////
   
   // 상품 상세페이지 내용 select
   @Override
   public Map<String, Object> getProdDetail(String prod_code) throws SQLException {
	   
	   Map<String, Object> prodMap = new HashMap<>();
	   
	   try {
		   
		   conn = ds.getConnection();
		   
		   // 상품 정보 가져오기(tbl_prod, tbl_prod_info, tbl_stock)
		   String sql = " select A.sort_code, A.prod_code, prod_name, prod_exp, prod_price, prod_ice, prod_plus, prod_select, discount_price, prod_stock, A.sort_name " + 
				   		" from " + 
				   		" ( " + 
				   		"     select P.sort_name, P.sort_code, P.prod_code, prod_name, prod_exp, prod_price, prod_ice, prod_plus, prod_select, nvl(discount_price,-9999) AS discount_price " + 
				   		"     from tbl_prod_info I " + 
				   		"         JOIN " + 
				   		"             ( " + 
				   		"                 select sort_name, fk_sort_code AS sort_code, prod_code " + 
				   		"                 from tbl_prod N JOIN tbl_sort M ON N.fk_sort_code = M.sort_code " + 
				   		"                 where prod_code = ? " + 
				   		"             ) P " + 
				   		"         ON P.prod_code = I.fk_prod_code " + 
				   		"     where prod_sale = 1 " + 
				   		" )A  JOIN tbl_stock S " + 
				   		"     ON A.prod_code = S.fk_prod_code ";
		   
		   pstmt = conn.prepareStatement(sql);
		   
		   pstmt.setString(1, prod_code);
		   
		   rs = pstmt.executeQuery();
		   
		   if(rs.next()) {
			   
			   ProductVO pvo = new ProductVO();
			   
			   pvo.setSort_code(rs.getInt(1));
			   pvo.setProd_code(rs.getString(2));
			   pvo.setProd_name(rs.getString(3));
			   pvo.setProd_exp(rs.getString(4));
			   pvo.setProd_price(rs.getInt(5));
			   pvo.setProd_ice(rs.getInt(6));
			   pvo.setProd_plus(rs.getInt(7));
			   pvo.setProd_select(rs.getInt(8));
			   pvo.setDiscount_price(rs.getInt(9));
			   pvo.setProd_stock(rs.getInt(10));
			   pvo.setSort_name(rs.getString(11));
			   
			   prodMap.put("pvo", pvo);
			   
			   // 타이틀 이미지 가져오기			   
			   sql = " select prod_img_url from tbl_prod_img where fk_prod_code = ? order by prod_img_code ";
			   
			   pstmt = conn.prepareStatement(sql);
			   
			   pstmt.setString(1, prod_code);
			   
			   rs = pstmt.executeQuery();
			   
			   List<String> titleImgList = new ArrayList<>();
			   
			   while(rs.next()) {				   
				   titleImgList.add(rs.getString(1));			   
			   }
			   
			   prodMap.put("titleImgList", titleImgList);
			   
			   // 상세 이미지 가져오기			   
			   sql = " select prod_img_detail_url from tbl_prod_img_detail where fk_prod_code = ? order by prod_img_detail_code ";
			   
			   pstmt = conn.prepareStatement(sql);
			   
			   pstmt.setString(1, prod_code);
			   
			   rs = pstmt.executeQuery();
			   
			   List<String> detailImgList = new ArrayList<>();
			   
			   while(rs.next()) {				   
				   detailImgList.add(rs.getString(1));				   
			   }
			   
			   prodMap.put("detailImgList", detailImgList);
			   
			   // 추가구성상품이 있을 경우 추가구성상품 목록 가져오기
			   if(pvo.getProd_plus() == 1) {
				   
				   sql = " select I.fk_prod_code, prod_name, prod_price, discount_price, prod_stock, prod_img_url " + 
				   		 " from " + 
				   		 "     ( " + 
				   		 "         select A.fk_prod_code, prod_name, prod_price, nvl(discount_price,-9999) AS discount_price, prod_stock " + 
				   		 "         from tbl_prod_info A JOIN tbl_stock S ON A.fk_prod_code = S.fk_prod_code " + 
				   		 "         where A.fk_prod_code in ( " + 
				   		 "                                     select fk_prod_plus_code AS prod_plus_code " + 
				   		 "                                     from tbl_prod_plus " + 
				   		 "                                     where fk_prod_code = ? " + 
				   		 "                                  ) and prod_sale = 1 " + 
				   		 "      ) I " + 
				   		 " JOIN ( " + 
				   		 "        select distinct first_value(prod_img_url) over(partition by fk_prod_code order by prod_img_code) AS prod_img_url " + 
				   		 "             , fk_prod_code " + 
				   		 "        from tbl_prod_img " + 
				   		 "       ) T " + 
				   		 " ON I.fk_prod_code = T.fk_prod_code order by 1 ";
				   
				   pstmt = conn.prepareStatement(sql);
				   
				   pstmt.setString(1, prod_code);
				   
				   rs = pstmt.executeQuery();
				   
				   List<ProductVO_KJH> plusList = new ArrayList<>();
				   
				   while(rs.next()) {
					   
					   ProductVO_KJH plusvo = new ProductVO_KJH();
					   
					   plusvo.setProd_code(rs.getString(1));
					   plusvo.setProd_name(rs.getString(2));
					   plusvo.setProd_price(rs.getInt(3));
					   plusvo.setDiscount_price(rs.getInt(4));
					   plusvo.setProd_stock(rs.getInt(5));
					   
					   ImageVO imgvo = new ImageVO();
					   
					   imgvo.setProd_img_url(rs.getString(6));
					   
					   plusvo.setImgvo(imgvo);
					   
					   plusList.add(plusvo);					   
					   
				   }// end of while---------------------------
				   
				   prodMap.put("plusList", plusList);
				   
			   }  
			   
			   // 골라담기 상품일 경우 골라담기구성상품 목록 가져오기
			   if(pvo.getProd_select() != 0) {
					   
				   sql = " select I.fk_prod_code, prod_name, prod_price, discount_price, prod_stock, prod_img_url " + 
				   		 " from " + 
				   		 "     ( " + 
				   		 "         select A.fk_prod_code, prod_name, prod_price, nvl(discount_price,-9999) AS discount_price, prod_stock " + 
				   		 "         from tbl_prod_info A JOIN tbl_stock S ON A.fk_prod_code = S.fk_prod_code " + 
				   		 "         where A.fk_prod_code in ( " + 
				   		 "                                     select fk_prod_select_code AS prod_select_code " + 
				   		 "                                     from tbl_prod_select " + 
				   		 "                                     where fk_prod_code = ? " + 
				   		 "                                  ) AND prod_sale = 1 " + 
				   		 "      ) I " + 
				   		 " JOIN ( " + 
				   		 "        select distinct first_value(prod_img_url) over(partition by fk_prod_code order by prod_img_code) AS prod_img_url " + 
				   		 "             , fk_prod_code " + 
				   		 "        from tbl_prod_img " + 
				   		 "       ) T " + 
				   		 " ON I.fk_prod_code = T.fk_prod_code order by 1 ";
				   
				   pstmt = conn.prepareStatement(sql);
				   
				   pstmt.setString(1, prod_code);
				   
				   rs = pstmt.executeQuery();
				   
				   List<ProductVO_KJH> selectList = new ArrayList<>();
				   
				   while(rs.next()) {
					   
					   ProductVO_KJH selectvo = new ProductVO_KJH();
					   
					   selectvo.setProd_code(rs.getString(1));
					   selectvo.setProd_name(rs.getString(2));
					   selectvo.setProd_price(rs.getInt(3));
					   selectvo.setDiscount_price(rs.getInt(4));
					   selectvo.setProd_stock(rs.getInt(5));
					   
					   ImageVO imgvo = new ImageVO();
					   
					   imgvo.setProd_img_url(rs.getString(6));
					   
					   selectvo.setImgvo(imgvo);
					   
					   selectList.add(selectvo);					   
					   
				   }// end of while---------------------------
				   
				   prodMap.put("selectList", selectList);
				   			   
			   }	
			   
		   }
		   	
	   } finally {
		   close();
	   }	
	   
	   return prodMap;
	   
   }
   
   //////////////////////////////////////////////////////////////////////////////////////////
   
   // 카테고리와 배너 받아오기
   @Override
   public List<Map<String, Object>> allBanner() throws SQLException {
	   
	   List<Map<String, Object>> bannerList = new ArrayList<>(); 
	   
	   try {
		   
		   conn = ds.getConnection();
		   
		   String sql = " select sort_code, sort_name, nvl(ad_img_url, -9999) " + 
				   		" from tbl_sort S LEFT JOIN tbl_prod_ad A " + 
				   		" ON S.sort_code = A.fk_sort_code "+
				   		" order by sort_code ";
		   
		   pstmt = conn.prepareStatement(sql);
		   
		   rs = pstmt.executeQuery();
		   
		   while(rs.next()) {
			   
			   Map<String, Object> bannerMap = new HashMap<>();
			   
			   SortVO sort = new SortVO();
			   
			   sort.setSort_code(rs.getInt(1));
			   sort.setSort_name(rs.getString(2));
			   
			   bannerMap.put("sort", sort);			   
			   bannerMap.put("img", rs.getString(3));
			   
			   bannerList.add(bannerMap);
			   
		   }
		   		   
	   } finally {
		close();
	   }
	   
	   return bannerList;
   }

	
   /////////////////////////////////////////////////////////////////////////////////////////////////
   
   // 신규배너등록
   @Override	
   public int insertBanner(Map<String, String> paraMap) throws SQLException {
	
	   int result = 0;
		
	   try {
		
		   conn = ds.getConnection();
		   
		   String sql = " insert into tbl_prod_ad(fk_sort_code, ad_img_url) " + 
		   				" values(?, ?) ";
		   
		   pstmt = conn.prepareStatement(sql);
		   
		   pstmt.setString(1, paraMap.get("sort_code"));
		   pstmt.setString(2, paraMap.get("ad_img_url"));
		   
		   result = pstmt.executeUpdate();		   
		   
	   } finally {
		   close();
	   }
	   
	   return result;
	
   }

   ////////////////////////////////////////////////////////////////////////////////
   
   // 배너삭제
	@Override
	public int deleteBanner(String this_sort_code) throws SQLException {
		
		int result = 0;
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " delete from tbl_prod_ad where fk_sort_code = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, this_sort_code);
			
			result = pstmt.executeUpdate();
			
		} finally {
			close();
		}
		
		return result;
		
	}
	
	//////////////////////////////////////////////////////////////////////////
	
	// 배너수정
	@Override
	public int updateBanner(String this_sort_code, String ad_img_url_pick) throws SQLException {
		
		int result = 0;
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " update tbl_prod_ad set ad_img_url = ? where fk_sort_code = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, ad_img_url_pick);
			pstmt.setString(2, this_sort_code);
			
			result = pstmt.executeUpdate();
			
		} finally {
			close();
		}
		
		return result;
		
	}

	///////////////////////////////////////////////////////////////////////////////
	
	// 리뷰를 작성할 주문건 가져오기
	@Override
	public String getOrdernoforReview(String prod_code, String userid) throws SQLException {
		
		String orderno = "-9999";
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select distinct first_value(order_no) over(partition by reviewno order by order_no) AS order_no " + 
						 " from " + 
						 " ( " + 
						 " select order_no, nvl(reviewno, -9999) AS reviewno " + 
						 " from (  select order_no " + 
						 "         from ORDER_SETLE " + 
						 "         where fk_prod_code = ? and fk_user_id = ?) O LEFT JOIN tbl_review R ON O.order_no = R.fk_orderno " + 
						 " ) " + 
						 " where reviewno = -9999 ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, prod_code);
			pstmt.setString(2, userid);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				orderno = rs.getString(1);
			}
						
		} finally {
			close();
		}
		
		return orderno;
		
	}

	/////////////////////////////////////////////////////////////////////////////////////
	
	// 리뷰테이블 insert
	@Override
	public int insertReview(Map<String, String> paraMap) throws SQLException {
		
		int result = 0;
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " insert into tbl_review(reviewno, fk_orderno, fk_prod_code, fk_userid, content, review_img, score)"
					   + " values(seq_reviewno.nextval, ?, ?, ?, ?, ?, ?) ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, paraMap.get("orderno"));
			pstmt.setString(2, paraMap.get("prod_code"));
			pstmt.setString(3, paraMap.get("userid"));
			pstmt.setString(4, paraMap.get("content"));
			pstmt.setString(5, paraMap.get("review_img"));
			pstmt.setString(6, paraMap.get("score"));
			
			result = pstmt.executeUpdate();
			
			if(result != 0) {
				
				sql = " update tbl_member set point = point + ? where userid = ? ";
				
				pstmt = conn.prepareStatement(sql);
				
				if(paraMap.get("photo") == null) {
					pstmt.setInt(1, 100);
				}
				
				else {
					pstmt.setInt(1, 200);
				}
				
				pstmt.setString(2, paraMap.get("userid"));
				
				result = pstmt.executeUpdate();
				
			}
			
		} finally {
			close();
		}
		
		return result;
		
	}

	///////////////////////////////////////////////////////////////////////
	
	// 상품 리뷰 select	
	@Override
	public List<ReviewVO> getReviewList(String prod_code, String currentShowPageNo) throws SQLException {
		
		List<ReviewVO> reviewList = new ArrayList<>();
	
		try {
			
			conn = ds.getConnection();
			
			String sql = " select reviewno, name, content, review_img, score, review_date "+
						 " from  "+
						 " ( "+
						 " select rownum AS rno, reviewno, name, content, nvl(review_img, '-9999') as review_img, to_char(score, '0.0') as score, to_char(review_date, 'yyyy-mm-dd') as review_date " + 
						 " from  " + 
						 " ( " + 
						 "     select reviewno, fk_userid, content, review_img, score, review_date " + 
						 "     from tbl_review " + 
						 "     where fk_prod_code = ? " + 
						 "     order by review_date desc " + 
						 " )R  " + 
						 " JOIN  " + 
						 " ( " + 
						 "     select name, userid from tbl_member " + 
						 " ) M " + 
						 " ON R.fk_userid = M.userid " +
						 " ) T " +
						 " where rno between ? and ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, prod_code);
			
			int n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			pstmt.setInt(2, (n_currentShowPageNo * 8) - (8 - 1)); // 페이징 공식(start)
			pstmt.setInt(3, (n_currentShowPageNo * 8)); // 페이징 공식(end)
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				ReviewVO rvo = new ReviewVO();
				
				rvo.setReviewno(rs.getString(1));
				rvo.setUsername(rs.getString(2));
				rvo.setContent(rs.getString(3));
				rvo.setReview_img(rs.getString(4));
				rvo.setScore(rs.getString(5));
				rvo.setReview_date(rs.getString(6));
				
				reviewList.add(rvo);
				
			}
			
		} finally {
			close();
		}
		
		return reviewList;
	
	}

	/////////////////////////////////////////////////////////////////////////
	
	// 상품 평점 select
	@Override
	public String getAvgScore(String prod_code) throws SQLException {
		
		String avg_score = "";
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select avg(to_number(score)) AS avg_score " + 
						 " from tbl_review " + 
						 " where fk_prod_code = ? " + 
						 " group by fk_prod_code ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, prod_code);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				avg_score = rs.getString(1);
			}
			
			else {
				avg_score = "0.0";
			}
			
			
		} finally {
			close();
		}
		
		return avg_score;
		
	}

	/////////////////////////////////////////////////////////////////////////
	
	// 상품 평점별 갯수 select
	@Override
	public List<Map<String, String>> getScoreCnt(String prod_code) throws SQLException {
		
		List<Map<String, String>> scoreCntList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			for(int i = 5; i > 0; i--) {
				
				String sql = " select nvl(sum(count(reviewno)), 0) AS count " + 
						 	 " from tbl_review " + 
						 	 " where fk_prod_code = ? and ";
				
				if(i != 1) {
					sql += " (? < score and score <= ?) ";
				}
				
				else {
					sql += " (? <= score and score <= ?) ";
				}
				
				sql += " group by score order by score ";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, prod_code);
				pstmt.setInt(2, i-1);
				pstmt.setInt(3, i);
				
				rs = pstmt.executeQuery();
				
				Map<String, String> scoreCntMap = new HashMap<>();
				
				if(rs.next()) {
					scoreCntMap.put("score", i+"");
					scoreCntMap.put("cnt", rs.getString(1));
				}
				
				else {
					scoreCntMap.put("score", i+"");
					scoreCntMap.put("cnt", "0");
				}
				
				scoreCntList.add(scoreCntMap);
				
			}
						
		} finally {
			close();
		}
		
		return scoreCntList;
		
	}

	////////////////////////////////////////////////////////////////////////////
	
	// 리뷰 페이징 처리를 위한 페이지바 만들기
	@Override
	public Map<String, String> getReviewTotal(String prod_code) throws SQLException {
		
		Map<String, String> reviewTotalMap = new HashMap<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select ceil(count(*)/8), count(*) " + 
						 "from tbl_review " + 
						 "where fk_prod_code = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, prod_code);
			
			rs = pstmt.executeQuery();
			
			rs.next();
			
			reviewTotalMap.put("reviewTotalPage", rs.getString(1));
			reviewTotalMap.put("reviewTotalCnt", rs.getString(2));
			
		} finally {
			close();
		}
		
		return reviewTotalMap;
		
	}
	
	// 장바구니 테이블  insert
	   @Override
	   public int insertBasket(Map<String, Object> paraMap) throws SQLException {
	      
	      int result = 0;
	      
	      try {
	         
	         conn = ds.getConnection();
	                  
	         String[] arrProd_code = (String[]) paraMap.get("arrProd_code");
	         String[] arrAmount = (String[]) paraMap.get("arrAmount");
	         String userid = (String) paraMap.get("userid");
	         
	         for(int i=0; i<arrProd_code.length; i++) {            

	            String sql = " insert into tbl_basket(BASKET_NO, FK_USER_ID, FK_PROD_CODE, GOODS_QY) " + 
	                      " values(BASKET_NO.nextval, ?, ?, ?) ";
	            
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setString(1, userid);
	            pstmt.setString(2, arrProd_code[i]);
	            pstmt.setString(3, arrAmount[i]);
	            
	            result = pstmt.executeUpdate();            
	            
	         }
	         
	      } finally {
	         close();
	      }
	      
	      return result;
	      
	   }

	/////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////////
	
	// 상품 입고, 폐기 기록 가져오기
	@Override
	public List<InOutVO> getInOutList(String prod_code) throws SQLException {
		
		List<InOutVO> inoutList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select inout_code, status, fk_prod_code, inout_qty, nvl(inout_exp, '-9999') as inout_exp " + 
						 "      , to_char(inout_date, 'yyyy-mm-dd hh24:mi:ss') as inout_date " + 
						 " from tbl_inout_stock where fk_prod_code = ? " + 
						 " order by inout_date desc ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, prod_code);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				InOutVO iovo = new InOutVO();
				
				iovo.setInout_code(rs.getInt(1));
				iovo.setStatus(rs.getInt(2));
				iovo.setProd_code(rs.getString(3));
				iovo.setInout_qty(rs.getInt(4));
				iovo.setInout_exp(rs.getString(5));
				iovo.setInout_date(rs.getString(6));
				
				inoutList.add(iovo);
				
			}
			
		} finally {
			close();
		}
		
		return inoutList;
		
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 상품정보가져오기(관리자버전)
	@Override
	public Map<String, Object> getAdminProdDetail(String prod_code) throws SQLException {

		   Map<String, Object> prodMap = new HashMap<>();
		   
		   try {
			   
			   conn = ds.getConnection();
			   
			   // 상품 정보 가져오기(tbl_prod, tbl_prod_info, tbl_stock)
			   String sql = " select A.sort_code, A.prod_code, prod_name, prod_exp, prod_price, prod_ice, prod_plus, prod_select, discount_price, prod_stock, A.sort_name, prod_sale " + 
					   		" from " + 
					   		" ( " + 
					   		"     select P.sort_name, P.sort_code, P.prod_code, prod_name, prod_exp, prod_price, prod_ice, prod_plus, prod_select, nvl(discount_price,-9999) AS discount_price, prod_sale " + 
					   		"     from tbl_prod_info I " + 
					   		"         JOIN " + 
					   		"             ( " + 
					   		"                 select sort_name, fk_sort_code AS sort_code, prod_code " + 
					   		"                 from tbl_prod N JOIN tbl_sort M ON N.fk_sort_code = M.sort_code " + 
					   		"                 where prod_code = ? " + 
					   		"             ) P " + 
					   		"         ON P.prod_code = I.fk_prod_code " +  
					   		" )A  JOIN tbl_stock S " + 
					   		"     ON A.prod_code = S.fk_prod_code ";
			   
			   pstmt = conn.prepareStatement(sql);
			   
			   pstmt.setString(1, prod_code);
			   
			   rs = pstmt.executeQuery();
			   
			   if(rs.next()) {
				   
				   ProductVO pvo = new ProductVO();
				   
				   pvo.setSort_code(rs.getInt(1));
				   pvo.setProd_code(rs.getString(2));
				   pvo.setProd_name(rs.getString(3));
				   pvo.setProd_exp(rs.getString(4));
				   pvo.setProd_price(rs.getInt(5));
				   pvo.setProd_ice(rs.getInt(6));
				   pvo.setProd_plus(rs.getInt(7));
				   pvo.setProd_select(rs.getInt(8));
				   pvo.setDiscount_price(rs.getInt(9));
				   pvo.setProd_stock(rs.getInt(10));
				   pvo.setSort_name(rs.getString(11));
				   pvo.setProd_sale(rs.getInt(12));
				   
				   prodMap.put("pvo", pvo);
				   
				   // 타이틀 이미지 가져오기			   
				   sql = " select prod_img_url from tbl_prod_img where fk_prod_code = ? order by prod_img_code ";
				   
				   pstmt = conn.prepareStatement(sql);
				   
				   pstmt.setString(1, prod_code);
				   
				   rs = pstmt.executeQuery();
				   
				   List<String> titleImgList = new ArrayList<>();
				   
				   while(rs.next()) {				   
					   titleImgList.add(rs.getString(1));			   
				   }
				   
				   prodMap.put("titleImgList", titleImgList);
				   
				   // 상세 이미지 가져오기			   
				   sql = " select prod_img_detail_url from tbl_prod_img_detail where fk_prod_code = ? order by prod_img_detail_code ";
				   
				   pstmt = conn.prepareStatement(sql);
				   
				   pstmt.setString(1, prod_code);
				   
				   rs = pstmt.executeQuery();
				   
				   List<String> detailImgList = new ArrayList<>();
				   
				   while(rs.next()) {				   
					   detailImgList.add(rs.getString(1));				   
				   }
				   
				   prodMap.put("detailImgList", detailImgList);
				   
				   // 추가구성상품이 있을 경우 추가구성상품 목록 가져오기
				   if(pvo.getProd_plus() == 1) {
					   
					   sql = " select I.fk_prod_code, prod_name, prod_price, discount_price, prod_stock, prod_img_url " + 
					   		 " from " + 
					   		 "     ( " + 
					   		 "         select A.fk_prod_code, prod_name, prod_price, nvl(discount_price,-9999) AS discount_price, prod_stock " + 
					   		 "         from tbl_prod_info A JOIN tbl_stock S ON A.fk_prod_code = S.fk_prod_code " + 
					   		 "         where A.fk_prod_code in ( " + 
					   		 "                                     select fk_prod_plus_code AS prod_plus_code " + 
					   		 "                                     from tbl_prod_plus " + 
					   		 "                                     where fk_prod_code = ? " + 
					   		 "                                  ) and prod_sale = 1 " + 
					   		 "      ) I " + 
					   		 " JOIN ( " + 
					   		 "        select distinct first_value(prod_img_url) over(partition by fk_prod_code order by prod_img_code) AS prod_img_url " + 
					   		 "             , fk_prod_code " + 
					   		 "        from tbl_prod_img " + 
					   		 "       ) T " + 
					   		 " ON I.fk_prod_code = T.fk_prod_code order by 1 ";
					   
					   pstmt = conn.prepareStatement(sql);
					   
					   pstmt.setString(1, prod_code);
					   
					   rs = pstmt.executeQuery();
					   
					   List<ProductVO_KJH> plusList = new ArrayList<>();
					   
					   while(rs.next()) {
						   
						   ProductVO_KJH plusvo = new ProductVO_KJH();
						   
						   plusvo.setProd_code(rs.getString(1));
						   plusvo.setProd_name(rs.getString(2));
						   plusvo.setProd_price(rs.getInt(3));
						   plusvo.setDiscount_price(rs.getInt(4));
						   plusvo.setProd_stock(rs.getInt(5));
						   
						   ImageVO imgvo = new ImageVO();
						   
						   imgvo.setProd_img_url(rs.getString(6));
						   
						   plusvo.setImgvo(imgvo);
						   
						   plusList.add(plusvo);					   
						   
					   }// end of while---------------------------
					   
					   prodMap.put("plusList", plusList);
					   
				   }  
				   
				   // 골라담기 상품일 경우 골라담기구성상품 목록 가져오기
				   if(pvo.getProd_select() != 0) {
						   
					   sql = " select I.fk_prod_code, prod_name, prod_price, discount_price, prod_stock, prod_img_url " + 
					   		 " from " + 
					   		 "     ( " + 
					   		 "         select A.fk_prod_code, prod_name, prod_price, nvl(discount_price,-9999) AS discount_price, prod_stock " + 
					   		 "         from tbl_prod_info A JOIN tbl_stock S ON A.fk_prod_code = S.fk_prod_code " + 
					   		 "         where A.fk_prod_code in ( " + 
					   		 "                                     select fk_prod_select_code AS prod_select_code " + 
					   		 "                                     from tbl_prod_select " + 
					   		 "                                     where fk_prod_code = ? " + 
					   		 "                                  ) AND prod_sale = 1 " + 
					   		 "      ) I " + 
					   		 " JOIN ( " + 
					   		 "        select distinct first_value(prod_img_url) over(partition by fk_prod_code order by prod_img_code) AS prod_img_url " + 
					   		 "             , fk_prod_code " + 
					   		 "        from tbl_prod_img " + 
					   		 "       ) T " + 
					   		 " ON I.fk_prod_code = T.fk_prod_code order by 1 ";
					   
					   pstmt = conn.prepareStatement(sql);
					   
					   pstmt.setString(1, prod_code);
					   
					   rs = pstmt.executeQuery();
					   
					   List<ProductVO_KJH> selectList = new ArrayList<>();
					   
					   while(rs.next()) {
						   
						   ProductVO_KJH selectvo = new ProductVO_KJH();
						   
						   selectvo.setProd_code(rs.getString(1));
						   selectvo.setProd_name(rs.getString(2));
						   selectvo.setProd_price(rs.getInt(3));
						   selectvo.setDiscount_price(rs.getInt(4));
						   selectvo.setProd_stock(rs.getInt(5));
						   
						   ImageVO imgvo = new ImageVO();
						   
						   imgvo.setProd_img_url(rs.getString(6));
						   
						   selectvo.setImgvo(imgvo);
						   
						   selectList.add(selectvo);					   
						   
					   }// end of while---------------------------
					   
					   prodMap.put("selectList", selectList);
					   			   
				   }	
				   
			   }
			   	
		   } finally {
			   close();
		   }	
		   
		   return prodMap;
		   
	}

	//////////////////////////////////////////////////////////////////////////////////////
	
	// 상품 삭제
	@Override
	public int deleteProduct(String prod_code) throws SQLException {
		
		int result = 0;
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " delete from tbl_prod where prod_code = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, prod_code);
			
			result = pstmt.executeUpdate();
			
		} finally {
			close();
		}
		
		return result;
		
	}

	////////////////////////////////////////////////////////////////////////////////////////
	
	// 배너리스트 파일명 select
	@Override
	public List<Map<String, String>> getBannerList() throws SQLException {
		
		List<Map<String, String>> bannerList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select ad_img_url, fk_sort_code from tbl_prod_ad order by fk_sort_code ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				Map<String, String> bannerMap = new HashMap<>();
				
				bannerMap.put("img", rs.getString(1));
				bannerMap.put("sort_code", rs.getString(2));
				
				bannerList.add(bannerMap);
				
			}
			
		} finally {
			close();
		}
		
		return bannerList;
		
	}

	///////////////////////////////////////////////////////////////////////////////////////////
	
	// NEW 상품 4개 select
	@Override
	public List<ProductVO_KJH> getNewList() throws SQLException {
		
		List<ProductVO_KJH> newList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select prod_code, prod_name, prod_price, nvl(discount_price, -9999) as discount_price, prod_img_url " + 
						 " from " + 
						 " ( " + 
						 "     select rownum, prod_code, prod_name, prod_price, discount_price, to_char(prod_date, 'yyyy-mm-dd hh24:mi:ss') as prod_date " + 
						 "            , prod_stock, prod_img_url " + 
						 "     from " + 
						 "     ( " + 
						 "         select distinct prod_code, prod_name, prod_price, discount_price, prod_date " + 
						 "                , prod_stock, first_value(prod_img_url) over(partition by fk_prod_code order by prod_img_code) AS prod_img_url " + 
						 "         from " + 
						 "         ( " + 
						 "             select prod_code, prod_name, prod_price, prod_sale, discount_price, prod_date, prod_stock " + 
						 "             from  " + 
						 "             ( " + 
						 "                 select prod_code, prod_name, prod_price, prod_sale, discount_price, prod_date " + 
						 "                 from " + 
						 "                 tbl_prod P JOIN tbl_prod_info I ON P.prod_code = I.fk_prod_code where fk_sort_code != -9999 " + 
						 "             ) A JOIN tbl_stock S ON A.prod_code = S.fk_prod_code " + 
						 "         ) B JOIN tbl_prod_img F ON B.prod_code = F.fk_prod_code " + 
						 "         where prod_sale != 0 " + 
						 "         order by prod_date desc " + 
						 "     ) " + 
						 " ) " + 
						 " where rownum between 1 and 4 " + 
						 " order by rownum ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				ProductVO_KJH pvo = new ProductVO_KJH();
				
				pvo.setProd_code(rs.getString(1));
				pvo.setProd_name(rs.getString(2));
				pvo.setProd_price(rs.getInt(3));
				pvo.setDiscount_price(rs.getInt(4));
				
				ImageVO ivo = new ImageVO();
				
				ivo.setProd_img_url(rs.getString(5));
				
				pvo.setImgvo(ivo);
				
				newList.add(pvo);
				
			}
			
		} finally {
			close();
		}
		
		return newList;
		
	}

	///////////////////////////////////////////////////////////////////////////////
	
	// HIT 상품 4개 select
	@Override
	public List<ProductVO_KJH> getHitList() throws SQLException {
		
		List<ProductVO_KJH> hitList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select prod_code, prod_name, prod_price, nvl(discount_price, -9999) as discount_price, prod_img_url " + 
						 " from view_prodonedetail " + 
						 " where prod_code IN  ( " + 
						 "                         select prod_code " + 
						 "                         from " + 
						 "                         ( " + 
						 "                         select prod_code, rank() over(order by cnt desc) as rank " + 
						 "                         from ( " + 
						 "                             select fk_prod_code as prod_code, count(*) as cnt  " + 
						 "                             from ORDER_SETLE " + 
						 "                             where order_dt between (sysdate - 7) and sysdate  " + 
						 "                             group by fk_prod_code " + 
						 "                             ) " + 
						 "                         ) " + 
						 "                         where rank between 1 and 4 " + 
						 "                     ) ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			
			while(rs.next()) {

				cnt++;
				
				if(cnt > 4) break;
				
				ProductVO_KJH pvo = new ProductVO_KJH();
				
				pvo.setProd_code(rs.getString(1));
				pvo.setProd_name(rs.getString(2));
				pvo.setProd_price(rs.getInt(3));
				pvo.setDiscount_price(rs.getInt(4));
				
				ImageVO ivo = new ImageVO();
				
				ivo.setProd_img_url(rs.getString(5));
				
				pvo.setImgvo(ivo);
				
				hitList.add(pvo);
				
			}
			
		} finally {
			close();
		}
		
		return hitList;
		
	}

	///////////////////////////////////////////////////////////////////////
	
	// BEST 상품 4개 select
	@Override
	public List<ProductVO_KJH> getBestList() throws SQLException {

		List<ProductVO_KJH> bestList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select prod_code, prod_name, prod_price, nvl(discount_price, -9999) as discount_price, prod_img_url " + 
						 " from view_prodonedetail " + 
						 " where prod_code IN  ( " + 
						 "                         select prod_code " + 
						 "                         from " + 
						 "                         ( " + 
						 "                         select prod_code, rank() over(order by cnt desc) as rank " + 
						 "                         from ( " + 
						 "                             select fk_prod_code as prod_code, count(*) as cnt  " + 
						 "                             from ORDER_SETLE " +  
						 "                             group by fk_prod_code " + 
						 "                             ) " + 
						 "                         ) " + 
						 "                         where rank between 1 and 4 " + 
						 "                     ) ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			
			while(rs.next()) {
				
				cnt++;
				
				if(cnt > 4) break;
				
				ProductVO_KJH pvo = new ProductVO_KJH();
				
				pvo.setProd_code(rs.getString(1));
				pvo.setProd_name(rs.getString(2));
				pvo.setProd_price(rs.getInt(3));
				pvo.setDiscount_price(rs.getInt(4));
				
				ImageVO ivo = new ImageVO();
				
				ivo.setProd_img_url(rs.getString(5));
				
				pvo.setImgvo(ivo);
				
				bestList.add(pvo);
				
			}
			
		} finally {
			close();
		}
		
		return bestList;
		
	}

	//////////////////////////////////////////////////////////////////////////
	
	// SALE 상품 4개 select
	@Override
	public List<ProductVO_KJH> getSaleList() throws SQLException {

		List<ProductVO_KJH> saleList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select prod_code, prod_name, prod_price, discount_price, prod_img_url " + 
						 " from " + 
						 " ( " + 
						 "     select rownum, prod_code, prod_name, prod_price, discount_price, prod_img_url " + 
						 "     from view_prodonedetail " + 
						 "     where discount_price >= 0 " + 
						 " ) " + 
						 " where rownum between 1 and 4 ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
						
			while(rs.next()) {
				
				ProductVO_KJH pvo = new ProductVO_KJH();
				
				pvo.setProd_code(rs.getString(1));
				pvo.setProd_name(rs.getString(2));
				pvo.setProd_price(rs.getInt(3));
				pvo.setDiscount_price(rs.getInt(4));
				
				ImageVO ivo = new ImageVO();
				
				ivo.setProd_img_url(rs.getString(5));
				
				pvo.setImgvo(ivo);
				
				saleList.add(pvo);
				
			}
			
		} finally {
			close();
		}
		
		return saleList;
		
	}
	
	//////////////////////////////////////////////////////////////////////////

	// 최신 리뷰 4개 select
	@Override
	public List<ReviewVO> getReviewList() throws SQLException {
		
		List<ReviewVO> reviewList = new ArrayList<>();
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select reviewno, name, content, nvl(review_img, '-9999') as review_img, to_char(score, '0.0'), review_date, prod_name, fk_prod_code  " + 
						 " from " + 
						 " ( " + 
						 "     select rownum, reviewno, name, content, review_img, score, to_char(review_date, 'yyyy-mm-dd') as review_date, prod_name, fk_prod_code  " + 
						 "     from  " + 
						 "     ( " + 
						 "         select reviewno, fk_userid, content, review_img, score, review_date, prod_name, A.fk_prod_code " + 
						 "         from tbl_review A JOIN tbl_prod_info B ON A.fk_prod_code = B.fk_prod_code " + 
						 "         order by review_date desc " + 
						 "     )R  " + 
						 "     JOIN  " + 
						 "     ( " + 
						 "         select name, userid from tbl_member " + 
						"     ) M  " + 
						"     ON R.fk_userid = M.userid " + 
						" ) " + 
						" where rownum between 1 and 4 ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				ReviewVO rvo = new ReviewVO();
				
				rvo.setReviewno(rs.getString(1));
				rvo.setUsername(rs.getString(2));
				rvo.setContent(rs.getString(3));
				rvo.setReview_img(rs.getString(4));
				rvo.setScore(rs.getString(5));
				rvo.setReview_date(rs.getString(6));
				rvo.setProd_name(rs.getString(7));
				rvo.setProd_code(rs.getString(8));
				
				reviewList.add(rvo);
				
			}
			
		} finally {
			close();
		}
		
		return reviewList;
		
	}

	/////////////////////////////////////////////////////////////////////////////////////
	
	// 상품 검색 결과 select
	@Override
	public List<ProductVO_KJH> getSearchResult(String searchWord) throws SQLException {
		
		List<ProductVO_KJH> productList = new ArrayList<>();	
		
		try {
			
			conn = ds.getConnection();
			
			String sql = " select prod_img_url, prod_name, prod_price, nvl(discount_price, -9999), prod_code " + 
						 " from view_prodonedetail " + 
						 " where prod_name like '%' || ? || '%' and sort_code != -9999 " + 
						 " order by prod_code desc ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, searchWord);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				ProductVO_KJH pvo = new ProductVO_KJH();
				
				ImageVO ivo = new ImageVO();
				
				ivo.setProd_img_url(rs.getString(1));
				
				pvo.setImgvo(ivo);
				pvo.setProd_name(rs.getString(2));
				pvo.setProd_price(rs.getInt(3));
				pvo.setDiscount_price(rs.getInt(4));
				pvo.setProd_code(rs.getString(5));
				
				productList.add(pvo);
				
			}
			
		} finally {
			close();
		}
		
		return productList;
	
	}

}
