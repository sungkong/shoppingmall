package mypage.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.AddressVO;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;

public class DeliverModifyController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
	
		if(super.checkLogin(request)) {
			
			InterMemberDAO mdao = new MemberDAO();
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			String userid = loginuser.getUserid();
			
			String type = "";
			
			if("GET".equalsIgnoreCase(method)) {
				
				Long ano = Long.parseLong(request.getParameter("ano"));
				AddressVO addressVo = mdao.getAddress(ano, userid);
				request.setAttribute("addressVo", addressVo);
				type = request.getParameter("type");
				
				if("orderForm".equalsIgnoreCase(type)) {
					setViewPage("/WEB-INF/views/order/deliverModify.jsp");
				} else {
					setViewPage("/WEB-INF/views/mypage/deliverModify.jsp");
				}
			
			} else {			
				
				
				AddressVO addressVo = null;
				
				Long ano = Long.parseLong(request.getParameter("ano"));
				String delivername = request.getParameter("delivername");
				userid = request.getParameter("userid");
				String name = request.getParameter("name");
				String postcode = request.getParameter("postcode");
				String address = request.getParameter("address");
				String detailaddress = request.getParameter("detailaddress");
				String extraaddress = request.getParameter("extraaddress");
				String default_yn = request.getParameter("default_yn");
				
				String hp1 = request.getParameter("hp1");
				String hp2 = request.getParameter("hp2");
				String hp3 = request.getParameter("hp3");		
				String hometel = hp1+hp2+hp3;
				
				String mo1 = request.getParameter("mo1");
				String mo2 = request.getParameter("mo2");
				String mo3 = request.getParameter("mo3");
				String mobile= mo1+mo2+mo3;
				
				addressVo = new AddressVO(ano, delivername, userid, name, postcode, address, detailaddress, extraaddress, default_yn, hometel, mobile);
			    
				int result = mdao.updateAddress(addressVo);
				int defaultChange = 0;
								
				if(default_yn.equals("y")) {
					defaultChange = mdao.changeAddressDefaultN(addressVo);
				}
				
				type = request.getParameter("type");
				
				if(result == 1) {					
					super.setViewPage("/mypage/deliveraddr.go?type="+type);
				} else {
					request.setAttribute("message", "배송지 수정이 실패하였습니다.");
					request.setAttribute("loc", "/mypage/deliveraddr.go?type="+type);
					
					super.setViewPage("/WEB-INF/msg.jsp");
				}
			}
		} else {
			
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/member/login.go");
			setViewPage("/WEB-INF/msg.jsp");
			
		}
				
	}

}
