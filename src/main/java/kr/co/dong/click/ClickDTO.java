package kr.co.dong.click;

import java.sql.Timestamp;

public class ClickDTO {
    private int id;
    private String uniqueId; 
    private String actualUrl; 
    private String userId; 
    private int dealId; 
    private int clickCount; 
    private Timestamp createdAt; 
    private String category; // click_history 기록을 위해 keyword(category) 임시 저장용

    public ClickDTO() {}

    // 링크 생성 시 사용하는 생성자
    public ClickDTO(String userId, int dealId, String actualUrl) {
        this.userId = userId;
        this.dealId = dealId;
        this.actualUrl = actualUrl;
    }

    // --- Getter and Setter ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUniqueId() { return uniqueId; }
    public void setUniqueId(String uniqueId) { this.uniqueId = uniqueId; }
    public String getActualUrl() { return actualUrl; }
    public void setActualUrl(String actualUrl) { this.actualUrl = actualUrl; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public int getDealId() { return dealId; }
    public void setDealId(int dealId) { this.dealId = dealId; }
    public int getClickCount() { return clickCount; }
    public void setClickCount(int clickCount) { this.clickCount = clickCount; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}