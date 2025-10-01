<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="ko"> <!-- 언어를 명시적으로 설정해주는 것이 좋습니다. -->
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>홈 화면</title>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
    <!-- ✅ jQuery + Bootstrap CDN -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <!-- 상단 네비게이션 (상단 메뉴) -->
    <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

    <div class="d-flex">
        <!-- 왼쪽 네비게이션 -->
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
        <div class="flex-grow-1">
            <!-- 헤더 부분 -->
            <%@ include file="/WEB-INF/views/include/header.jsp"%>
            <!-- 주요 섹션 -->
            <%@ include file="/WEB-INF/views/include/section.jsp"%>
            <!-- 하단 푸터 -->
            <%@ include file="/WEB-INF/views/include/footer.jsp"%>
        </div>
    </div>
</body>
</html>
