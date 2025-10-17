<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <title>문의 수정</title>
  <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
  <style>
    body { font-family:"Pretendard",sans-serif; background:#f9fafb; margin:0; padding:0; }
    .card { border:1px solid #e5e7eb; border-radius:12px; background:#fff; margin-bottom:16px; }
    .card-header { padding:12px 16px; border-bottom:1px solid #eef0f3; font-weight:600; background:#f7fafc; }
    .card-body { padding:16px; }
    .btn { display:inline-block; border:1px solid #d1d5db; background:#fff; padding:6px 12px; border-radius:8px; text-decoration:none; color:#111; font-size:13px; }
    .btn:hover { background:#f5f6f8; }
    .btn-primary { background:#2563eb; border-color:#2563eb; color:#fff; }
    .btn-primary:hover { background:#1d4ed8; }
    input[type=text], textarea, select {
      width:100%; padding:8px; border:1px solid #ddd; border-radius:6px; box-sizing:border-box;
    }
  </style>
</head>

<body style="display:flex; flex-direction:column; min-height:100vh;">
  <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

  <div class="d-flex" style="flex:1 0 auto;">
    <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

    <div class="flex-grow-1">
      <div class="content-wrapper">
        <section class="content-header">
          <h2 class="fw-bold mb-1">문의 수정</h2>
          <ol class="breadcrumb">
            <li><a href="${pageContext.request.contextPath}/inquiry/list">문의 목록</a></li>
          </ol>
        </section>

        <section class="content">
          <div class="card">
            <div class="card-header">문의 내용 수정</div>
            <div class="card-body">
              <form action="${pageContext.request.contextPath}/inquiry/edit" method="post">
                <input type="hidden" name="id" value="${dto.id}" />

                <label>카테고리</label>
                <select name="category" required>
                  <option value="일반문의" <c:if test="${dto.category eq '일반문의'}">selected</c:if>>일반문의</option>
                  <option value="버그제보" <c:if test="${dto.category eq '버그제보'}">selected</c:if>>버그제보</option>
                  <option value="계정문의" <c:if test="${dto.category eq '계정문의'}">selected</c:if>>계정문의</option>
                  <option value="기타" <c:if test="${dto.category eq '기타'}">selected</c:if>>기타</option>
                </select>

                <label style="margin-top:10px;">제목</label>
                <input type="text" name="title" value="${dto.title}" required />

                <label style="margin-top:10px;">내용</label>
                <textarea name="content" rows="8" required>${dto.content}</textarea>

                <label style="margin-top:10px;">비밀글 여부</label>
                <select name="secret">
                  <option value="false" <c:if test="${!dto.secret}">selected</c:if>>공개</option>
                  <option value="true" <c:if test="${dto.secret}">selected</c:if>>비밀글</option>
                </select>

                <div style="margin-top:20px; text-align:right;">
                  <button type="submit" class="btn-primary">수정 완료</button>
                  <c:url var="listUrl" value="/inquiry/list"/>
                  <a href="${listUrl}" class="btn" style="margin-left:8px;">취소</a>
                </div>
              </form>
            </div>
          </div>
        </section>
      </div>

      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>
</body>
</html>
