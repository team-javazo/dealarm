package kr.co.dong.trend;

import java.util.List;

public class TrendGroup {
    private String groupName;
    private List<String> keywords;

    public TrendGroup() {}
    public TrendGroup(String groupName, List<String> keywords) {
        this.groupName = groupName;
        this.keywords = keywords;
    }

    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public List<String> getKeywords() { return keywords; }
    public void setKeywords(List<String> keywords) { this.keywords = keywords; }
}
