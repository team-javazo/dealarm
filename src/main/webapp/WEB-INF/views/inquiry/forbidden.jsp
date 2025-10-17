<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>접근 제한</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5" style="max-width:720px;">
  <div class="alert alert-warning">
    <h5 class="mb-2">접근이 제한되었습니다.</h5>
    <div>${error != null ? error : '권한이 없습니다.'}</div>

    <!-- 디버그: 현재 세션 상태 -->
    <div class="small text-muted mt-2">
      [debug] isAdmin=${isAdmin} / session.isAdmin=${dbg_admin} / session.user=${dbg_user}
    </div>
  </div>
  <a class="btn btn-secondary" href="${pageContext.request.contextPath}/inquiry/list">목록으로</a>
</div>
</body>
</html>
