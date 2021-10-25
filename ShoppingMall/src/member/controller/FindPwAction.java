package member.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import util.email.GoogleMail;

public class FindPwAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		if("GET".equalsIgnoreCase(method)) {
			super.setViewPage("/WEB-INF/views/member/findPwForm.jsp");
		} else {
			
			Map<String, String> paraMap = new HashMap<>();
			
			String userid = request.getParameter("userid");
			String email = request.getParameter("email");
			
			paraMap.put("userid", userid);
			paraMap.put("email", email);
			
			InterMemberDAO mdao = new MemberDAO();
			int result = mdao.isExistId(paraMap);
			boolean sendMailSuccess = false; // 메일 전송 성공 유무 확인용
			
			if(result != 0) {
				
				Random rnd = new Random();
				String certificationCode = "";
				
				char randchar = ' ';
				for(int i=0; i<5; i++) {
					
					randchar = (char)(rnd.nextInt('z' - 'a' + 1) + 'a');
					certificationCode += randchar;
				}
				
				int randnum = 0;
				for(int i=0; i<7; i++) {
					randnum = rnd.nextInt(9 - 0 + 1) + 0;
					certificationCode += randnum;
				}
				// 랜덤하게 생성한 인증코드(certificationCode)를 비밀번호 찾기를 하고자 하는 사용자의 email로 전송시킨다.
				GoogleMail mail = new GoogleMail();
			
				try {
					mail.sendmail(email, certificationCode);
					sendMailSuccess = true;
					HttpSession session = request.getSession();
					session.setAttribute("userid", userid);
					session.setAttribute("certificationCode", certificationCode);
					
				} catch(Exception e) {
					// 메일 전송이 실패한 경우
					e.printStackTrace();
					sendMailSuccess = false;
				}
				
			} else {
												
			}
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("result", result);
			
			String json = jsonObj.toString(); // 문자열 형태의 json
			// 페이지 반환이 아닌 json을 출력해줘야 한다.
			request.setAttribute("json", json);
			super.setViewPage("/WEB-INF/jsonview.jsp");
		}
		
	}

}
