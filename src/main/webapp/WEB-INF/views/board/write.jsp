<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 글쓰기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {margin:0;padding:0;height:100vh;display:flex;flex-direction:column;}
        .main-wrapper {flex-grow:1;display:flex;overflow:hidden;}
        nav.sidebar {width:250px;background:#f8f9fa;border-right:1px solid #ddd;padding:1rem;overflow-y:auto;}
        main.content {flex-grow:1;padding:2rem;overflow-y:auto;background:#fff;}
    </style>
</head>
<body>
    <!-- ✅ 상단 네비 -->
    <%@ include file="/WEB-INF/views/include/top_nav.jsp" %>

    <div class="main-wrapper">
        <!-- ✅ 좌측 사이드바 -->
        <%@ include file="/WEB-INF/views/include/left_nav.jsp" %>

        <!-- ✅ 본문: 글쓰기 폼 -->
        <main class="content">
            <h4 class="mb-3">게시판 글쓰기</h4>
            <form action="${pageContext.request.contextPath}/board/write" method="post">
                <div class="mb-3">
                    <label for="title" class="form-label">제목</label>
                    <input type="text" id="title" name="title" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="writer" class="form-label">작성자</label>
                    <input type="text" id="writer" name="writer" class="form-control" value="${sessionScope.id}" readonly>
                </div>
                <div class="mb-3">
                    <label for="content" class="form-label">내용</label>
                    <textarea id="content" name="content" class="form-control" rows="8" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">등록</button>
                <a href="${pageContext.request.contextPath}/board/list" class="btn btn-secondary">취소</a>
            </form>
        </main>
    </div>

    <!-- ✅ 스크립트 (My키워드 & 인기키워드 동일 유지) -->
    <script>
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

        var defaultGender = "all";
        var defaultAgeRange = ["10","20","30","40","50","60"];
        $("#gender").val(defaultGender);
        $("#ages").val(defaultAgeRange);
        $("#trendForm").on("submit", function(e) {
            e.preventDefault();
            var gender = $("#gender").val();
            var ageRange = $("#ages").val();
            var startAge = parseInt(ageRange[0],10);
            var endAge = parseInt(ageRange[ageRange.length-1],10)+9;
            $.ajax({
                url: contextPath + "/keywords/ranking",
                type: "GET",
                data: {gender:gender,startAge:startAge,endAge:endAge},
                success: function(response) {
                    var html = "";
                    if (response.keywordRankings && response.keywordRankings.length > 0) {
                        response.keywordRankings.forEach(function(keyword) {
                            html += "<li class='list-group-item'>" + keyword.keyword + " - " + keyword.frequency + "회</li>";
                        });
                    } else {
                        html = "<li class='list-group-item'>등록된 키워드가 없습니다.</li>";
                    }
                    $("#trendResultSidebar").html(html);
                },
                error: function() {
                    alert("키워드 랭킹 조회 실패");
                }
            });
        });
        $("#trendForm").trigger("submit");
    });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
