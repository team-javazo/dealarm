<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body {margin:0;padding:0;height:100vh;display:flex;flex-direction:column;}
        .main-wrapper {flex-grow:1;display:flex;overflow:hidden;}
        nav.sidebar {width:250px;background:#f8f9fa;border-right:1px solid #ddd;padding:1rem;overflow-y:auto;}
        main.content {flex-grow:1;padding:2rem;overflow-y:auto;background:#fff;}
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/include/top_nav.jsp" %>
    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp" %>

        <!-- ✅ 본문: 수정 -->
        <main class="content">
            <h4 class="mb-3">게시글 수정</h4>
            <form action="${pageContext.request.contextPath}/board/edit" method="post">
    <input type="hidden" name="id" value="${board.id}"/>

    <div class="mb-3">
        <label class="form-label">제목</label>
        <input type="text" class="form-control" name="title" value="${board.title}" required>
    </div>

    <div class="mb-3">
        <label class="form-label">작성자</label>
        <input type="text" class="form-control" name="writer" value="${board.writer}" readonly>
    </div>

    <div class="mb-3">
        <label class="form-label">내용</label>
        <textarea class="form-control" name="content" rows="5">${board.content}</textarea>
    </div>

    <div class="form-check mb-3">
        <input type="checkbox" class="form-check-input" name="notice" value="true"
               <c:if test="${board.notice}">checked</c:if>>
        <label class="form-check-label">공지글</label>
    </div>

    <button type="submit" class="btn btn-primary">수정하기</button>
    <a href="${pageContext.request.contextPath}/board/list" class="btn btn-secondary">목록</a>
</form>

        </main>
    </div>
</body>
</html>
