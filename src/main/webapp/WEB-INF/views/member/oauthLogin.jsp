<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Redirecting...</title>
    <script type="text/javascript">
        window.location.href = "${url}";
    </script>
</head>
<body>
    <!-- 사용자가 자바스크립트를 꺼놨을 경우 대비 -->
    <noscript>
        <meta http-equiv="refresh" content="0;url=${url}" />
    </noscript>
</body>
</html>