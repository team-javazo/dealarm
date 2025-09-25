<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

 <!-- TopNavigation-->
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/main">Dealarm</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
                
                
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                	<!--  왼쪽메뉴 -->
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                        <li class="nav-item"><a class="nav-link active" aria-current="page" href="${pageContext.request.contextPath}/main">Home</a></li>
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
		                 			<span class="navbar-text me-2"><b>${sessionScope.id}</b>&nbsp;관리자 계정으로 로그인하였습니다</span>
		                 		</li>
		                 		<li class="nav-item d-flex align-items-center">
               						 <a class="nav-link" href="<c:url value='/member/members'/>">회원관리</a>
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
        
 