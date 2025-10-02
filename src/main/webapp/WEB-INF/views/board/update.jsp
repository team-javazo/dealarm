<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
  <title>글 수정</title>
</head>
<body>
<h2>글 수정</h2>
<form method="post" action="${pageContext.request.contextPath}/board/update">
  <input type="hidden" name="id" value="${dto.id}">
  제목: <input type="text" name="title" value="${dto.title}" size="50"><br><br>
  작성자: <input type="text" name="writer" value="${dto.writer}"><br><br>
  내용:<br>
  <textarea name="content" rows="10" cols="60">${dto.content}</textarea><br><br>
  <input type="submit" value="수정완료">
</form>
<a href="${pageContext.request.contextPath}/board/detail/${dto.id}">돌아가기</a>
</body>
</html>
