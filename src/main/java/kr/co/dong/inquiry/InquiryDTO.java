package kr.co.dong.inquiry;

import java.sql.Timestamp;

/**
 * InquiryDTO
 * 문의 게시판 데이터 전송 객체
 * - 일반 사용자 및 관리자 공용
 */
public class InquiryDTO {

    // 🔹 기본 필드
    private int id;                 // 글 번호 (PK)
    private String title;           // 제목
    private String writer;          // 작성자 (또는 관리자)
    private String content;         // 내용
    private String category;        // 카테고리 (일반문의, 결제문의 등)
    private boolean secret;         // 비밀글 여부
    private Timestamp regdate;      // 등록일
    private int hit;                // 조회수

    // 🔹 답변 및 상태 관련 필드
    private String answer;          // 관리자 답변
    private Timestamp answer_date;  // 답변 등록일
    private String status;          // 상태 (대기, 답변완료 등)

    // 🔹 기본 생성자
    public InquiryDTO() {}

    // 🔹 전체 생성자
    public InquiryDTO(int id, String title, String writer, String content, String category,
                      boolean secret, Timestamp regdate, int hit,
                      String answer, Timestamp answer_date, String status) {
        this.id = id;
        this.title = title;
        this.writer = writer;
        this.content = content;
        this.category = category;
        this.secret = secret;
        this.regdate = regdate;
        this.hit = hit;
        this.answer = answer;
        this.answer_date = answer_date;
        this.status = status;
    }

    // 🔹 Getter & Setter
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

    // 🔹 디버깅용 toString
    @Override
    public String toString() {
        return "InquiryDTO{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", writer='" + writer + '\'' +
                ", category='" + category + '\'' +
                ", secret=" + secret +
                ", regdate=" + regdate +
                ", hit=" + hit +
                ", status='" + status + '\'' +
                '}';
    }
}
