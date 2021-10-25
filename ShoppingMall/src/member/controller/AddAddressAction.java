package member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import member.model.AddressVO;
import member.model.InterMemberDAO;
import member.model.MemberDAO;

public class AddAddressAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		
		if(method.equalsIgnoreCase("GET")) {		
			// super.checkLoginAuth(request, "/WEB-INF/addAddress_pop.jsp");	
		} else {
			
			AddressVO addressVo = null;
			
			String delivername = request.getParameter("delivername");
			String userid = request.getParameter("userid");
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
			
			addressVo = new AddressVO(delivername, userid, name, postcode, address, detailaddress, extraaddress, default_yn, hometel, mobile);
			
			InterMemberDAO mdao = new MemberDAO();
			int result = mdao.registerAddress(addressVo);
			int defaultChange = 0;
			
			if(default_yn.equals("y")) {
				defaultChange = mdao.changeAddressDefaultN(addressVo);
			}
			
			if(result == 1) {
				
				super.setRedirect(true);			
				String type = request.getParameter("type");
				super.setViewPage("/mypage/deliveraddr.go?type="+type);			
				
			} else {
				request.setAttribute("message", "배송지 등록이 실패하였습니다.");
				request.setAttribute("loc", "/mypage/deliveraddr.go");
				
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			
		}
	}

}
