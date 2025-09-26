<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<html>
<head>

<meta charset="utf-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<title>홈 화면</title>
<!-- Favicon-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!--    <link rel="icon" type="image/x-icon" href="assets/favicon.ico" /> -->
<!-- Bootstrap icons-->
<!--    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />   -->
<!-- Core theme CSS (includes Bootstrap)-->
<link href="${pageContext.request.contextPath}/resources/css/styles.css"
	rel="stylesheet" />

</head>

<body>
	<!-- =======================[바디시작]================================ -->
	<div class="homeView">
		<div class="homeText">
			<h1>환영합니다!</h1>
			<p>빠르고 편리한 할인 정보, 당신을 위한 실시간 쇼핑 파트너.</p>
		</div>

		<div class="homeButton">
			<a href="<c:url value='/main'/>">메인 페이지로 이동(클릭)</a>
		</div>
		<p id="autoRedirectMsg" style="margin-top: 10px; color: white;"></p>
	</div>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>|

	<!-- =================== [메인 영역 시작]==================================-->
	<script>
		let countdown = 7;
		const msg = document.getElementById('autoRedirectMsg');

		const timer = setInterval(function() {
			msg.textContent = countdown + '초 후 자동으로 메인 페이지로 이동합니다.';
			countdown--;

			if (countdown < 0) {
				clearInterval(timer);
				window.location.href = '<c:url value="/main"/>';
			}
		}, 1000);
	</script>
</body>
</html>