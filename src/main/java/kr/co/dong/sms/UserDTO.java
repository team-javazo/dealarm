package kr.co.dong.sms;

public class UserDTO {
	private String userId;
    private String phone;
    private int notification;

    public UserDTO() {}

	public UserDTO(String userId, String phone, int notification) {
		super();
		this.userId = userId;
		this.phone = phone;
		this.notification = notification;
	}
	
	public String getuserId() {
		return userId;
	}
	public void setuserId(String userId) {
		this.userId = userId;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public int getNotification() {
		return notification;
	}
	public void setNotification(int notification) {
		this.notification = notification;
	}
    
    
}
