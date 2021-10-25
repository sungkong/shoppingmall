package board.member;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.*;
import java.util.*;
import java.util.Date;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import board.common.JdbcUtil;
import member.model.MemberVO;
import util.security.AES256;
import util.security.SecretMyKey;

public class BoardDAO implements InterBoardDAO {
	
	private JdbcUtil ju;
	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	public BoardDAO() {
		
		
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
	public int insert(BoardVO vo) {
		
		String query = " insert into board(num,title,writer,content,regdate,cnt) "+
				" values(board_seq.nextval, ?, ?, ?, sysdate, 0) ";
		int ret = -1;
		try {
			conn = ju.getConnection();
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, vo.getTitle());
			pstmt.setString(2, vo.getWriter());
			pstmt.setString(3, vo.getContent());
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
	// 조회
	public List<BoardVO> selectAll() {
		
		Statement stmt = null;
		
		String query = " select num,title,writer,content,to_char(regdate,'yyyy-mm-dd hh24:mi:ss') AS regdate, cnt "+
				" from board  " +
				" order by num " ;
		ArrayList<BoardVO> ls = new ArrayList<BoardVO>();
		
		try {
			conn = ju.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);
			while(rs.next()) {
				BoardVO vo = new BoardVO(
						rs.getInt(1),
						rs.getString(2),
						rs.getString(3),
						rs.getString(4),
						rs.getString(5),
						rs.getInt(6));
				ls.add(vo);
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} finally {
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
		return ls;
	}
	
	// 조회 한개만
		public BoardVO selectOne(int num) {
			
			String query = " select num,title,writer,content,regdate,cnt "+
					" from board "+
					" where num=? ";
			ArrayList<BoardVO> ls = new ArrayList<BoardVO>();
			BoardVO vo = null;
			try {
				conn = ju.getConnection();
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					updateCnt(num); // 조회수 증가
					vo = new BoardVO(
							rs.getInt(1),
							rs.getString(2),
							rs.getString(3),
							rs.getString(4),
							rs.getString(5),
							rs.getInt(6) + 1);
					
				}
			} catch(SQLException e) {
				e.printStackTrace();
			} finally {
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
			return vo;
		}
	
	// 수정
		
		public int updateCnt(int num) {
			
			String query = " update \"BOARD\" set \"CNT\"=\"CNT\"+1 where \"NUM\"=?" ;
			int ret = -1;
			try {
				conn = ju.getConnection();
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, num);
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
		
		public int update(BoardVO vo) {
			
			String query = "update board set title=?, content=? "+
					" where num=? ";
			int ret = -1;
			try {
				conn = ju.getConnection();
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, vo.getTitle());
				pstmt.setString(2, vo.getContent());
				pstmt.setInt(3, vo.getNum());
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
	
	// 삭제
		public int delete(int num) {
			
			String query = "delete from board where num=?";
			int ret = -1;
			try {
				conn = ju.getConnection();
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, num);
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

		
		// 회원 검색기능 만들기 그리고 페이지당 개수
		@Override
		public List<BoardVO> selectPagingMember(Map<String, String> paraMap) throws SQLException {
			
			List<BoardVO> boardList = new ArrayList<>();
			
			
			try {
				conn = ds.getConnection();
				
				String sql = " select num, title, writer, regdate, cnt \r\n" + 
						"from \r\n" + 
						"(\r\n" + 
						"    select rownum AS RNO, num, title, writer, regdate, cnt \r\n" + 
						"    from \r\n" + 
						"    (\r\n" + 
						"     select num, title, writer, to_char(regdate,'yyyy-mm-dd hh24:mi:ss') AS regdate, cnt\r\n" + 
						"     from board\r\n" + 
						"     where writer != '관리자' " ; 
				
				String colname = paraMap.get("searchType");
				String searchWord = paraMap.get("searchWord");
				
				if( searchWord !=null && !searchWord.trim().isEmpty() ) {
					
					sql += " and "+colname+" like '%'|| ? ||'%' ";
					
				}
						
						
				
				sql +=	"    order by num desc " + 
						"    ) V " + 
						" )T " + 
						" where RNO between ? and ? ";
				pstmt = conn.prepareStatement(sql);
	            
				
				int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
	            int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
	            
	            if( searchWord != null && !searchWord.trim().isEmpty() ) {
		               pstmt.setString(1, searchWord);
		               pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1)); // 공식 
		               pstmt.setInt(3, (currentShowPageNo * sizePerPage)); // 공식
	            }
	            else {
	               pstmt.setInt(1, (currentShowPageNo * sizePerPage) - (sizePerPage - 1)); // 공식 
	               pstmt.setInt(2, (currentShowPageNo * sizePerPage)); // 공식
	            }
				
	            rs = pstmt.executeQuery();
	            
	            while(rs.next()) {
		               
                    BoardVO bvo = new BoardVO();
                    
                    bvo.setNum(rs.getInt("num"));
                	bvo.setTitle(rs.getString("title"));
                	bvo.setWriter(rs.getString("writer"));
                	bvo.setRegdate(rs.getString("regdate"));
                	bvo.setCnt(rs.getInt("cnt"));
                	                	
                	boardList.add(bvo);
	            }
	            
				
			} finally {
				close();
			}
			
			return boardList;
		}
		
		
		// 페이징 처리 검색 ox 총페이지 수
		@Override
		public int getTotalPage(Map<String, String> paraMap) throws SQLException {

			int totalPage = 0;
			
			try {
				conn = ds.getConnection();
				
				String sql = " select ceil(count(*)/?) " + 
						" from board " + 
						" where writer != '관리자' ";
				
				String colname = paraMap.get("searchType");
		        String searchWord = paraMap.get("searchWord");
		        
		        
		         
		        if( searchWord != null && !searchWord.trim().isEmpty() ) {
		            sql += " and "+colname+" like '%'|| ? ||'%' ";
		         }
		         
		         pstmt = conn.prepareStatement(sql);
		         
		         pstmt.setString(1, paraMap.get("sizePerPage"));
		         
		         if( searchWord != null && !searchWord.trim().isEmpty() ) {
		            pstmt.setString(2, searchWord);
		         }
		         
		         rs = pstmt.executeQuery();
		         
		         rs.next();
		         
		         totalPage = rs.getInt(1);
		        
			
			} finally {
				close();
			}
			
			return totalPage;
		}
		
		
		
		
		
		
		
}
