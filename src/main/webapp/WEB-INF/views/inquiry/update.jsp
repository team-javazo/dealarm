<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>문의 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container mt-4">
    <h3>문의 수정</h3>
    <form action="${pageContext.request.contextPath}/inquiry/update" method="post">
        <input type="hidden" name="id" value="${dto.id}">
        <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" name="title" class="form-control" value="${dto.title}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">내용</label>
            <textarea name="content" class="form-control" rows="5" required>${dto.content}</textarea>
        </div>
        <div class="form-check mb-3">
            <input type="checkbox" name="secret" value="true" class="form-check-input" id="secretCheck"
                   <c:if test="${dto.secret}">checked</c:if>>
            <label class="form-check-label" for="secretCheck">비밀글</label>
        </div>
        <button type="submit" class="btn btn-warning">수정</button>
        <a href="${pageContext.request.contextPath}/inquiry/detail?id=${dto.id}" class="btn btn-secondary">취소</a>
    </form>
</div>
</body>
</html>
