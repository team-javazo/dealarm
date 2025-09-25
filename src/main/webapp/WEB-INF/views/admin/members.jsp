<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
	<meta charset="UTF-8">
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
<title>회원관리</title>
<!-- Bootstrap 5 CSS CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />

</head>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<body style="margin:0; padding:0; display: flex; flex-direction: column; height: 100vh;">

   <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>
    <div class="d-flex">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
        <div class="flex-grow-1">
            
	
			  <!-- =================[회원관리페이지]============ -->
			<div class="container mt-4">
		
				<h2 class="mb-3">회원관리 페이지</h2>
				<h3>총 회원수 : ${totalCount} 명</h3>
				<h3>검색된 인원 수: ${searchCount} 명</h3>
				<a href="${pageContext.request.contextPath}/member/members"
					class="btn btn-outline-primary btn-sm ms-3"
					onclick="document.querySelector('input[name=searchValue]').value = '';
		       			document.querySelector('select[name=searchType]').value = 'all';">전체
					회원리스트</a>
				<button type="button" class="btn btn-outline-primary btn-sm ms-3" onclick="location.href='<c:url value="/main"/>'">홈으로</button>
				<hr>
		
				<!-- 검색 폼 -->
			 	<form action="${pageContext.request.contextPath}/member/members_search"		
					method="post" class="d-flex mb-3" role="search">
					<select class="form-select me-2" style="max-width: 120px;"
						name="searchType">
						<option value="all"
							<c:if test="${empty param.searchType or param.searchType == 'all'}">selected</c:if>>전체</option>
						<option value="id"
							<c:if test="${param.searchType == 'id'}">selected</c:if>>아이디</option>
						<option value="name"
							<c:if test="${param.searchType == 'name'}">selected</c:if>>이름</option>
						<option value="phone"
							<c:if test="${param.searchType == 'phone'}">selected</c:if>>전화번호</option>
						<option value="birth_date"
							<c:if test="${param.searchType == 'birth_date'}">selected</c:if>>생년월일</option>
						<option value="gender"
							<c:if test="${param.searchType == 'gender'}">selected</c:if>>성별</option>
						<option value="notification"
							<c:if test="${param.searchType == 'notification'}">selected</c:if>>알림동의</option>
						<option value="region"
							<c:if test="${param.searchType == 'region'}">selected</c:if>>지역</option>
						<option value="role"
							<c:if test="${param.searchType == 'role'}">selected</c:if>>권한</option>
						<option value="is_active"
							<c:if test="${param.searchType == 'is_active'}">selected</c:if>>계정상태</option>
						<option value="created_at"
							<c:if test="${param.searchType == 'created_at'}">selected</c:if>>가입일</option>
					</select> <input type="text" name="searchValue" class="form-control me-2"
						style="max-width: 300px;" placeholder="검색어를 입력하세요"
						value="${param.searchValue}"> <input type="submit"
						class="btn btn-primary" value="검색">
				</form>
		
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
									<td><c:choose>
								      <c:when test="${user.gender == 'male'}">남자</c:when>
								      <c:otherwise>여자</c:otherwise>
								    </c:choose></td>
									<td><c:choose>
								      <c:when test="${member.notification == '1'}">동의</c:when>
								      <c:otherwise>비동의</c:otherwise>
								    </c:choose></td>									
									<td>${member.region}</td>
									<td><c:choose>
								      <c:when test="${member.role == 'ADMIN'}">관리자</c:when>
								      <c:otherwise>회원</c:otherwise>
								    </c:choose></td>									
									<td><c:choose>
								      <c:when test="${member.is_active == '1'}">활성화</c:when>
								      <c:otherwise>비활성화</c:otherwise>
								    </c:choose></td>
									<td>${member.created_at}</td>
									<td><button class="btn btn-secondary btn-sm">상세조회</button></td>
							  	<td><button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal" data-id="${member.id}">수정</button></td>
								<td><button type="button" class="btn btn-danger btn-sm"	data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="${member.id}">삭제</button></td></tr>
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
				
				        <!-- 현재 페이지 + 번호 -->
				        <c:choose>
				        	<c:when test="${totalPage <= 1 }">
				        		<li class="page-item disabled">
				        			<a class="page-link" href="#">1</a>
				        		</li>
				        	</c:when>
					        <c:otherwise>
					        	<c:forEach var="i" begin="${startPage}" end="${endPage}">
						           	<li class="page-item ${i == currentPage ? 'active' : ''}">
						            	<a class="page-link" href="?currentPage=${i}&searchType=${param.searchType}&searchValue=${param.searchValue}&genderFilter=${param.genderFilter}&roleFilter=${param.roleFilter}&notificationFilter=${param.notificationFilter}&is_activeFilter=${param.is_activeFilter}&birth_orderType=${param.birth_orderType}&created_orderType=${param.created_orderType}">${i}</a>
						            </li>
						        </c:forEach>    
					        </c:otherwise>
				        </c:choose>
		       
				
				        <!-- 다음 페이지 -->
				        <c:choose>
				            <c:when test="${empty totalPages or currentPage >= totalPages}">
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
				
				
				
				
				<!-- 수정 확인 모달 -->
				<div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
				  <div class="modal-dialog modal-dialog-centered">
				    <div class="modal-content">
				      <div class="modal-header">
				        <h5 class="modal-title" id="updateModalLabel">회원 정보 수정 확인</h5>
				        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
				      </div>
				      <div class="modal-body">
				        회원 정보를 수정하시겠습니까?
				      </div>
				      <div class="modal-footer">
				        <form id="updateForm" method="post" action="${pageContext.request.contextPath}/member/adminupdate">
				          <input type="hidden" name="id" id="updateId">
				          <button type="submit" class="btn btn-primary">수정</button>
				          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
				        </form>
				      </div>
				    </div>
				  </div>
				</div>
				
				<!-- 삭제 확인 모달 -->
				<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
				  <div class="modal-dialog modal-dialog-centered">
				    <div class="modal-content">
				      <div class="modal-header">
				        <h5 class="modal-title" id="deleteModalLabel">회원 삭제 확인</h5>
				        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
				      </div>
				      <div class="modal-body">
				        정말 삭제하시겠습니까?
				      </div>
				      <div class="modal-footer">
				        <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/member/deleteadmin">
				          <input type="hidden" name="id" id="deleteId">
				          <button type="submit" class="btn btn-danger">삭제</button>
				          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
				        </form>
				      </div>
				    </div>
				  </div>
				</div>
	
	  <!-- =================[회원관리페이지 end]============ -->
            <%@ include file="/WEB-INF/views/include/footer.jsp"%>
        </div>
    </div>
   






<script>
document.addEventListener('DOMContentLoaded', function () {
	var deleteModal = document.getElementById('deleteModal');
	deleteModal.addEventListener('show.bs.modal', function (event) {
		var button = event.relatedTarget; // 삭제 버튼
		var memberId = button.getAttribute('data-id'); // data-id 값 가져오기
		var deleteInput = document.getElementById('deleteId');
		deleteInput.value = memberId; // hidden input에 설정
  	});
	
	var updateModal = document.getElementById('updateModal');
	updateModal.addEventListener('show.bs.modal', function (event) {
		var button = event.relatedTarget;
		var memberId = button.getAttribute('data-id');
		var updateInput = document.getElementById('updateId');
		updateInput.value = memberId;
	});    
});
</script>
</body>
</html>