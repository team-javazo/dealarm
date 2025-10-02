package kr.co.dong.board;

import java.util.Date;

public class BoardDTO {
    private int id;
    private String title;
    private String writer;
    private String content;
    private Date regdate;
    private int hit;
    private int commentCount;
    private boolean notice;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Date getRegdate() { return regdate; }
    public void setRegdate(Date regdate) { this.regdate = regdate; }

    public int getHit() { return hit; }
    public void setHit(int hit) { this.hit = hit; }

    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }

    public boolean isNotice() { return notice; }
    public void setNotice(boolean notice) { this.notice = notice; }
}
