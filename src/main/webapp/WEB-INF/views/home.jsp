<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<html>
<head>
    <title>Home</title>
</head>
<body>
    <h1>홈 화면</h1>

    <!-- 로그인 여부에 따라 다른 화면 출력 -->
    <c:choose>
    <c:when test="${empty sessionScope.id}">
        <a href="<c:url value='/member/join'/>">회원가입</a> |
        <a href="<c:url value='/member/login'/>">로그인</a>
    </c:when>
    <c:when test="${sessionScope.role eq 'ADMIN'}">
            <p><b>${sessionScope.role}</b> 님, 환영합니다!</p>
        <a href="<c:url value='/member/members'/>">회원목록</a>
        <a href="<c:url value='/member/logout'/>">로그아웃</a>
        <a href="<c:url value='/member/mypage'/>">마이페이지</a>
    </c:when>
    <c:otherwise>
        <p><b>${sessionScope.name}</b> 님, 환영합니다!</p>
        <a href="<c:url value='/member/logout'/>">로그아웃</a>
        <a href="<c:url value='/member/mypage'/>">마이페이지</a>
    </c:otherwise>
</c:choose>

    <hr>
    <p>서버 시간: ${serverTime}</p>

</body>
</html>