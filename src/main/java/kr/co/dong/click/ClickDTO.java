package kr.co.dong.click;

/**
 * 사용자-딜 클릭 이력 데이터를 담는 DTO 테이블 필드: id, user_id, deal_id, keyword, count
 */
public class ClickDTO {

	private long id;
	private String userId; // user_id (BIGINT)
	private long dealId; // deal_id (BIGINT)
	private String keyword; // keyword (VARCHAR)
	private int count; // count (INT)

	// 기본 생성자
	public ClickDTO() {
	}

	// 필수 필드 생성자 (클릭 추적 시 입력되는 값)
	public ClickDTO(String userId, long dealId, String keyword) {
		this.userId = userId;
		this.dealId = dealId;
		this.keyword = keyword;
	}

	// Getter와 Setter
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getDealId() {
		return dealId;
	}

	public void setDealId(long dealId) {
		this.dealId = dealId;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	@Override
	public String toString() {
		return "ClickDTO{" + "id=" + id + ", userId=" + userId + ", dealId=" + dealId + ", keyword='" + keyword + '\''
				+ ", count=" + count + '}';
	}
}
