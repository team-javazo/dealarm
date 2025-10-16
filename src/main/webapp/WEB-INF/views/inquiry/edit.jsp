<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <title>문의 수정</title>
  <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
</head>
<body style="margin:0; padding:0; display:flex; flex-direction:column; min-height:100vh;">

  <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

  <div class="d-flex" style="flex:1 1 auto;">
    <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

    <div class="flex-grow-1" style="padding:24px;">
      <div class="content-wrapper" style="background:#fff; border-radius:8px; box-shadow:0 2px 10px rgba(0,0,0,.05); padding:24px;">

        <section class="content-header" style="margin-bottom:16px;">
          <h2 class="fw-bold mb-1" style="border-bottom:2px solid #007bff; padding-bottom:8px;">문의 수정</h2>
          <ol class="breadcrumb">
            <li><a href="${pageContext.request.contextPath}/"><i class="fa fa-home"></i> 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/inquiry/list">문의 목록</a></li>
            <li class="active">수정</li>
          </ol>
        </section>

        <section class="content">
          <form method="post" action="${pageContext.request.contextPath}/inquiry/update">
            <input type="hidden" name="id" value="${dto.id}"/>

            <div class="form-group" style="margin-bottom:12px;">
              <label>제목</label>
              <input class="form-control" type="text" name="title" value="${dto.title}" required/>
            </div>

            <div class="form-group" style="margin-bottom:12px;">
              <label>작성자</label>
              <input class="form-control" type="text" value="${dto.writer}" readonly/>
              <small class="text-muted">작성자는 변경될 수 없습니다.</small>
            </div>

            <div class="form-group" style="margin-bottom:12px;">
              <label>내용</label>
              <textarea class="form-control" name="content" rows="8" required>${dto.content}</textarea>
            </div>

            <div class="form-group" style="margin-bottom:12px;">
              <div class="checkbox">
                <label>
                  <input type="checkbox" name="secret" value="true" <c:if test="${dto.secret}">checked</c:if> />
                  비밀글
                </label>
              </div>
            </div>

            <div class="text-end">
              <a class="btn btn-default" href="${pageContext.request.contextPath}/inquiry/detail?id=${dto.id}&hit=false">취소</a>
              <button class="btn btn-primary" type="submit">저장</button>
            </div>
          </form>
        </section>
      </div>

      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>
</body>
</html>
