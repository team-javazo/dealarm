package kr.co.dong.sms.dto;

public class SmsDTO {
	private String userId;
	private String phone;
	private String title;
	private String url;
	
	public SmsDTO() {}
	
	public SmsDTO(String userId, String phone, String title, String url) {
		super();
		this.userId = userId;
		this.phone = phone;
		this.title = title;
		this.url = url;
	}
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}

}
