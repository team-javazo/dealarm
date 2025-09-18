<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 수정</title>
</head>
<body>
<h1>정보 수정</h1>
	<c:forEach var="project" items="${list}">
		<form action="adminupdate" method="post">
			<table border="1" style="margin-bottom: 20px;">
						<tr>
					<th>이름 :</th>
					<td><input type="text" name="name" value="${project.name}"readonly></td>
				</tr>
				<tr>
					<th>이메일 :</th>
					<td><input type="text" name="email" value="${project.email}"></td>
				</tr>
				<tr>
					<th>나이 :</th>
					<td><input type="text" name="birth_date" value="${project.birth_date}"readonly></td>
				</tr>
				<tr>
					<th>성별 :</th>
					<td><input type="text" name="gender" value="${project.gender}"readonly></td>
				</tr>
				<tr>
					<th>지역 :</th>
					<td><input type="text" name="region" value="${project.region}"></td>
				</tr>
				<tr>
					<th>권한 :</th>
					<td><input type="text" name="role" value="${project.role}"></td>
				</tr>
				<tr>
					<th>가입일 :</th>
					<td><input type="text" name="created_at" value="${project.created_at}"></td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center;"><input
						type="hidden" name="id" value="${project.id}">
						<button type="submit" class="btn btn-success">수정</button>
				</tr>
			</table>
		</form>
	</c:forEach>

</body>
</html>