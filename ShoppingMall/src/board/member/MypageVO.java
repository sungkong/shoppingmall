package board.member;
// myno,mytitle,myday ,fk_userid,myview
public class MypageVO {
	private int myno;
	private String mytitle;
	private String myday;
	private String fk_userid;
	private int myview;
	private String mycontent;
	
	public MypageVO() {}
	
	
	
	public MypageVO(int myno, String mytitle, String myday, String fk_userid, int myview, String mycontent) {
		super();
		this.myno = myno;
		this.mytitle = mytitle;
		this.myday = myday;
		this.fk_userid = fk_userid;
		this.myview = myview;
		this.mycontent = mycontent;
	}



	public int getMyno() {
		return myno;
	}
	public void setMyno(int myno) {
		this.myno = myno;
	}
	public String getMytitle() {
		return mytitle;
	}
	public void setMytitle(String mytitle) {
		this.mytitle = mytitle;
	}
	public String getMyday() {
		return myday;
	}
	public void setMyday(String myday) {
		this.myday = myday;
	}
	public String getFk_userid() {
		return fk_userid;
	}
	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}
	public int getMyview() {
		return myview;
	}
	public void setMyview(int myview) {
		this.myview = myview;
	}


	public String getMycontent() {
		return mycontent;
	}


	public void setMycontent(String mycontent) {
		this.mycontent = mycontent;
	}


	@Override
	public String toString() {
		return "MypageVO [myno=" + myno + ", mytitle=" + mytitle + ", myday=" + myday + ", fk_userid=" + fk_userid
				+ ", myview=" + myview + ", mycontent=" + mycontent + "]";
	}
	
	
	
	
	
	
}
