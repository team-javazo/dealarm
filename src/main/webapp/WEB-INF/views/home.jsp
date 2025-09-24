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
            <a href="<c:url value='/member/login'/>">로그인</a>
      </c:when>
      <c:when test="${sessionScope.role eq 'ADMIN'}">
         <p>
            <b>${sessionScope.role}</b> 님, 환영합니다!
         </p>
         <a href="<c:url value='/member/members'/>">회원목록</a> |
            <a href="<c:url value='/member/logout'/>">로그아웃</a> |
            <a href="<c:url value='/member/mypage'/>">마이페이지</a>
      </c:when>
      <c:otherwise>
         <p>
            <b>${sessionScope.name}</b> 님, 환영합니다!
         </p>
         <a href="<c:url value='/member/logout'/>">로그아웃</a> |
            <a href="<c:url value='/member/mypage'/>">마이페이지</a>

         <!-- 키워드 등록 -->
         <h3>키워드 등록</h3>
         <form id="addKeywordForm">
            <input type="hidden" name="userId" value="${sessionScope.id}" /> <input
               type="text" id="keyword" name="keyword" placeholder="키워드 입력"
               required />
            <button type="submit">추가</button>
         </form>

         <h3>키워드 관리</h3>
         <!-- 키워드 리스트 -->
         <ul id="keywordList">
            <!-- 키워드 목록이 동적으로 삽입됩니다. -->
         </ul>

         <script>
            // 키워드 추가
            $('#addKeywordForm')
                  .on(
                        'submit',
                        function(e) {
                           e.preventDefault(); // 폼 제출 기본 동작 방지
                           const keyword = $('#keyword').val().trim();
                           const userId = "${sessionScope.id}"; // 세션에서 사용자 ID 가져오기

                           if (keyword) {
                              // 키워드 추가 API 호출
                              $
                                    .ajax({
                                       url : '${pageContext.request.contextPath}/keywords/add',
                                       method : 'POST',
                                       contentType : 'application/json',
                                       data : JSON.stringify({
                                          userId : userId,
                                          keyword : keyword
                                       }),
                                       success : function(response) {
                                          if (response.success) {
                                             alert('키워드가 추가되었습니다.');
                                             loadKeywords(); // 키워드 리스트 새로고침
                                          } else {
                                             alert(response.message); // 에러 메시지 출력
                                          }
                                       },
                                       error : function() {
                                          alert('서버 오류가 발생했습니다.');
                                       }
                                    });
                           } else {
                              alert('키워드를 입력해주세요.');
                           }
                        });

            // 키워드 삭제
            $(document)
                  .on(
                        'click',
                        '.deleteBtn',
                        function() {
                           const keywordId = $(this).data('id');
                           if (confirm('이 키워드를 삭제하시겠습니까?')) {
                              // 키워드 삭제 API 호출
                              $
                                    .ajax({
                                       url : '${pageContext.request.contextPath}/keywords/delete/'
                                             + keywordId,
                                       method : 'POST',
                                       success : function(response) {
                                          if (response.success) {
                                             alert('키워드가 삭제되었습니다.');
                                             loadKeywords(); // 키워드 리스트 새로고침
                                          } else {
                                             alert('삭제 실패');
                                          }
                                       },
                                       error : function() {
                                          alert('서버 오류가 발생했습니다.');
                                       }
                                    });
                           }
                        });

            // 키워드 리스트 불러오기            
            function loadKeywords() {
               var userId = "${sessionScope.id}";
               var url = "${pageContext.request.contextPath}/keywords/list?userId="
                     + userId;

               console.log("Ajax 요청 URL:", url);

               $
                     .ajax({
                        url : url,
                        type : 'GET',
                        dataType : 'json',
                        success : function(response) {
                           console.log("서버 응답:", response);
                           var htmls = "";

                           if (response.keywords
                                 && response.keywords.length > 0) {
                              $(response.keywords)
                                    .each(
                                          function() {
                                             console
                                                   .log(
                                                         "Keyword object:",
                                                         this);

                                             let id = this.id ? this.id
                                                   : "ID 없음";
                                             let keywordUserId = this.userId ? this.userId
                                                   : "User ID 없음";
                                             let keywordValue = this.keyword ? this.keyword
                                                   : "키워드 없음";
                                             let createdAtStr = this.createdAt ? new Date(
                                                   this.createdAt)
                                                   .toLocaleString()
                                                   : "날짜 없음";

                                             htmls += '<li>';
                                             htmls += id
                                                   + ', '
                                                   + keywordUserId
                                                   + ', '
                                                   + keywordValue
                                                   + ', '
                                                   + createdAtStr;
                                             htmls += ' <button class="deleteBtn" data-id="' + id + '">삭제</button>';
                                             htmls += '</li>';
                                          });
                           } else {
                              htmls = "<li>등록된 키워드가 없습니다.</li>";
                           }

                           $("#keywordList").html(htmls);
                        },
                        error : function(xhr, status, error) {
                           alert("키워드 목록 불러오기 실패: " + error);
                           console.error("에러 상태:", status, error);
                        }
                     });
            }

            // 페이지 로딩 시 키워드 리스트 불러오기
            $(document).ready(function() {
               loadKeywords(); // 키워드 리스트 불러오기
            });
         </script>
      </c:otherwise>
   </c:choose>

   <hr>
   <p>서버 시간: ${serverTime}</p>
</body>
</html>
    