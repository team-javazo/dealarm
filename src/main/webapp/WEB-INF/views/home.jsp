<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<html>
<head>
    <title>Home</title>
</head>
<body>
    <h1>홈 화면</h1>

    <!-- 로그인 여부에 따라 다른 화면 출력 -->
    <c:choose>
    <c:when test="${empty sessionScope.id}">
        <a href="<c:url value='/member/join'/>">회원가입</a>
        <a href="<c:url value='/member/login'/>">로그인</a>
    </c:when>
    <c:when test="${sessionScope.role eq 'ADMIN'}">
            <p><b>${sessionScope.role}</b> 님, 환영합니다!</p>
        <a href="<c:url value='/member/members'/>">회원목록</a>
        <a href="<c:url value='/member/logout'/>">로그아웃</a>
        <a href="<c:url value='/member/mypage'/>">마이페이지</a>
    </c:when>
	<c:when test="${sessionScope.is_active == 0}">
        <button type="button" onclick="openModal()">계정 활성화</button>

	<div id="activeModal"
		style="display: none; border: 1px solid #000; padding: 10px; background: #eee;">
		<p>
			<strong>계정활성화 시키시겠습니까?</strong> 비밀번호를 입력해주세요.
		</p>

		<input type="hidden" id="activeid" value="${sessionScope.id}">
		비밀번호: <input type="password" id="activePw" required><br>
		<br>

		<button type="button" onclick="closeModal()">취소</button>
		<button type="button" id="confirmactive">활성화</button>
	</div>

<script>
  function openModal() {
    document.getElementById("activeModal").style.display = "block";
  }

  function closeModal() {
    document.getElementById("activeModal").style.display = "none";
    document.getElementById("activePw").value = "";
  }

  document.getElementById("confirmactive").addEventListener("click", function () {
    const id = document.getElementById("activeid").value;
    const password = document.getElementById("activePw").value.trim();

    if (!password) {
      alert("비밀번호를 입력해주세요.");
      return;
    }

    fetch("${pageContext.request.contextPath}/member/active", {
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
    </c:when>
    <c:otherwise>
        <p><b>${sessionScope.name}</b> 님, 환영합니다!</p>
        <a href="<c:url value='/member/logout'/>">로그아웃</a>
        <a href="<c:url value='/member/mypage'/>">마이페이지</a>
    </c:otherwise>
</c:choose>

    <hr>
    <p>서버 시간: ${serverTime}</p>

</body>
</html>