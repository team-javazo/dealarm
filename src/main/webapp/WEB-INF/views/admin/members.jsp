<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta charset="UTF-8">
<title>회원관리</title>
<!-- Bootstrap 5 CSS CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

</head>
<body>
	<div class="container mt-4">

    <h2 class="mb-3">회원관리 페이지</h2>
	<h3>총 회원수 : ${count} 명</h3>
	<a href="${pageContext.request.contextPath}/admin/members" class="btn btn-outline-primary btn-sm ms-3"
	   onclick="document.querySelector('input[name=searchValue]').value = '';
       			document.querySelector('select[name=searchType]').value = 'all';">총 회원리스트</a>
	<button type="button" class="btn btn-outline-primary btn-sm ms-3" onclick="location.href='<c:url value="/"/>'">홈으로</button>
    <!-- 검색 폼 -->
    <form action="${pageContext.request.contextPath}/member/members_search" method="post" class="d-flex mb-3" role="search">
        <select class="form-select me-2" style="max-width: 120px;" name="searchType">
            <option value="all" <c:if test="${empty param.searchType or param.searchType == 'all'}">selected</c:if>>전체</option>
            <option value="id" <c:if test="${param.searchType == 'id'}">selected</c:if>>아이디</option>
            <option value="name" <c:if test="${param.searchType == 'name'}">selected</c:if>>이름</option>
            <option value="phone" <c:if test="${param.searchType == 'phone'}">selected</c:if>>전화번호</option>
            <option value="birth_date" <c:if test="${param.searchType == 'birth_date'}">selected</c:if>>생년월일</option>
            <option value="gender" <c:if test="${param.searchType == 'gender'}">selected</c:if>>성별</option>
            <option value="notification" <c:if test="${param.searchType == 'notification'}">selected</c:if>>알림동의</option>
            <option value="region" <c:if test="${param.searchType == 'region'}">selected</c:if>>지역</option>
            <option value="role" <c:if test="${param.searchType == 'role'}">selected</c:if>>권한</option>
            <option value="is_active" <c:if test="${param.searchType == 'is_active'}">selected</c:if>>계정상태</option>
            <option value="created_at" <c:if test="${param.searchType == 'created_at'}">selected</c:if>>가입일</option>
        </select>
        <input type="text" name="searchValue" class="form-control me-2" style="max-width: 300px;" placeholder="검색어를 입력하세요" value="$param.searchValue}">
        <input type="submit" class="btn btn-primary" value="검색">
    </form>

    <!-- 회원 목록 테이블 -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover text-center">
            <thead class="table-light">
                <tr>
                    <th>아이디</th>
                    <th>비밀번호</th>
                    <th>이름</th>
                    <th>전화번호</th>
                    <th>이메일</th>
                    <th>생년월일</th>
                    <th>성별</th>
                    <th>알림동의</th>
                    <th>지역</th>
                    <th>권한</th>
                    <th>계정상태</th>
                    <th>가입일</th>
                    <th>상세조회</th>
                    <th>수정</th>
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="member" items="${list}">
                    <tr>
                        <td>${member.id}</td>
                        <td>${member.password}</td>
                        <td>${member.name}</td>
                        <td>${member.phone}</td>
                        <td>${member.email}</td>
                        <td>${member.birth_date}</td>
                        <td>${member.gender}</td>
                        <td>${member.notification}</td>
                        <td>${member.region}</td>
                        <td>${member.role}</td>
                        <td>
                            <c:choose>
                                <c:when test="${member.is_active == 1}">활성</c:when>
                                <c:otherwise>비활성</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${member.created_at}</td>
                        <td><button class="btn btn-secondary btn-sm" onclick="alert('상세조회: ${member.id}')">상세조회</button></td>
						<form action="${pageContext.request.contextPath}/member/adminupdate" method="post">
						    <input type="hidden" name="id" value="${member.id}">
						    <td>
						        <button type="submit" class="btn btn-secondary btn-sm">
						            수정
						        </button>
						    </td>
						</form>
                       <form action="${pageContext.request.contextPath}/member/deleteadmin" method="post">
						    <input type="hidden" name="id" value="${member.id}">
						    <td>
						        <button type="submit" class="btn btn-secondary btn-sm">
						            삭제
						        </button>
						    </td>
						</form>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    
</div>

		<!-- 회원 목록 테이블 -->

		<form action="${pageContext.request.contextPath}/member/members_search" method="post">			
	        <!-- 타입불일치오류 제거용 searchType/searchValue hidden input 추가 -->
	        <input type="hidden" name="searchType" value="${param.searchType}">
	        <input type="hidden" name="searchValue" value="${param.searchValue}">
	        
			<table class="table table-bordered table-hover text-center" style="table-layout: fixed; width: 1400px; margin-bottom: 0;">
				<thead class="table-light">
					<tr>
						<th style="width: 30px; vertical-align: middle;">아이디</th>
<!--         			<th style="width: 100px;vertical-align: middle;">비밀번호</th>	 -->
						<th style="width: 30px; vertical-align: middle;">이름</th>
<!--        			<th style="width: 100px;vertical-align: middle;">전화번호</th>  	 -->
<!--         		  	<th style="width: 100px;vertical-align: middle;">이메일</th>		 -->
<!--					<th style="width: 25px; vertical-align: middle;">생년월일</th>		-->
						<th style="width: 25px; vertical-align: middle;">
							<select name="birth_orderType" id="birth_orderType" class="form-select form-select-sm" onchange="this.form.submit()">
								<option value="">생년월일</option>
								<option value="birth_date_asc">오름차순</option>
								<option value="birth_date_desc">내림차순</option>			 
							</select>
						</th>
<!-- 	          		<th style="width: 20px;vertical-align: middle;">성별</th>		 -->
						<th style="width: 20px; vertical-align: middle;">
							<select name="genderFilter" class="form-select form-select-sm" onchange="this.form.submit()">
								<option value="">성별	</option>
								<option value="male" <c:if test="${param.genderFilter == 'male'}">selected</c:if>>남자</option>
								<option value="female" <c:if test="${param.genderFilter == 'female'}">selected</c:if>>여자</option>
							</select>
						</th>
<!-- 					<th style="width: 15px; vertical-align: middle;">알림동의</th>		 -->		
	 					<th style="width: 19px; vertical-align: middle;">
	 						<select name="notificationFilter" class="form-select form-select-sm" onchange="this.form.submit()">
	 							<option value="">알림</option>
	 							<option value="1" <c:if test="${param.notificationFilter == '1'}">selected</c:if>>동의</option>
	 							<option value="0" <c:if test="${param.notificationFilter == '0'}">selected</c:if>>거부</option>
	 						</select>
	 							
	 					</th>			
						<th style="width: 20px; vertical-align: middle;">지역</th>
<!-- 					<th style="width: 20px; vertical-align: middle;">권한</th>		 -->	
						<th style="width: 20px; vertical-align: middle;">
	 						<select name="roleFilter" class="form-select form-select-sm" onchange="this.form.submit()">
	 							<option value="">권한</option>
	 							<option value="USER" <c:if test="${param.roleFilter == 'USER'}">selected</c:if>>회원</option>
	 							<option value="ADMIN" <c:if test="${param.roleFilter == 'ADMIN'}">selected</c:if>>관리자</option>
							</select>
	 					</th>
<!-- 					<th style="width: 15px; vertical-align: middle;">계정상태</th>		 -->	
						<th style="width: 19px; vertical-align: middle;">
	 						<select name="is_activeFilter" class="form-select form-select-sm" onchange="this.form.submit()">
	 							<option value="">상태</option>
	 							<option value="1" <c:if test="${param.is_activeFilter == '1'}">selected</c:if>>활성</option>
	 							<option value="0" <c:if test="${param.is_activeFilter == '0'}">selected</c:if>>탈퇴</option>
							</select>
	 					</th>						
<!--					<th style="width: 45px; vertical-align: middle;">가입일</th>	 -->
						<th style="width: 45px; vertical-align: middle;">
							<select name="created_orderType" id="created_orderType" class="form-select form-select-sm" onchange="this.form.submit()">
								<option value="">가입일</option>
								<option value="created_at_asc">오름차순</option>
								<option value="created_at_desc">내림차순</option>			 
							</select>	 
						</th>
						<th style="width: 28px; vertical-align: middle;">상세조회</th>
						<th style="width: 20px; vertical-align: middle;">수정</th>
						<th style="width: 20px; vertical-align: middle;">삭제</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="member" items="${list}">
						<tr>
							<td>${member.id}</td>
							<!--                		<td>${member.password}</td>	 -->
							<td>${member.name}</td>
							<!--                		<td>${member.phone}</td>	 -->
							<!--                		<td>${member.email}</td>	 -->
							<td>${member.birth_date}</td>
							<td>${member.gender}</td>
							<td>${member.notification}</td>
							<td>${member.region}</td>
							<td>${member.role}</td>
							<td>${member.is_active }</td>
							<td>${member.created_at}</td>
							<td><button class="btn btn-secondary btn-sm">상세조회</button></td>
							<td><button class="btn btn-primary btn-sm">수정</button></td>
							<td><button class="btn btn-danger btn-sm">삭제</button></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</form>
			
		<!-- 페이징 UI ver2 -->
		<c:set var="limit" value="${limit}"/>
		<c:set var="totalPages" value="${totalPages}"/>
		<c:set var="startPage" value="${currentPage - 2 <= 0 ? 1 : currentPage - 2}"/>
		<c:set var="endPage" value="${startPage + 4 > totalPages ? totalPages : startPage +4}"/>
		<c:if test="${endPage > totalPages}">
		    <c:set var="endPage" value="${totalPages}"/>
		</c:if> 
		
		<!-- 페이징 네비게이션 -->
		<nav aria-label="Page navigation">
		    <ul class="pagination justify-content-center mt-3">
		        <!-- 이전 페이지 -->
		        <c:choose>
		            <c:when test="${currentPage == 1}">
		                <li class="page-item disabled">
		                    <a class="page-link" href="#" tabindex="-1" aria-disabled="true">이전페이지</a>
		                </li>
		            </c:when>
		            <c:otherwise>
		                <li class="page-item">
		                    <a class="page-link" href="?currentPage=${currentPage - 1}&searchType=${param.searchType}&searchValue=${param.searchValue}&genderFilter=${param.genderFilter}&roleFilter=${param.roleFilter}&notificationFilter=${param.notificationFilter}&is_activeFilter=${param.is_activeFilter}&birth_orderType=${param.birth_orderType}&created_orderType=${param.created_orderType}">이전페이지</a>
		                </li>
		            </c:otherwise>
		        </c:choose>
		
		        <!-- 페이지 번호 -->
		        <c:forEach var="i" begin="${startPage}" end="${endPage}">
		            <li class="page-item ${i == currentPage ? 'active' : ''}">
		                <a class="page-link" href="?currentPage=${i}&searchType=${param.searchType}&searchValue=${param.searchValue}&genderFilter=${param.genderFilter}&roleFilter=${param.roleFilter}&notificationFilter=${param.notificationFilter}&is_activeFilter=${param.is_activeFilter}&birth_orderType=${param.birth_orderType}&created_orderType=${param.created_orderType}">${i}</a>
		            </li>
		        </c:forEach>
		
		        <!-- 다음 페이지 -->
		        <c:choose>
		            <c:when test="${currentPage >= totalPages}">
		                <li class="page-item disabled">
		                    <a class="page-link" href="#" tabindex="-1" aria-disabled="true">다음페이지</a>
		                </li>
		            </c:when>
		            <c:otherwise>
		                <li class="page-item">
		                    <a class="page-link" href="?currentPage=${currentPage + 1}&searchType=${param.searchType}&searchValue=${param.searchValue}&genderFilter=${param.genderFilter}&roleFilter=${param.roleFilter}&notificationFilter=${param.notificationFilter}&is_activeFilter=${param.is_activeFilter}&birth_orderType=${param.birth_orderType}&created_orderType=${param.created_orderType}">다음페이지</a>
		                </li>
		            </c:otherwise>
		        </c:choose>
		    </ul>
		</nav>
		<div style="background:#f8f9fa; padding:10px; margin:10px 0; border:1px solid #ddd;">
		    <strong>페이징 디버그</strong><br/>
		    currentPage: ${currentPage}<br/>
		    limit: ${limit}<br/>
		    searchCount: ${searchCount}<br/>
		    totalPages: ${totalPages}<br/>
		    조건 (currentPage == totalPages): ${currentPage == totalPages}<br/>
		    조건 (currentPage == totalPages): ${currentPage >= totalPages}<br/>
		</div>
		
			
			<!-- 페이징 UI ver1 -->
<!--  
			<c:set var="limit" value="10"/>
			<c:set var="totalPages" value="${(totalCount / limit) + (totalCount % limit > 0 ? 1 : 0)}"/>
			<c:set var="startPage" value="${currentPage - 2 <= 0 ? 1 : currentPage - 2}"/>
			<c:set var="endPage" value="${startPage + 4 > totalPages ? totalPages : startPage + 4}"/>
			
			<nav aria-label="Page navigation example">
			    <ul class="pagination justify-content-center mt-3">
			        <!-- 이전 페이지 -->
<!--
 			        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
			            <a class="page-link" href="?currentPage=${currentPage - 1}&searchType=${param.searchType}&searchValue=${param.searchValue}&genderFilter=${param.genderFilter}&roleFilter=${param.roleFilter}&notificationFilter=${param.notificationFilter}&is_activeFilter=${param.is_activeFilter}&birth_orderType=${param.birth_orderType}&created_orderType=${param.created_orderType}">Previous</a>
			        </li>
			
			        <!-- 페이지 번호 -->
<!--
			        <c:forEach var="i" begin="${startPage}" end="${endPage}">
			            <li class="page-item ${i == currentPage ? 'active' : ''}">
			                <a class="page-link" href="?currentPage=${i}&searchType=${param.searchType}&searchValue=${param.searchValue}&genderFilter=${param.genderFilter}&roleFilter=${param.roleFilter}&notificationFilter=${param.notificationFilter}&is_activeFilter=${param.is_activeFilter}&birth_orderType=${param.birth_orderType}&created_orderType=${param.created_orderType}">${i}</a>
			            </li>
			        </c:forEach>
			
			        <!-- 다음 페이지 -->
<!--
			        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
			            <a class="page-link" href="?currentPage=${currentPage + 1}&searchType=${param.searchType}&searchValue=${param.searchValue}&genderFilter=${param.genderFilter}&roleFilter=${param.roleFilter}&notificationFilter=${param.notificationFilter}&is_activeFilter=${param.is_activeFilter}&birth_orderType=${param.birth_orderType}&created_orderType=${param.created_orderType}">Next</a>
			        </li>
			    </ul>
			</nav>
			</div>
 --> 		
 
 
 	


		<!-- 					
							<td>${member.is_active }
	                            <c:choose>
	                                <c:when test="${member.is_active == 1}">활성</c:when>
	                                <c:otherwise>비활성</c:otherwise>
	                            </c:choose>
	                        </td>
-->
</body>
</html>