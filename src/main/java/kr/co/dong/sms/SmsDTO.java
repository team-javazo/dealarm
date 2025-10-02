package kr.co.dong.sms;

public class SmsDTO {
	private String userId;
	private String phone;
	private String title;
	private String url;
	private int dealId;
	private String keyword;
	
	public SmsDTO() {}

	public SmsDTO(String userId, String phone, String title, String url, int dealId) {
		super();
		this.userId = userId;
		this.phone = phone;
		this.title = title;
		this.url = url;
		this.dealId = dealId;
	}

	public SmsDTO(String userId, String phone, int dealId) {
		super();
		this.userId = userId;
		this.phone = phone;
		this.dealId = dealId;
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

	public int getDealId() {
		return dealId;
	}

	public void setDealId(int dealId) {
		this.dealId = dealId;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	
	

}
