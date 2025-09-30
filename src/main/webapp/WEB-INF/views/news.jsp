<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>네이버 뉴스 검색</title>
<style>
body {
    font-family: Arial, sans-serif;
    max-width: 900px;
    margin: 20px auto;
    padding: 0 15px;
    background-color: #f9f9f9;
}
h1 {
    color: #2c3e50;
    margin-bottom: 20px;
}
form {
    margin-bottom: 30px;
}
input[type="text"] {
    width: 400px;
    padding: 8px;
    font-size: 16px;
}
button {
    padding: 8px 16px;
    background: #2c3e50;
    color: white;
    border: none;
    cursor: pointer;
}
button:hover {
    background: #34495e;
}
.section {
    margin-bottom: 40px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 0 6px rgba(0,0,0,0.1);
    padding: 15px 20px;
}
.section h2 {
    border-bottom: 2px solid #ecf0f1;
    padding-bottom: 8px;
    margin-bottom: 15px;
    color: #2980b9;
}
ul {
    list-style: none;
    padding: 0;
    margin: 0;
}
li {
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid #ecf0f1;
}
li:last-child {
    border-bottom: none;
}
a {
    font-size: 18px;
    font-weight: bold;
    color: #2c3e50;
    text-decoration: none;
}
a:hover {
    color: #2980b9;
    text-decoration: underline;
}
.desc {
    margin: 5px 0 5px 0;
    color: #555;
}
.small-info {
    font-size: 13px;
    color: #7f8c8d;
}
</style>
</head>
<body>

<h1>뉴스 검색</h1>

<!-- 검색어 입력 form -->
<form action="${pageContext.request.contextPath}/news" method="get">
    <input type="text" name="query" placeholder="검색어 입력"/>
    <button type="submit">검색</button>
    <button type="button" onclick="location.href='<c:url value="/main"/>'">돌아가기</button>
</form>

<!-- 뉴스 리스트 -->
<c:if test="${not empty keywordNewsMap}">
    <c:forEach var="entry" items="${keywordNewsMap}">
        <div class="section">
            <h2>키워드: ${entry.key}</h2>
            <ul>
                <c:forEach var="item" items="${entry.value}">
                    <li>
                        <a href="${item.link}" target="_blank">
                            <c:out value="${item.title}" escapeXml="false"/>
                        </a>
                        <div class="desc">
                            <c:out value="${item.description}" escapeXml="false"/>
                        </div>
                        <div class="small-info">
                            ${item.pubDate} | 출처: 
                            <c:out value="${fn:replace(fn:substringAfter(item.link,'//'),'/','')}" />
                        </div>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </c:forEach>
</c:if>

<c:if test="${empty keywordNewsMap}">
    <p>뉴스가 없습니다.</p>
</c:if>

</body>
</html>
