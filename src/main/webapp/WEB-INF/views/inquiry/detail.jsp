<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <title>문의 상세</title>
  <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
  <style>
    body { font-family:"Pretendard",sans-serif; background:#f9fafb; margin:0; padding:0; }
    .card { border:1px solid #e5e7eb; border-radius:12px; background:#fff; }
    .card + .card { margin-top:16px; }
    .card-header { padding:12px 16px; border-bottom:1px solid #eef0f3; font-weight:600; background:#f7fafc; }
    .card-body { padding:16px; }
    .pill { display:inline-block; padding:2px 8px; border-radius:999px; font-size:12px; border:1px solid #e1e4e8; background:#f8fafc; }
    .pill.success { color:#0a7; border-color:#bff0de; background:#eafff6; }
    .pill.warn { color:#b7791f; border-color:#fbd38d; background:#fffaf0; }
    .pill.admin { background:#e0ecff; color:#1d4ed8; border-color:#cbd5e1; font-weight:600; }
    .muted { color:#6b7280; }
    .btn { display:inline-block; border:1px solid #d1d5db; background:#fff; padding:6px 12px; border-radius:8px; text-decoration:none; color:#111; cursor:pointer; }
    .btn:hover { background:#f5f6f8; }
    .btn-primary { background:#2563eb; border-color:#2563eb; color:#fff; }
    .btn-primary:hover { background:#1d4ed8; }
    .btn-danger { background:#e11d48; color:#fff; }
    .btn-danger:hover { background:#be123c; }
    .comment { padding:10px 12px; border-bottom:1px solid #eee; border-radius:8px; margin-bottom:10px; }
    .comment strong { color:#111; }
    .comment small { color:#777; font-size:12px; }
    .comment.admin { background:#f0f7ff; border-left:3px solid #2563eb; }
    .comment.user { background:#fff; }
    .no-comment { text-align:center; color:#777; padding:16px 0; }
    textarea { width:100%; border:1px solid #ddd; border-radius:6px; padding:8px; resize:none; }
  </style>
</head>

<body>
  <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>
  <div class="d-flex" style="flex:1 0 auto;">
    <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
    <div class="flex-grow-1">
      <div class="content-wrapper">

        <!-- 제목 -->
        <section class="content-header">
          <h2 class="fw-bold mb-1">문의 상세</h2>
          <ol class="breadcrumb">
            <li><a href="${pageContext.request.contextPath}/inquiry/list">문의 목록</a></li>
          </ol>
        </section>

        <section class="content">

          <!-- 기본 정보 -->
          <div class="card">
            <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
              <div>
                <c:if test="${inquiry.secret}"><span>🔒</span></c:if>
                <c:out value="${inquiry.title}"/>
              </div>
              <div>
                <a href="${pageContext.request.contextPath}/inquiry/list" class="btn btn-sm">← 목록</a>
                <c:if test="${isAdmin or (currentLoginId eq inquiry.writer)}">
                  <a href="${pageContext.request.contextPath}/inquiry/edit?id=${inquiry.id}" class="btn btn-primary btn-sm">수정</a>
                  <a href="${pageContext.request.contextPath}/inquiry/delete?id=${inquiry.id}" class="btn btn-danger btn-sm"
                     onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                </c:if>
              </div>
            </div>

            <div class="card-body">
              <p><b>작성자:</b> ${inquiry.writer}</p>
              <p><b>카테고리:</b> <span class="pill">${inquiry.category}</span></p>
              <p><b>작성일:</b> <fmt:formatDate value="${inquiry.regdate}" pattern="yyyy-MM-dd HH:mm"/></p>
              <p><b>조회수:</b> ${inquiry.hit}</p>
              <p><b>상태:</b>
                <c:choose>
                  <c:when test="${inquiry.status eq '답변완료'}"><span class="pill success">답변완료</span></c:when>
                  <c:otherwise><span class="pill warn">대기</span></c:otherwise>
                </c:choose>
              </p>
            </div>
          </div>

          <!-- 본문 -->
          <div class="card">
            <div class="card-header">내용</div>
            <div class="card-body">
              <pre style="white-space:pre-wrap; font-size:14px;"><c:out value="${inquiry.content}"/></pre>
            </div>
          </div>

          <!-- 댓글 -->
          <div class="card">
            <div class="card-header">댓글</div>
            <div class="card-body">
              <c:if test="${not empty commentList}">
                <c:forEach var="c" items="${commentList}">
                  <div class="comment <c:choose><c:when test='${c.writer eq "관리자"}'>admin</c:when><c:otherwise>user</c:otherwise></c:choose>">
                    <strong>${c.writer}
                      <c:if test="${c.writer eq '관리자'}">
                        <span class="pill admin" style="margin-left:6px;">관리자</span>
                      </c:if>
                    </strong>
                    <small><fmt:formatDate value="${c.regdate}" pattern="yyyy-MM-dd HH:mm"/></small>
                    <p style="margin:6px 0;">${c.content}</p>

                    <c:if test="${isAdmin or (currentLoginId eq c.writer)}">
                      <a href="${pageContext.request.contextPath}/comment/delete?id=${c.id}&inquiryId=${inquiry.id}" 
                         class="btn btn-danger btn-sm"
                         onclick="return confirm('댓글을 삭제하시겠습니까?');">삭제</a>
                    </c:if>
                  </div>
                </c:forEach>
              </c:if>

              <c:if test="${empty commentList}">
                <div class="no-comment">등록된 댓글이 없습니다.</div>
              </c:if>

              <!-- 댓글 작성 -->
              <c:if test="${isAdmin or (currentLoginId eq inquiry.writer)}">
                <form action="${pageContext.request.contextPath}/comment/insert" method="post" style="margin-top:16px;">
                  <input type="hidden" name="inquiryId" value="${inquiry.id}" />
                  <textarea name="content" rows="3" placeholder="댓글을 입력하세요..." required></textarea>
                  <div style="text-align:right; margin-top:8px;">
                    <button type="submit" class="btn btn-primary">댓글 등록</button>
                  </div>
                </form>
              </c:if>

              <c:if test="${not (isAdmin or (currentLoginId eq inquiry.writer))}">
                <p class="muted" style="font-size:14px;">댓글은 관리자 또는 작성자만 작성할 수 있습니다.</p>
              </c:if>
            </div>
          </div>

        </section>
      </div>
      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>
</body>
</html>
