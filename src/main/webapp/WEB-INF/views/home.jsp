<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true"%>
<html>
<head>

        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
    <title>홈 화면</title>
        <!-- Favicon-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        
<!--    <link rel="icon" type="image/x-icon" href="assets/favicon.ico" /> -->
        <!-- Bootstrap icons-->
<!--    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />   --> 
        <!-- Core theme CSS (includes Bootstrap)-->
<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />

</head>
<body>
	<h1>홈 화면</h1>
<!-- =======================[바디시작]================================ -->
        <!-- Navigation-->
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="/">Dealarm</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
                
                
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                	<!--  왼쪽메뉴 -->
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                        <li class="nav-item"><a class="nav-link active" aria-current="page" href="#!">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="#!">About</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Shop</a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="#!">All Products</a></li>
                                <li><hr class="dropdown-divider" /></li>
                                <li><a class="dropdown-item" href="#!">Popular Items</a></li>
                                <li><a class="dropdown-item" href="#!">New Arrivals</a></li>
                            </ul>
                        </li>
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
					        </c:when>
	
		                 	<c:when test="${sessionScope.role eq 'ADMIN'}">
		                 		<li class="nav-item d-flex align-items-center">
		                 			<span class="navbar-text me-2"><b>${sessionScope.role}</b> 님, 환영합니다!</span>
		                 		</li>
		                 		<li class="nav-item d-flex align-items-center">
               						 <a class="nav-link" href="<c:url value='/member/members'/>">회원목록</a>
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
									<span class="navbar-text me-2 "><b>${sessionScope.role}</b>님, 환영합니다!</span>
								</li>
		                 		<li class="nav-item d-flex align-items-center">
		                 			<a class="nav-link" href="<c:url value='/member/mypage'/>">마이페이지</a>
		                 		</li>		                 	
		                 		<li class="nav-item d-flex align-items-center">
		                 			<a class="nav-link" href="<c:url value='/member/logout'/>">로그아웃</a>
		                 		</li>
		                 				                 	
		                 	</c:otherwise>
					    </c:choose>
		                 
		                 
						<li class="nav-item d-flex align-items-center">
				            <form class="d-flex align-items-center mb-0">
		                        <button class="btn btn-outline-dark" type="submit">
		                            <i class="bi-cart-fill me-1"></i>
		                            관심상품
		                            <span class="badge bg-dark text-white ms-1 rounded-pill">0</span>
		                        </button>
		                    </form>
		                </li> 
		                
		                  
	                </ul>   
                </div>
            </div>
        </nav>
        <!-- Header-->
		<header class="py-5 position-relative" style="height: 300px; max-width: 1220px; margin: 0 auto;">
    
	    <!-- 왼쪽 컨테이너 -->
	    <div class="left-container position-absolute h-100 d-flex align-items-center">
	        <p class="text-black ms-3">좌측 컨텐츠</p>
	    </div>
	
	    <!-- 가운데 이미지 컨테이너 -->
	    <div class="center-container d-flex justify-content-center align-items-center h-100">
	        <img src="${pageContext.request.contextPath}/resources/images/header-bg.jpg"
	             alt="배너" 
	             style="width: 550px;  /* 가로 크기 지정 */
               			height: auto;  /* 세로 비율 자동 */
              			object-fit: contain;">
	    </div>
	
	    <!-- 오른쪽 컨테이너 -->
	    <div class="right-container position-absolute end-0 top-0 h-100 d-flex align-items-center">
	        <p class="text-black me-3">우측 컨텐츠</p>
	    </div>
	
	</header>
        <!-- Section-->
        <section class="py-5">
            <div class="container px-4 px-lg-5 mt-5">
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="https://dummyimage.com/450x300/dee2e6/6c757d.jpg" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder">Fancy Product</h5>
                                    <!-- Product price-->
                                    $40.00 - $80.00
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="#">View options</a></div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Sale badge-->
                            <div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">Sale</div>
                            <!-- Product image-->
                            <img class="card-img-top" src="https://dummyimage.com/450x300/dee2e6/6c757d.jpg" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder">Special Item</h5>
                                    <!-- Product reviews-->
                                    <div class="d-flex justify-content-center small text-warning mb-2">
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                    </div>
                                    <!-- Product price-->
                                    <span class="text-muted text-decoration-line-through">$20.00</span>
                                    $18.00
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="#">Add to cart</a></div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Sale badge-->
                            <div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">Sale</div>
                            <!-- Product image-->
                            <img class="card-img-top" src="https://dummyimage.com/450x300/dee2e6/6c757d.jpg" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder">Sale Item</h5>
                                    <!-- Product price-->
                                    <span class="text-muted text-decoration-line-through">$50.00</span>
                                    $25.00
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="#">Add to cart</a></div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="https://dummyimage.com/450x300/dee2e6/6c757d.jpg" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder">Popular Item</h5>
                                    <!-- Product reviews-->
                                    <div class="d-flex justify-content-center small text-warning mb-2">
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                    </div>
                                    <!-- Product price-->
                                    $40.00
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="#">Add to cart</a></div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Sale badge-->
                            <div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">Sale</div>
                            <!-- Product image-->
                            <img class="card-img-top" src="https://dummyimage.com/450x300/dee2e6/6c757d.jpg" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder">Sale Item</h5>
                                    <!-- Product price-->
                                    <span class="text-muted text-decoration-line-through">$50.00</span>
                                    $25.00
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="#">Add to cart</a></div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="https://dummyimage.com/450x300/dee2e6/6c757d.jpg" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder">Fancy Product</h5>
                                    <!-- Product price-->
                                    $120.00 - $280.00
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="#">View options</a></div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Sale badge-->
                            <div class="badge bg-dark text-white position-absolute" style="top: 0.5rem; right: 0.5rem">Sale</div>
                            <!-- Product image-->
                            <img class="card-img-top" src="https://dummyimage.com/450x300/dee2e6/6c757d.jpg" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder">Special Item</h5>
                                    <!-- Product reviews-->
                                    <div class="d-flex justify-content-center small text-warning mb-2">
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                    </div>
                                    <!-- Product price-->
                                    <span class="text-muted text-decoration-line-through">$20.00</span>
                                    $18.00
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="#">Add to cart</a></div>
                            </div>
                        </div>
                    </div>
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" src="https://dummyimage.com/450x300/dee2e6/6c757d.jpg" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder">Popular Item</h5>
                                    <!-- Product reviews-->
                                    <div class="d-flex justify-content-center small text-warning mb-2">
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                        <div class="bi-star-fill"></div>
                                    </div>
                                    <!-- Product price-->
                                    $40.00
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="#">Add to cart</a></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>


	



	<!-- =================== [메인 영역 시작]==================================-->
    <h1>홈 화면</h1>

	<!-- 로그인 여부에 따라 다른 화면 출력 -->
	<c:choose>
		<c:when test="${empty sessionScope.id}">
			<a href="<c:url value='/member/join'/>">회원가입</a> |
    <!-- 로그인 여부에 따라 다른 화면 출력 -->
 
    <c:choose>
    <c:when test="${empty sessionScope.id}">
        <a href="<c:url value='/member/join'/>">회원가입</a>
        <a href="<c:url value='/member/login'/>">로그인</a>
		</c:when>
		<c:when test="${sessionScope.role eq 'ADMIN'}">
			<p>
				<b>${sessionScope.role}</b> 님, 환영합니다!
			</p>
			<a href="<c:url value='/member/members'/>">회원목록</a>
			<a href="<c:url value='/member/logout'/>">로그아웃</a>
			<a href="<c:url value='/member/mypage'/>">마이페이지</a>

		</c:when>
		<c:otherwise>
			<p>
				<b>${sessionScope.name}</b> 님, 환영합니다!
			</p>
			<a href="<c:url value='/member/logout'/>">로그아웃</a>
			<a href="<c:url value='/member/mypage'/>">마이페이지</a>
			<h3>키워드 등록</h3>
			<form action="<c:url value='/keywords/add'/>" method="post">
				<input type="hidden" name="userId" value="${sessionScope.id}" /> <input
					type="text" name="keyword" placeholder="키워드 입력" required />
				<button type="submit">추가</button>
			</form>
    </c:when>
    <c:when test="${sessionScope.role eq 'ADMIN'}">
            <p><b>${sessionScope.role}</b> 님, 환영합니다!</p>
        <a href="<c:url value='/member/members'/>">회원목록</a>
        <a href="<c:url value='/member/logout'/>">로그아웃</a>
        <a href="<c:url value='/member/mypage'/>">마이페이지</a>
    </c:when>
	<c:when test="${sessionScope.is_active == 0}">
        <button type="button" onclick="openModal()">계정 활성화</button>
 
	<!-- 계정 활성화 모달 -->
 
	<div id="activeModal"
		style="display: none; border: 1px solid #000; padding: 10px; background: #eee;">
		<p>
			<strong>계정활성화 시키시겠습니까?</strong> 비밀번호를 입력해주세요.
		</p>

			<h3>내 키워드 목록</h3>
			<table border="1">
				<tr>
					<th>ID</th>
					<th>키워드</th>
					<th>등록일</th>
					<th>삭제</th>
				</tr>
				<c:forEach var="k" items="${keywords}">
					<tr>
						<td>${k.userId}</td>
						<td>${k.keyword}</td>
						<td>${k.createdAt}</td>
						<td>
							<form action="<c:url value='/keywords/delete/${k.num}'/>"
								method="post">
								<button type="submit">삭제</button>
							</form>
						</td>
					</tr>
				</c:forEach>
			</table>
			<hr>
		</c:otherwise>
	</c:choose>
		<input type="hidden" id="activeid" value="${sessionScope.id}">
		비밀번호: <input type="password" id="activePw" required><br>
		<br>
		<button type="button" id="confirmactive">활성화</button>
		<button type="button" onclick="closeModal()">취소</button>
	</div>
	

	<hr>
	<p>서버 시간: ${serverTime}</p>
	
<!-- ===========================스크립트 원본 훼손방지================================ -->
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
        <!-- Footer-->
        <footer class="py-5 bg-dark">
            <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
        </footer>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

</body>
</html>