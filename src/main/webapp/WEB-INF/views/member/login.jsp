<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
    <title>로그인</title>
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
   			
   			<div class="container" style="max-width: 400px; magin-top: 80px;">
   				<div class="card shadow-sm">
   					<div class="card-body">
 			            <h2 class="card-title text-center mb-4">로그인</h2>
					    
					    <form action="<c:url value='/member/login'/>" method="post">
	    					<div class="mb-3">
					        	<label for="id" class="form-label">아이디</label> 
					        	<input type="text" class="form-control" id="id" name="id" required>
	    					</div>
	    					
	    					<div class="mb-3">
	    						<label for="password" class="form-label">비밀번호</label> 
					        	<input type="password" class="form-control" id="password" name="password" required>
							</div>
								    				  					
		        			<button type="submit">로그인</button>
	    				</form>
	    				
   					</div>
   				</div>
   			</div>         
   
   
		        
		        
            
		    <!-- 로그인 실패 메시지 표시 -->
		    <c:if test="${not empty errorMsg}">
		        <p style="color:red;">${errorMsg}</p>
		    </c:if>
		
		    <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="<c:url value='/member/join'/>">회원가입</a>
		       <a href="<c:url value='/main'/>">홈으로</a></p>
         
            
            
            <!-- =================[로그인페이지 end]============ -->
            <%@ include file="/WEB-INF/views/include/footer.jsp"%>
        </div>
    </div>
   
   

</body>
</html>