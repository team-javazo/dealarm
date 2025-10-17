package kr.co.dong.inquiry;

import java.sql.Timestamp;

public class InquiryDTO {
    private int id;
    private String title;
    private String writer;
    private String content;
    private String category;
    private boolean secret;
    private Timestamp regdate;
    private int hit;

    private String answer;
    private Timestamp answer_date;
    private String status;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public boolean isSecret() { return secret; }
    public void setSecret(boolean secret) { this.secret = secret; }
    public Timestamp getRegdate() { return regdate; }
    public void setRegdate(Timestamp regdate) { this.regdate = regdate; }
    public int getHit() { return hit; }
    public void setHit(int hit) { this.hit = hit; }
    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }
    public Timestamp getAnswer_date() { return answer_date; }
    public void setAnswer_date(Timestamp answer_date) { this.answer_date = answer_date; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
