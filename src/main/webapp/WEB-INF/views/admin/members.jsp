<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>

<title>회원관리</title>
<!-- Bootstrap 5 CSS CDN -->
	<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
<style>
/* 전체 컨테이너 */
.d-flex {
    display: flex;
    flex: 1;
    overflow: hidden;
}

.flex-grow-1 {
    flex: 1;
    padding: 20px;
    overflow-y: auto;
}

/* 기간 설정 폼 */
#searchForm {
    margin-bottom: 20px;
}

#searchForm input,
#searchForm button {
    margin-right: 10px;
    padding: 5px 10px;
    font-size: 14px;
}

/* 그래프 컨테이너: 가로 배치, gap 유지 */
.chart-container {
    display: flex;
    gap: 20px;
    height: 50vh; /* 브라우저 창 기준 높이 */
}

/* 그래프 박스: 부모 크기에 맞춰 canvas 채움 */
.chart-box {
    flex: 1;
    position: relative;
    display: flex; /* canvas가 flex:1로 부모 채우도록 */
}

.chart-box canvas {
    flex: 1;
    width: 100% !important;
    height: 100% !important;
}
</style>
</head>
<body style="margin:0; padding:0; display: flex; flex-direction: column; height: 100vh;">

<%@ include file="/WEB-INF/views/include/top_nav.jsp"%>
<div class="d-flex">
    <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
    <div class="flex-grow-1">

        <h2>키워드별 클릭 통계</h2>

        <!-- 기간 설정 -->
        <form id="searchForm">
            시작일: <input type="date" id="startDate"> 
            종료일: <input type="date" id="endDate">
            <button type="button" id="searchBtn">조회</button>
        </form>

        <!-- 도넛 & 막대 그래프 -->
        <div class="chart-container">
            <div class="chart-box">
                <canvas id="doughnutChart"></canvas>
            </div>
            <div class="chart-box">
                <canvas id="barChart"></canvas>
            </div>
        </div>

    </div>

    <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    loadStats(); // 기본 전체기간 출력

    document.getElementById("searchBtn").addEventListener("click", function() {
        loadStats();
    });
});

function loadStats() {
    var startDate = document.getElementById("startDate").value || "2000-01-01";
    var endDate = document.getElementById("endDate").value || "2100-12-31";

    var url = "${pageContext.request.contextPath}/statsData?startDate=" + startDate + "&endDate=" + endDate;

    fetch(url)
        .then(function(res){
            if (!res.ok) throw new Error("서버 에러: " + res.status);
            return res.json();
        })
        .then(function(result){
            var data = result.data;

            if (!data || data.length === 0) {
                alert("통계 데이터가 없습니다.");
                return;
            }

            var labels = data.map(function(d){ return d.keyword; });
            var counts = data.map(function(d){ return d.totalCount; });

            // --- 도넛 (TOP 10 + 기타) ---
            var top10Labels = labels.slice(0,10);
            var top10Counts = counts.slice(0,10);
            var otherSum = counts.slice(10).reduce(function(a,b){ return a+b; }, 0);
            if (otherSum > 0) {
                top10Labels.push("기타");
                top10Counts.push(otherSum);
            }

            // --- 막대 (11~25위 + 기타) ---
            var barLabels = labels.slice(10,25);
            var barCounts = counts.slice(10,25);
            var otherBarSum = counts.slice(25).reduce(function(a,b){ return a+b; }, 0);
            if (otherBarSum > 0) {
                barLabels.push("기타");
                barCounts.push(otherBarSum);
            }

            drawCharts(top10Labels, top10Counts, barLabels, barCounts);
        })
        .catch(function(err){
            alert(err.message);
        });
}

var doughnutChart, barChart;

function drawCharts(dLabels, dCounts, bLabels, bCounts) {
    // 도넛 그래프
    if (doughnutChart) doughnutChart.destroy();
    var ctx1 = document.getElementById("doughnutChart").getContext("2d");
    doughnutChart = new Chart(ctx1, {
        type: "doughnut",
        data: {
            labels: dLabels,
            datasets: [{
                data: dCounts,
                backgroundColor: Array.from({length:dLabels.length}, function(_,i){ return 'hsl(' + (i*36) + ',70%,60%)'; })
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // 부모 크기에 맞게 조정
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(ctx) {
                            var total = dCounts.reduce(function(a,b){ return a+b; },0);
                            var val = ctx.parsed || 0;
                            var percent = total ? ((val / total) * 100).toFixed(1) : 0;
                            return ctx.label + ": " + val + " (" + percent + "%)";
                        }
                    }
                },
                legend: { position: "right" }
            }
        }
    });

    // 막대 그래프
    if (barChart) barChart.destroy();
    var ctx2 = document.getElementById("barChart").getContext("2d");
    barChart = new Chart(ctx2, {
        type: "bar",
        data: {
            labels: bLabels,
            datasets: [{
                label: "클릭 수",
                data: bCounts,
                backgroundColor: 'hsl(200,70%,60%)'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // 부모 크기에 맞게 조정
            scales: { y: { beginAtZero:true } },
            plugins: { legend:{ display:false } }
        }
    });
}
</script>

</body>
</html>