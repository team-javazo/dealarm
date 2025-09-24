package kr.co.dong.UserKeyword;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class UserKeywordDTO {
	private int id;
	private String userId;
	private String keyword;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	private Date createdAt;

	public int getId() {
		return id;
	}

	public void setId(int id) {
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
		this.id = id;
		this.userId = userId;
		this.keyword = keyword;
		this.createdAt = createdAt;
	}

}
