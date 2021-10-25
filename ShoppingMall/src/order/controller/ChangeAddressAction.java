package order.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import member.model.AddressVO;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;

public class ChangeAddressAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if(super.checkLogin(request)) {
			
			if("POST".equalsIgnoreCase(request.getMethod())) {
				
				HttpSession session = request.getSession();
				MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
				String userid = loginuser.getUserid();
				
				InterMemberDAO mdao = new MemberDAO();
				long ano = Long.parseLong(request.getParameter("ano"));
				
				AddressVO address = mdao.getAddress(ano, userid);
				
				JSONObject jsonObj = new JSONObject();
				// USERID, POSTCODE, ADDRESS, DETAILADDRESS, EXTRAADDRESS, DEFAULT_YN, HOMETEL, MOBILE, ANO, DELIVERNAME, NAME				
				jsonObj.put("delivername", address.getDelivername());
				jsonObj.put("name", address.getName());
				jsonObj.put("ano", address.getAno());
				jsonObj.put("postcode", address.getPostcode());
				jsonObj.put("address", address.getAddress());
				jsonObj.put("detailaddress", address.getDetailaddress());
				jsonObj.put("extraaddress", address.getExtraaddress());
				jsonObj.put("hometel", address.getHometel());
				jsonObj.put("mobile", address.getMobile());		
				
				String json = jsonObj.toString();
				request.setAttribute("json", json);
				super.setViewPage("/WEB-INF/jsonview.jsp");
						
			} else {
				
				request.setAttribute("message", "비정상적인 접근입니다.");
				request.setAttribute("loc", "/");
				
				super.setViewPage("/WEB-INF/msg.jsp");
				
			}
			
		} else {
			
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/member/login.go");
			
			super.setViewPage("/WEB-INF/msg.jsp");
		}
	}

}
