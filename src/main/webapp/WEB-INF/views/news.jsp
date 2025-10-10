<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>네이버 뉴스 검색</title>
<link href="${pageContext.request.contextPath}/resources/css/styles.css"
	rel="stylesheet" />
<style>
#newsWrapper {
    display: flex; 
    max-width: 1220px; /* 헤더 max-width와 동일 */
    margin: 0 auto;    /* 중앙 정렬 */
    padding-top: 20px;
    box-sizing: border-box;
}

#newsLeft {
    width: 880px; /* 헤더 왼쪽 컨테이너 + 중앙 배너 폭 */
}

#newsRight {
    flex: 1; /* 오른쪽 공간 채우기용 빈 컨테이너 */
}

#mainContaner h1 {
	color: #2c3e50;
	margin-bottom: 20px;
}

#mainContaner form {
	margin-bottom: 30px;
}

#mainContaner input[type="text"] {
	width: 400px;
	padding: 8px;
	font-size: 16px;
}

#mainContaner button {
	padding: 8px 16px;
	background: #2c3e50;
	color: white;
	border: none;
	cursor: pointer;
}

#mainContaner button:hover {
	background: #34495e;
}

#mainContaner .section {
	margin-bottom: 40px;
	background: white;
	border-radius: 8px;
	box-shadow: 0 0 6px rgba(0, 0, 0, 0.1);
	padding: 15px 20px;
}

#mainContaner .section h2 {
	border-bottom: 2px solid #ecf0f1;
	padding-bottom: 8px;
	margin-bottom: 15px;
	color: #2980b9;
}

#mainContaner ul {
	list-style: none;
	padding: 0;
	margin: 0;
}

#mainContaner li {
	margin-bottom: 20px;
	padding-bottom: 10px;
	border-bottom: 1px solid #ecf0f1;
}

#mainContaner li:last-child {
	border-bottom: none;
}

#mainContaner a {
	font-size: 18px;
	font-weight: bold;
	color: #2c3e50;
	text-decoration: none;
}

#mainContaner a:hover {
	color: #2980b9;
	text-decoration: underline;
}

#mainContaner .desc {
	margin: 5px 0 5px 0;
	color: #555;
}

#mainContaner .small-info {
	font-size: 13px;
	color: #7f8c8d;
}
</style>
</head>
<body style="margin:0; padding:0; display:flex; flex-direction:column; min-height:100vh;">

<%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

<div class="d-flex">
    <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

    <div class="flex-grow-1">

        <%@ include file="/WEB-INF/views/include/header.jsp"%>

        <!-- 뉴스 컨테이너 외부 래퍼 -->
        <div id="newsWrapper">

            <!-- 왼쪽 뉴스 컨테이너 -->
            <div id="newsLeft">
                <div id="mainContaner">

                    <h1>뉴스 검색</h1>

                    <!-- 검색어 입력 form -->
                    <form action="${pageContext.request.contextPath}/news" method="get">
                        <input type="text" name="query" placeholder="검색어 입력" />
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
                                                <c:out value="${fn:replace(fn:substringAfter(item.link,'//'),'/','')}"/>
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

                </div>
            </div>

            <!-- 오른쪽 빈 컨테이너: 헤더와 폭 맞춤용 -->
            <div id="newsRight">
                <!-- 빈 공간 -->
            </div>

        </div>

        <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
</div>

</body>
</html>
