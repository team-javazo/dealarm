<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<html>
<head>
<title>통계페이지</title>
<link href="${pageContext.request.contextPath}/resources/css/styles.css"
	rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body
	style="margin: 0; padding: 0; display: flex; flex-direction: column; height: 100vh;">

	<%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

	<div class="d-flex flex-grow-1">
		<%@ include file="/WEB-INF/views/include/left_nav.jsp"%>

		<div class="flex-grow-1 p-4 bg-light">

			<!-- 키워드 클릭 통계 -->
			<div class="card shadow-sm mb-4">
				<div class="card-header bg-primary text-white">
					<h2 class="mb-0">키워드별 클릭 통계</h2>
				</div>
				<div class="card-body">
					<form id="searchForm" class="row g-3 align-items-center mb-3">
						<div class="col-auto">
							<label for="startDate" class="col-form-label">시작일</label>
						</div>
						<div class="col-auto">
							<input type="date" id="startDate" class="form-control">
						</div>
						<div class="col-auto">
							<label for="endDate" class="col-form-label">종료일</label>
						</div>
						<div class="col-auto">
							<input type="date" id="endDate" class="form-control">
						</div>
						<div class="col-auto">
							<button type="button" id="searchBtn" class="btn btn-primary">조회</button>
						</div>
					</form>

					<div class="chart-container">
						<div class="card p-3 doughnut-card">
							<h3>TOP10 키워드 클릭</h3>
							<canvas id="doughnutChart"></canvas>
						</div>
						<div class="card p-3 bar-card">
							<h3>기타 키워드 클릭</h3>
							<canvas id="barChart"></canvas>
						</div>
					</div>
				</div>
			</div>

			<!-- 사용자 키워드 랭킹 -->
			<div class="card shadow-sm mb-4">
				<div class="card-header bg-success text-white">
					<h2 class="mb-0">사용자 키워드 랭킹</h2>
				</div>
				<div class="card-body">
					<form id="rankingForm" class="mb-3">
						<!-- 성별 -->
						<div class="mb-3">
							<label class="fw-bold me-3">성별:</label>
							<div class="form-check form-check-inline">
								<input class="form-check-input" type="radio" name="gender"
									value="all" checked> <label class="form-check-label">전체</label>
							</div>
							<div class="form-check form-check-inline">
								<input class="form-check-input" type="radio" name="gender"
									value="m"> <label class="form-check-label">남자</label>
							</div>
							<div class="form-check form-check-inline">
								<input class="form-check-input" type="radio" name="gender"
									value="f"> <label class="form-check-label">여자</label>
							</div>
						</div>

						<!-- 연령 -->
						<div class="mb-3">
							<label class="fw-bold me-3">연령:</label>
							<button type="button" id="selectAllAges"
								class="btn btn-sm btn-outline-secondary me-1">전체선택</button>
							<button type="button" id="deselectAllAges"
								class="btn btn-sm btn-outline-secondary me-3">전체해제</button>
							<div class="d-inline-flex flex-wrap align-items-center gap-2">
								<c:forEach var="age"
									items="${fn:split('0-9,10-19,20-29,30-39,40-49,50-59,60-69', ',')}">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="checkbox"
											name="ageGroup" value="${age}"> <label
											class="form-check-label"> <c:choose>
												<c:when test="${age eq '0-9'}">10대 이하</c:when>
												<c:otherwise>${fn:substring(age, 0, 2)}대</c:otherwise>
											</c:choose>
										</label>
									</div>
								</c:forEach>

								<button type="button" id="loadRanking" class="btn btn-success">조회</button>
							</div>
							

						</div>
					</form>

					<div class="rankChart-container">
						<canvas id="rankingBarChart"></canvas>
					</div>
				</div>
			</div>

		</div>
	</div>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>

	<script>
document.addEventListener("DOMContentLoaded", function() {
    loadStats();
    loadDefaultRanking();

    document.getElementById("searchBtn").addEventListener("click", loadStats);
    document.getElementById("loadRanking").addEventListener("click", loadRanking);

    document.getElementById("selectAllAges").addEventListener("click", function() {
        document.querySelectorAll('input[name="ageGroup"]').forEach(cb => cb.checked = true);
    });
    document.getElementById("deselectAllAges").addEventListener("click", function() {
        document.querySelectorAll('input[name="ageGroup"]').forEach(cb => cb.checked = false);
    });
});

var doughnutChart, barChart, rankingChart;

const doughnutColors = ['#FF6384','#36A2EB','#FFCE56','#4BC0C0','#9966FF','#FF9F40','#66FF66','#FF6666','#66FFFF','#FF66FF','#C0C0C0'];
const rankingColors = ['#FF6384','#36A2EB','#FFCE56','#4BC0C0','#9966FF','#FF9F40','#66FF66','#FF6666','#66FFFF','#FF66FF'];

function loadStats() {
    var startDate = document.getElementById("startDate").value || "2000-01-01";
    var endDate = document.getElementById("endDate").value || "2100-12-31";
    var url = "${pageContext.request.contextPath}/statsData?startDate=" + startDate + "&endDate=" + endDate;

    fetch(url)
        .then(res => { if(!res.ok) throw new Error("서버 에러: "+res.status); return res.json(); })
        .then(result => {
            var data = result.data;
            if(!data || data.length===0){ alert("통계 데이터가 없습니다."); return; }

            var labels = data.map(d=>d.keyword);
            var counts = data.map(d=>d.totalCount);

            var top10Labels = labels.slice(0,10);
            var top10Counts = counts.slice(0,10);
            var otherSum = counts.slice(10).reduce((a,b)=>a+b,0);
            if(otherSum>0){ top10Labels.push("기타"); top10Counts.push(otherSum); }

            var barLabels = labels.slice(10,25);
            var barCounts = counts.slice(10,25);
            var otherBarSum = counts.slice(25).reduce((a,b)=>a+b,0);
            if(otherBarSum>0){ barLabels.push("기타"); barCounts.push(otherBarSum); }

            drawCharts(top10Labels, top10Counts, barLabels, barCounts);
        })
        .catch(err => alert(err.message));
}

function drawCharts(dLabels, dCounts, bLabels, bCounts){
    if(doughnutChart) doughnutChart.destroy();
    doughnutChart = new Chart(document.getElementById("doughnutChart").getContext("2d"), {
        type:"doughnut",
        data:{ labels:dLabels, datasets:[{data:dCounts, backgroundColor:dLabels.map((_,i)=>doughnutColors[i % doughnutColors.length])}]},
        options:{
            responsive:true,
            maintainAspectRatio:true,
            plugins:{
                tooltip:{callbacks:{label:ctx=>{
                    const total=dCounts.reduce((a,b)=>a+b,0);
                    const val=ctx.parsed||0;
                    const percent=total?((val/total)*100).toFixed(1):0;
                    return ctx.label+": "+val+" ("+percent+"%)";
                }}},
                legend:{position:"right"}
            }
        }
    });

    if(barChart) barChart.destroy();
    barChart = new Chart(document.getElementById("barChart").getContext("2d"), {
        type:"bar",
        data:{ labels:bLabels, datasets:[{label:"클릭 수", data:bCounts, backgroundColor:bLabels.map((_,i)=>doughnutColors[i % doughnutColors.length])}]},
        options:{
            responsive:true,
            maintainAspectRatio:false, // 카드에 맞춤
            scales:{y:{beginAtZero:true}},
            plugins:{legend:{display:false}}
        }
    });
}

function loadDefaultRanking() {
    fetch("${pageContext.request.contextPath}/keywords/ranking/default")
    .then(res=>{if(!res.ok)throw new Error("서버 에러: "+res.status); return res.json();})
    .then(data=>{
        if(!data.keywordRankings || data.keywordRankings.length===0){ if(rankingChart) rankingChart.destroy(); return; }
        var labels = data.keywordRankings.map(k=>k.keyword);
        var counts = data.keywordRankings.map(k=>k.frequency||k.count);
        drawRankingChart(labels, counts);
    })
    .catch(err=>console.log(err.message));
}

function loadRanking() {
    var gender = document.querySelector('input[name="gender"]:checked')?.value || 'all';
    var ageChecked = Array.from(document.querySelectorAll('input[name="ageGroup"]:checked')).map(cb=>cb.value);
    if(ageChecked.length===0){ alert("연령 그룹을 최소 하나 선택해 주세요."); return; }

    var ages = ageChecked.flatMap(a=>a.split('-').map(Number));
    var startAge = Math.min(...ages);
    var endAge = Math.max(...ages);

    var url = "${pageContext.request.contextPath}/keywords/ranking?gender="+encodeURIComponent(gender)+"&startAge="+encodeURIComponent(startAge)+"&endAge="+encodeURIComponent(endAge);

    fetch(url)
    .then(res=>{if(!res.ok)throw new Error("서버 에러: "+res.status); return res.json();})
    .then(data=>{
        if(!data.keywordRankings || data.keywordRankings.length===0){ alert("데이터가 없습니다."); if(rankingChart) rankingChart.destroy(); return; }
        var labels = data.keywordRankings.map(k=>k.keyword);
        var counts = data.keywordRankings.map(k=>k.frequency||k.count);
        drawRankingChart(labels, counts);
    })
    .catch(err=>alert(err.message));
}

function drawRankingChart(labels, counts){
    if(rankingChart) rankingChart.destroy();
    rankingChart = new Chart(document.getElementById("rankingBarChart").getContext("2d"), {
        type:"bar",
        data:{ labels:labels, datasets:[{label:"등록 수", data:counts, backgroundColor:labels.map((_,i)=>rankingColors[i % rankingColors.length])}]},
        options:{
            responsive:true,
            maintainAspectRatio:true,
            scales:{y:{beginAtZero:true}},
            plugins:{legend:{display:false}}
        }
    });
}
</script>

</body>
</html>