<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>문의 삭제 확인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container mt-4">
    <h3>정말 삭제하시겠습니까?</h3>
    <p><strong>${dto.title}</strong></p>
    <form action="${pageContext.request.contextPath}/inquiry/delete" method="post">
        <input type="hidden" name="id" value="${dto.id}">
        <button type="submit" class="btn btn-danger">삭제</button>
        <a href="${pageContext.request.contextPath}/inquiry/detail?id=${dto.id}" class="btn btn-secondary">취소</a>
    </form>
</div>
</body>
</html>
