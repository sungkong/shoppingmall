package common.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import product.model.InterProductDAO;
import product.model.ProductDAO;
import product.model.SortVO;


@WebServlet(
		urlPatterns = { "*.go" }, 
		initParams = { 
				@WebInitParam(name = "FrontControllerA", value = "C:/Users/a/git/ShoppingMall/ShoppingMall/WebContent/WEB-INF/Command.properties")
		})
public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Map<String, Object> cmdMap = new HashMap<>(); // 요청 URI와 처리할 
	
	public void init(ServletConfig config) throws ServletException {
		
		String props = config.getInitParameter("FrontControllerA"); 				
		FileInputStream fis = null; 
		try {
			fis = new FileInputStream(props);
			Properties pr = new Properties();
			pr.load(fis);
			
			Enumeration<Object> en = pr.keys(); // properties 파일의 내용물에서 =을 기준으로 왼쪽에 있는 모든 key들을 가져온다.
			while(en.hasMoreElements()) {
				String key = (String)en.nextElement();
				
				System.out.println("~~~ 확인용 Key => " + key);
				String className = pr.getProperty(key);
				
				if(className != null) {
					className = className.trim();
					Class<?> cls = Class.forName(className);
					Constructor<?> constrt = cls.getDeclaredConstructor(); 
					Object obj = constrt.newInstance(); // 
					System.out.println("~~~ 확인용 obj.toString() => " + obj.toString()); 
					cmdMap.put(key, obj); 
				}
			}
		} catch (FileNotFoundException e) {
			System.out.println("파일 없음.");
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			System.out.println("클래스가 발견되지 않았습니다.");
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String uri = request.getRequestURI();
		System.out.println("~~~ 확인용 uri => " + uri);
		// 경로에 컨텍스트 제거
		String key = uri.substring(request.getContextPath().length());
		System.out.println("~~~ 확인용 key => " + key);
		AbstractController action = (AbstractController)cmdMap.get(key); // 요청에 맞는 컨트롤러 객체 가져오기
		if(action == null) {
			System.out.println(key + "에 매핑된 클래스가 없습니다. <<");
		} else {
			try {
				request.setCharacterEncoding("UTF-8");
				
				action.execute(request, response); // 요청시 로직을 실행할 메소드 실행
				String viewPage = action.getViewPage(); // 반환할 페이지 가져오기
				boolean isRedirect = action.isRedirect();
				if(isRedirect == true) {
					if(viewPage != null) {
						response.sendRedirect(viewPage);
					}
				} else {
					if(viewPage != null) {
						RequestDispatcher dispatcher = request.getRequestDispatcher(viewPage);
						dispatcher.forward(request, response);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
	}
}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
