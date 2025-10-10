<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>문의 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body {margin:0;padding:0;height:100vh;display:flex;flex-direction:column;}
        .main-wrapper {flex-grow:1;display:flex;overflow:hidden;}
        nav.sidebar {width:250px;background:#f8f9fa;border-right:1px solid #ddd;padding:1rem;overflow-y:auto;}
        main.content {flex-grow:1;padding:2rem;overflow-y:auto;background:#fff;}
        .label {font-weight: bold; width: 120px; display: inline-block;}
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

        <!-- 문의 상세 본문 -->
        <main class="content">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0">문의 상세</h4>
                <div>
                    <a href="${pageContext.request.contextPath}/inquiry/list" class="btn btn-secondary btn-sm">
                        <i class="bi bi-list"></i> 목록
                    </a>
                    <!-- 게시자 본인 또는 관리자만 수정/삭제 버튼 노출 -->
                    <c:if test="${sessionScope.name eq dto.writer || sessionScope.role eq 'admin'}">
                        <a href="${pageContext.request.contextPath}/inquiry/update?id=${dto.id}" class="btn btn-warning btn-sm">
                            <i class="bi bi-pencil"></i> 수정
                        </a>
                        <a href="${pageContext.request.contextPath}/inquiry/deleteConfirm?id=${dto.id}" class="btn btn-danger btn-sm">
                            <i class="bi bi-trash"></i> 삭제
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- 상세 내용 -->
            <div class="card mb-3">
                <div class="card-body">
                    <p><span class="label">제목</span> ${dto.title}</p>
                    <p><span class="label">작성자</span> ${dto.writer}</p>
                    <p><span class="label">카테고리</span> ${dto.category}</p>
                    <p><span class="label">작성일</span> 
                        <fmt:formatDate value="${dto.regdate}" pattern="yyyy-MM-dd HH:mm"/>
                    </p>
                    <p><span class="label">조회수</span> ${dto.hit}</p>
                    <p><span class="label">공개여부</span> 
                        <c:if test="${dto.secret}">비공개</c:if>
                        <c:if test="${!dto.secret}">공개</c:if>
                    </p>
                    <p><span class="label">상태</span> 
                        <c:choose>
                            <c:when test="${dto.status eq '답변완료'}">
                                <span class="badge bg-success">답변완료</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">대기중</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <hr>
                    <p><span class="label">내용</span></p>
                    <div class="border rounded p-3 mb-3">${dto.content}</div>
                </div>
            </div>

            <!-- 답변 영역 -->
            <c:if test="${not empty dto.answer}">
                <div class="card">
                    <div class="card-header bg-light">
                        <strong>관리자 답변</strong> 
                        <small class="text-muted">
                            (<fmt:formatDate value="${dto.answer_date}" pattern="yyyy-MM-dd HH:mm"/>)
                        </small>
                    </div>
                    <div class="card-body">
                        ${dto.answer}
                    </div>
                </div>
            </c:if>

            <!-- 답변 등록 폼 (게시자 또는 관리자만 노출, 답변 없을 때만) -->
            <c:if test="${empty dto.answer && (sessionScope.name eq dto.writer || sessionScope.role eq 'admin')}">
                <div class="mt-4">
                    <form action="${pageContext.request.contextPath}/inquiry/answer" method="post">
                        <input type="hidden" name="id" value="${dto.id}">
                        <div class="mb-3">
                            <label class="form-label">답변 작성</label>
                            <textarea name="answer" class="form-control" rows="4" placeholder="답변을 입력하세요"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">답변 등록</button>
                    </form>
                </div>
            </c:if>
        </main>
    </div>
</body>
</html>
