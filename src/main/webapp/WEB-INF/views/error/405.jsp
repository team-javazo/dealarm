<%@ page contentType="text/html;charset=UTF-8" %>
<script>
    alert("잘못된 접근입니다. 메인으로 이동합니다.");
    location.href = "<%= request.getContextPath() %>/main";
</script>