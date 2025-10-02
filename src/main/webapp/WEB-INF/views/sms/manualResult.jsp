<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>SMS 발송 결과</title>
</head>
<body>
    <h2>발송 결과</h2>

    <c:if test="${result.error != null}">
	    <p style="color:red;">❌ 오류: ${result.error}</p>
	    <c:if test="${result.details != null}">
	        <pre style="color:gray;">${result.details}</pre>
    	</c:if>
	</c:if>

    <c:if test="${result.result == 'sent'}">
        <p style="color:green;">✅ 성공적으로 전송되었습니다.</p>
        <p>SID: ${result.sid}</p>
    </c:if>

    <a href="/sms/dong/manualForm">← 다시 보내기</a>
</body>
</html>