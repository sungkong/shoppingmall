package member.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import order.model.OrderSetleVO;
import util.paging.Pagination;
import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class MemberDAO implements InterMemberDAO {

	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	public MemberDAO() {
		
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/semioracle");
		    
			aes = new AES256(SecretMyKey.KEY); // AES256 암호화 객체 생성
				    
		} catch(NamingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void close() {
		
	      try {
	         if(rs != null)    {rs.close();    rs=null;}
	         if(pstmt != null) {pstmt.close(); pstmt=null;}
	         if(conn != null)  {conn.close();  conn=null;}
	      } catch(SQLException e) {
	         e.printStackTrace();
	      }
	   }

	public boolean idDuplicateCheck(String userid) throws SQLException {
		
		boolean isExist = false;
		try {
			conn = ds.getConnection();
			String sql = "select userid"
					+ " from tbl_member"
					+ " where userid = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			
			isExist = rs.next();
			
		} finally {
			close();
		}
		
		return isExist;
	}

	@Override
	public int registerMember(MemberVO member, String type) throws SQLException {
		
		int n = 0;
		String sql = "";
		try {
			conn = ds.getConnection();
			
			if(type.equalsIgnoreCase("normal")) {
				
					sql   += "insert into tbl_member(userid, pwd, name, email, mobile, gender, birthday, logintype) "     
		                  + "values(?, ?, ?, ?, ?, ?, ?, ?)"; 
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, member.getUserid());
				pstmt.setString(2, Sha256.encrypt(member.getPwd())); 
				pstmt.setString(3, member.getName());
				pstmt.setString(4, aes.encrypt(member.getEmail()));
				pstmt.setString(5, aes.encrypt(member.getMobile()));
		
				pstmt.setString(6, member.getGender());
				pstmt.setString(7, member.getBirthday());
				pstmt.setString(8, type);
				
			} else {
				
				if(member.getEmail() != null) {
					
					sql = "insert into tbl_member(userid, pwd, name, email, logintype) "			
		                + "values(?, ?, ?, ?, ?)";
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, member.getUserid());
					pstmt.setString(2, Sha256.encrypt(member.getPwd()));
					pstmt.setString(3, member.getName());
					pstmt.setString(4, aes.encrypt(member.getEmail()));
					pstmt.setString(5, type);
					
				} else {
					
					sql = "insert into tbl_member(userid, pwd, name, logintype) "		
		                + "values(?, ?, ?, ?)"; 
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, member.getUserid());
					pstmt.setString(2, Sha256.encrypt(member.getPwd()));
					pstmt.setString(3, member.getName());
					pstmt.setString(4, type);
				}		
			}
			
			n = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}	
		return n;
	}

	@Override
	public boolean emailDuplicateCheck(String email) throws SQLException {
		
		boolean isExist = false;
		try {
			conn = ds.getConnection();
			String sql = "select email"
					+ " from tbl_member"
					+ " where email = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, aes.encrypt(email));
			rs = pstmt.executeQuery();
			
			isExist = rs.next();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		
		return isExist;
	}

	@Override
	public MemberVO selectOneMember(Map<String, String> paraMap, String loginType) throws SQLException {
		
		MemberVO member = null;
		String sql = "";
		try {
			conn = ds.getConnection();
			
			if("normal".equalsIgnoreCase(loginType)) {
				
				   sql = "SELECT userid, name, email, mobile, gender"+
						", birthyyyy, birthmm, birthdd, point, registerday, pwdchangegap"+
						", NVL(lastlogingap, trunc(months_between(sysdate, registerday)) ) AS lastlogingap, grade, logintype "+
						"FROM "+
						"("+
						"select userid, name, email, mobile, gender"+
						", substr(birthday,1,4) AS birthyyyy, substr(birthday,6,2) AS birthmm, substr(birthday,9) AS birthdd"+
						", point, to_char(registerday, 'yyyy-mm-dd') AS registerday"+
						", trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap, grade, logintype "+
						"from tbl_member "+
						"where status = 1 and userid = ? and pwd = ?"+
						") M "+
						"CROSS JOIN "+
						"("+
						"select trunc( months_between(sysdate, max(logindate) ) ) AS lastlogingap "+
						"from tbl_loginhistory "+
						"where fk_userid = ?"+
						") H";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, paraMap.get("userid"));
				pstmt.setString(2, Sha256.encrypt(paraMap.get("pwd")));
				pstmt.setString(3, paraMap.get("userid"));
				
				rs = pstmt.executeQuery();
				if(rs.next()) {
					member = new MemberVO();
					
					member.setUserid(rs.getString(1));
					member.setName(rs.getString(2));
					member.setEmail(aes.decrypt(rs.getString(3)));
					member.setMobile( aes.decrypt(rs.getString(4)) ); // 복호화 
		            member.setGender(rs.getString(5));
		            
		            member.setBirthday(rs.getString(6) + rs.getString(7) + rs.getString(8));
		            member.setPoint(rs.getInt(9));
		            member.setRegisterday(rs.getString(10));
		            member.setGrade(rs.getInt(13));
		            member.setLoginType(rs.getString(14));
		            
		            if(rs.getInt(11) >= 3) {
		            	// 마지막으로 암호를 변경한 날짜가 현재시각으로 부터 3개월이 지났으면 true
		                // 마지막으로 암호를 변경한 날짜가 현재시각으로 부터 3개월이 지나지 않았으면 false
		            	member.setRequirePwdChange(true); // 로그인시 암호를 변경해라는 alert 를 띄우도록 할때 사용한다.
		            } else {
		            	member.setRequirePwdChange(false);
		            }
		            
		            if(rs.getInt(12) >= 12) {
		            	// 마지막으로 로그인 한 날짜시간이 현재시각으로 부터 1년이 지났으면 휴면으로 지정
		            	member.setIdle(1);
		            	
		            	sql = "update tbl_member set idle = 1 "
		            		+ "where userid = ? ";
		            	
		            	pstmt = conn.prepareStatement(sql);
		            	pstmt.setString(1, paraMap.get("userid"));
		            	
		            	pstmt.executeUpdate();
		            }
		            // === tbl_loginhistory(로그인기록) 테이블에 insert 하기 === //
		            if(member.getIdle() != 1) {
		            	
		            	sql = "insert into tbl_loginhistory(fk_userid, clientip) "
		            		+ "values(?, ?) ";
		            	pstmt = conn.prepareStatement(sql);
		            	pstmt.setString(1, paraMap.get("userid"));
		            	pstmt.setString(2, paraMap.get("clientip"));
		            	
		            	pstmt.executeUpdate();
		            }
				}
				
			} else {
				
				   sql = "SELECT userid, name, email, mobile, gender"+
						", birthyyyy, birthmm, birthdd, point, registerday, pwdchangegap"+
						", NVL(lastlogingap, trunc(months_between(sysdate, registerday)) ) AS lastlogingap, grade "+
						"FROM "+
						"("+
						"select userid, name, email, mobile, gender"+
						", substr(birthday,1,4) AS birthyyyy, substr(birthday,6,2) AS birthmm, substr(birthday,9) AS birthdd"+
						", point, to_char(registerday, 'yyyy-mm-dd') AS registerday"+
						", trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap, grade "+
						"from tbl_member "+
						"where status = 1 and userid = ? "+
						") M "+
						"CROSS JOIN "+
						"("+
						"select trunc( months_between(sysdate, max(logindate) ) ) AS lastlogingap "+
						"from tbl_loginhistory "+
						"where fk_userid = ?"+
						") H";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, paraMap.get("userid"));
				pstmt.setString(2, paraMap.get("userid"));
				
				rs = pstmt.executeQuery();
				if(rs.next()) {
					member = new MemberVO();
					
					member.setUserid(rs.getString(1));
					member.setName(rs.getString(2));
					member.setEmail(aes.decrypt(rs.getString(3)));
		            member.setPoint(rs.getInt(9));
		            member.setRegisterday(rs.getString(10));
		            member.setGrade(rs.getInt(13));
		            		          		            
		            if(rs.getInt(12) >= 12) {
		            	
		            	member.setIdle(1);
		            	
		            	sql = "update tbl_member set idle = 1 "
		            		+ "where userid = ? ";
		            	
		            	pstmt = conn.prepareStatement(sql);
		            	pstmt.setString(1, paraMap.get("userid"));
		            	
		            	pstmt.executeUpdate();
		            }
		
		            if(member.getIdle() != 1) {
		            	
		            	sql = "insert into tbl_loginhistory(fk_userid, clientip) "
		            		+ "values(?, ?) ";
		            	pstmt = conn.prepareStatement(sql);
		            	pstmt.setString(1, paraMap.get("userid"));
		            	pstmt.setString(2, paraMap.get("clientip"));
		            	
		            	pstmt.executeUpdate();
		            }
				}
				
			}
					
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return member;
	}

	@Override
	public int updateMember(MemberVO member) throws SQLException {
		
		int n = 0;
		try {
			conn = ds.getConnection();
			String sql = "update tbl_member set email = ?, mobile = ?, lastpwdchangedate = sysdate ";
			if(member.getPwd() != "") {
				   sql += ",pwd = ? ";
			}
				   sql += "where name = ?";
			
			pstmt = conn.prepareStatement(sql);        
	        pstmt.setString(1, aes.encrypt(member.getEmail()) );
	        pstmt.setString(2, aes.encrypt(member.getMobile()) );
	        
	        if(member.getPwd() != "") {
	        	pstmt.setString(3, Sha256.encrypt(member.getPwd()));
	        	pstmt.setString(4, member.getName() );
	        } else {
	        	pstmt.setString(3, member.getName() );
	        }
	
			n = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return n;
	}
	
	@Override
	public List<MemberVO> getMemberList(Pagination pg) throws SQLException {
		
		List<MemberVO> memberList = new ArrayList<>();
	
		try {
			conn = ds.getConnection();
			String sql = "SELECT userid, name, email, mobile, gender, birthday, point "
					+ "FROM "
					+ "    ("
					+ "        SELECT ROWNUM AS RNUM, V.* "
					+ "        FROM "
					+ "        (select userid, name, email, mobile, gender, birthday, point  "
					+ "            from tbl_member "
					+ " 		   where grade = 0 and status = 1 and idle = 0 ";
			String colname = pg.getSearchType();
			String keyword = pg.getKeyword();
			
			if("email".equals(colname)) {
				keyword = aes.encrypt(keyword);
			}
			
			if(keyword != null && !keyword.trim().isEmpty()) {
				sql += " 			and " + colname + " like '%'|| ? ||'%' ";
			}
	
			  sql +=  "            order by userid "
					+ "        ) V          "
					+ "        WHERE ROWNUM <= ? "
					+ "    ) "
					+ "WHERE ? <= RNUM";
			
			pstmt = conn.prepareStatement(sql);
			
	
			int currPageNo = pg.getCurrPageNo();
			int sizePerPage = pg.getSizePerPage();
			
			if(keyword != null && !keyword.trim().isEmpty()) {
				
				pstmt.setString(1, keyword);
				pstmt.setInt(2, currPageNo * sizePerPage );
				pstmt.setInt(3, pg.getStartList() );
				
			} else {
				
				pstmt.setInt(1, currPageNo * sizePerPage );
				pstmt.setInt(2, pg.getStartList() );
				
			}
	
						
			rs = pstmt.executeQuery();
					
			while(rs.next()) {
				MemberVO member = new MemberVO();
				
				member.setUserid(rs.getString(1));
				member.setName(rs.getString(2));
				member.setEmail(aes.decrypt(rs.getString(3)) );
				member.setMobile(aes.decrypt(rs.getString(4)));
				member.setGender(rs.getString(5));
				member.setBirthday(rs.getString(6));
				member.setPoint(rs.getInt(7));
								
				memberList.add(member);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return memberList;
	}

	@Override
	public int getTotalCnt(Pagination pg) throws SQLException {
		int totalCnt = 0;
		try {
			conn = ds.getConnection();
			String sql = "SELECT count(*) " +
						 "FROM tbl_member " +
						 "WHERE grade = 0 ";
			
			String colname = pg.getSearchType();
			String keyword = pg.getKeyword();
			
			if("email".equals(colname)) {
				keyword = aes.encrypt(keyword);
			}
			
			if(keyword != null && !keyword.trim().isEmpty() ) {
				sql += "AND " + colname + " like '%'|| ? || '%' ";
			}
			pstmt = conn.prepareStatement(sql);
			
			if(keyword != null && !keyword.trim().isEmpty() ) {
				pstmt.setString(1, keyword);
			}
			rs = pstmt.executeQuery();
			rs.next();
			
			totalCnt = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return totalCnt;
	}

	/*
	 * 배송지 관련 메소드
	 */
	
	// 배송지 등록하기
	@Override
	public int registerAddress(AddressVO address) throws SQLException {
		
		int result = 0;
		try {
			conn = ds.getConnection();
			String sql = "insert into TBL_ADDRESS_LIST(ANO, DELIVERNAME, USERID, POSTCODE, ADDRESS, DETAILADDRESS, EXTRAADDRESS, DEFAULT_YN, HOMETEL, MOBILE, NAME) "
	                   + "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; 
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setLong(1, address.getAno());
			pstmt.setString(2, address.getDelivername());
			pstmt.setString(3, address.getUserid());
			pstmt.setString(4, address.getPostcode());
			pstmt.setString(5, address.getAddress());
			pstmt.setString(6, address.getDetailaddress());
			pstmt.setString(7, address.getExtraaddress());
			pstmt.setString(8, address.getDefault_yn());
			pstmt.setString(9, address.getHometel());
			pstmt.setString(10, address.getMobile());
			pstmt.setString(11, address.getName());
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}	
		
		return result;
	}

	@Override
	public List<AddressVO> getAddressList(String userid) throws SQLException {
		
		List<AddressVO> addrList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			String sql = "SELECT DELIVERNAME, USERID, POSTCODE, ADDRESS, DETAILADDRESS, EXTRAADDRESS, DEFAULT_YN, HOMETEL, MOBILE, NAME, ANO "
					+ "FROM TBL_ADDRESS_LIST "
					+ "WHERE userid = ? "
					+ "ORDER BY DEFAULT_YN desc";
			pstmt = conn.prepareStatement(sql);		
			pstmt.setString(1, userid);
			
						
			rs = pstmt.executeQuery();
					
			while(rs.next()) {
				
				AddressVO addressVo = new AddressVO();
				addressVo.setDelivername(rs.getString(1));
				addressVo.setUserid(rs.getString(2));
				addressVo.setPostcode(rs.getString(3));
				addressVo.setAddress(rs.getString(4));
				addressVo.setDetailaddress(rs.getString(5));
				addressVo.setExtraaddress(rs.getString(6));
				addressVo.setDefault_yn(rs.getString(7));
				addressVo.setHometel(rs.getString(8));
				addressVo.setMobile(rs.getString(9));
				addressVo.setName(rs.getString(10));
				addressVo.setAno(rs.getLong(11));
											
				addrList.add(addressVo);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return addrList;
	}

	@Override
	public int changeAddressDefaultN(AddressVO addressVo) throws SQLException {

		int result = 0;
		try {
			conn = ds.getConnection();
			String sql = "UPDATE TBL_ADDRESS_LIST SET default_yn = 'n' "
						+ "WHERE userid = ? and ano != ?";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, addressVo.getUserid());
	        pstmt.setLong(2, addressVo.getAno());
	   
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		
		return result;
	}

	@Override
	public int getAddressCnt(String userid) throws SQLException {
		
		int n = 0;
		try {
			conn = ds.getConnection();
			String sql = "SELECT count(*) "
						+"FROM TBL_ADDRESS_LIST "
						+ "WHERE userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);
	   
	        rs = pstmt.executeQuery();
			rs.next();
			n = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return n;
	}

	@Override
	public int deleteAddress(Long ano, String userid) throws SQLException {
				
		int result = 0;
		try {
			conn = ds.getConnection();
			String sql = "DELETE FROM TBL_ADDRESS_LIST "
						+ "WHERE ano = ? and userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setLong(1, ano);
	        pstmt.setString(2, userid);
	   
	        result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	@Override
	public AddressVO getAddress(Long ano, String userid) throws SQLException {
		
		AddressVO addressVo = new AddressVO();
		try {
			conn = ds.getConnection();
			String sql = "SELECT USERID, POSTCODE, ADDRESS, DETAILADDRESS, EXTRAADDRESS, DEFAULT_YN, HOMETEL, MOBILE, ANO, DELIVERNAME, NAME "
						+"FROM TBL_ADDRESS_LIST "
						+ "WHERE ano = ? and userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setLong(1, ano);
	        pstmt.setString(2, userid);
	        
	        rs = pstmt.executeQuery();
			rs.next();
			
			addressVo.setUserid(rs.getString(1));
			addressVo.setPostcode(rs.getString(2));
			addressVo.setAddress(rs.getString(3));
			addressVo.setDetailaddress(rs.getString(4));
			addressVo.setExtraaddress(rs.getString(5));
			addressVo.setDefault_yn(rs.getString(6));
			addressVo.setHometel(rs.getString(7));
			addressVo.setMobile(rs.getString(8));
			addressVo.setAno(rs.getLong(9));
			addressVo.setDelivername(rs.getString(10));
			addressVo.setName(rs.getString(11));
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return addressVo;
	}

	@Override
	public int updateAddress(AddressVO addressVo) throws SQLException {
		
		int n = 0;
		try {
			conn = ds.getConnection();
			String sql = "UPDATE tbl_address_list SET POSTCODE = ?, ADDRESS = ?, DETAILADDRESS = ?, EXTRAADDRESS = ?, DEFAULT_YN = ?, "
					   +"HOMETEL = ?, MOBILE = ?, DELIVERNAME = ?, NAME = ? "
					   + "WHERE ANO = ? and USERID = ?";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, addressVo.getPostcode());
	        pstmt.setString(2, addressVo.getAddress());
	        pstmt.setString(3, addressVo.getDetailaddress());
	        pstmt.setString(4, addressVo.getExtraaddress());
	        pstmt.setString(5, addressVo.getDefault_yn());
	        pstmt.setString(6, addressVo.getHometel());
	        pstmt.setString(7, addressVo.getMobile());
	        pstmt.setString(8, addressVo.getDelivername());
	        pstmt.setString(9, addressVo.getName());
	        pstmt.setLong(10, addressVo.getAno());
	        pstmt.setString(11, addressVo.getUserid());
			
			n = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return n;
	}
	
	@Override
	public AddressVO getAddressL(String userid) throws SQLException {
		
		AddressVO addressVo = new AddressVO();
		try {
			conn = ds.getConnection();
			String sql = "SELECT USERID, POSTCODE, ADDRESS, DETAILADDRESS, EXTRAADDRESS, DEFAULT_YN, HOMETEL, MOBILE, ANO, DELIVERNAME, NAME "
						+"FROM TBL_ADDRESS_LIST "
						+ "WHERE userid = ? and DEFAULT_YN ='y'";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);
	        
	        rs = pstmt.executeQuery();
			while(rs.next()) {				
				addressVo.setUserid(rs.getString(1));
				addressVo.setPostcode(rs.getString(2));
				addressVo.setAddress(rs.getString(3));
				addressVo.setDetailaddress(rs.getString(4));
				addressVo.setExtraaddress(rs.getString(5));
				addressVo.setDefault_yn(rs.getString(6));
				addressVo.setHometel(rs.getString(7));
				addressVo.setMobile(rs.getString(8));
				addressVo.setAno(rs.getLong(9));
				addressVo.setDelivername(rs.getString(10));
				addressVo.setName(rs.getString(11));				
			}
						
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return addressVo;
	}
	
	/////////////// end 배송지 /////////////////////////////////////////

	@Override
	public String findId(Map<String, String> paraMap) throws SQLException {
		
		String userid = "";
		try {
			conn = ds.getConnection();
			String sql = "SELECT userid "
						+"FROM TBL_MEMBER "
						+ "WHERE name = ? and email = ? and logintype ='normal' ";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, paraMap.get("name"));
	        pstmt.setString(2, aes.encrypt(paraMap.get("email")) );
	        
	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	        	userid = rs.getString(1);
	        }
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return userid;
	}

	@Override
	public int isExistId(Map<String, String> paraMap) throws SQLException {
		
		int result = 0;
		try {
			conn = ds.getConnection();
			String sql = "SELECT count(*) "
						+"FROM TBL_MEMBER "
						+ "WHERE userid = ? and email = ?";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, paraMap.get("userid"));
	        pstmt.setString(2, aes.encrypt(paraMap.get("email")) );
	        
	        rs = pstmt.executeQuery();
	        while(rs.next()) {
	        	result = rs.getInt(1);
	        }
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	@Override
	public int updatePw(Map<String, String> paraMap) throws SQLException {
	
		int success = 0;
		try {
			conn = ds.getConnection();
			String sql = "UPDATE tbl_member set pwd = ? "
					+ ", lastpwdchangedate = sysdate "
					+ "where userid = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, Sha256.encrypt(paraMap.get("pwd")));
			pstmt.setString(2, paraMap.get("userid"));
			
			success = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		
		return success;
		
	}

	
	///////////////////////////////////////////////////////////////////////////////////
	/* 적립금페이지 */
	// userid 값을 입력받아서 회원1명에 대한 총적립금 알아오기(select)
	@Override
	public MemberVO memberTotalPoint(String userid) throws SQLException {
	MemberVO mvo = null;
	
	try {
			conn = ds.getConnection();
			
			String sql = " select POINT "+
			" from TBL_MEMBER "+
			" where userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {  
			
			mvo = new MemberVO();
			
			mvo.setPoint(rs.getInt(1));
			
	}
	
	} catch (Exception e) {
	e.printStackTrace();
	} finally {
	close();
	}
	
	
	
	return mvo;
	}
	
	//////////////////////////////////////////////////////
	// 페이징 처리를 한 회원 한명의 적립금 내역 보여주기
	@Override
	public List<OrderSetleVO> selectPointList(Map<String, String> paraMap) throws SQLException {
	
	List<OrderSetleVO> pointList = new ArrayList<>();
	
	try {
			conn = ds.getConnection();
			
			String sql = " select order_dt, prod_price, prod_name " + 
			" from " + 
			" ( " + 
			"    select row_number() over(order by ORDER_NO asc) AS RNO  " + 
			"          , order_no, order_dt, prod_price, prod_name " + 
			"    from ORDER_SETLE " + 
			"    where fk_user_id = ? " + 
			" ) V " + 
			" where RNO between ? and ?  " + 
			" order by order_dt desc ";
			
	pstmt = conn.prepareStatement(sql);	 		
	
	int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo")); //currentShowPageNo는 문자열이라서 인트타입으로 바꿔야 공식을 써서 계산할 수 있다
	int sizePerPage = 10;
	
	pstmt.setString(1, paraMap.get("userid"));
	pstmt.setInt(2, (currentShowPageNo * sizePerPage) - (sizePerPage - 1)); // 공식
	pstmt.setInt(3, (currentShowPageNo * sizePerPage)); // 공식 
	
	rs = pstmt.executeQuery(); //sql문을 실행한다. 리턴타입은 리슐트셋이 될 것이다
	
	while(rs.next()) { //있는지 묻는다. 있으면 와일문을 실행함
	
	OrderSetleVO opvo = new OrderSetleVO();
	opvo.setOrder_dt(rs.getString(1));
	opvo.setAddpoint(rs.getInt(2)); //OrderSetleVO에 메소드 만들기
	opvo.setProd_name(rs.getString(3)); 
	
	pointList.add(opvo); // pvo에 넣은 것들을pointList에 다 담았다. 액션에 넘겨주고 액션이 뷰단에 넘겨주면 뷰단에서는 각각을 겟해올 것이다
	
	}// end of while-------------------
	
	
	} finally {
	close();
	}
	
	return pointList;
	}// end of public List<MemberVO> selectPagingMember(Map<String, String> paraMap) ------------------
	
	
	
	
	// 페이징 처리를 위한 회원 한명의 적립금 내역 총페이지 수(totalPage) 알아오기
	@Override
	public int getPointTotalPage(String userid) throws SQLException {
	
	int totalPage = 0;
	
	try {
		conn = ds.getConnection();
		
		String sql = " select ceil(count(*)/10) " + 
		" from order_setle  " + 
		" where fk_user_id = ? ";
		
		pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, userid );
		
		rs = pstmt.executeQuery();
		
		rs.next();
		
		totalPage = rs.getInt(1);
		
	} finally {
	close();
	}
	
	
	return totalPage;
	}

	@Override
	public MemberVO getMemberById(String userid) throws SQLException {
		
		MemberVO member = null;
		try {
			conn = ds.getConnection();
			String sql = "select USERID, NAME, EMAIL, MOBILE, GENDER, POINT, REGISTERDAY, STATUS, IDLE, GRADE, LOGINTYPE "
					    + "FROM tbl_member "
						+ "WHERE userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);
	
			rs = pstmt.executeQuery();
			while(rs.next()) {
				
				member = new MemberVO();
				
				member.setUserid(rs.getString(1));
				member.setName(rs.getString(2));
				member.setEmail(aes.decrypt(rs.getString(3)));
				member.setMobile( aes.decrypt(rs.getString(4)) );
	            member.setGender(rs.getString(5));
	            	      
	            member.setPoint(rs.getInt(6));
	            member.setRegisterday(rs.getString(7));
	            member.setStatus(rs.getInt(8));
	            member.setIdle(rs.getInt(9));
	            member.setGrade(rs.getInt(10));
	            member.setLoginType(rs.getString(11));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		
		return member;
	}


	

}
