<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>

    <meta charset="UTF-8">

    <title>마이페이지</title>


    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />

    <!-- ✅ MyPage 전용 스타일 (충돌 방지용 내부 정의) -->
    <style>
        /* ✅ 마이페이지 정보와 그래프 영역 자동 균형 */
        .info-graph-container {
            display: flex;
            justify-content: space-between;
            align-items: stretch; /* 두 영역 높이 동일 */
            gap: 2rem;
            flex-wrap: wrap; /* 화면이 좁으면 자동 줄바꿈 */
        }

        .info-section {
            flex: 1 1 55%;
            min-width: 350px;
        }

        .graph-wrapper {
            flex: 1 1 40%;
            min-width: 320px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        /* 그래프 카드 스타일 통일 */
        .graph-wrapper .card {
            height: 100%;
            margin-bottom: 0; /* 카드 하단 여백 제거 */
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        /* 그래프 크기 자동 맞춤 */
        .graph-wrapper canvas {
            width: 100% !important;
            height: 100% !important;
            object-fit: contain;
        }

        @media (max-width: 768px) {
            .info-graph-container {
                flex-direction: column;
            }
            .graph-wrapper {
                margin-top: 20px;
            }
        }
    </style>
</head>

<body style="margin:0; padding:0; display:flex; flex-direction:column; height:100vh;">

    <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

    <div class="d-flex">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

        <div class="flex-grow-1">
            <%@ include file="/WEB-INF/views/include/banner.jsp"%>

            <!-- =================[마이페이지 본문]================= -->
            <div class="container mt-5">
                <div class="card shadow-sm p-4">
                    <h2 class="card-title text-start mb-4">마이페이지</h2>

                    <!-- ✅ 정보 / 그래프 가로 정렬 컨테이너 -->
                    <div class="info-graph-container">
                        
                        <!-- 왼쪽 : 회원정보 -->
                        <div class="info-section">
                            <table class="table table-bordered align-middle mb-0">
                                <tbody>
                                    <tr><th style="width:150px;" class="text-center">아이디</th><td>${user.id}</td></tr>
                                    <tr><th class="text-center">비밀번호</th><td>*******</td></tr>
                                    <tr><th class="text-center">이름</th><td>${user.name}</td></tr>
                                    <tr><th class="text-center">전화번호</th><td>${user.phone}</td></tr>
                                    <tr><th class="text-center">이메일</th><td>${user.email}</td></tr>
                                    <tr><th class="text-center">생년월일</th><td>${user.birth_date}</td></tr>
                                    <tr>
                                        <th class="text-center">성별</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.gender == 'male'}">남자</c:when>
                                                <c:otherwise>여자</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="text-center">알림 수신 여부</th>
                                        <td>
                                            <label class="me-2">
                                                <input type="radio" name="notification" value="1"
                                                    <c:if test="${user.notification == 1}">checked</c:if> disabled> 동의
                                            </label>
                                            <label>
                                                <input type="radio" name="notification" value="0"
                                                    <c:if test="${user.notification != 1}">checked</c:if> disabled> 동의하지 않음
                                            </label>
                                        </td>
                                    </tr>
                                    <tr><th class="text-center">지역</th><td>${user.region}</td></tr>
                                    <tr><th class="text-center">권한</th><td>${user.role}</td></tr>
                                    <tr><th class="text-center">가입일</th><td>${user.created_at}</td></tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 오른쪽 : 그래프 -->
                        <div class="graph-wrapper">
                            <%@ include file="/WEB-INF/views/include/Graph.jsp" %>
                        </div>
                    </div>

                    <!-- 버튼 영역 -->
                    <div class="mt-4 text-center">
                        <button type="button" class="btn btn-primary me-2" onclick="openPassModal()">수정</button>
                        <button type="button" class="btn btn-secondary" onclick="location.href='<c:url value="/main"/>'">홈으로</button>
                    </div>
                </div>
            </div>
            <!-- =================[마이페이지 본문 끝]================= -->

            <%@ include file="/WEB-INF/views/include/footer.jsp"%>
        </div>
    </div>

    <!-- =================[비밀번호 확인 모달]================= -->
    <div class="modal fade" id="passwordModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">비밀번호 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="password" id="inputPass" class="form-control" placeholder="비밀번호 입력">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="checkPassword()">확인</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>

    <!-- =================[스크립트 영역]================= -->
    <script>
        function openPassModal() {
            const modal = new bootstrap.Modal(document.getElementById('passwordModal'));
            modal.show();
        }

        function checkPassword() {
            const userId = "${user.id}";
            const inputPass = document.getElementById("inputPass").value.trim();
            if (!inputPass) return alert("비밀번호를 입력하세요.");

            const form = document.createElement("form");
            form.method = "post";
            form.action = "${pageContext.request.contextPath}/member/mypage_pass";

            const postId = document.createElement("input");
            postId.type = "hidden"; postId.name = "id"; postId.value = userId;
            form.appendChild(postId);

            const postPass = document.createElement("input");
            postPass.type = "hidden"; postPass.name = "password"; postPass.value = inputPass;
            form.appendChild(postPass);

            document.body.appendChild(form);
            form.submit();
        }

        <c:if test="${not empty passFail}">
            alert("비밀번호가 틀렸습니다.");
            const modal = new bootstrap.Modal(document.getElementById('passwordModal'));
            modal.show();
        </c:if>
    </script>

</body>
</html>
