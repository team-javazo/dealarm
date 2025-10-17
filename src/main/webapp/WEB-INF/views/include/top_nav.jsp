<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Top 네비</title>
	<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
	<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/resources/images/icon.jpg" />
</head>
<body style="margin:0; padding:0; display: flex; flex-direction: column; height: 100vh;">
    
    
 <!-- TopNavigation-->
        <nav class="navbar navbar-expand-lg navbar-light bg-light"
        			style="position: relative; z-index:9999;">
            <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/">Home</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
                
                
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                	<!--  왼쪽메뉴 -->
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                        <li class="nav-item"><a class="nav-link active" aria-current="page" href="${pageContext.request.contextPath}/main">Main</a></li>
 <!-- 
                        <li class="nav-item"><a class="nav-link" href="#!">About</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Shop</a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="#!">드롭다운메뉴</a></li>
                                <li><hr class="dropdown-divider" /></li>
                                <li><a class="dropdown-item" href="#!">Popular Items</a></li>
                                <li><a class="dropdown-item" href="#!">New Arrivals</a></li>
                            </ul>
                        </li>
 -->                    
                    </ul>
                    <!-- 오른쪽 메뉴 -->
                    <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    	<c:choose>
                    		<c:when test="${empty sessionScope.id}">
                            	<li class="nav-item">
                            		<a class="nav-link" href="<c:url value='/member/login'/>">로그인</a>
                            	</li>
		                    	<li class="nav-item">
		                    		<a class="nav-link" href="<c:url value='/member/join'/>">회원가입</a>
		                    	</li>
		                 	</c:when>
		                 	
						    <c:when test="${sessionScope.is_active == 0}">
						        <li class="nav-item d-flex align-items-center">
					                <button class="btn btn-warning nav-link" type="button" onclick="openModal()">계정 활성화</button>
					            </li>
					            <li class="nav-item d-flex align-items-center">
					                <a class="nav-link" href="<c:url value='/member/logout'/>">로그아웃</a>
					            </li>
					        </c:when>
	
		                 	<c:when test="${sessionScope.role eq 'ADMIN'}">
		                 		<li class="nav-item d-flex align-items-center">
		                 			<span class="navbar-text me-2"><b>${sessionScope.id}</b>&nbsp;관리자 계정으로 로그인하였습니다</span>
		                 		</li>
		                 	
		                 		<li class="nav-item dropdown">
		                            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">관리자메뉴</a>
		                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
		                                <li><a class="dropdown-item" href="<c:url value='/member/members'/>">회원관리</a></li>
		                                <li><a class="dropdown-item" href="<c:url value='/stats'/>">통계</a></li>
<!--  	                                <li><a class="dropdown-item" href="#!">New Arrivals</a></li>   -->
		                              
		                                <li><hr class="dropdown-divider" /></li>
		                            </ul>
		                        </li>
		                 		
		                 		
		                 		
		                 		

		                 		<li class="nav-item d-flex align-items-center">
					                <a class="nav-link" href="<c:url value='/member/mypage'/>">마이페이지</a>
					            </li>
					            <li class="nav-item d-flex align-items-center">
					                <a class="nav-link" href="<c:url value='/member/logout'/>">로그아웃</a>
					            </li>
		                 	</c:when>

		                 	<c:otherwise>
								<li class="nav-item d-flex align-items-center">
									<span class="navbar-text me-2 "><b>${sessionScope.id}</b>&nbsp;님, 환영합니다!</span>
								</li>
		                 		<li class="nav-item d-flex align-items-center">
		                 			<a class="nav-link" href="<c:url value='/member/mypage'/>">마이페이지</a>
		                 		</li>		                 	
		                 		<li class="nav-item d-flex align-items-center">
		                 			<a class="nav-link" href="<c:url value='/member/logout'/>">로그아웃</a>
		                 		</li>
		                 				                 	
		                 	</c:otherwise>
					    </c:choose>
		                 
						<!-- 
						<li class="nav-item d-flex align-items-center">
				            <form class="d-flex align-items-center mb-0">
		                        <button class="btn btn-outline-dark" type="submit">
		                            <i class="bi-cart-fill me-1"></i>
		                            관심상품
		                            <span class="badge bg-dark text-white ms-1 rounded-pill">0</span>
		                        </button>
		                    </form>
		                </li>
		                 --> 
		                
		                  
	                </ul>   
                </div>
            </div>
        </nav>
        
        
        
<!-- 계정 활성화 모달 -->
<div id="activeModal"
     style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%);
            background:#fff; border:2px solid #000; padding:20px; z-index:2000; width:320px;">
    <h5 style="margin-bottom:15px;">계정을 활성화하시겠습니까?</h5>
    <input type="hidden" id="activeid" value="${sessionScope.id}">
    
    <label for="activePw"><b>비밀번호 입력</b></label>
    <input type="password" id="activePw"
           style="width:100%; padding:8px; margin-top:5px; margin-bottom:15px; border:1px solid #ccc;">
    
    <div style="text-align:right;">
        <button id="confirmactive" class="btn btn-primary" style="margin-right:5px;">확인</button>
        <button onclick="closeModal()" class="btn btn-secondary">취소</button>
    </div>
</div>

<!-- Bootstrap JS Bundle (Popper 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
        crossorigin="anonymous"></script>

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
        
</body>
</html>        
        