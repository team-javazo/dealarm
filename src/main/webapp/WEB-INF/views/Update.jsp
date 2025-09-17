<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
				<td><input type="text" name="name" value="${user.name}"	readonly></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="text" name="email" value="${user.email}"></td>
			</tr>
			<tr>
				<th>나이</th>
				<td><input type="text" name="birth_date" value="${user.birth_date}" readonly></td>
			</tr>
			<tr>
				<th>성별</th>
				<td><input type="text" name="gender" value="${user.gender}"	readonly></td>
			</tr>
			<tr>
				<th>지역</th>
				<td><input type="text" name="region" value="${user.region}"></td>
			</tr>
			<tr>
				<td colspan="2" style="text-align: center;"><input
					type="hidden" name="id" value="${user.id}"> <input
					type="submit" value="수정">
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
	<%
	} else {
	%>
	<!-- 관리자 회원 정보 수정 폼 -->
	<form action="/adminupdate" method="post">
		<table border="1" style="margin-bottom: 20px;">
			<tr>
				<th>계정 상태 :</th>
				<td><input type="text" name="is_activeCheck" value="${user.is_activeCheck}" ></td>
			</tr>
			<tr>
				<th>이름 :</th>
				<td><input type="text" name="name" value="${user.name}" ></td>
			</tr>
			<tr>
				<th>이메일 :</th>
				<td><input type="text" name="email" value="${user.email}"></td>
			</tr>
			<tr>
				<th>나이 :</th>
				<td><input type="text" name="birth_date" value="${user.birth_date}"></td>
			</tr>
			<tr>
				<th>성별 :</th>
				<td><input type="text" name="gender" value="${user.gender}"></td>
			</tr>
			<tr>
				<th>지역 :</th>
				<td><input type="text" name="region" value="${user.region}"></td>
			</tr>
			<tr>
				<th>권한 :</th>
				<td><input type="text" name="role" value="${user.role}"></td>
			</tr>
			<tr>
				<th>가입일 :</th>
				<td><input type="text" name="created_at" value="${user.created_at}"></td>
			</tr>
			<tr>
				<td colspan="2" style="text-align: center;"><input type="hidden" name="id" value="${project.id}">
					<button type="submit" class="btn btn-success">수정</button>
			</tr>
		</table>
	</form>
	<%
	}
	%>

</body>
</html>
