<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true"%>
<html>
<head>
<title>Home</title>
</head>
<body>
	<h1>홈 화면</h1>

	<!-- 로그인 여부에 따라 다른 화면 출력 -->
	<c:choose>
		<c:when test="${empty sessionScope.id}">
			<a href="<c:url value='/member/join'/>">회원가입</a> |
        <a href="<c:url value='/member/login'/>">로그인</a>
		</c:when>
		<c:when test="${sessionScope.role eq 'ADMIN'}">
			<p>
				<b>${sessionScope.role}</b> 님, 환영합니다!
			</p>
			<a href="<c:url value='/member/members'/>">회원목록</a>
			<a href="<c:url value='/member/logout'/>">로그아웃</a>
			<a href="<c:url value='/member/mypage'/>">마이페이지</a>

		</c:when>
		<c:otherwise>
			<p>
				<b>${sessionScope.name}</b> 님, 환영합니다!
			</p>
			<a href="<c:url value='/member/logout'/>">로그아웃</a>
			<a href="<c:url value='/member/mypage'/>">마이페이지</a>
			<h3>키워드 등록</h3>
			<form action="<c:url value='/keywords/add'/>" method="post">
				<input type="hidden" name="userId" value="${sessionScope.id}" /> <input
					type="text" name="keyword" placeholder="키워드 입력" required />
				<button type="submit">추가</button>
			</form>

			<h3>내 키워드 목록</h3>
			<table border="1">
				<tr>
					<th>ID</th>
					<th>키워드</th>
					<th>등록일</th>
					<th>삭제</th>
				</tr>
				<c:forEach var="k" items="${keywords}">
					<tr>
						<td>${k.userId}</td>
						<td>${k.keyword}</td>
						<td>${k.createdAt}</td>
						<td>
							<form action="<c:url value='/keywords/delete/${k.num}'/>"
								method="post">
								<button type="submit">삭제</button>
							</form>
						</td>
					</tr>
				</c:forEach>
			</table>
			<hr>
		</c:otherwise>
	</c:choose>

	<hr>
	<p>서버 시간: ${serverTime}</p>

</body>
</html>