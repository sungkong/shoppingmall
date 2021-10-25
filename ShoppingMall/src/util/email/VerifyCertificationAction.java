package util.email;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;

public class VerifyCertificationAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// String userid = (String) request.getSession().getAttribute("userid");
		String userCertificationCode = request.getParameter("userCertificationCode");
		
		HttpSession session = request.getSession();
		String certificationCode = (String)session.getAttribute("certificationCode");
		
		String message = "";
		String loc = "";
		
		if(userCertificationCode.equals(certificationCode)) {
			message = "인증에 성공했습니다.";
			loc = "/member/updatePw.go";
		} else {
			message = "발급된 인증코드가 아닙니다. 다시 입력하세요.";
			loc = "/member/findPw.go";
		}
		
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);
		
		super.setViewPage("/WEB-INF/msg.jsp");
		session.removeAttribute("certificationCode");
		
	}

}
