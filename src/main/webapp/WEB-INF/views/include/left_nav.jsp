<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<div class="d-flex">
    <!-- Sidebar -->
    <nav class="d-flex flex-column flex-shrink-0 p-3 bg-light"
         style="width: 250px; min-height: 100vh;">

        <a href="/"
           class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
            <span class="fs-4">Dealarm</span>
        </a>
        <hr>

        <!-- 네비 메뉴 -->
        <ul class="nav nav-pills flex-column">
            <li class="nav-item"><a href="/" class="nav-link active" aria-current="page">카테고리</a></li>
            <li><a href="/about" class="nav-link link-dark">아무거나</a></li>
            <li><a href="/shop" class="nav-link link-dark">누르지마</a></li>
            <li><a href="/contact" class="nav-link link-dark">오류나</a></li>
            <li><a href="/dong/news" class="nav-link link-dark">뉴스 검색</a></li>
        </ul>

        <hr>

        <!-- ✅ 카테고리 인기 키워드 블록 -->
        <div class="p-3 bg-white border rounded mb-3"
             style="width: 100%; height: 300px; overflow-y: auto;">
            <h6 class="fw-bold">카테고리 인기 키워드</h6>

            <!-- 선택 폼 -->
            <form id="trendForm" class="mb-2">
                <select id="category" class="form-select mb-2">
                    <option value="50000000">패션의류</option>
                    <option value="50000001">패션잡화</option>
                    <option value="50000002">화장품/미용</option>
                    <option value="50000003">디지털/가전</option>
                    <option value="50000004">가구/인테리어</option>
                    <option value="50000005">출산/육아</option>
                    <option value="50000006">식품</option>
                    <option value="50000007">스포츠/레저</option>
                    <option value="50000008">생활/건강</option>
                    <option value="50000009">자동차용품</option>
                    <option value="50000010">도서/음반/DVD</option>
                </select>

                <select id="gender" class="form-select mb-2">
                    <option value="all">전체</option>
                    <option value="m">남성</option>
                    <option value="f">여성</option>
                </select>

                <select id="ages" multiple class="form-select mb-2">
                    <option value="10">10대</option>
                    <option value="20">20대</option>
                    <option value="30">30대</option>
                    <option value="40">40대</option>
                    <option value="50">50대</option>
                    <option value="60">60대</option>
                </select>

                <button type="submit" class="btn btn-primary w-100">조회</button>
            </form>

            <!-- ✅ id 수정 -->
            <ol id="trendResultSidebar" class="list-group list-group-numbered small"></ol>
        </div>

        <!-- My키워드 섹션 -->
        <ul class="nav nav-pills flex-column mb-auto">
            <c:choose>
                <c:when test="${not empty sessionScope.id}">
                    <li class="nav-item">
                        <a class="nav-link dropdown-toggle" href="#" id="myKeywordDropdown">My키워드</a>
                        <div id="keywordSection" class="mt-2 p-3 bg-light border rounded"
                             style="display:none; width:100%;">
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

<!-- =================[ SCRIPT ]============ -->
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
});
</script>
