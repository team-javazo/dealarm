<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <title>문의 상세</title>
  <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
  <style>
    /* --- 최소한의 정리 스타일 --- */
    .card { border:1px solid #e5e7eb; border-radius:12px; background:#fff; }
    .card + .card { margin-top:16px; }
    .card-header { padding:12px 16px; border-bottom:1px solid #eef0f3; font-weight:600; }
    .card-body { padding:16px; }
    .pill { display:inline-block; padding:2px 8px; border-radius:999px; font-size:12px; border:1px solid #e1e4e8; background:#f8fafc; }
    .pill.success { color:#0a7; border-color:#bff0de; background:#eafff6; }
    .pill.warn { color:#b7791f; border-color:#fbd38d; background:#fffaf0; }
    .pill.muted { color:#6b7280; }
    .grid { display:grid; grid-template-columns: repeat(6, 1fr); gap:12px; }
    @media (max-width: 992px){ .grid { grid-template-columns: repeat(2, 1fr);} }
    @media (max-width: 576px){ .grid { grid-template-columns: 1fr;} }
    .cell { border:1px dashed #e5e7eb; border-radius:10px; padding:12px 14px; background:#fcfcfd; }
    .cell .label { font-size:12px; color:#6b7280; display:block; margin-bottom:6px; }
    .cell .value { font-size:14px; font-weight:600; color:#111827; }
    pre.content { white-space:pre-wrap; margin:0; font-size:14px; line-height:1.6; }
    .actions { display:flex; justify-content:flex-end; gap:8px; }
    .btn { display:inline-block; border:1px solid #d1d5db; background:#fff; padding:6px 12px; border-radius:8px; text-decoration:none; color:#111; }
    .btn:hover { background:#f5f6f8; }
    .btn-primary { background:#2563eb; border-color:#2563eb; color:#fff; }
    .btn-primary:hover { background:#1d4ed8; }
    .btn-sm { padding:4px 10px; font-size:12px; }
    .muted { color:#6b7280; }
    .lock { margin-right:6px; }
  </style>
</head>
<body style="margin:0; padding:0; display:flex; flex-direction:column; min-height:100vh;">

  <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

  <div class="d-flex" style="flex:1 0 auto;">
    <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

    <div class="flex-grow-1">
      <div class="content-wrapper">

        <!-- 브레드크럼 / 상단 타이틀 -->
        <section class="content-header">
          <h2 class="fw-bold mb-1">문의 상세</h2>
          <ol class="breadcrumb">
            
            <li><a href="${pageContext.request.contextPath}/inquiry/list">문의 목록</a></li>
           
          </ol>
        </section>

        <section class="content">

          <!-- 상단 타이틀 카드 -->
          <div class="card">
            <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;">
              <div>
                <c:if test="${inquiry.secret}">
                  <span class="lock">&#128274;</span>
                </c:if>
                <span><c:out value="${inquiry.title}"/></span>
              </div>
              <div>
                <c:url var="listUrl" value="/inquiry/list"/>
                <a class="btn btn-sm" href="${listUrl}">← 목록</a>
              </div>
            </div>

            <!-- 메타정보: 각 항목을 칸(cell)으로 -->
            <div class="card-body">
              <div class="grid">
                <div class="cell">
                  <span class="label">작성자</span>
                  <span class="value"><c:out value="${inquiry.writer}"/></span>
                </div>
                <div class="cell">
                  <span class="label">작성일</span>
                  <span class="value"><fmt:formatDate value="${inquiry.regdate}" pattern="yyyy-MM-dd HH:mm"/></span>
                </div>
                <div class="cell">
                  <span class="label">조회</span>
                  <span class="value">${inquiry.hit}</span>
                </div>
                <div class="cell">
                  <span class="label">상태</span>
                  <span class="value">
                    <c:choose>
                      <c:when test="${inquiry.status eq '답변완료'}"><span class="pill success">답변완료</span></c:when>
                      <c:otherwise><span class="pill muted">대기</span></c:otherwise>
                    </c:choose>
                  </span>
                </div>
                <div class="cell">
                  <span class="label">비밀글</span>
                  <span class="value">
                    <c:choose>
                      <c:when test="${inquiry.secret}"><span class="pill warn">Y</span></c:when>
                      <c:otherwise><span class="pill muted">N</span></c:otherwise>
                    </c:choose>
                  </span>
                </div>
                <div class="cell">
                  <span class="label">글 번호</span>
                  <span class="value">${inquiry.id}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 본문 카드 -->
          <div class="card">
            <div class="card-header"><i class="fa fa-file-text-o"></i> 내용</div>
            <div class="card-body">
              <pre class="content"><c:out value="${inquiry.content}"/></pre>
            </div>
          </div>

          <!-- 관리자 답변 카드 -->
          <c:choose>
            <c:when test="${not empty inquiry.answer}">
              <div class="card">
                <div class="card-header"><i class="fa fa-check-circle"></i> 관리자 답변</div>
                <div class="card-body">
                  <pre class="content"><c:out value="${inquiry.answer}"/></pre>
                  <div class="muted" style="text-align:right; margin-top:8px;">
                    답변일:
                    <c:choose>
                      <c:when test="${not empty inquiry.answer_date}">
                        <fmt:formatDate value="${inquiry.answer_date}" pattern="yyyy-MM-dd HH:mm"/>
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <div class="card">
                <div class="card-header"><i class="fa fa-info-circle"></i> 관리자 답변</div>
                <div class="card-body">
                  <span class="muted">아직 등록된 답변이 없습니다.</span>
                </div>
              </div>
            </c:otherwise>
          </c:choose>

          <!-- 관리자 답변 등록/수정 카드 -->
          <c:set var="admin" value="${isAdmin or sessionScope.isAdmin or (sessionScope.role != null and (sessionScope.role == 'admin' or sessionScope.role == 'ADMIN' or sessionScope.role == 'ROLE_ADMIN'))}" />
          <c:if test="${admin}">
            <div class="card">
              <div class="card-header"><i class="fa fa-pencil"></i> 관리자 답변 등록/수정</div>
              <div class="card-body">
                <c:url var="answerUrl" value="/inquiry/answer"/>
                <form method="post" action="${answerUrl}">
                  <input type="hidden" name="id" value="${inquiry.id}"/>
                  <div class="form-group" style="margin-bottom:12px;">
                    <textarea name="answer" class="form-control" rows="6" placeholder="답변 내용을 입력하세요."><c:out value="${inquiry.answer}"/></textarea>
                  </div>
                  <div class="actions">
                    <button type="submit" class="btn btn-primary">저장</button>
                    <c:url var="detailUrl" value="/inquiry/detail"><c:param name="id" value="${inquiry.id}"/></c:url>
                    <a href="${detailUrl}" class="btn">취소</a>
                  </div>
                </form>
              </div>
            </div>
          </c:if>

          <!-- 하단 상태/토글 -->
          <div class="card">
            <div class="card-body" style="display:flex; justify-content:space-between; align-items:center;">
              <div class="muted">
                <b>현재 사용자:</b> <span class="text-primary">${sessionScope.username}</span>
                &nbsp;|&nbsp;
                <b>관리자:</b>
                <span class="text-danger">
                  <c:choose>
                    <c:when test="${admin}">ON</c:when>
                    <c:otherwise>OFF</c:otherwise>
                  </c:choose>
                </span>
              </div>
              
            </div>
          </div>

        </section>
      </div>

      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>

</body>
</html>
