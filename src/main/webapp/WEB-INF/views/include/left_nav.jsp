<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<!-- 좌측 네비바 -->
<div class="d-flex">
	<!-- Sidebar -->
	<nav class="d-flex flex-column flex-shrink-0 p-3 bg-light"
		style="width: 250px; min-height: 100vh;">

		<a href="/"
			class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
			<span class="fs-4">Dealarm</span>
		</a>
		<hr>
		<ul class="nav nav-pills flex-column">
			<li class="nav-item"><a href="/" class="nav-link active"
				aria-current="page"> 카테고리</a></li>

			<li><a href="/about" class="nav-link link-dark">아무거나</a></li>

			<li><a href="/shop" class="nav-link link-dark">누르지마</a></li>

			<li><a href="/contact" class="nav-link link-dark">오류나</a></li>
		</ul>

		<hr>
		<ul class="nav nav-pills flex-column mb-auto">
			<c:choose>
				<c:when test="${not empty sessionScope.id}">
					<li class="nav-item">
						<!-- My키워드 토글 --> <a class="nav-link dropdown-toggle" href="#"
						id="myKeywordDropdown"> My키워드 </a> <!-- 토글 시 열리는 영역 -->
						<div id="keywordSection" class="mt-2 p-3 bg-light border rounded"
							style="display: none; width: 100%;">

							<!-- 키워드 등록 -->
							<form id="addKeywordForm">
								<input type="hidden" name="userId" value="${sessionScope.id}" />
								<div class="mb-2">
									<input type="text" id="keyword" name="keyword"
										class="form-control" placeholder="키워드 입력" required />
								</div>
								<button type="submit" class="btn btn-primary w-100">추가</button>
							</form>

							<hr>
							<!-- 키워드 목록 -->
							<h6>내 키워드</h6>
							<ul id="keywordList" class="list-unstyled small"></ul>


						</div>
					</li>
				</c:when>

				<c:otherwise>
					<a href="${pageContext.request.contextPath}/member/login"
						class="btn btn-outline-primary w-100">로그인</a>
				</c:otherwise>
			</c:choose>
		</ul>

	</nav>

</div>

	<!-- =================[ end]============ -->

<script>
// My키워드 클릭 시 열고/닫기
const keywordToggle = document.getElementById('myKeywordDropdown');
const keywordSection = document.getElementById('keywordSection');

if (keywordToggle) {
    // 페이지 로딩 시 localStorage 값 확인
    if (localStorage.getItem("keywordOpen") === "true") {
        keywordSection.style.display = "block";
    }

    keywordToggle.addEventListener('click', function(e){
        e.preventDefault();
        e.stopPropagation();
        if (keywordSection.style.display === 'none' || keywordSection.style.display === '') {
            keywordSection.style.display = 'block';
            localStorage.setItem("keywordOpen", "true"); // 상태 저장
        } else {
            keywordSection.style.display = 'none';
            localStorage.setItem("keywordOpen", "false"); // 상태 저장
        }
    });
}


</script>


<script>
$(function() {
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
                    	let createdAtStr = k.createdAt ? new Date(k.createdAt).toLocaleString() : "날짜 없음";
//ver1
//              	htmls += "<li>" + k.id + ", " + k.userId + ", " + k.keyword + ", " + createdAtStr +
//                          " <button class='deleteBtn' data-id='" + k.id + "'>삭제</button></li>";

					htmls += "<li>" + k.keyword + "<button class='deleteBtn btn btn-sm p-0 text-danger' data-id='" + k.id + "' title='삭제'>" +
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

    loadKeywords(); // 페이지 로딩 시 키워드 리스트 불러오기
});
</script>



</body>
</html>
