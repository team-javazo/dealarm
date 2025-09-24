<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<meta charset="UTF-8">
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
<title>마이페이지</title>
<!-- Bootstrap CSS/JS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />

</head>
<body style="margin:0; padding:0; display: flex; flex-direction: column; height: 100vh;">

 
    <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

    <div class="d-flex">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
        <div class="flex-grow-1">
            <%@ include file="/WEB-INF/views/include/banner.jsp"%>
            <!-- =================[로그인페이지]============ -->
		
			<!-- 로그인세션확인 
			<script>
				var loginUser = "${sessionScope.id}";
				if(loginUser == null){
					alert("로그인이 필요합니다");
					location.href = "/login";
				}
			</script>
		 -->
		
			<div class="container mt-5">
				<div class="card shadow-sm" style="max-width:600px; margin:auto;">
					<div>
					    <h2 class="card-title text-center mb-4">마이페이지</h2>
							<table class="table table-bordered text-center";">
								<tbody>
								
								</tbody>
					</div>
				</div>
			
			
			        <tr><th style="width: 150px;"class="text-center">아이디</th><td>${user.id}</td></tr>
			        <tr><th class="text-center">비밀번호</th><td>*******</td></tr>
			        <tr><th>이름</th><td>${user.name}</td></tr>
			        <tr><th>전화번호</th><td>${user.phone}</td></tr>
			        <tr><th>이메일</th><td>${user.email}</td></tr>
			        <tr><th>생년월일</th><td>${user.birth_date}</td></tr>
			        <tr><th>성별</th><td>${user.gender}</td></tr>
			        <tr>
			            <th>알림 수신 여부</th>
			            <td>
			                <label>
			                    <input type="radio" name="notification" value="1" 
			                        <c:if test="${user.notification == 1}">checked</c:if> disabled>동의
			                </label>
			                <label>
			                    <input type="radio" name="notification" value="0"
			                        <c:if test="${user.notification != 1}">checked</c:if> disabled>동의하지 않음
			                </label>
			            </td>
			        </tr>
			        <tr><th>지역</th><td>${user.region}</td></tr>
			        <tr><th>권한</th><td>${user.role}</td></tr>
			        <tr><th>가입일</th><td>${user.created_at}</td></tr>
			    </table>
			
			    <div class="mt-3">
			        <button type="button" class="btn btn-primary" onclick="openPassModal()">수정</button>
					<button type="button" class="btn btn-secondary" onclick="location.href='<c:url value="/"/>'">홈으로</button>
			    </div>
			</div>
			
			
			<!-- 비밀번호 확인 모달 -->
			<div class="modal fade" id="passwordModal" tabindex="-1">
			  <div class="modal-dialog">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title">비밀번호 확인</h5>
			        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			      </div>
			      <div class="modal-body">
			        <input type="password" id="inputPass" class="form-control" placeholder="비밀번호 입력">
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-primary" onclick="checkPassword()">확인</button>
			        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			      </div>
			    </div>
			  </div>
			</div>


            <!-- =================[로그인페이지 end]============ -->
            <%@ include file="/WEB-INF/views/include/footer.jsp"%>
        </div>
    </div>
   






	
	<!-- 수정페이지로 넘길 ID -->
	<input type="hidden" id="userId" value="${user.id}">
	
	
	<!-- 비밀번호 불일치 alert -->
	<c:if test="${not empty passFail}">
		<script>
			alert("비밀번호가 틀렸습니다.")
			document.getElementById('inputPass').value = ""; //입력칸 초기화
			var modal = new bootstrap.Modal(document.getElementById('passwordModal'));
			modal.show();
		</script>
	</c:if>
	
	<!-- 모달 스크립트 -->
	<script>
	    function openPassModal(){	//패스워드 모달 띄우기
	        var modal = new bootstrap.Modal(document.getElementById('passwordModal'));
	        modal.show();
	    }
	    
	   	function checkPassword(){
	   		var userId = document.getElementById("userId").value;
	   		var inputPass = document.getElementById("inputPass").value.trim();
	   		
	   		if(!inputPass){
	   			alert("비밀번호를 입력하세요")
	   			return;
	   		}
	   		
	   	
	   	// 서버로 post
	   	var form = document.createElement("form");
	   	form.method = "post";
	   	form.action = "${pageContext.request.contextPath}/member/mypage_pass";
	   	var postId = document.createElement("input");
	   	postId.type = "hidden";
	   	postId.name = "id";
	   	
	   	postId.value = userId;
	   	form.appendChild(postId);
	   	
	   	var postPass = document.createElement("input");
	   	postPass.type = "hidden";
	   	postPass.name = "password";
	   	postPass.value = inputPass;
	   	form.appendChild(postPass);
	   	
	   	document.body.appendChild(form);
	   	form.submit();
	   }
	</script>



</body>
</html>