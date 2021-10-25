package mypage.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import order.model.OrderSetleVO;
import member.model.*;

public class PointController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		if(loginuser != null) {		
		
			String userid = loginuser.getUserid();
			InterMemberDAO mdao = new MemberDAO();
			MemberVO mvo = mdao.memberTotalPoint(userid); // userid 값을 입력받아서 회원1명에 대한 총적립금 알아오기(select)
			
			request.setAttribute("mvo", mvo);
			
			///////////////////////////////////////////////////////////////////////
			String currentShowPageNo = request.getParameter("currentShowPageNo");
			
			
			if(currentShowPageNo == null) {
				currentShowPageNo = "1";
			}
			
			
			// === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 숫자 아닌 문자를 입력한 경우 또는 
	        //     int 범위를 초과한 숫자를 입력한 경우라면 currentShowPageNo 는 1 페이지로 만들도록 한다. ==== // 
			try { //int 범위를 초과한 숫자를 입력한 경우
				Integer.parseInt(currentShowPageNo);
			} catch (NumberFormatException e) {
				currentShowPageNo = "1";
			}
			
			Map<String,String> paraMap = new HashMap<>();
			
			paraMap.put("currentShowPageNo", currentShowPageNo);
			paraMap.put("userid", userid);
			
			List<OrderSetleVO> pointList = mdao.selectPointList(paraMap);
			
			request.setAttribute("pointList", pointList); 
			
			
			
			/////////////////////////////////////////////////////////
			String pageBar = "";
			
			int blockSize = 1;
			// blockSize 는 블럭(토막)당 보여지는 페이지 번호의 개수이다.
			
			int loop = 1;
			// loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다. 
			
			// !!! 아래는 pageNo 를 구하는 공식이다. !!! //
			int pageNo =  ( (Integer.parseInt(currentShowPageNo )- 1)/blockSize ) * blockSize + 1 ;
			// pageNo 는 페이지바에서 보여지는 첫번째 번호이다.
			
			
			// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 전체회원에 대한 총페이지 수(totalPage) 알아오기
			int totalPage = mdao.getPointTotalPage(userid);
			// System.out.println("~~~ 확인용 totalPage : " + totalPage); 
			
			
			///////////////////////////////////////////////////////
		//  **** [맨처음 <<] [이전 <] 만들기 **** //
		
					if(pageNo != 1) { // 맨처음 1쪽이면 [맨처음] [이전]이 안나오도록 하기 위해서 if조건을 추가함
						pageBar +=  "<li class='page-item'><a class='page-link' href='point.go?currentShowPageNo=1&userid="+userid+"'> << </a></li>";
						pageBar +=  "<li class='page-item'><a class='page-link' href='point.go?currentShowPageNo="+(pageNo - 1)+"&userid="+userid+"'> < </a></li>";
					}
					
					
					while( !(loop > blockSize || pageNo > totalPage ) ) { //loop가 1인데 매번증가해서 blockSize(10이라 해둠)보다 크면 탈출하라는 것. 작거나 같을때까지는 돌림. 
																		  // || 는'또는' 이라는 뜻. &&는 '그리고'  !(a || b)는 (!a && !b) 이다.
						
						if( pageNo == Integer.parseInt(currentShowPageNo)  ) {
							pageBar +=  "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; //클릭한 곳에 active를 줌. 색이 변한다. #은 그냥 자기페이지라는 의미. 클릭한곳의 페이지이다
						}
						else {//검색했을때 페이지
							pageBar +=  "<li class='page-item'><a class='page-link' href='point.go?currentShowPageNo="+pageNo+"&userid="+userid+"'>"+pageNo+"</a></li>";
						}
						
						
						loop++;   
						
						pageNo++; 
						
					}// end of while----------------------------------------
					
					
					//  **** [다음 >] [마지막 >>] 만들기 **** //
					
					if(pageNo <= totalPage) { //마지막페이지로 가면 [다음] [마지막] 가 사라지도록 한다
						pageBar +=  "<li class='page-item'><a class='page-link' href='point.go?currentShowPageNo="+pageNo+"&userid="+userid+"'> > </a></li>";
						pageBar +=  "<li class='page-item'><a class='page-link' href='point.go?currentShowPageNo="+totalPage+"&userid="+userid+"'> >> </a></li>";
					}
					
					request.setAttribute("pageBar", pageBar); //뷰단으로 보내기위해 넣음
			
			
			
		// super.setRedirect(false);
		super.setViewPage("/WEB-INF/views/mypage/point.jsp");
		
		
		
		} else {		
			request.setAttribute("message", "로그인이 필요합니다.");
			request.setAttribute("loc", "/member/login.go");
			super.setViewPage("/WEB-INF/msg.jsp");
			return;
		}	
		
	}

}
