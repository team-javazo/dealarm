<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보</title>
</head>
<body>

	<!-- 회원 정보 수정 폼 -->
	<%
	if (session.getAttribute("role").equals("admin")) {
	%>
	<form action="/userupdate" method="post">
		<table border="1">
			<tr>
				<th>이름</th>
				<td><input type="text" name="name" value="${user.name}"
					readonly></td>
			</tr>
			<tr>
				<th>번호</th>
				<td><input type="text" name="phone" value="${user.phone}"></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="email" name="email" value="${user.email}"></td>
			</tr>
			<tr>
				<th>나이</th>
				<td><input type="text" name="birth_date" value="${user.birth_date}" readonly></td>
			</tr>

			<tr>
				<th>성별</th>
				<td><input type="text" name="gender" value="${user.gender}"
					readonly></td>
			</tr>
			<tr>
				<th>지역</th>
				<td><input type="text" name="region" value="${user.region}"></td>
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
				<td colspan="2" style="text-align: center;"><input
					type="hidden" name="id" value="${user.id}"> <input
					type="submit" value="수정">
					<button type="button" onclick="openPwModal()">비밀번호 변경</button>
					<button type="button" onclick="openModal()">탈퇴</button></td>
			</tr>
		</table>
	</form>

	<br>

	<!-- 탈퇴 모달 -->
	<div id="deleteModal"
		style="display: none; border: 1px solid #000; padding: 10px; background: #eee;">
		<p>
			<strong>정말로 탈퇴하시겠습니까?</strong> 비밀번호를 입력해주세요.
		</p>

		<input type="hidden" id="deleteEmpno" value="${user.id}">
		비밀번호: <input type="password" id="deletePw" required><br>
		<br>

		<button type="button" onclick="closeModal()">취소</button>
		<button type="button" id="confirmDelete">탈퇴</button>
	</div>

	<script>
  function openModal() {
    document.getElementById("deleteModal").style.display = "block";
  }

  function closeModal() {
    document.getElementById("deleteModal").style.display = "none";
    document.getElementById("deletePw").value = "";
  }

  document.getElementById("confirmDelete").addEventListener("click", function () {
    const id = document.getElementById("deleteEmpno").value;
    const password = document.getElementById("deletePw").value.trim();

    if (!password) {
      alert("비밀번호를 입력해주세요.");
      return;
    }

    fetch("/user/delete", { //@PostMapping("/user/delete") 생성해야한다요
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ id, password })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert("회원 탈퇴가 완료되었습니다.");
        location.href = "/logout";
      } else {
        alert(data.message || "비밀번호가 일치하지 않습니다.");
      }
    })
    .catch(error => {
      console.error("에러 발생:", error);
      alert("서버 오류가 발생했습니다.");
    });
  });
</script>
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

    fetch("/user/change-password", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ id, currentPw, newPw })
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          alert("비밀번호가 성공적으로 변경되었습니다.");
          closePwModal();
        } else {
          alert(data.message || "현재 비밀번호가 올바르지 않습니다.");
        }
      })
      .catch(err => {
        console.error("에러 발생:", err);
        alert("서버 오류가 발생했습니다.");
      });
  });
</script>
	<%
	} else {
	%>
	
	<%
	}
	%>

</body>
</html>
