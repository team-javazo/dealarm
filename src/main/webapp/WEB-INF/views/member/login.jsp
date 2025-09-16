<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>로그인</title>
</head>
<body>
    <h2>로그인</h2>
    <form action="<c:url value='/member/login'/>" method="post">
        <p>
            아이디: <input type="text" name="id" required>
        </p>
        <p>
            비밀번호: <input type="password" name="password" required>
        </p>
        <button type="submit">로그인</button>
    </form>

    <!-- 로그인 실패 메시지 표시 -->
    <c:if test="${not empty errorMsg}">
        <p style="color:red;">${errorMsg}</p>
    </c:if>

    <p><a href="<c:url value='/member/join'/>">회원가입</a></p>
    <p><a href="<c:url value='/'/>">홈으로</a></p>
</body>
</html>