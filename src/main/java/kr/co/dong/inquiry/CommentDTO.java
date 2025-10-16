package kr.co.dong.inquiry;

import java.sql.Timestamp;

public class CommentDTO {
    private long id;
    private long inquiryId;
    private String writer;
    private String content;
    private String role; // USER / ADMIN
    private Timestamp createdAt;

    // getters & setters ...
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public long getInquiryId() { return inquiryId; }
    public void setInquiryId(long inquiryId) { this.inquiryId = inquiryId; }
    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
