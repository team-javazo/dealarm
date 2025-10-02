<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
<title>회원가입</title>
        <!-- Favicon-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!--    <link rel="icon" type="image/x-icon" href="assets/favicon.ico" /> -->
        <!-- Bootstrap icons-->
<!--    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />   --> 
        <!-- Core theme CSS (includes Bootstrap)-->
		<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />


</head>
<body style="margin:0; padding:0; display: flex; flex-direction: column; height: 100vh;">
 
    <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

    <div class="d-flex">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
        <div class="flex-grow-1">
            <%@ include file="/WEB-INF/views/include/banner.jsp"%>
            
            
            <!-- =================[로그인페이지]============ -->
            
			 <div class="container" style="max-width: 500px; margin-top: 0px;">
			    <div class="card shadow-sm">
			        <div class="card-body">
			            <h2 class="card-title mb-4 text-center">회원가입</h2>
			
			            <form action="${pageContext.request.contextPath}/member/join" method="post">
			                <div class="mb-3">
			                    <label for="id" class="form-label">아이디</label>
			                    <input type="text" class="form-control" id="id" name="id" required>
			                </div>
			
			                <div class="mb-3">
			                    <label for="password" class="form-label">비밀번호</label>
			                    <input type="password" class="form-control" id="password" name="password" required>
			                </div>
			
			                <div class="mb-3">
			                    <label for="name" class="form-label">이름</label>
			                    <input type="text" class="form-control" id="name" name="name"
			                        value="${name}" required>
			                </div>
			
			                <div class="mb-3">
			                    <label for="phone" class="form-label">휴대폰 번호</label>
			                    <input type="text" class="form-control" id="phone" name="phone"
			                        value="${mobile}" required>
			                </div>
			
			                <div class="mb-3">
			                    <label for="email" class="form-label">이메일</label>
			                    <input type="email" class="form-control" id="email" name="email"
			                        value="${email}">
			                </div>
			
			                <div class="mb-3">
			                    <label for="birth_date" class="form-label">생년월일</label>
			                    <input type="date" class="form-control" id="birth_date" name="birth_date" required>
			                </div>
			
			                <div class="mb-3">

			                    <label for="gender" class="form-label">성별</label><br>						
									<div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="gender" value="male">
			                        <label class="form-check-label">남자</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="gender" value="female">
			                        <label class="form-check-label">여자</label>
			                    </div>
			                </div>


			                <div class="mb-3">
			                    <label for="notification" class="form-label">수신동의</label><br>
			                        <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="notification" value="1" checked>
			                        <label class="form-check-label">동의</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="notification" value="0">
			                        <label class="form-check-label">동의하지 않음</label>
			                    </div>
			                </div>
			
			                <div class="mb-3">
			                    <label for="region" class="form-label">지역</label>
			                    <input type="text" class="form-control" id="region" name="region"
			                        value="${member.region != null ? member.region : ''}">
			                </div>
			
			                <button type="submit" class="btn btn-primary w-100">가입하기</button>
			            </form>
			
			        </div>
			    </div>
			</div>
            
            
            
            <!-- =================[로그인페이지 end]============ -->
            <%@ include file="/WEB-INF/views/include/footer.jsp"%>
        </div>
    </div>


</body>
</html>