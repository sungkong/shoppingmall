package order.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import order.model.InterOrderDAO;
import order.model.OrderDAO;

public class ChangeProdStockAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if(super.checkLogin(request)) {
			
			InterOrderDAO odao = new OrderDAO();
			int prod_stock = 0;
			
			String prod_code = request.getParameter("prod_code");
			prod_stock = odao.getProdStock(prod_code);
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("prod_stock", prod_stock);
			String json = jsonObj.toString();
			
			request.setAttribute("json", json);
			super.setViewPage("/WEB-INF/jsonview.jsp");
			
		} else {
			
			request.setAttribute("message", "비정상적인 접근입니다.");
			request.setAttribute("loc", "/");
			
			super.setViewPage("/WEB-INF/msg.jsp");
		}
	}

}
