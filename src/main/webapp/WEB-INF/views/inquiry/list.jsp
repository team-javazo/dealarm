<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <title>문의 목록</title>
  <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
  <style>
    body { font-family: "Pretendard", sans-serif; background:#f9fafb; margin:0; padding:0; }
    .card { border:1px solid #e5e7eb; border-radius:12px; background:#fff; margin-bottom:16px; }
    .card-header { padding:12px 16px; border-bottom:1px solid #eef0f3; font-weight:600; background:#f7fafc; }
    .card-body { padding:16px; }
    .table { width:100%; border-collapse:collapse; }
    .table th, .table td { border:1px solid #edf2f7; padding:10px 12px; }
    .table thead th { background:#f9fafb; font-weight:600; }
    .btn { display:inline-block; border:1px solid #d1d5db; background:#fff; padding:6px 12px; border-radius:8px; text-decoration:none; color:#111; }
    .btn:hover { background:#f5f6f8; }
    .btn-primary { background:#2563eb; border-color:#2563eb; color:#fff; }
    .btn-primary:hover { background:#1d4ed8; }
    .pill { display:inline-block; padding:2px 8px; border-radius:999px; font-size:12px; border:1px solid #e1e4e8; background:#f8fafc; }
    .pill.success { color:#0a7; border-color:#bff0de; background:#eafff6; }
    .pill.warn { color:#b7791f; border-color:#fbd38d; background:#fffaf0; }
    .pill.muted { color:#6b7280; }
    .lock { margin-right:6px; color:#777; }
  </style>
</head>

<body style="display:flex; flex-direction:column; min-height:100vh;">

  <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

  <div class="d-flex" style="flex:1 0 auto;">
    <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

    <div class="flex-grow-1">
      <div class="content-wrapper">

        <section class="content-header">
          <h2 class="fw-bold mb-1">문의 게시판</h2>
          <ol class="breadcrumb">
            <li class="active">문의 목록</li>
          </ol>
        </section>

        <section class="content">

          <div class="card">
            <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;">
              <span>검색</span>
              <c:url var="writeUrl" value="/inquiry/write"/>
              <a href="${writeUrl}" class="btn btn-primary btn-sm">글쓰기</a>
            </div>
            <div class="card-body">
              <c:url var="listUrl" value="/inquiry/list"/>
              <form method="get" action="${listUrl}" style="display:flex; gap:8px; flex-wrap:wrap;">
                <input type="text" name="keyword" class="form-control" style="min-width:240px;"
                       placeholder="제목 / 작성자 검색" value="${param.keyword}">
                <button class="btn" type="submit">검색</button>
              </form>
            </div>
          </div>

          <div class="card">
            <div class="card-header">문의 목록</div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table text-center align-middle">
                  <thead>
                    <tr>
                      <th>번호</th>
                      <th>제목</th>
                      <th>작성자</th>
                      <th>작성일</th>
                      <th>조회</th>
                      <th>상태</th>
                      <th>비밀</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:choose>
                      <c:when test="${not empty list}">
                        <c:forEach var="dto" items="${list}">
                          <c:set var="isOwner" value="${currentLoginId != null and currentLoginId == dto.writer}" />
                          <c:set var="canView" value="${not dto.secret or isAdmin or isOwner}" />

                          <tr>
                            <td>${dto.id}</td>
                            <td class="text-start">
                              <c:choose>
                                <c:when test="${canView}">
                                  <c:url var="detailUrl" value="/inquiry/detail">
                                    <c:param name="id" value="${dto.id}"/>
                                  </c:url>
                                  <a href="${detailUrl}" style="text-decoration:none; color:#222; font-weight:600;">
                                    <c:if test="${dto.secret}"><span class="lock">🔒</span></c:if>
                                    <c:out value="${dto.title}"/>
                                  </a>
                                  <c:if test="${dto.status eq '답변완료'}">
                                    <span class="pill success">답변완료</span>
                                  </c:if>
                                </c:when>
                                <c:otherwise>
                                  <span class="muted"><span class="lock">🔒</span> 비밀글 (작성자/관리자만 열람 가능)</span>
                                </c:otherwise>
                              </c:choose>
                            </td>
                            <td><c:out value="${dto.writer}"/></td>
                            <td><fmt:formatDate value="${dto.regdate}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td>${dto.hit}</td>
                            <td>
                              <c:choose>
                                <c:when test="${dto.status eq '답변완료'}"><span class="pill success">완료</span></c:when>
                                <c:otherwise><span class="pill muted">대기</span></c:otherwise>
                              </c:choose>
                            </td>
                            <td>
                              <c:choose>
                                <c:when test="${dto.secret}"><span class="pill warn">Y</span></c:when>
                                <c:otherwise><span class="pill muted">N</span></c:otherwise>
                              </c:choose>
                            </td>
                          </tr>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <tr><td colspan="7" style="padding:24px;">등록된 문의가 없습니다.</td></tr>
                      </c:otherwise>
                    </c:choose>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="card-body" style="display:flex; justify-content:space-between; align-items:center;">
              <div>
                <b>현재 사용자:</b> <span class="text-primary">${currentLoginId}</span> |
                <b>관리자:</b> <span class="text-danger"><c:choose>
                  <c:when test="${isAdmin}">ON</c:when>
                  <c:otherwise>OFF</c:otherwise>
                </c:choose></span>
              </div>
              <div>
                <c:url var="adminOn" value="/inquiry/dev/admin/on"/>
                <c:url var="adminOff" value="/inquiry/dev/admin/off"/>
                <a href="${adminOn}" class="btn btn-sm">관리자ON</a>
                <a href="${adminOff}" class="btn btn-sm">OFF</a>
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
