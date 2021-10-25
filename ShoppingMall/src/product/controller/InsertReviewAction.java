package product.controller;

import java.io.IOException;
import java.util.*;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import common.controller.AbstractController;
import product.model.InterProductDAO_KJH;
import product.model.ProductDAO_KJH;

public class InsertReviewAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
		if("POST".equalsIgnoreCase(method)) {
		
			if(super.checkLogin(request)) {
				
				MultipartRequest mtrequest = null;
				
				HttpSession session = request.getSession();
				
				ServletContext svlCtx = session.getServletContext();
				String uploadFileDir = svlCtx.getRealPath("/img_review");
				
			//	System.out.println(">> uploadFileDir : " + uploadFileDir);
				
				try {
					
					mtrequest = new MultipartRequest(request, uploadFileDir, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
					
				} catch (IOException e) {
					request.setAttribute("message", "업로드 되어질 경로가 잘못되었거나 또는 최대용량 10MB를 초과했으므로 파일업로드 실패함!!");
					request.setAttribute("loc", request.getContextPath()+"/shop/admin/productRegister.up"); 
					  
					super.setViewPage("/WEB-INF/msg.jsp");
					return; // 종료								
				}
								
				String orderno = mtrequest.getParameter("orderno");
				String prod_code = mtrequest.getParameter("prod_code");
				String userid = mtrequest.getParameter("userid");
				String content = mtrequest.getParameter("content").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>");
				String score = mtrequest.getParameter("score");
				
				String photo = mtrequest.getFilesystemName("photo");
				String review_img = mtrequest.getParameter("review_img");
								
			//	if(review_img == "") 
			//	System.out.println(orderno + " , " + prod_code + " , " + userid + " , " + content + " , " + review_img + " , " + score);
				
				Map<String,String> paraMap = new HashMap<>();
				
				paraMap.put("orderno", orderno);
				paraMap.put("prod_code", prod_code);
				paraMap.put("userid", userid);
				paraMap.put("content", content);
				paraMap.put("photo", photo);
				paraMap.put("review_img", review_img);
				paraMap.put("score", score);
				
				InterProductDAO_KJH pdao = new ProductDAO_KJH();
				
				int result = pdao.insertReview(paraMap);
				
				if(result != 0) {
					request.setAttribute("message", "리뷰 작성이 완료되었습니다");
			        request.setAttribute("loc", "/product/prodDetail.go?prod_code=" + prod_code);
			        
			        super.setViewPage("/WEB-INF/msg.jsp");
				}
				
				else {
					request.setAttribute("message", "리뷰 작성이 실패하였습니다");
					request.setAttribute("loc", "/product/prodDetail.go?prod_code=" + prod_code);
			        
			        super.setViewPage("/WEB-INF/msg.jsp");
				}
			}
			
			else {
				request.setAttribute("message", "로그인이 필요합니다.");
				request.setAttribute("loc", "/member/login.go");
				setViewPage("/WEB-INF/msg.jsp");
			}
			
			
		}
		
		else {
			request.setAttribute("message", "비정상적인 접근 경로입니다");
			request.setAttribute("loc", "/");
	        
	        super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
