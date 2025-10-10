<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
	
<div class="d-flex">
	<nav class="d-flex flex-column flex-shrink-0 p-3 bg-light"
		style="width: 250px; min-height: 700px;">

		<a href="/"
			class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
			<span class="fs-4">Dealarm</span>
		</a>
		<hr>

		<ul class="nav nav-pills flex-column">
<!-- 
			<li class="nav-item"><a href="/" class="nav-link active"
				aria-current="page">카테고리</a></li>
			<li><a href="/about" class="nav-link link-dark">아무거나</a></li>
			<li><a href="/shop" class="nav-link link-dark">누르지마</a></li>
			<li><a href="/contact" class="nav-link link-dark">오류나</a></li>
 -->
 			<li><a href="${pageContext.request.contextPath}/inquiry/list" class="nav-link link-dark">고객문의</a></li> 
			<li><a href="/dong/news" class="nav-link link-dark">뉴스 검색</a></li>
		</ul>


		<hr>

		<div class="p-3 bg-white border rounded mb-3"
			style="width: 100%; height: 300px; overflow-y: auto;">
			<h6 class="fw-bold">카테고리 인기 키워드</h6>

			<form id="trendForm" class="mb-2">
				<select id="gender" class="form-select mb-2">
					<option value="all">전체</option>
					<option value="m">남성</option>
					<option value="f">여성</option>
				</select>

				<select id="ages" multiple class="form-select mb-2">
					<option value="all">전체</option>
					<option value="10">10대</option>
					<option value="20">20대</option>
					<option value="30">30대</option>
					<option value="40">40대</option>
					<option value="50">50대</option>
					<option value="60">60대</option>
				</select>

				<button type="submit" class="btn btn-primary w-100">조회</button>
			</form>

				
			<%-- <ol id="trendResultSidebar"
				class="list-group list-group-numbered small"></ol> --%>
		</div>

		<ul class="nav nav-pills flex-column mb-auto">
			<c:choose>
				<c:when test="${not empty sessionScope.id}">
					<li class="nav-item"><a class="nav-link dropdown-toggle"
						href="#" id="myKeywordDropdown">My키워드</a>
						<div id="keywordSection" class="mt-2 p-3 bg-light border rounded"
							style="display: none; width: 100%;">
							<form id="addKeywordForm">
								<input type="hidden" name="userId" value="${sessionScope.id}" />
								<div class="mb-2">
									<input type="text" id="keyword" name="keyword"
										class="form-control" placeholder="키워드 입력" required />
								</div>
								<button type="submit" class="btn btn-primary w-100">추가</button>
							</form>
							<hr>
							<h6>내 키워드</h6>
							<ul id="keywordList" class="list-unstyled small"></ul>
						</div></li>
				</c:when>
				<c:otherwise>
					<a href="${pageContext.request.contextPath}/member/login"
						class="btn btn-outline-primary w-100">로그인</a>
				</c:otherwise>
			</c:choose>
		</ul>
	</nav>
</div>

<script>
// My키워드 클릭 시 열고/닫기
const keywordToggle = document.getElementById('myKeywordDropdown');
const keywordSection = document.getElementById('keywordSection');

if (keywordToggle) {
    if (localStorage.getItem("keywordOpen") === "true") {
        keywordSection.style.display = "block";
    }
    keywordToggle.addEventListener('click', function(e){
        e.preventDefault();
        e.stopPropagation();
        if (keywordSection.style.display === 'none' || keywordSection.style.display === '') {
            keywordSection.style.display = 'block';
            localStorage.setItem("keywordOpen", "true");
        } else {
            keywordSection.style.display = 'none';
            localStorage.setItem("keywordOpen", "false");
        }
    });
}
</script>

<script>
$(function() {
    // ------------------------------------
    // My 키워드 관리 로직 (기존 유지)
    // ------------------------------------
    const $keywordList = $("#keywordList");
    const userId = "${sessionScope.id}";
    const contextPath = "${pageContext.request.contextPath}";

    function loadKeywords() {
        $.ajax({
            url: contextPath + "/keywords/list?userId=" + userId,
            type: "GET",
            dataType: "json",
            success: function(response) {
                let htmls = "";
                if (response.keywords && response.keywords.length > 0) {
                    response.keywords.forEach(k => {
                        htmls += "<li>" + k.keyword +
                                 "<button class='deleteBtn btn btn-sm p-0 text-danger' data-id='" + k.id + "' title='삭제'>" +
                                 "<i class='bi bi-x-circle-fill'></i>" +
                                 "</button></li>";
                    });
                } else {
                    htmls = "<li>등록된 키워드가 없습니다.</li>";
                }
                $keywordList.html(htmls);
            },
            error: function() {
                alert("키워드 목록 불러오기 실패");
            }
        });
    }

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

    loadKeywords();


    // ------------------------------------
    // ✅ 카테고리별 인기 키워드 랭킹 로직 (수정 및 통합)
    // ------------------------------------
    
    // 페이지 로딩 시 기본값 설정
    var defaultGender = "all"; // 기본값: 전체 성별
    // 기본값: 10대부터 60대까지 모든 옵션의 'value' 배열
    var defaultAgeRange = ["10", "20", "30", "40", "50", "60"]; 

    // 기본값 설정
    $("#gender").val(defaultGender);
    // multiple select에 기본값 설정
    $("#ages").val(defaultAgeRange); 

    // 폼 제출 이벤트 핸들러
    $("#trendForm").on("submit", function(e) {
        e.preventDefault(); // 폼 기본 동작 방지

        // 성별과 연령 값 가져오기
        var gender = $("#gender").val();
        var ageRange = $("#ages").val(); // multiple 선택일 경우 배열로 반환

        var startAge, endAge;

        // ✅ "전체"가 선택된 경우
        if (ageRange.includes("all")) {
            startAge = 10;
            endAge = 100;
        } else {
            // 선택된 값 중 가장 작은/큰 값으로 범위 계산
            startAge = parseInt(ageRange[0], 10);
            endAge = parseInt(ageRange[ageRange.length - 1], 10) + 9;
        }
        
        // AJAX 요청
        $.ajax({
            url: contextPath + "/keywords/ranking", // 서버로 키워드 랭킹 요청
            type: "GET",
            data: {
                gender: gender, 
                startAge: startAge, 
                endAge: endAge 
            }, 
            success: function(response) {
                var html = "";
                if (response.keywordRankings && response.keywordRankings.length > 0) {
                    // 키워드 랭킹 결과 HTML 생성
                    response.keywordRankings.forEach(function(keyword) {
                        html += "<li class='list-group-item'>"
                            + keyword.keyword
                            + " - "
                            + keyword.frequency
                            + "회</li>";
                    });
                } else {
                    html = "<li class='list-group-item'>등록된 키워드가 없습니다.</li>";
                }

                // ✅ 결과 리스트 업데이트: 헤더와 사이드바 두 곳 모두 반영
                $("#trendResultHeader").html(html);  // 헤더의 결과
                $("#trendResultSidebar").html(html); // 사이드바의 결과
            },
            error: function(xhr, status, error) {
                console.log("Error:", xhr.responseText); 
                alert("키워드 랭킹 조회 실패");
            }
        });
    });

    // 페이지 로딩 시 기본값으로 전체 유저 키워드 랭킹 불러오기
    $("#trendForm").trigger("submit"); 
});
</script>