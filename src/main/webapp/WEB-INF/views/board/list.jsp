<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 리스트</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {margin:0;padding:0;height:100vh;display:flex;flex-direction:column;}
        .main-wrapper {flex-grow:1;display:flex;overflow:hidden;}
        nav.sidebar {width:250px;background:#f8f9fa;border-right:1px solid #ddd;padding:1rem;overflow-y:auto;}
        main.content {flex-grow:1;padding:2rem;overflow-y:auto;background:#fff;}
        .table th, .table td {vertical-align: middle;}
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/include/top_nav.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp" %>

        <!-- 게시판 본문 -->
        <main class="content">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0">게시판 리스트</h4>
                <div class="d-flex">
                    <!-- 🔍 검색창 -->
                    <form class="d-flex me-2" method="get" action="${pageContext.request.contextPath}/board/list">
                        <input type="text" class="form-control form-control-sm me-2" 
                               name="q" placeholder="검색어 입력" value="${q}">
                        <button type="submit" class="btn btn-outline-primary btn-sm">검색</button>
                    </form>
                    <!-- ✏️ 글쓰기 버튼 -->
                    <a href="${pageContext.request.contextPath}/board/write" class="btn btn-primary btn-sm">
                        <i class="bi bi-pencil-square"></i> 글쓰기
                    </a>
                </div>
            </div>

            <table class="table table-bordered table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th style="width:60px;">번호</th>
                        <th>제목</th>
                        <th style="width:120px;">작성자</th>
                        <th style="width:150px;">작성일</th>
                        <th style="width:80px;">조회수</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty boardList}">
                            <c:forEach var="board" items="${boardList}">
                                <tr>
                                    <td>${board.id}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/board/detail?id=${board.id}">
                                            ${board.title}
                                        </a>
                                        <c:if test="${board.notice}">
                                            <span class="badge bg-warning text-dark">공지</span>
                                        </c:if>
                                    </td>
                                    <td>${board.writer}</td>
                                    <td><fmt:formatDate value="${board.regdate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>${board.hit}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-center">등록된 글이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item disabled"><a class="page-link">Prev</a></li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">Next</a></li>
                </ul>
            </nav>
        </main>
    </div>

    <!-- My키워드 & 인기 키워드 AJAX 로직 -->
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
</body>
</html>
