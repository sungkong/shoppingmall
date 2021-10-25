package util.utility;

import javax.servlet.http.HttpServletRequest;

public class MyUtil {

	
	
	public static String getCurrentURL(HttpServletRequest request) {
		
		String currentURL = request.getRequestURL().toString();
		String queryString = request.getQueryString();
		
		if(queryString != null) { // GET
			currentURL += "?" + queryString;
		}
		String ctxPath = request.getContextPath();
		int index = currentURL.indexOf(ctxPath) + ctxPath.length();
		
		currentURL = currentURL.substring(index); //
		return currentURL;
		// 돌아갈 페이지이에서 받는다. 그리고 돌아가기 버튼에 파라미터로 설정해준다
	}
}
