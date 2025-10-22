<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<header style="position: relative; max-width: 1220px; margin: 0 auto;">

	<!-- 중앙 배너 이미지 -->
	<div class="center-container">
		<img
			src="${pageContext.request.contextPath}/resources/images/header-bg.jpg"
			alt="배너" class="header-img">
	</div>

	<!-- 왼쪽 인기 순위 영역 -->
	<div class="p-3 bg-white border rounded mb-3"
	style="width: 25%; height: 250px; overflow-y: auto;">
	<h6 class="fw-bold">인기 키워드</h6>

	<ol id="trendResultSidebar"
		class="list-group list-group-numbered small"></ol>
</div>


	<!-- 오른쪽 뉴스 영역 -->
	<div class="right-container"
		style="padding: 10px; border: 1px solid #ddd; border-radius: 5px; background-color: #f9f9f9; text-align: left; display: block; clear: both;">

		<!-- 로그인 여부에 따라 타이틀 변경 -->
		<div
			style="font-weight: bold; margin-bottom: 10px; font-size: 14px; text-align: center;">
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
			<div style="max-height: 745px; overflow-y: auto; padding-right: 5px;">
				<ul style="list-style: none; padding-left: 0; margin-top: 0;">
					<c:forEach var="item" items="${sessionScope.latestNews}">
						<li style="margin-bottom: 5px;">
							<!-- 뉴스 제목 --> <a href="${item.link}" target="_blank"
							style="text-decoration: none; color: blue; font-size: 14px;">
								<c:out value="${item.title}" escapeXml="false" />
						</a> <!-- 날짜 + 키워드 -->
							<div style="font-size: 11px; color: gray;">
								${fn:replace(item.pubDate, '+0900', '')} | 키워드: <span
									style="font-weight: bold; color: black;">${item.keyword}</span>
							</div>
						</li>
					</c:forEach>
				</ul>
			</div>
		</c:if>

		<c:if test="${empty sessionScope.latestNews}">
			<div style="margin-top: 5px; color: gray; text-align: center;">
				최신 뉴스가 없습니다.</div>
		</c:if>
	</div>

</header>
