package util.paging;

public class Pagination {

	private int currPageNo;/// 현재 페이지 번호
	private int sizePerPage = 10; // 한 페이지당 보여질 리스트 개수
	private int totalCnt; // 전체 목록 개수
	private int pageCnt; // 전체 페이지 개수
	
	private int startList; // 게시판 시작 번호
	private int range = 1; // 페이지 범위.    1 : 1~5     2: 6~10   ...
	private int pageSize = 5; // 한 페이지 범위에 보여질 페이지 개수
	private int startPage; // 각 페이지 범위의 시작 번호
	
	// 검색
	private String status; // 배송상태 검색
	private String searchType; // 검색타입
	private String keyword; // 키워드
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	private String fromDate; // 날짜 기한
	private String toDate; // 날짜 기한
	
	private String userid; // 사용자

	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getFromDate() {
		return fromDate;
	}
	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}
	public String getToDate() {
		return toDate;
	}
	public void setToDate(String toDate) {
		this.toDate = toDate;
	}
	public int getStartList() {
		return startList;
	}
	public void setStartList(int startList) {
		this.startList = startList;
	}

	private int endPage; // 각 페이지 범위 끝 번호
	
	private boolean prev; // 이전 페이지 여부
	private boolean next; // 다음 페이지 여부
	
	
	
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public int getCurrPageNo() {
		return currPageNo;
	}
	public void setCurrPageNo(int currPageNo) {
		this.currPageNo = currPageNo;
	}
	public int getSizePerPage() {
		return sizePerPage;
	}
	public void setSizePerPage(int sizePerPage) {
		this.sizePerPage = sizePerPage;
	}
	public int getTotalCnt() {
		return totalCnt;
	}
	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}
	public int getPageCnt() {
		return pageCnt;
	}
	public void setPageCnt(int pageCnt) {
		this.pageCnt = pageCnt;
	}
	public int getRange() {
		return range;
	}
	public void setRange(int range) {
		this.range = range;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public int getStartPage() {
		return startPage;
	}
	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	public boolean isPrev() {
		return prev;
	}
	public void setPrev(boolean prev) {
		this.prev = prev;
	}
	public boolean isNext() {
		return next;
	}
	public void setNext(boolean next) {
		this.next = next;
	}
	
	
	
	public void pageInfo(int currPageNo, int range, int totalCnt) {
		this.currPageNo = currPageNo;
		this.range = range;
		this.totalCnt = totalCnt;
		
		// 전체 페이지 수
		this.pageCnt = (int) Math.ceil((double)totalCnt/sizePerPage);
		// 시작 페이지
		this.startPage = (range - 1) * pageSize + 1;
		// 끝 페이지
		this.endPage = range * pageSize;
		// 게시판 시작 번호
		this.startList = (currPageNo - 1) * sizePerPage + 1;
		// 이전 버튼 상태
		this.prev = range == 1 ? false : true;
		// 다음 버튼 상태
		this.next = endPage > pageCnt ? false : true;
		if(this.endPage > this.pageCnt) {
			this.endPage = this.pageCnt;
			this.next = false;
		}
		
	}
}
