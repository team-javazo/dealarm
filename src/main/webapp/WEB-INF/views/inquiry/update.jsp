<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head>
<meta charset="UTF-8"><title>수정 완료</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head><body class="bg-light text-center">
<%@ include file="../include/top_nav.jsp" %>
<div class="container mt-5">
  <div class="alert alert-success shadow-sm"><h4>수정이 완료되었습니다.</h4></div>
  <a href="${pageContext.request.contextPath}/inquiry/list" class="btn btn-primary mt-3">목록으로 이동</a>
</div>
<%@ include file="../include/footer.jsp" %>
</body></html>
