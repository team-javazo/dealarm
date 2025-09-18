<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>회원관리</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
<div class="container mt-4">

    <h2 class="mb-3">회원관리 페이지</h2>

    <!-- 검색 폼 -->
    <form action="${pageContext.request.contextPath}/admin/members" method="post" class="d-flex mb-3" role="search">
        <select class="form-select me-2" style="max-width: 120px;" name="searchType">
            <option value="all" selected>전체</option>
            <option value="id">아이디</option>
            <option value="name">이름</option>
            <option value="phone">전화번호</option>
            <option value="birth_date">생년월일</option>
            <option value="gender">성별</option>
            <option value="notification">알림동의</option>
            <option value="region">지역</option>
            <option value="role">권한</option>
            <option value="is_active">계정상태</option>
            <option value="created_at">가입일</option>
        </select>
        <input type="text" name="searchValue" class="form-control me-2" style="max-width: 300px;" placeholder="검색어를 입력하세요">
        <input type="submit" class="btn btn-primary" value="검색">
    </form>

    <!-- 회원 목록 테이블 -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover text-center">
            <thead class="table-light">
                <tr>
                    <th>아이디</th>
                    <th>비밀번호</th>
                    <th>이름</th>
                    <th>전화번호</th>
                    <th>이메일</th>
                    <th>생년월일</th>
                    <th>성별</th>
                    <th>알림동의</th>
                    <th>지역</th>
                    <th>권한</th>
                    <th>계정상태</th>
                    <th>가입일</th>
                    <th>상세조회</th>
                    <th>수정</th>
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="member" items="${list}">
                    <tr>
                        <td>${member.id}</td>
                        <td>${member.password}</td>
                        <td>${member.name}</td>
                        <td>${member.phone}</td>
                        <td>${member.email}</td>
                        <td>${member.birth_date}</td>
                        <td>${member.gender}</td>
                        <td>${member.notification}</td>
                        <td>${member.region}</td>
                        <td>${member.role}</td>
                        <td>
                            <c:choose>
                                <c:when test="${member.is_active == 1}">활성</c:when>
                                <c:otherwise>비활성</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${member.created_at}</td>
                        <td><button class="btn btn-secondary btn-sm" onclick="alert('상세조회: ${member.id}')">상세조회</button></td>
                        <td><button class="btn btn-primary btn-sm" onclick="alert('수정: ${member.id}')">수정</button></td>
                        <td><button class="btn btn-danger btn-sm" onclick="alert('삭제: ${member.id}')">삭제</button></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="mt-3">
        <a href="${pageContext.request.contextPath}/admin/members" class="btn btn-outline-primary">회원 전체보기</a>
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">홈으로</a>
    </div>

</div>


</body>
</html>