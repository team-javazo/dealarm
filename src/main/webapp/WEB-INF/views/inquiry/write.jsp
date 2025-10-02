<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>문의 등록</title>
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
    <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

        <!-- 고객문의 본문 -->
        <main class="content">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0">문의 등록</h4>
                <a href="${pageContext.request.contextPath}/inquiry/list" class="btn btn-secondary btn-sm">
                    <i class="bi bi-list"></i> 목록
                </a>
            </div>

            <!-- 등록 폼 -->
            <form action="${pageContext.request.contextPath}/inquiry/write" method="post">
                <!-- 제목 -->
                <div class="mb-3">
                    <label class="form-label">제목</label>
                    <input type="text" name="title" class="form-control" required>
                </div>

                <!-- 작성자 (세션 자동 기입) -->
                <div class="mb-3">
                    <label class="form-label">작성자</label>
                    <input type="text" name="writer" class="form-control" value="${writer}" readonly>
                </div>

                <!-- 카테고리 선택 -->
                <div class="mb-3">
                    <label class="form-label">카테고리</label>
                    <select name="category" class="form-select" required>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 내용 -->
                <div class="mb-3">
                    <label class="form-label">내용</label>
                    <textarea name="content" class="form-control" rows="5" required></textarea>
                </div>

                <!-- 비밀글 여부 -->
                <div class="form-check mb-3">
                    <input type="checkbox" name="secret" value="true" class="form-check-input" id="secretCheck">
                    <label class="form-check-label" for="secretCheck">비밀글</label>
                </div>

                <button type="submit" class="btn btn-primary">등록</button>
                <a href="${pageContext.request.contextPath}/inquiry/list" class="btn btn-secondary">취소</a>
            </form>
        </main>
    </div>
</body>
</html>
