package common.controller;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import member.model.MemberVO;
import product.model.InterProductDAO;
import product.model.ProductDAO;
import product.model.SortVO;

public abstract class AbstractController implements InterCommand{

   private boolean isRedirect = false;
   // isRedirect가 false면 foward로 이동시키고, true면 response.sendRedirect로 이동시키겠다.
   
   private String viewPage; // 반환할 페이지

   public boolean isRedirect() {
      return isRedirect;
   }
   public void setRedirect(boolean isRedirect) {
      this.isRedirect = isRedirect;
   }
   public String getViewPage() {
      return viewPage;
   }
   public void setViewPage(String viewPage) {
      this.viewPage = viewPage;
   }
   public boolean checkLogin(HttpServletRequest request) {
      boolean check = false;
      HttpSession session = request.getSession();
      MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
      if(loginuser != null) check = true;
      
      return check;
   }

   public void checkLoginAuth(HttpServletRequest request, String view) {
      
      HttpSession session = request.getSession();
      MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
      if(loginuser != null) {               
         setViewPage(view);
      } else {      
         request.setAttribute("message", "로그인이 필요합니다.");
         request.setAttribute("loc", "/member/login.go");
         setViewPage("/WEB-INF/msg.jsp");
      }
   }
   
   public void checkAdministration(HttpServletRequest request, String view) {
          
       if(checkLogin(request)) {
         
         HttpSession session = request.getSession();
         MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
         int grade = loginuser.getGrade();
         if(grade == 1) {
            
            setViewPage(view);
         } else {      
            request.setAttribute("message", "관리자 전용 페이지입니다.");
            request.setAttribute("loc", "/");            
            setViewPage("/WEB-INF/msg.jsp");
            return;
         }
         
      } else {
         
         request.setAttribute("message", "로그인이 필요합니다.");
         request.setAttribute("loc", "/");
         setViewPage("/WEB-INF/msg.jsp");
         return;
      }
   }
   
   public void getCategory(HttpServletRequest request) throws SQLException {
      
      InterProductDAO pdao = new ProductDAO();
      
      // 모든 카테고리 가져오기
      List<SortVO> sortList = pdao.AllSort();
      
      request.setAttribute("sortList", sortList);
      
   //   System.out.println(sortList);
      
   }
   

}