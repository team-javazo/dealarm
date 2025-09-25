<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>수동 SMS 발송</title>
</head>
<body>
    <h2>수동 SMS 발송 테스트</h2>
    <form method="post" action="${pageContext.request.contextPath}/sms/manualSend">
        <label>유저 ID:</label>
        <input type="text" name="userId" required><br><br>

        <label>전화번호:</label>
        <input type="text" name="phone" required placeholder="01032047742"><br><br>

        <label>상품명:</label>
        <input type="text" name="title" required><br><br>

        <label>링크(URL):</label>
        <input type="text" name="url"><br><br>

        <label>딜 ID:</label>
        <input type="text" name="dealId" required><br><br>

        <button type="submit">📩 SMS 보내기</button>
    </form>
</body>
</html>