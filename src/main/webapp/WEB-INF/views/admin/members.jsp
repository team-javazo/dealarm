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
	<h3>총 회원수 : ${count} 명</h3>
	<a href="${pageContext.request.contextPath}/admin/members" class="btn btn-outline-primary btn-sm ms-3"
	   onclick="document.querySelector('input[name=searchValue]').value = '';
       			document.querySelector('select[name=searchType]').value = 'all';">총 회원리스트</a>
	
    <!-- 검색 폼 -->
    <form action="${pageContext.request.contextPath}/admin/membersSearch" method="post" class="d-flex mb-3" role="search">
        <select class="form-select me-2" style="max-width: 120px;" name="searchType">
            <option value="all" <c:if test="${empty param.searchType or param.searchType == 'all'}">selected</c:if>>전체</option>
            <option value="id" <c:if test="${param.searchType == 'id'}">selected</c:if>>아이디</option>
            <option value="name" <c:if test="${param.searchType == 'name'}">selected</c:if>>이름</option>
            <option value="phone" <c:if test="${param.searchType == 'phone'}">selected</c:if>>전화번호</option>
            <option value="birth_date" <c:if test="${param.searchType == 'birth_date'}">selected</c:if>>생년월일</option>
            <option value="gender" <c:if test="${param.searchType == 'gender'}">selected</c:if>>성별</option>
            <option value="notification" <c:if test="${param.searchType == 'notification'}">selected</c:if>>알림동의</option>
            <option value="region" <c:if test="${param.searchType == 'region'}">selected</c:if>>지역</option>
            <option value="role" <c:if test="${param.searchType == 'role'}">selected</c:if>>권한</option>
            <option value="is_active" <c:if test="${param.searchType == 'is_active'}">selected</c:if>>계정상태</option>
            <option value="created_at" <c:if test="${param.searchType == 'created_at'}">selected</c:if>>가입일</option>
        </select>
        <input type="text" name="searchValue" class="form-control me-2" style="max-width: 300px;" placeholder="검색어를 입력하세요" value="$param.searchValue}">
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
    
</div>


</body>
</html>