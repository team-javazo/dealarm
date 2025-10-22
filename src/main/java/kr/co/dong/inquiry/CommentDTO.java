package kr.co.dong.inquiry;

import java.sql.Timestamp;

public class CommentDTO {
    private int id;
    private int inquiryId;
    private String writer;
    private String content;
    private Timestamp regdate;
    private String role; // 🔹 admin / user

    // getter/setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getInquiryId() { return inquiryId; }
    public void setInquiryId(int inquiryId) { this.inquiryId = inquiryId; }

    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }


    public Timestamp getRegdate() { return regdate; }
    public void setRegdate(Timestamp regdate) { this.regdate = regdate; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}
