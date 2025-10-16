<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
  <title>문의 목록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container py-4">
  <h2 class="mb-3">문의 목록</h2>
  <table class="table table-hover align-middle">
    <thead class="table-light">
      <tr>
        <th style="width:80px;">번호</th>
        <th>제목</th>
        <th style="width:140px;">작성자</th>
        <th style="width:160px;">작성일</th>
        <th style="width:80px;">조회</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="row" items="${list}">
        <tr>
          <td>${row.id}</td>
          <td>
            <a href="${pageContext.request.contextPath}/inquiry/detail?id=${row.id}">
              <c:if test="${row.secret}">[비밀]</c:if> ${row.title}
            </a>
          </td>
          <td>${row.writer}</td>
          <td>${row.regdate}</td>
          <td>${row.hit}</td>
        </tr>
      </c:forEach>
      <c:if test="${empty list}">
        <tr><td colspan="5" class="text-center text-muted">등록된 글이 없습니다.</td></tr>
      </c:if>
    </tbody>
  </table>
</body>
</html>
