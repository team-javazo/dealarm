<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>
	<!-- 로그인세션확인 (일단 비활성화) -->
	<script>
		var loginUser = "${sessionScope.loginUser}";
		if(loginUser == null){
			alert("로그인이 필요합니다");
			location.href = "/login";
		}
	</script>
 


	<div class="sectionContainer">
		<h1>마이페이지</h1>
		<form action="${pageContext.request.contextPath}/mypage" method="post">
			<table class="user-table">
				<tr><td>아이디</td><td>${user.id}</td></tr>
<!-- 			<tr><td>비밀번호</td><td>${loginUser.password}</td></tr>  	-->
				<tr><td>이름</td>	<td>${user.name}</td></tr>
				<tr><td>전화번호</td><td>${user.phone}</td></tr>
				<tr><td>이메일</td><td>${user.email}</td></tr>
				<tr><td>생년월일</td><td>${user.birth_date}</td>	</tr>
				<tr><td>성별</td>	<td>${user.gender}</td></tr>
<!-- 			<tr><td>알림수신여부</td><td>${user.notification}</td></tr>   -->	
				<tr>
		            <td>알림 수신 여부</td>
		            <c:choose>
		               <c:when test="${user.notification == 1}">
		                  <td>동의</td>
		               </c:when>
		               <c:otherwise>
		                  <td>거부</td>
		               </c:otherwise>
		            </c:choose>
		         </tr>

				<tr><td>지역</td>	<td>${user.region}</td></tr>
<!--			<tr><td>권한</td>	<td>${user.role}</td></tr>		-->
<!--			<tr><td>계정상태</td><td>${user.is_active}</td></tr>		-->
				<tr><td>가입일</td><td>${user.created_at}</td></tr>
			</table>

			<div class="mt-3">
				<button type="submit" class="btn btn-primary">수정</button>
				<button type="button" class="btn btn-secondary" onclick="history.back()">이전페이지</button>
			</div>
		</form>
	</div>



</body>
</html>