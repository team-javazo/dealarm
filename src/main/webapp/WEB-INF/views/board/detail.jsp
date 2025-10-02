<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기</title>
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

        <!-- ✅ 본문: 상세보기 -->
        <main class="content">
            <h4 class="mb-3">게시글 상세보기</h4>

            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">${board.title}</h5>
                    <div class="mb-2 text-muted">
                        <span>작성자: <b>${board.writer}</b></span> · 
                        <span>작성일: ${board.regdate}</span> · 
                        <span>조회수: ${board.hit}</span>
                    </div>
                    <hr>
                    <p class="card-text" style="white-space:pre-line;">${board.content}</p>
                </div>
            </div>

            <!-- 버튼 -->
            <div class="d-flex justify-content-between">
                <a href="${pageContext.request.contextPath}/board/list" class="btn btn-secondary btn-sm">
                    <i class="bi bi-list"></i> 목록
                </a>
                <div>
                    <a href="${pageContext.request.contextPath}/board/edit?id=${board.id}" class="btn btn-warning btn-sm">
                        <i class="bi bi-pencil"></i> 수정
                    </a>
                    <a href="${pageContext.request.contextPath}/board/delete?id=${board.id}" 
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('정말 삭제하시겠습니까?');">
                        <i class="bi bi-trash"></i> 삭제
                    </a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
