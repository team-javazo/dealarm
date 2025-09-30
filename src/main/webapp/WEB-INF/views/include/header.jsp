<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<header style="position: relative; height: 300px; max-width: 1220px; margin: 0 auto;">
    
    <!-- 이미지 -->
    <div class="center-container">
        <img src="${pageContext.request.contextPath}/resources/images/header-bg.jpg"
             alt="배너"
             class="header-img">
    </div>

    <!-- 왼쪽 컨테이너 -->
    <div class="left-container">
        <p>왼쪽 컨텐츠</p>
    </div>

   <!-- 오른쪽 컨테이너: 키워드 뉴스 -->
<div class="right-container" style="padding:10px; border:1px solid #ddd; border-radius:5px; background-color:#f9f9f9; margin-top:10px; text-align:left; display:block;">
    <div style="font-weight:bold; margin-bottom:10px; font-size:14px; text-align:center;">
        내 키워드 뉴스
    </div>

    <c:choose>
        <c:when test="${not empty sessionScope.id}">
            <c:if test="${not empty sessionScope.keywordNewsMap}">
                <!-- 키워드 최대 3개 -->
                <c:forEach var="entry" items="${sessionScope.keywordNewsMap}" begin="0" end="2">
                    <div style="margin-bottom:15px; display:block;"> <!-- display:block으로 세로 정렬 -->
                        <strong>키워드: ${entry.key}</strong>
                        <ul style="list-style:none; padding-left:0; margin-top:5px;">
                            <!-- 뉴스 아이템 최대 5개 -->
                            <c:forEach var="item" items="${entry.value}" begin="0" end="3">
                                <li style="margin-bottom:5px;">
                                    <a href="${item.link}" target="_blank" style="text-decoration:none; color:#2980b9;">
                                        <c:out value="${item.title}" escapeXml="false"/>
                                    </a>
                                    <div style="font-size:11px; color:gray;">
                                        ${item.pubDate} | 
                                        <c:out value="${fn:replace(fn:substringAfter(item.link,'//'),'/','')}"/>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:forEach>
            </c:if>

            <c:if test="${empty sessionScope.keywordNewsMap}">
                <div style="margin-top:5px; color:gray; text-align:center;">
                    키워드 뉴스가 없습니다.
                </div>
            </c:if>
        </c:when>

        <c:otherwise>
            <div style="margin-top:5px; color:gray; text-align:center;">
                로그인 후 키워드 뉴스를 확인할 수 있습니다.
            </div>
        </c:otherwise>
    </c:choose>
</div>

</header>
