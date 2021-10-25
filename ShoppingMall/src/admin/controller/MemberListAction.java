package admin.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;
import util.paging.Pagination;

public class MemberListAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
				
		if(checkLogin(request)) {
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			int grade = loginuser.getGrade();
			if(grade == 1) {
				InterMemberDAO mdao = new MemberDAO();
				
				String searchType = request.getParameter("searchType");
				String keyword = request.getParameter("keyword");
				
				int currPageNo = 0;				
				int sizePerPage = 0;
				int range = 0;
				
				// 주소창에 GET 문자열 입력 방지
				try {
					currPageNo = Integer.parseInt(request.getParameter("currPageNo"));		
				} catch(Exception e) {
					currPageNo = 1;			
				}
				try {
					range = Integer.parseInt(request.getParameter("range"));		
				} catch(Exception e) {
					range = 1;			
				}
				try {
					sizePerPage = Integer.parseInt(request.getParameter("sizePerPage"));		
				} catch(Exception e) {
					sizePerPage = 1;			
				}
				
				// 처음 페이지 접속시 페이지번호와 페이지 범위 초기화
				if(currPageNo == 0) {
					currPageNo = 1;
				}
				if(range == 0) {
					range = 1;
				}
							
				if(sizePerPage == 0 || !(sizePerPage == 3 || sizePerPage == 5 || sizePerPage == 10  )) {
					sizePerPage = 10;
				}
				
				Pagination pg = new Pagination();
				pg.setSearchType(searchType);
				pg.setKeyword(keyword);
				pg.setCurrPageNo(currPageNo);
				pg.setSizePerPage(sizePerPage);
				
				
				int totalCnt = mdao.getTotalCnt(pg);
				pg.pageInfo(currPageNo, range, totalCnt);
				
				List<MemberVO> memberList = mdao.getMemberList(pg);
				
				request.setAttribute("pagination", pg);
				request.setAttribute("memberList", memberList);
				request.setAttribute("sizePerPage", sizePerPage);
				request.setAttribute("searchType", searchType);
				request.setAttribute("keyword", keyword);
				
				super.setViewPage("/WEB-INF/views/admin/memberList.jsp");
			} else {		
				request.setAttribute("message", "관리자 전용 페이지입니다.");
				request.setAttribute("loc", "/");				
				setViewPage("/WEB-INF/msg.jsp");
				return;
			}
			
		} else {
			
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/");
			super.setViewPage("/WEB-INF/msg.jsp");
			return;
		}
	}

}
