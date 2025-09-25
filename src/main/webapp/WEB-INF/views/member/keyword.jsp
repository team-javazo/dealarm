<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
	<title>키워드 관리</title>
	<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
	
</head>
<body style="margin:0; padding:0; display: flex; flex-direction: column; height: 100vh;">

 
    <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

    <div class="d-flex">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
        <div class="flex-grow-1">
            <%@ include file="/WEB-INF/views/include/banner.jsp"%>
            <!-- =================[키워드]============ -->





<h3>키워드 등록</h3>
<form id="addKeywordForm">
    <input type="hidden" name="userId" value="${sessionScope.id}" />
    <input type="text" id="keyword" name="keyword" placeholder="키워드 입력" required />
    <button type="submit">추가</button>
</form>

<h3>키워드 관리</h3>
<ul id="keywordList"></ul>

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
                        htmls += "<li>" + k.id + ", " + k.userId + ", " + k.keyword + ", " + createdAtStr +
                                 " <button class='deleteBtn' data-id='" + k.id + "'>삭제</button></li>";
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

          <!-- =================[ end]============ -->
            <%@ include file="/WEB-INF/views/include/footer.jsp"%>
        </div>
    </div>

</body>
</html>
