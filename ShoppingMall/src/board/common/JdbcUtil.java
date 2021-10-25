package board.common;

import java.sql.*;

import javax.naming.*;
import javax.sql.DataSource;


public class JdbcUtil {
	private static JdbcUtil instance = new JdbcUtil();
	
	private static DataSource ds;
	static {
		try {
			Class.forName("oracle.jdbc.OracleDriver");
			System.out.println("드라이버 로딩 성공");
			InitialContext ctx = new InitialContext();
			ds = (DataSource)ctx.lookup("java:comp/env/jdbc/semioracle");
			System.out.println("Connection pool 생성");
			
		}catch(ClassNotFoundException e) {
			e.printStackTrace();
		} catch(NamingException e) {
			e.printStackTrace();
		}
	}
	
	private JdbcUtil() { }
	
	public static JdbcUtil getInstance() {
		return instance;
	}
	
	public Connection getConnection() throws SQLException {
			return ds.getConnection();
	}
}
