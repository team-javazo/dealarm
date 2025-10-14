<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<div class="card shadow-sm" style="border-radius:10px;">
    <div class="card-header bg-light text-center fw-bold">
        <i class="bi bi-bar-chart-line text-primary me-2"></i>키워드 클릭 통계
    </div>
    <div class="card-body" style="height:280px;">
        <canvas id="clickChart" style="width:100%; height:100%;"></canvas>
        <p id="noDataMsg" class="text-center text-muted mt-4" style="display:none;">클릭 데이터가 없습니다.</p>
    </div>
</div>

<script>
$(function() {
    const userId = "${user.id}";
    console.log("📊 [Graph.jsp] userId:", userId);

    $.ajax({
        url: "${pageContext.request.contextPath}/mypage/click-stats",
        type: "GET",
        data: { userId: userId },
        dataType: "json",
        success: function(data) {
            console.log("📊 [Ajax] 결과:", data);
            if (!data || data.length === 0) {
                $("#noDataMsg").show();
                return;
            }

            const labels = data.map(d => d.keyword);
            const counts = data.map(d => d.total_count);

            const ctx = document.getElementById("clickChart").getContext("2d");
            new Chart(ctx, {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [{
                        label: "클릭 횟수",
                        data: counts,
                        backgroundColor: "rgba(13, 110, 253, 0.5)",
                        borderColor: "rgba(13, 110, 253, 1)",
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        x: { grid: { display: false } },
                        y: { beginAtZero: true, ticks: { stepSize: 1 } }
                    },
                    plugins: { legend: { display: false } }
                }
            });
        },
        error: function(xhr, status, err) {
            console.error("❌ [Ajax] 데이터 로드 실패:", err);
        }
    });
});
</script>
