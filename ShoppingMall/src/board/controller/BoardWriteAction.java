package board.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import board.member.*;
import common.controller.AbstractController;



public class BoardWriteAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/* HttpSession session = request.getSession(); */
		
		/* MemberVO loginuser = (MemberVO) session.getAttribute("loginuser"); */
		
	/*	if( loginuser !=null && "admin".equals(loginuser.getUserid()) ) {
			// 관리자 (admin)로 로그인 했을 경우
*/			
			InterBoardDAO bdao = new BoardDAO();
			
			Map<String,String>paraMap = new HashMap<>();
			
			String searchType = request.getParameter("searchType"); // writer
			String searchWord = request.getParameter("searchWord"); // "오"
			
			paraMap.put("searchType", searchType);
			paraMap.put("searchWord", searchWord);
			
			String currentShowPageNo = request.getParameter("currentShowPageNo");
			
			String sizePerPage = request.getParameter("sizePerPage");
			
			
			if(currentShowPageNo == null) {
				currentShowPageNo = "1";
			}
			
			if(sizePerPage == null || !("3".equals(sizePerPage) || "5".equals(sizePerPage) || "10".equals(sizePerPage)) ) {
				sizePerPage = "10";
			}
			
			try {
				Integer.parseInt(currentShowPageNo);
			} catch (NumberFormatException e) {
				currentShowPageNo = "1";
			}
			
			
			paraMap.put("currentShowPageNo", currentShowPageNo);
			paraMap.put("sizePerPage", sizePerPage);
			
			
			List<BoardVO> boardList = bdao.selectPagingMember(paraMap);
			
			/*
			 * System.out.println("~~~~ 확인용 boardList ~~~~ ");
			 * 
			 * for(BoardVO bvo : boardList) { System.out.print("num : " + bvo.getNum() +
			 * " "); System.out.print("title : " + bvo.getTitle() + " ");
			 * System.out.print("writer : " + bvo.getWriter() + " ");
			 * System.out.print("regdate : " + bvo.getRegdate() + " ");
			 * System.out.println("cnt : " + bvo.getCnt() + " "); }
			 */
			
			request.setAttribute("boardList", boardList);
			request.setAttribute("sizePerPage", sizePerPage);
			
			///////////////////////////////////////////////////////////////////////
			if(searchType == null) {
				searchType = "";
			}
			
			if(searchWord == null) {
				searchWord = "";
			}
			
			request.setAttribute("searchType", searchType);
			request.setAttribute("searchWord", searchWord);
			///////////////////////////////////////////////////////////////////////
			
			// 페이지바 시작 // 
			String pageBar = "";
			
			int blockSize = 10;
			
			int loop = 1;
			
			int pageNo = ( ( Integer.parseInt(currentShowPageNo) - 1)/blockSize ) * blockSize + 1;
			
			int totalPage = bdao.getTotalPage(paraMap);
			//System.out.println("확인용 totalPage : " +  totalPage);
			
			while( !(loop > blockSize || pageNo > totalPage ) ) {
				
				if( pageNo == Integer.parseInt(currentShowPageNo) ) {
					pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>";
				}
				else {
					pageBar += "<li class='page-item'><a class='page-link' href='boardWrite.go?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>"+pageNo+"</a></li>";
				}
				
				loop++; // 1 2 3 4 5 6 7 8 9 10
				
				pageNo++; // 1 2 3 4 5 6 7 8 9 10
						  // 11 12 13 14 15 16 17 18 19 20 
						  // 21 22 23 24 25 26 27 28 29 30 
						  // 31 32 33 34 35 36 37 38 39 40
						  // 41 42 43 44 45 46 47 48 49 50 
				
				}// end of while----------------
			
			request.setAttribute("pageBar", pageBar);
			
			// 페이지바 끝 //
			
			super.setViewPage("/WEB-INF/views/board/boardWrite.jsp");
			
			/*
			 * } else { // 로그인을 안한 경우 또는 일반 사용자로 로그인한 경우 String message = "관리자만 접근이 가능합니다.";
			 * String loc = "javascript:history.back()";
			 * 
			 * request.setAttribute("message", message); request.setAttribute("loc", loc);
			 * 
			 * //super.setRedirect(false); super.setViewPage("/WEB-INF/msg.jsp"); }
			 */
		
		
	}

}
