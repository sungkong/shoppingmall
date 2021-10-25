package board.member;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import board.common.JdbcUtil;
import util.security.AES256;
import util.security.SecretMyKey;

public class MypageDAO {
	private JdbcUtil ju;
	
	
	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	public MypageDAO() {
		
		
		ju = JdbcUtil.getInstance();
		
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/semioracle");
		    
		    aes = new AES256(SecretMyKey.KEY);
		    // SecretMyKey.KEY 는 우리가 만든 비밀키이다.
	    } catch(NamingException e) {
			e.printStackTrace();
		} catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		
	}
	
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
	   
	   // 삽입
	   public int insert(MypageVO vo) {
		   Connection conn = null;
		   PreparedStatement pstmt = null;
		   String sql = " insert into Mypage(myno,mytitle,myday ,fk_userid,myview,mycontent) " + 
			   		" values(Mypage_seq.nextval, '제목1', sysdate, 'ohjw', 0, '제가 쓴 글내용입니다.') ";
			   int ret = -1;
		   try {
			   conn = ju.getConnection();
			   pstmt = conn.prepareStatement(sql);
			   pstmt.setInt(1, vo.getMyno());
			   pstmt.setString(2, vo.getMytitle());
			   pstmt.setString(3, vo.getMyday());
			   pstmt.setString(4, vo.getFk_userid());
			   pstmt.setInt(5, vo.getMyview());
			   pstmt.setString(6, vo.getMycontent());
			   ret = pstmt.executeUpdate();
			   
		   }catch(SQLException e) {
			   e.printStackTrace();
		   }finally {
			   if(conn != null) {
				   try {
					conn.close();
				   } catch (SQLException e) {
					
					e.printStackTrace();
				   }
				   
			   }
			   if(pstmt != null) {
				   try {
					pstmt.close();
				   } catch (SQLException e) {
					
					e.printStackTrace();
				   }
				   
			   }
			   
		   }
		   return ret;
	   }
	   
	   
	   
	   
	// 조회하기
	   public List<MypageVO> selectpage() {
		   Connection conn = null;
		   Statement stmt = null;
		   ResultSet rs = null;
		   String sql = " select myno,mytitle,myday ,fk_userid,myview,mycontent " + 
		   		" from Mypage ";
		   ArrayList<MypageVO> as = new ArrayList<MypageVO>();
		   
		   try {
			   conn = ju.getConnection();
			   stmt = conn.createStatement();
			   rs = stmt.executeQuery(sql);
			   while(rs.next()) {
				   MypageVO mvo = new MypageVO(
						   rs.getInt(1),
						   rs.getString(2),
						   rs.getString(3),
						   rs.getString(4),
						   rs.getInt(5),
						   rs.getString(6));
					as.add(mvo);	   
			   }
		   }catch(SQLException e) {
			   e.printStackTrace();
		   }finally {
			   if(rs != null) {
				   try {
					rs.close();
				   } catch (SQLException e) {
					
					e.printStackTrace();
				   }
				   
			   }
			   if(stmt != null) {
				   try {
					stmt.close();
				   } catch (SQLException e) {
					
					e.printStackTrace();
				   }
				   
			   }
			   if(conn != null) {
				   try {
					conn.close();
				   } catch (SQLException e) {
					
					e.printStackTrace();
				   }
				   
			   }
		   }
		   return as;
		   
	   }
	   
	   
	   
	// 조회하기
	   public MypageVO selectpageOne(int myno) {
		   Connection conn = null;
		   PreparedStatement pstmt = null;
		   ResultSet rs = null;
		   String sql = " select myno,mytitle,myday ,fk_userid,myview,mycontent " + 
		   		" from Mypage " + 
		   		" where myno = ? ";
		   MypageVO mvo = null;
		   try {
			   conn = ju.getConnection();
			   pstmt = conn.prepareStatement(sql);
			   pstmt.setInt(1, myno);
			   rs = pstmt.executeQuery();
			   if(rs.next()) {
				   updateView(myno); // 조회수 증가하는 것
				   mvo = new MypageVO(
						   rs.getInt(1),
						   rs.getString(2),
						   rs.getString(3),
						   rs.getString(4),
						   rs.getInt(5),
						   rs.getString(6));
						   
			   }
		   }catch(SQLException e) {
			   e.printStackTrace();
		   }finally {
			   if(rs != null) {
				   try {
					rs.close();
				   } catch (SQLException e) {
					
					e.printStackTrace();
				   }
				   
			   }
			   if(pstmt != null) {
				   try {
					pstmt.close();
				   } catch (SQLException e) {
					
					e.printStackTrace();
				   }
				   
			   }
			   if(conn != null) {
				   try {
					conn.close();
				   } catch (SQLException e) {
					
					e.printStackTrace();
				   }
				   
			   }
		   }
		   return mvo;
		   
	   }
	   // 조회수 1증가하기
	   public int updateView(int myno) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			String sql = " update Mypage set myview = myview+1 where myno = ? " ;
			int ret = -1;
			try {
				conn = ju.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, myno);
				ret = pstmt.executeUpdate();
				
				
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if(pstmt != null) {
					try {
						pstmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
				if(conn != null) {
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			return ret;
		}
	   
	   
	   
	   
}
