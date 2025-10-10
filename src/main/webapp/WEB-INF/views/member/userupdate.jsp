<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보</title>
<!-- Bootstrap CSS/JS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/styles.css"
	rel="stylesheet" />

</head>
<body
	style="margin: 0; padding: 0; display: flex; flex-direction: column; height: 100vh;">



	<%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

	<div class="d-flex">
		<%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
		<div class="flex-grow-1">
			<%@ include file="/WEB-INF/views/include/banner.jsp"%>
			<!-- =================[내용추가할 부분]============ -->

			<!-- 회원 정보 수정 폼 -->
			<div class="container mt-5">
				<div class="card shadow-sm"
					style="max-width: 600px; margin: 0 auto;">
					<div class="card-body">
						<h2 class="card-title text-center mb-4">내 정보 수정</h2>

						<form
							action="${pageContext.request.contextPath}/member/userupdate"
							method="post">
							<table class="table table-bordered align-middle text-center">
								<tr>
									<th style="width: 150px;">이름</th>
									<td><input type="text" class="form-control" name="name"
										value="${user.name}" disabled></td>
								</tr>
								<tr>
									<th>번호</th>
									<td><input type="text" class="form-control" name="phone"
										value="${user.phone}"></td>
								</tr>
								<tr>
									<th>이메일</th>
									<td><input type="email" class="form-control" name="email"
										value="${user.email}"></td>
								</tr>
								<tr>
									<th>나이</th>
									<td><input type="text" class="form-control"
										name="birth_date" value="${user.birth_date}" disabled></td>
								</tr>
								<tr>
									<th>성별</th>
									<td><c:if test="${user.gender eq 'male'}">
											<input type="text" class="form-control" value="남자" disabled>
											<input type="hidden" name="gender" value="male">
										</c:if> <c:if test="${user.gender eq 'female'}">
											<input type="text" class="form-control" value="여자" disabled>
											<input type="hidden" name="gender" value="female">
										</c:if></td>
								</tr>
								<tr>
									<th>지역</th>
									<td><input type="text" class="form-control" name="region"
										value="${user.region}"></td>
								</tr>
								<tr>
									<th>알림 수신 여부</th>
									<td>
										<div class="form-check form-check-inline">
											<input type="radio" class="form-check-input"
												name="notification" value="1"
												<c:if test="${user.notification == 1}">checked</c:if>>
											<label class="form-check-label">동의</label>
										</div>
										<div class="form-check form-check-inline">
											<input type="radio" class="form-check-input"
												name="notification" value="0"
												<c:if test="${user.notification != 1}">checked</c:if>>
											<label class="form-check-label">동의하지 않음</label>
										</div>
									</td>
								</tr>
							</table>

							<input type="hidden" name="id" value="${user.id}">

							<!-- 버튼 영역 -->
							<div class="d-flex justify-content-between mt-4">
								<button type="submit" class="btn btn-primary">수정</button>
								<button type="button" class="btn btn-warning"
									onclick="openPwModal()">비밀번호 변경</button>
								<button type="button" class="btn btn-danger"
									onclick="openModal()">탈퇴</button>
								<button type="button" class="btn btn-secondary"
									onclick="location.href='<c:url value="/main"/>'">홈으로</button>
							</div>
						</form>
					</div>
				</div>
			</div>


			<!-- ============================= -->
			<%@ include file="/WEB-INF/views/include/footer.jsp"%>
		</div>
	</div>
	<br>

<!-- 탈퇴 모달 -->
<div class="modal fade" id="deleteModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      
      <div class="modal-header">
        <h5 class="modal-title">회원 탈퇴</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <p class="mb-3"><strong>정말로 탈퇴하시겠습니까?</strong></p>
        <input type="hidden" id="deleteid" value="${user.id}">
        <input type="password" class="form-control" id="deletePw" placeholder="비밀번호 입력" required>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-danger" id="confirmDelete">탈퇴</button>
      </div>

    </div>
  </div>
</div>

<script>
  // Bootstrap Modal 객체 생성
  const deleteModal = new bootstrap.Modal(document.getElementById("deleteModal"));

  function openModal() {
    deleteModal.show();
  }

  function closeModal() {
    deleteModal.hide();
    document.getElementById("deletePw").value = "";
  }

  document.getElementById("confirmDelete").addEventListener("click", function () {
    const id = document.getElementById("deleteid").value;
    const password = document.getElementById("deletePw").value.trim();

    if (!password) {
      alert("비밀번호를 입력해주세요.");
      return;
    }

    fetch("${pageContext.request.contextPath}/member/delete", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ id: id, password: password })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert(data.message);
        location.href = "${pageContext.request.contextPath}/member/logout";
      } else {
        alert("비밀번호가 일치하지 않습니다.");
      }
    })
    .catch(error => {
      console.error("에러 발생:", error);
      alert("서버 오류가 발생했습니다.");
    });
  });
</script>

<!-- 비밀번호 변경 모달 -->
<div class="modal fade" id="changePwModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      
      <div class="modal-header">
        <h5 class="modal-title">비밀번호 변경</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <p class="mb-3"><strong>비밀번호를 변경하시겠습니까?</strong></p>

        <input type="hidden" id="changePwUserId" value="${user.id}">

        <div class="mb-3">
          <label for="currentPw" class="form-label">현재 비밀번호</label>
          <input type="password" class="form-control" id="currentPw" required>
        </div>

        <div class="mb-3">
          <label for="newPw" class="form-label">새 비밀번호</label>
          <input type="password" class="form-control" id="newPw" required>
        </div>

        <div class="mb-3">
          <label for="confirmNewPw" class="form-label">새 비밀번호 확인</label>
          <input type="password" class="form-control" id="confirmNewPw" required>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" id="confirmChangePw">변경</button>
      </div>

    </div>
  </div>
</div>

<script>
  // Bootstrap Modal 객체 생성
  const changePwModal = new bootstrap.Modal(document.getElementById("changePwModal"));

  function openPwModal() {
    changePwModal.show();
  }

  function closePwModal() {
    changePwModal.hide();
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
