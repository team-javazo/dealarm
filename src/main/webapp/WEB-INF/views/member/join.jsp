<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head><title>회원가입</title></head>
<body>
<h2>회원가입</h2>
<form action="${pageContext.request.contextPath}/member/join" method="post">
    아이디: <input type="text" name="id" required><br>
    비밀번호: <input type="password" name="password" required><br>
    이름: <input type="text" name="name" required><br>
    이메일: <input type="email" name="email"><br>
    생년월일: <input type="date" name="birth_date"><br>
    지역: <input type="text" name="region"><br>
    <button type="submit">가입하기</button>
</form>
</body>
</html>