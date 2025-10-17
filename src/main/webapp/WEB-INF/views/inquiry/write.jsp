<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>문의 작성</title>
<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />

<style>
.card { border: 1px solid #e5e7eb; border-radius: 12px; background: #fff; margin-bottom:16px; }
.card-header { padding: 12px 16px; border-bottom: 1px solid #eef0f3; font-weight: 600; }
.card-body { padding: 16px; }
.grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
@media (max-width: 576px) { .grid { grid-template-columns: 1fr; } }
.cell { border: 1px dashed #e5e7eb; border-radius: 10px; padding: 12px 14px; background: #fcfcfd; }
.cell label { display: block; font-size: 12px; color: #6b7280; margin-bottom: 6px; }
.form-control { width: 100%; padding: 8px 10px; border: 1px solid #d1d5db; border-radius: 8px; }
.btn { display: inline-block; border: 1px solid #d1d5db; background: #fff; padding: 6px 12px; border-radius: 8px; text-decoration: none; color: #111; }
.btn:hover { background: #f5f6f8; }
.btn-primary { background: #2563eb; border-color: #2563eb; color: #fff; }
.btn-primary:hover { background: #1d4ed8; }
.btn-sm { padding: 4px 10px; font-size: 12px; }
.text-muted { color: #6b7280; font-size: 12px; }
</style>
</head>

<body style="margin: 0; padding: 0; display: flex; flex-direction: column; min-height: 100vh;">

	<%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

	<div class="d-flex" style="flex: 1 0 auto;">
		<%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

		<div class="flex-grow-1">
			<div class="content-wrapper">

				<!-- 헤더 -->
				<section class="content-header">
					<h2 class="fw-bold mb-1">문의 작성</h2>
					<ol class="breadcrumb">
						<li><a href="${pageContext.request.contextPath}/inquiry/list">문의 목록</a></li>
						<li class="active">작성</li>
					</ol>
				</section>

				<section class="content">

					<!-- 작성 카드 -->
					<div class="card">
						<div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
							<span>새 글 쓰기</span>
							<a href="${pageContext.request.contextPath}/inquiry/list" class="btn btn-sm">← 목록</a>
						</div>

						<div class="card-body">
							<form id="writeForm" method="post" action="${pageContext.request.contextPath}/inquiry/write">
								<div class="grid">

									<!-- 제목 -->
									<div class="cell">
										<label>제목 <span style="color: #dc2626">*</span></label>
										<input type="text" name="title" class="form-control" maxlength="255"
											   placeholder="제목을 입력하세요." required />
									</div>

									<!-- 작성자 -->
									<div class="cell">
										<label>작성자 <span style="color: #dc2626">*</span></label>
										<c:choose>
											<c:when test="${not empty currentWriter}">
												<input type="text" name="writer" class="form-control"
													   value="${currentWriter}" readonly />
												<small class="text-muted">로그인 정보로 자동 입력됨</small>
											</c:when>
											<c:otherwise>
												<input type="text" name="writer" class="form-control"
													   maxlength="100" placeholder="이름(닉네임)을 입력하세요." required />
											</c:otherwise>
										</c:choose>
									</div>

									<!-- 카테고리 -->
									<div class="cell">
										<label>카테고리</label>
										<select name="category" class="form-control">
											<option value="">선택 (선택사항)</option>
											<option value="일반문의">일반문의</option>
											<option value="결제문의">결제문의</option>
											<option value="버그제보">버그제보</option>
											<option value="기능요청">기능요청</option>
										</select>
									</div>

									<!-- 비밀글 -->
									<div class="cell">
										<label>비밀글</label>
										<div style="display: flex; align-items: center; gap: 8px;">
											<input type="checkbox" id="secretCheck" />
											<span class="text-muted">🔒 비밀글로 등록 (관리자/작성자만 열람)</span>
										</div>
										<input type="hidden" name="secret" id="secretField" value="0" />
									</div>

									<!-- 내용 -->
									<div class="cell" style="grid-column: 1/-1;">
										<label>내용 <span style="color: #dc2626">*</span></label>
										<textarea name="content" class="form-control" rows="10"
												  placeholder="내용을 입력하세요." required></textarea>
									</div>
								</div>

								<div style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 12px;">
									<button type="submit" class="btn btn-primary">등록</button>
									<a href="${pageContext.request.contextPath}/inquiry/list" class="btn">취소</a>
								</div>
							</form>
						</div>
					</div>

					<!-- 하단 세션 / 관리자 토글 -->
					<div class="card">
						<div class="card-body" style="display: flex; justify-content: space-between; align-items: center;">
							<div class="text-muted">
								<b>현재 사용자:</b> <span class="text-primary">
									${sessionScope.id != null ? sessionScope.loginId : (sessionScope.username != null ? sessionScope.username : '비로그인')}
								</span> &nbsp;|&nbsp;
								<b>관리자:</b> 
								<span class="text-danger">
									<c:choose>
										<c:when test="${sessionScope.isAdmin or (sessionScope.role != null and (sessionScope.role == 'admin' or sessionScope.role == 'ADMIN' or sessionScope.role == 'ROLE_ADMIN'))}">ON</c:when>
										<c:otherwise>OFF</c:otherwise>
									</c:choose>
								</span>
							</div>
							<div>
								<a href="${pageContext.request.contextPath}/inquiry/dev/admin/on" class="btn btn-sm">관리자ON</a>
								<a href="${pageContext.request.contextPath}/inquiry/dev/admin/off" class="btn btn-sm">OFF</a>
							</div>
						</div>
					</div>

				</section>
			</div>

			<%@ include file="/WEB-INF/views/include/footer.jsp"%>
		</div>
	</div>

	<!-- 🔸비밀글 체크 연동 -->
	<script>
	(function() {
		const chk = document.getElementById('secretCheck');
		const fld = document.getElementById('secretField');
		if (chk && fld) {
			const sync = () => fld.value = chk.checked ? '1' : '0';
			chk.addEventListener('change', sync);
			sync();
		}

		const form = document.getElementById('writeForm');
		if (form) {
			form.addEventListener('submit', function(e) {
				const title = this.title.value.trim();
				const writer = this.writer.value.trim();
				const content = this.content.value.trim();
				if (!title || !writer || !content) {
					alert('제목/작성자/내용은 필수입니다.');
					e.preventDefault();
				}
			});
		}
	})();
	</script>
</body>
</html>
