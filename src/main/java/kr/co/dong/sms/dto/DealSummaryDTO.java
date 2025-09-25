package kr.co.dong.sms.dto;

public class DealSummaryDTO {
    private String userId;
    private String title;
    private String url;
    private int dealId;
    private int notified;

    // getters & setters
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }
    public int getNotified() { return notified; }
    public void setNotified(int notified) { this.notified = notified; }
	public int getDealId() { return dealId; }
	public void setDealId(int dealId) { this.dealId = dealId; }
}
