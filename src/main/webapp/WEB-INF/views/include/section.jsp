<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="alertListContainer">
    <h3>알림 목록</h3>
    <div id="alertList"></div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    loadAlerts();
});

function loadAlerts() {
    $.ajax({
        url: "${pageContext.request.contextPath}/alerts/ajaxList",
        type: "GET",
        dataType: "json",
        success: function(result) {
            let htmls = "";
            if(!result || result.length === 0) {
                htmls = "<p>등록된 알림이 없습니다.</p>";
            } else {
                result.forEach(function(alert) {
                    htmls += "<div>";
                    htmls += alert.title + " | 가격: " + alert.price + "원 | 사이트: " + alert.site;
                    htmls += " | 게시일: " + alert.postedAt + " | 등록일: " + alert.createdAt;
                    htmls += "</div>";
                });
            }
            $("#alertList").html(htmls);
        },
        error: function(err) {
            console.error("알림 로드 실패:", err.responseText || err);
        }
    });
}
</script>
