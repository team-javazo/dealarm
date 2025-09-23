package kr.co.dong.UserKeyword;

import java.util.Date;

public class UserKeywordDTO {
	private String userId;
	private String keyword;
	private Date createdAt;
	private int id;
	
	public int getNum() {
		return id;
	}

	public void setNum(int id) {
		this.id = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public UserKeywordDTO() {
	}

	@Override
	public String toString() {
		return "UserKeywordDTO [userId=" + userId + ", keyword=" + keyword + ", createdAt=" + createdAt + ", id=" + id
				+ "]";
	}

	public UserKeywordDTO(String userId, String keyword, Date createdAt, int id) {
		super();
		this.userId = userId;
		this.keyword = keyword;
		this.createdAt = createdAt;
		this.id = id;
	}

	
}
