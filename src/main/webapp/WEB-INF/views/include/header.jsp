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
<div class="right-container" 
     style="border:1px solid #ddd; border-radius:5px; background-color:#f9f9f9; text-align:left; display:block; clear:both;">

    <!-- 로그인 여부에 따라 타이틀 변경 -->
    <div style="font-weight:bold; margin-bottom:10px; font-size:14px; text-align:center;">
        <c:choose>
            	<c:when test="${not empty sessionScope.id}">
                키워드 뉴스
            </c:when>
            <c:otherwise>
                최신 뉴스
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${not empty sessionScope.latestNews}">
        <!-- 스크롤 영역 -->
        <div style="max-height:250px; overflow-y:auto; padding-right:5px;">
            <ul style="list-style:none; padding-left:0; margin-top:0;">
                <c:forEach var="item" items="${sessionScope.latestNews}">
                    <li style="margin-bottom:5px;">
                        <a href="${item.link}" target="_blank" style="text-decoration:none; color:blue; font-size:14px;">
                            <c:out value="${item.title}" escapeXml="false"/>
                        </a>
                        <div style="font-size:11px; color:gray;">
                            ${item.pubDate} | 키워드: <span style="font-weight:bold; color:black;">${item.keyword}</span>
                        </div>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <c:if test="${empty sessionScope.latestNews}">
        <div style="margin-top:5px; color:gray; text-align:center;">
            최신 뉴스가 없습니다.
        </div>
    </c:if>
</div>
</header>
