<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

    <!-- 오른쪽 컨테이너 -->
    <div class="right-container">
        <p>우측 컨텐츠</p>
    </div>

</header>