<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>회원 상세정보</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Favicon-->
<!--   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">		 -->
<!--    <link rel="icon" type="image/x-icon" href="assets/favicon.ico" /> -->
<!-- Bootstrap icons-->
<!--    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />   -->
<!-- Core theme CSS (includes Bootstrap)-->
<link href="${pageContext.request.contextPath}/resources/css/styles.css"
	rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">


</head>

<body
	style="margin: 0; padding: 0; display: flex; flex-direction: column; height: 100vh;">





	<%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

	<div class="d-flex">
		<%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
		<div class="flex-grow-1">
			<%@ include file="/WEB-INF/views/include/banner.jsp"%>
			<!-- =================[상세페이지]============ -->






			<div class="container d-flex justify-content-center mt-5 gap-4">
			    <div class="card shadow-sm" style="width: 500px;">
			        <div class="card-body">
			            <h2 class="card-title text-center mb-4">관리자 회원 상세 정보</h2>
			
			            <form action="${pageContext.request.contextPath}/member/adminupdate_ok" method="post">
			
			                <!-- 계정 상태 -->
			                <div class="mb-3">
			                    <label class="form-label">계정 상태</label><br/>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="is_active" value="1" 
			                            <c:if test="${user.is_active == 1}">checked</c:if> disabled>
			                        <label class="form-check-label">활성화</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="is_active" value="0"
			                            <c:if test="${user.is_active != 1}">checked</c:if> disabled>
			                        <label class="form-check-label">비활성화</label>
			                    </div>
			                </div>
			
			                <!-- 권한 -->
			                <div class="mb-3">
			                    <label class="form-label">권한</label><br/>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="role" value="USER"
			                            <c:if test="${user.role == 'USER'}">checked</c:if> disabled>
			                        <label class="form-check-label">회원</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="role" value="ADMIN"
			                            <c:if test="${user.role == 'ADMIN'}">checked</c:if> disabled>
			                        <label class="form-check-label">관리자</label>
			                    </div>
			                </div>
			
			                <!-- 알림 수신 여부 -->
			                <div class="mb-3">
			                    <label class="form-label">알림 수신 여부</label><br/>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="notification" value="1"
			                            <c:if test="${user.notification == 1}">checked</c:if> disabled>
			                        <label class="form-check-label">동의</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="notification" value="0"
			                            <c:if test="${user.notification != 1}">checked</c:if> disabled>
			                        <label class="form-check-label">동의하지 않음</label>
			                    </div>
			                </div>
			
			                <!-- 텍스트 입력 필드 -->
			                <div class="mb-3">
			                    <label for="name" class="form-label">이름</label>
			                    <input type="text" class="form-control" id="name" name="name" value="${user.name}"readonly>
			                </div>
			
			                <div class="mb-3">
			                    <label for="phone" class="form-label">핸드폰 번호</label>
			                    <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}"readonly>
			                </div>
			
			                <div class="mb-3">
			                    <label for="email" class="form-label">이메일</label>
			                    <input type="email" class="form-control" id="email" name="email" value="${user.email}"readonly>
			                </div>
			
			                <div class="mb-3">
			                    <label for="birth_date" class="form-label">나이</label>
			                    <input type="text" class="form-control" id="birth_date" name="birth_date" value="${user.birth_date}"readonly>
			                </div>
			
			                <div class="mb-3">
			                    <label for="gender" class="form-label">성별</label><br>						
									<div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="gender" value="male"
			                            <c:if test="${user.gender == 'male'}">checked</c:if> disabled>
			                        <label class="form-check-label">남자</label>
			                    </div>
			                    <div class="form-check form-check-inline">
			                        <input class="form-check-input" type="radio" name="gender" value="female"
			                            <c:if test="${user.gender == 'female'}">checked</c:if> disabled>
			                        <label class="form-check-label">여자</label>
			                    </div>
			                </div>
			
			                <div class="mb-3">
			                    <label for="region" class="form-label">지역</label>
			                    <input type="text" class="form-control" id="region" name="region" value="${user.region}"readonly>
			                </div>
			
			                <div class="mb-3">
			                    <label for="created_at" class="form-label">가입일</label>
			                    <input type="text" class="form-control" id="created_at" name="created_at" value="${user.created_at}"readonly>
			                </div>
			
			                <input type="hidden" name="id" value="${user.id}">
			
			                <!-- 버튼 -->
			                <div class="d-flex justify-content-between">
			                    <button type="button" class="btn btn-secondary" onclick="location.href='<c:url value="/member/members"/>'">목록으로</button>
			                </div>
			
			            </form>
			        </div>
			    </div>
<!-- ----------------------------------------[컨테이너 분할선 오른쪽 카드]------------------------------------------- -->
<!-- 
			    <div class="card shadow-sm" style="width: 500px;">
			        <div class="card-body">
			            <h2 class="card-title text-center mb-4">키워드</h2>
							<ul id="keywordList" class="list-unstyled small" style="min-height:150px; padding:0 10px;"></ul>
			        </div>
			    </div>
			</div>

 -->
 <div class="card shadow-sm" style="width: 500px;">
    <div class="card-body">
        <h2 class="card-title text-center mb-4">키워드</h2>

        <!-- 키워드 테이블 -->
        <table id="keywordTable" class="table table-sm table-bordered text-center">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>키워드</th>
                    <th>등록일</th>
                </tr>
            </thead>
            <tbody>
                <!-- JS에서 채움 -->
            </tbody>
        </table>
    </div>
</div>
 
 
			<!-- =================[상제정보 end]============ -->
		</div>
			<%@ include file="/WEB-INF/views/include/footer.jsp"%>
	</div>


<script>
$(function() {
    const $keywordList = $("#keywordList");
    const memberId = "${user.id}";
    const contextPath = "${pageContext.request.contextPath}";
		console.log("memberId:", memberId);
    
    function loadKeywords() {
        $.ajax({
            url: contextPath + "/keywords/memberKeyword?memberId=" + encodeURIComponent(memberId),
            type: "GET",
            dataType: "json",
            success: function(response) {
               
                console.log("keywords response:", JSON.stringify(response)); // 🔹 바꾼 부분
                let htmls = "";
                if (response.keywordList && response.keywordList.length > 0) {
                    response.keywordList.forEach((k, index) => {
                        let createdAtStr = k.createdAt ? new Date(k.createdAt).toLocaleString() : "날짜 없음";

                        htmls += "<tr>" +
                                    "<td>" + (index + 1) + "</td>" +
                                    "<td>" + k.keyword + "</td>" +
                                    "<td>" + createdAtStr + "</td>" +
                                 "</tr>";
                    });
                } else {
                    htmls = "<tr><td colspan='4'>등록된 키워드가 없습니다.</td></tr>";
                }

                $("#keywordTable tbody").html(htmls);
            },
            error: function() {
                alert("키워드 목록 불러오기 실패");
            }
        });
    }
            	
            	
            	
//            	let htmls = "";
//                if (response.keywordList && response.keywordList.length > 0) {
//                    response.keywordList.forEach(k => {
//                    	let createdAtStr = k.createdAt ? new Date(k.createdAt).toLocaleString() : "날짜 없음";
//ver1
//              	htmls += "<li>" + k.id + ", " + k.userId + ", " + k.keyword + ", " + createdAtStr +
//                          " <button class='deleteBtn' data-id='" + k.id + "'>삭제</button></li>";
//
//	ver2			htmls += "<li>" + k.keyword + "<button class='deleteBtn btn btn-sm p-0 text-danger' data-id='" + k.id + "' title='삭제'>" +
//			       		  	 "<i class='bi bi-x-circle-fill'></i></button></li>";
//					  console.log("keywords response:", response);
//                    });
//                } else {
//                    htmls = "<li>등록된 키워드가 없습니다.</li>";
//                }
//                $keywordList.html(htmls);
//                console.log(htmls);
//            },
//            error: function() {
//               alert("키워드 목록 불러오기 실패");
//            }
//        });
//    }

    $("#addKeywordForm").on("submit", function(e) {
        e.preventDefault();
        const keyword = $("#keyword").val().trim();
        if (!keyword) return alert("키워드를 입력해주세요.");

        $.ajax({
            url: contextPath + "/keywords/add",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({ userId: userId, keyword: keyword }),
            success: function(response) {
                if (response.success) {
                    $("#keyword").val("");
                    loadKeywords();
                } else {
                    alert(response.message);
                }
            },
            error: function() { alert("서버 오류"); }
        });
    });

    $(document).on("click", ".deleteBtn", function() {
        const keywordId = $(this).data("id");
        if (!confirm("삭제하시겠습니까?")) return;

        $.ajax({
            url: contextPath + "/keywords/delete/" + keywordId,
            method: "POST",
            success: function(response) {
                if (response.success) loadKeywords();
                else alert("삭제 실패");
            },
            error: function() { alert("서버 오류"); }
        });
    });

    loadKeywords(); // 페이지 로딩 시 키워드 리스트 불러오기
});
</script>




</body>
</html>