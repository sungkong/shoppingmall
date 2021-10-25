package util.message;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;
import order.model.InterOrderDAO;
import order.model.OrderDAO;
import order.model.OrderSetleVO;

/**
 * @class ExampleSend
 * @brief This sample code demonstrate how to send sms through CoolSMS Rest API PHP
 */
public class MessageSend extends AbstractController {
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String api_key = "NCSEGSNXYZOQFIDA";
	    String api_secret = "D6UOWK6DO228BAQHZUTYTBEPN6UIH4MS";
	    Message coolsms = new Message(api_key, api_secret);

	    InterOrderDAO odao = new OrderDAO();
	    InterMemberDAO mdao = new MemberDAO();
	    
	    OrderSetleVO orderSetle = odao.getOrderByOno(request.getParameter("order_no"));
	    MemberVO customer = mdao.getMemberById(orderSetle.getFk_user_id());
	    
	    // String mobile = request.getParameter("mobile"); 
	    String mobile = customer.getMobile();
	    String smsContent = odao.getMessageFrom();
	    	   smsContent += " [현재 상태 = " + request.getParameter("statusKR") + "]";
	    	   smsContent += " [주문번호 = " + request.getParameter("order_no") + "]";
	    	   smsContent += " [상품명 = " + orderSetle.getProd_name() + "]";
	    	   smsContent += " [금액 = " + orderSetle.getTot_amount() + "]";
	    	   
	    // String datetime = request.getParameter("datetime");
 
	    // 4 params(to, from, type, text) are mandatory. must be filled
	    HashMap<String, String> params = new HashMap<String, String>();
	    params.put("to", mobile); // 수신번호
	    params.put("from", "01026146217"); // 발신번호
	    params.put("type", "LMS"); // Message type ( SMS, LMS, MMS, ATA )
	    params.put("text", smsContent); // 문자내용    
	    params.put("app_version", "JAVA SDK v2.2"); // application name and version	    
	    
	    // Optional parameters for your own needs
	    // params.put("image", "desert.jpg"); // image for MMS. type must be set as "MMS"
	    // params.put("image_encoding", "binary"); // image encoding binary(default), base64 
	    // params.put("mode", "test"); // 'test' 모드. 실제로 발송되지 않으며 전송내역에 60 오류코드로 뜹니다. 차감된 캐쉬는 다음날 새벽에 충전 됩니다.
	    // params.put("delay", "10"); // 0~20사이의 값으로 전송지연 시간을 줄 수 있습니다.
	    // params.put("force_sms", "true"); // 푸시 및 알림톡 이용시에도 강제로 SMS로 발송되도록 할 수 있습니다.
	    // params.put("refname", ""); // Reference name
	    // params.put("country", "KR"); // Korea(KR) Japan(JP) America(USA) China(CN) Default is Korea
	    // params.put("sender_key", "5554025sa8e61072frrrd5d4cc2rrrr65e15bb64"); // 알림톡 사용을 위해 필요합니다. 신청방법 : http://www.coolsms.co.kr/AboutAlimTalk
	    // params.put("template_code", "C004"); // 알림톡 template code 입니다. 자세한 설명은 http://www.coolsms.co.kr/AboutAlimTalk을 참조해주세요. 
	    // params.put("datetime", "20140106153000"); // Format must be(YYYYMMDDHHMISS) 2014 01 06 15 30 00 (2014 Jan 06th 3pm 30 00)
	    // params.put("mid", "mymsgid01"); // set message id. Server creates automatically if empty
	    // params.put("gid", "mymsg_group_id01"); // set group id. Server creates automatically if empty
	    // params.put("subject", "Message Title"); // set msg title for LMS and MMS
	    // params.put("charset", "euckr"); // For Korean language, set euckr or utf-8
	    // params.put("app_version", "Purplebook 4.1") // 어플리케이션 버전

	    try {
	      JSONObject obj = (JSONObject) coolsms.send(params);
	      request.setAttribute("json", obj.toString());
	      super.setViewPage("/WEB-INF/jsonview.jsp");
	      System.out.println(obj.toString());
	    } catch (CoolsmsException e) {
	      System.out.println(e.getMessage());
	      System.out.println(e.getCode());
	    }
	    
	}
	
	
}
