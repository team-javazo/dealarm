package kr.co.dong.UserKeyword;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class UserKeywordDTO {
	private int id;
	private String userId;
	private String keyword;
	private int frequency;  // 추가: frequency 필드
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	private Date createdAt;

	
	public int getFrequency() {
		return frequency;
	}

	public void setFrequency(int frequency) {
		this.frequency = frequency;
	}

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

	public UserKeywordDTO(int id, String userId, String keyword, int frequency, Date createdAt) {
		super();
		this.id = id;
		this.userId = userId;
		this.keyword = keyword;
		this.frequency = frequency;
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "UserKeywordDTO [id=" + id + ", userId=" + userId + ", keyword=" + keyword + ", frequency=" + frequency
				+ ", createdAt=" + createdAt + "]";
	}

}
