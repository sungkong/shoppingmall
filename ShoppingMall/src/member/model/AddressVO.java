package member.model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class AddressVO {

	LocalDate nowDay = LocalDate.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
	String nowDate = nowDay.format(formatter);

	LocalTime now = LocalTime.now();
	DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("HHmmss");
	String nowTime = now.format(formatter2);
	
	private Long seiralNumber = Long.parseLong(nowDate+nowTime);
	
	private Long ano;; // 배송지 등록 일렬번호
	private String delivername; // 배송지명
	private String userid;
	private String name;
	private String postcode; // 우편번호
	private String address; // 기본주소
	private String detailaddress; // 상세주소
	private String extraaddress; // 참고항목
	private String default_yn; // 기본배송지
	private String hometel; // 집전화
	private String mobile; // 핸드폰
	
	public Long getAno() {
		return ano;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDelivername() {
		return delivername;
	}
	public void setDelivername(String delivername) {
		this.delivername = delivername;
	}
	public void setAno(Long ano) {
		this.ano = ano;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getPostcode() {
		return postcode;
	}
	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getDetailaddress() {
		return detailaddress;
	}
	public void setDetailaddress(String detailaddress) {
		this.detailaddress = detailaddress;
	}
	public String getExtraaddress() {
		return extraaddress;
	}
	public void setExtraaddress(String extraaddress) {
		this.extraaddress = extraaddress;
	}
	public String getDefault_yn() {
		return default_yn;
	}
	public void setDefault_yn(String default_yn) {
		this.default_yn = default_yn;
	}
	public String getHometel() {
		return hometel;
	}
	public void setHometel(String hometel) {
		this.hometel = hometel;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	public AddressVO() {}
	
	public AddressVO(String delivername, String userid, String name, String postcode, String address, String detailaddress, String extraaddress,
			String default_yn, String hometel, String mobile) {
		this.ano = seiralNumber;
		this.delivername = delivername;
		this.userid = userid;
		this.name = name;
		this.postcode = postcode;
		this.address = address;
		this.detailaddress = detailaddress;
		this.extraaddress = extraaddress;
		this.default_yn = default_yn;
		this.hometel = hometel;
		this.mobile = mobile;
		
	}
	// 수정용 생성자
	public AddressVO(Long ano, String delivername, String userid, String name, String postcode, String address, String detailaddress, String extraaddress,
			String default_yn, String hometel, String mobile) {
		this.ano = ano;
		this.delivername = delivername;
		this.userid = userid;
		this.name = name;
		this.postcode = postcode;
		this.address = address;
		this.detailaddress = detailaddress;
		this.extraaddress = extraaddress;
		this.default_yn = default_yn;
		this.hometel = hometel;
		this.mobile = mobile;
		
	}
	

	
}
