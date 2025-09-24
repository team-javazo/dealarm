<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
<div class="container mt-5">
<h1>관리자 회원 정보 수정</h1>
	<!-- 관리자 회원 정보 수정 폼 -->
	<form action="${pageContext.request.contextPath}/member/adminupdate_ok" method="post">
		<table class="table table-bordered text-center" style="width: 500px; table-layout: fixed;">
			<tr>
			    <th style="width: 150px;"class="text-center">계정 상태</th>
			    <td>
			        <label>
			            <input type="radio" name="is_active" value="1"
			                <c:if test="${user.is_active == 1}">checked</c:if> >
			            활성화
			        </label>
			        &nbsp;&nbsp;
			        <label>
			            <input type="radio" name="is_active" value="0"
			                <c:if test="${user.is_active != 1}">checked</c:if> >
			            비활성화
			        </label>
			    </td>
			</tr>
			<tr>
			    <th>권한</th>
			    <td>
			        <label>
			            <input type="radio" name="role" value="USER"
			                <c:if test="${user.role == 'USER'}">checked</c:if> >
			            회원
			        </label>
			        &nbsp;&nbsp;
			        <label>
			            <input type="radio" name="role" value="ADMIN"
			                <c:if test="${user.role == 'ADMIN'}">checked</c:if> >
			            관리자
			        </label>
			    </td>
			</tr>
			<tr>
			    <th>알림 수신 여부</th>
			    <td>
			        <label>
			            <input type="radio" name="notification" value="1"
			                <c:if test="${user.notification == 1}">checked</c:if> >
			            동의
			        </label>
			        &nbsp;&nbsp;
			        <label>
			            <input type="radio" name="notification" value="0"
			                <c:if test="${user.notification != 1}">checked</c:if> >
			            동의하지 않음
			        </label>
			    </td>
			</tr>
			<tr>
				<th>이름 :</th>
				<td><input type="text" name="name" value="${user.name}"></td>
			</tr>
			<tr>
				<th>핸드폰 번호</th>
				<td><input type="text" name="phone" value="${user.phone}"></td>
			</tr>
			<tr>
				<th>이메일 :</th>
				<td><input type="email" name="email" value="${user.email}"></td>
			</tr>
			<tr>
				<th>나이 :</th>
				<td><input type="text" name="birth_date" value="${user.birth_date}"></td>
			</tr>
			<tr>
				<th>성별 :</th>
				 <td>
			        <label>
			            <input type="radio" name="gender" value="male"
			                <c:if test="${user.gender == 'male'}">checked</c:if> >
			            남자
			        </label>
			        &nbsp;&nbsp;
			        <label>
			            <input type="radio" name="gender" value="female"
			                <c:if test="${user.gender == 'female'}">checked</c:if> >
			           여자
			        </label>
			    </td>
			</tr>
			<tr>
				<th>지역 :</th>
				<td><input type="text" name="region" value="${user.region}"></td>
			</tr>
			<tr>
				<th>가입일 :</th>
				<td><input type="text" name="created_at" value="${user.created_at}"></td>
			</tr>
			<tr>
					
					<td colspan="2" style="text-align: center;"><input type="hidden" name="id" value="${user.id}"> 
					<button type="button" onclick="location.href='<c:url value="/member/members"/>'">목록으로</button>
					<input type="submit" value="수정">
					<button type="button" onclick="openPwModal()">비밀번호 변경</button>
			</tr>
		</table>
	</form>
		</div>
	<!-- 비밀번호 변경 모달 -->
<div id="changePwModal"
     style="display: none; border: 1px solid #000; padding: 10px; background: #eee;">
  <p><strong>비밀번호를 변경하시겠습니까?</strong></p>

  <input type="hidden" id="changePwUserId" value="${user.id}">

  현재 비밀번호: <input type="password" id="currentPw" required><br><br>
  새 비밀번호: <input type="password" id="newPw" required><br><br>
  새 비밀번호 확인: <input type="password" id="confirmNewPw" required><br><br>

  <button type="button" onclick="closePwModal()">취소</button>
  <button type="button" id="confirmChangePw">변경</button>
</div>

<script>
  function openPwModal() {
    document.getElementById("changePwModal").style.display = "block";
  }

  function closePwModal() {
    document.getElementById("changePwModal").style.display = "none";
    document.getElementById("currentPw").value = "";
    document.getElementById("newPw").value = "";
    document.getElementById("confirmNewPw").value = "";
  }

  document.getElementById("confirmChangePw").addEventListener("click", function () {
    const id = document.getElementById("changePwUserId").value;
    const currentPw = document.getElementById("currentPw").value.trim();
    const newPw = document.getElementById("newPw").value.trim();
    const confirmNewPw = document.getElementById("confirmNewPw").value.trim();

    if (!currentPw || !newPw || !confirmNewPw) {
      alert("모든 항목을 입력해주세요.");
      return;
    }

    if (newPw !== confirmNewPw) {
      alert("새 비밀번호가 일치하지 않습니다.");
      return;
    }

    // JSON → Form 방식으로 변경
    const formData = new URLSearchParams();
    formData.append("id", id);
    formData.append("currentPw", currentPw);
    formData.append("newPw", newPw);

    fetch("${pageContext.request.contextPath}/member/change-password", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: formData
    })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        alert("비밀번호가 성공적으로 변경되었습니다.");
        closePwModal();
      } else {
        alert("현재 비밀번호가 올바르지 않습니다.");
      }
    })
    .catch(err => {
      console.error("에러 발생:", err);
      alert("서버 오류가 발생했습니다.");
    });
  });
</script>

</body>
</html>