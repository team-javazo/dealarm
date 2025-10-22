<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta charset="utf-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>회원 수정</title>

<!-- Favicon-->
<!--   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">		 -->
<!--    <link rel="icon" type="image/x-icon" href="assets/favicon.ico" /> -->
<!-- Bootstrap icons-->
<!--    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />   -->
<!-- Core theme CSS (includes Bootstrap)-->
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
			<!-- =================[로그인페이지]============ -->

			<div class="container d-flex justify-content-center mt-5">
			    <div class="card shadow-sm" style="width: 500px;">
			        <div class="card-body">
			            <h2 class="card-title text-center mb-4">관리자 회원 정보 수정</h2>
			
			            <form action="${pageContext.request.contextPath}/member/adminupdate_ok" method="post">
			
			                <!-- 계정 상태 -->
			                <div class="mb-3">
			                    <label class="form-label">계정 상태</label><br/>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="is_active" value="1" 
			                            <c:if test="${user.is_active == 1}">checked</c:if>>
			                        <label class="form-check-label">활성화</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="is_active" value="0"
			                            <c:if test="${user.is_active != 1}">checked</c:if>>
			                        <label class="form-check-label">비활성화</label>
			                    </div>
			                </div>
			
			                <!-- 권한 -->
			                <div class="mb-3">
			                    <label class="form-label">권한</label><br/>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="role" value="USER"
			                            <c:if test="${user.role == 'USER'}">checked</c:if>>
			                        <label class="form-check-label">회원</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="role" value="ADMIN"
			                            <c:if test="${user.role == 'ADMIN'}">checked</c:if>>
			                        <label class="form-check-label">관리자</label>
			                    </div>
			                </div>
			
			                <!-- 알림 수신 여부 -->
			                <div class="mb-3">
			                    <label class="form-label">알림 수신 여부</label><br/>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="notification" value="1"
			                            <c:if test="${user.notification == 1}">checked</c:if>>
			                        <label class="form-check-label">동의</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="notification" value="0"
			                            <c:if test="${user.notification != 1}">checked</c:if>>
			                        <label class="form-check-label">동의하지 않음</label>
			                    </div>
			                </div>
			
			                <!-- 텍스트 입력 필드 -->
			                <div class="mb-3">
			                    <label for="name" class="form-label">이름</label>
			                    <input type="text" class="form-control" id="name" name="name" value="${user.name}">
			                </div>
			
			                <div class="mb-3">
			                    <label for="phone" class="form-label">핸드폰 번호</label>
			                    <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
			                </div>
			
			                <div class="mb-3">
			                    <label for="email" class="form-label">이메일</label>
			                    <input type="email" class="form-control" id="email" name="email" value="${user.email}">
			                </div>
			
			                <div class="mb-3">
			                    <label for="birth_date" class="form-label">나이</label>
			                    <input type="text" class="form-control" id="birth_date" name="birth_date" value="${user.birth_date}">
			                </div>
			
			                <div class="mb-3">
			                    <label for="gender" class="form-label">성별</label><br>						
									<div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="gender" value="male"
			                            <c:if test="${user.gender == 'male'}">checked</c:if>>
			                        <label class="form-check-label">남자</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="gender" value="female"
			                            <c:if test="${user.gender == 'female'}">checked</c:if>>
			                        <label class="form-check-label">여자</label>
			                    </div>
			                </div>
			
			                <div class="mb-3">
			                    <label for="region" class="form-label">지역</label>
			                    <input type="text" class="form-control" id="region" name="region" value="${user.region}">
			                </div>
			
			                <div class="mb-3">
			                    <label for="created_at" class="form-label">가입일</label>
			                    <input type="text" class="form-control" id="created_at" name="created_at" value="${user.created_at}">
			                </div>
			
			                <input type="hidden" name="id" value="${user.id}">
			
			                <!-- 버튼 -->
			                <div class="d-flex justify-content-between">
			                    <button type="button" class="btn btn-secondary" onclick="location.href='<c:url value="/member/members"/>'">목록으로</button>
			                    <input type="submit" class="btn btn-primary" value="수정">
			                    <button type="button" class="btn btn-warning" onclick="openPwModal()">비밀번호 변경</button>
			                </div>
			
			            </form>
			        </div>
			    </div>
			</div>
			
			
<!-- 비밀번호 변경 모달 -->
<div class="modal fade" id="changePwModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">비밀번호 변경</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <p class="text-center"><strong>비밀번호를 변경하시겠습니까?</strong></p>

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

			<!-- =================[로그인페이지 end]============ -->
			<%@ include file="/WEB-INF/views/include/footer.jsp"%>
		</div>
	</div>

<script>
  // 모달 객체 전역 생성
  const pwModal = new bootstrap.Modal(document.getElementById("changePwModal"));

  function openPwModal() {
    pwModal.show(); // 부트스트랩 모달 열기
  }

  function closePwModal() {
    pwModal.hide(); // 부트스트랩 모달 닫기
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