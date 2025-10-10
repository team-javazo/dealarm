package kr.co.dong.inquiry;

import java.sql.Timestamp;

public class InquiryDTO {
    // 🔹 기본 문의 관련 필드
    private int id;                 // 문의 번호 (PK)
    private String title;           // 제목
    private String writer;          // 작성자
    private String content;         // 내용
    private String category;        // 카테고리 (일반문의, 결제문의 등)
    private boolean secret;         // 비밀글 여부
    private Timestamp regdate;      // 작성일
    private int hit;                // 조회수
    private String answer;          // 답변 내용
    private Timestamp answer_date;  // 답변 등록일
    private String status;          // 상태 (대기, 답변완료 등)

    // 🔹 첨부파일 관련 필드
    private int inquiryId;          // 문의 글 번호 (FK 역할, inquiry.id 참조)
    private String filename;        // 원본 파일명
    private String filepath;        // 서버 저장 경로
    private String uploadDate;      // 업로드 날짜

    // ---------- Getter & Setter ----------
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

    public int getInquiryId() { return inquiryId; }
    public void setInquiryId(int inquiryId) { this.inquiryId = inquiryId; }

    public String getFilename() { return filename; }
    public void setFilename(String filename) { this.filename = filename; }

    public String getFilepath() { return filepath; }
    public void setFilepath(String filepath) { this.filepath = filepath; }

    public String getUploadDate() { return uploadDate; }
    public void setUploadDate(String uploadDate) { this.uploadDate = uploadDate; }
}
