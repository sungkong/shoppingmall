package common.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class IndexController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setAttribute("name", "호호호"); //이걸 뷰단페이지에 포워드 방식으로 보내줄 것이다.
		System.out.println("### MainController 클래스의 execute() 메소드 호출됨 ###");
		// super.setRedirect(false);
		super.setViewPage("/WEB-INF/main.jsp");
		
	}

}
