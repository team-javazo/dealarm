<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header style="position: relative; height: 300px; max-width: 1220px; margin: 0 auto;">
    
    <!-- 배너 이미지 -->
    <div class="center-container">
        <img src="${pageContext.request.contextPath}/resources/images/header-bg.jpg"
             alt="배너"
             class="header-img">
    </div>

    <!-- 왼쪽 컨테이너: 소셜 트렌드 결과 -->
    <div class="left-container p-3 bg-white border rounded"
         style="width:300px; height:300px; overflow-y:auto;">
        <h6 class="fw-bold">소셜 트렌드 결과</h6>
        <!-- ✅ ol → ul 변경 -->
        <ul id="trendResultHeader" class="list-group small"></ul>
    </div>

    <!-- 오른쪽 컨테이너 -->
    <div class="right-container">
        <p>우측 컨텐츠</p>
    </div>

</header>

<script>
function loadSocialTrends() {
    var url = "/dong/trend/social"; // 컨트롤러 매핑 주소
    $.ajax({
        url: url,
        type: "GET",     // GET 방식
        dataType: "json", // JSON 응답 기대
        success: function(result) {
            var htmls = "";
            if (!result || result.length < 1) {
                htmls += "<li class='list-group-item'>데이터 없음</li>";
            } else {
                $(result).each(function(idx) {
                    // this = 배열 요소
                    var text = (typeof this === "string") ? this : JSON.stringify(this);
                    htmls += '<li class="list-group-item">';
                    htmls += (idx + 1) + ". " + text;
                    htmls += '</li>';
                });
            }
            $("#trendResultHeader").html(htmls);
        },
        error: function(err) {
            alert("에러 발생: " + JSON.stringify(err));
        }
    });
}

$(document).ready(function() {
    loadSocialTrends();
});

</script>
