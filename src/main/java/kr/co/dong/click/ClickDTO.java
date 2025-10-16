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
	
	private int totalCount;		// 클릭 합계
	private double clickRate;	// 클릭비율계산용

	// 기본 생성자
	public ClickDTO() {
	}

	public ClickDTO(String keyword, int count) {
		this.keyword = keyword;
		this.count = count;		
	}
	
	// 필수 필드 생성자 (클릭 추적 시 입력되는 값)
	public ClickDTO(String userId, long dealId, String keyword) {
		this.userId = userId;
		this.dealId = dealId;
		this.keyword = keyword;
	}

	public ClickDTO(long id, String userId, long dealId, String keyword, int count, int totalCount, double clickRate) {
		super();
		this.id = id;
		this.userId = userId;
		this.dealId = dealId;
		this.keyword = keyword;
		this.count = count;
		this.totalCount = totalCount;
		this.clickRate = clickRate;
	}

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

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public double getClickRate() {
		return clickRate;
	}

	public void setClickRate(double clickRate) {
		this.clickRate = clickRate;
	}

	@Override
	public String toString() {
		return "ClickDTO [id=" + id + ", userId=" + userId + ", dealId=" + dealId + ", keyword=" + keyword + ", count="
				+ count + ", totalCount=" + totalCount + ", clickRate=" + clickRate + "]";
	}


}
