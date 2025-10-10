<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>고객문의 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body {margin:0;padding:0;height:100vh;display:flex;flex-direction:column;}
        .main-wrapper {flex-grow:1;display:flex;overflow:hidden;}
        nav.sidebar {width:250px;background:#f8f9fa;border-right:1px solid #ddd;padding:1rem;overflow-y:auto;}
        main.content {flex-grow:1;padding:2rem;overflow-y:auto;background:#fff;}
        .table th, .table td {vertical-align: middle;}
    </style>
</head>
<body>
    <!-- 상단 네비게이션 -->
    <%@ include file="/WEB-INF/views/include/top_nav.jsp" %>

    <div class="main-wrapper">
        <!-- 좌측 네비게이션 -->
        <%@ include file="/WEB-INF/views/include/left_nav.jsp" %>

        <!-- 고객문의 본문 -->
        <main class="content">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0">고객문의 목록</h4>
                <div>
                    <!-- 검색 -->
                    <form action="${pageContext.request.contextPath}/inquiry/list" method="get" class="d-inline">
                        <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력" 
                               class="form-control d-inline" style="width:200px;display:inline-block;">
                        <button type="submit" class="btn btn-outline-primary btn-sm">검색</button>
                    </form>

                    <!-- 카테고리 필터 -->
                    <form action="${pageContext.request.contextPath}/inquiry/list" method="get" class="d-inline ms-2">
                        <select name="category" class="form-select form-select-sm d-inline" style="width:150px;display:inline-block;">
                            <option value="">전체</option>
                            <option value="일반문의" ${param.category eq '일반문의' ? 'selected' : ''}>일반문의</option>
                            <option value="결제문의" ${param.category eq '결제문의' ? 'selected' : ''}>결제문의</option>
                            <option value="계정문의" ${param.category eq '계정문의' ? 'selected' : ''}>계정문의</option>
                            <option value="기타" ${param.category eq '기타' ? 'selected' : ''}>기타</option>
                        </select>
                        <button type="submit" class="btn btn-outline-secondary btn-sm">조회</button>
                    </form>

                    <!-- 문의 등록 -->
                    <a href="${pageContext.request.contextPath}/inquiry/write" class="btn btn-primary btn-sm">문의하기</a>
                </div>
            </div>

            <!-- 📋 고객문의 테이블 -->
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th style="width:60px;">번호</th>
                        <th>제목</th>
                        <th style="width:120px;">작성자</th>
                        <th style="width:150px;">카테고리</th>
                        <th style="width:150px;">작성일</th>
                        <th style="width:80px;">조회수</th>
                        <th style="width:100px;">상태</th>
                        <th style="width:80px;">공개</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty inquiryList}">
                            <c:forEach var="inq" items="${inquiryList}">
                                <tr>
                                    <td>${inq.id}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/inquiry/detail?id=${inq.id}">
                                            ${inq.title}
                                        </a>
                                        <c:if test="${inq.secret}">
                                            <span class="text-danger ms-1">🔒</span>
                                        </c:if>
                                    </td>
                                    <td>${inq.writer}</td>
                                    <td>${inq.category}</td>
                                    <td><fmt:formatDate value="${inq.regdate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>${inq.hit}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${inq.status eq '답변완료'}">
                                                <span class="badge bg-success">답변완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">대기중</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${inq.secret}">비공개</c:if>
                                        <c:if test="${!inq.secret}">공개</c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="text-center">등록된 문의가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <!-- 페이지네이션 -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <c:if test="${page > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${page-1}&keyword=${keyword}&category=${param.category}">이전</a>
                            </li>
                        </c:if>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == page ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&keyword=${keyword}&category=${param.category}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${page < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${page+1}&keyword=${keyword}&category=${param.category}">다음</a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </main>
    </div>
</body>
</html>
