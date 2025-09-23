<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>회원가입</title>
<style>
        .toast {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background-color: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            z-index: 10000;
            display: none;
        }
    </style>
</head>
<body>

    <!-- Toast 알림 -->
    <div id="toast" class="toast">
        <p id="toastMessage"></p>
    </div>
	<h2>회원가입</h2>

	<form action="${pageContext.request.contextPath}/member/join"
		method="post">
		<!-- 아이디 입력 필드 -->
		아이디: <input type="text" name="id"
			value="${member.id != null ? member.id : ''}" required><br>

		<!-- 비밀번호 입력 필드 -->
		비밀번호: <input type="password" name="password"
			value="${member.password != null ? member.password : ''}" required><br>

		<!-- 이름 입력 필드 -->
		이름: <input type="text" name="name"
			value="${member.name != null ? member.name : ''}" required><br>

		<!-- 휴대폰 번호 입력 필드 -->
		휴대폰 번호: <input type="text" name="phone"
			value="${member.phone != null ? member.phone : ''}" required><br>

		<!-- 이메일 입력 필드 -->
		이메일: <input type="email" name="email"
			value="${member.email != null ? member.email : ''}"><br>

		<!-- 생년월일 입력 필드 -->
		생년월일: <input type="date" name="birth_date"
			value="${member.birth_date != null ? member.birth_date : ''}"><br>

		<!-- 성별 입력 필드 -->
		성별: <input type="text" name="gender"
			value="${member.gender != null ? member.gender : ''}"><br>

		<!-- 수신동의 입력 필드 -->
		수신동의: <input type="int" name="notification"
			value="${member.notification != null ? member.notification : ''}"><br>

		<!-- 지역 입력 필드 -->
		지역: <input type="text" name="region"
			value="${member.region != null ? member.region : ''}"><br>

		<button type="submit">가입하기</button>
	</form>

<script>
        function showToast(message) {
            const toast = document.getElementById('toast');
            const messageElement = document.getElementById('toastMessage');
            messageElement.textContent = message;
            toast.style.display = 'block';
            setTimeout(function() {
                toast.style.display = 'none';
            }, 3000);
        }

        // 페이지 로드 시, 서버로부터 전달된 errorMessage를 이용해 Toast 알림을 띄움
        window.onload = function() {
            const errorMessage = "${errorMessage}"; // 모델에서 받아온 메시지
            if (errorMessage) {
                showToast(errorMessage);
            }
        };
    </script>
</body>
</html>