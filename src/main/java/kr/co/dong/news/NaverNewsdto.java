package kr.co.dong.news;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class NaverNewsdto {
    private String lastBuildDate;
    private int total;
    private List<NewsItem> items;

    public String getLastBuildDate() {
        return lastBuildDate;
    }
    public void setLastBuildDate(String lastBuildDate) {
        this.lastBuildDate = lastBuildDate;
    }
    public int getTotal() {
        return total;
    }
    public void setTotal(int total) {
        this.total = total;
    }
    public List<NewsItem> getItems() {
        return items;
    }
    public void setItems(List<NewsItem> items) {
        this.items = items;
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class NewsItem {
        private String title;
        private String originallink;
        private String link;
        private String description;
        private String pubDate;

        public String getTitle() {
            return title;
        }
        public void setTitle(String title) {
            this.title = title;
        }
        public String getOriginallink() {
            return originallink;
        }
        public void setOriginallink(String originallink) {
            this.originallink = originallink;
        }
        public String getLink() {
            return link;
        }
        public void setLink(String link) {
            this.link = link;
        }
        public String getDescription() {
            return description;
        }
        public void setDescription(String description) {
            this.description = description;
        }
        public String getPubDate() {
            return pubDate;
        }
        public void setPubDate(String pubDate) {
            this.pubDate = pubDate;
        }
    }
}
