<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>

<title>회원관리</title>
<!-- Bootstrap 5 CSS CDN -->
	<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />

</head>
<body style="margin:0; padding:0; display: flex; flex-direction: column; height: 100vh;">

   <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>
    <div class="d-flex">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
        <div class="flex-grow-1">
            
	
			  <!-- =================[회원관리페이지]============ -->
			<div class="container mt-4">
		
				<h2 class="mb-3">통계 페이지</h2>

	
	  <!-- =================[회원관리페이지 end]============ -->
            <%@ include file="/WEB-INF/views/include/footer.jsp"%>
        </div>
    </div>
   






</body>
</html>