<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
	<title>회원관리</title>
	<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
</head>

<body style="margin:0; padding:0; display: flex; flex-direction: column; height: 100vh;">
   <%@ include file="/WEB-INF/views/include/top_nav.jsp"%>

    <div class="d-flex">
        <%@ include file="/WEB-INF/views/include/left_nav.jsp"%>
        <div class="flex-grow-1">

			<div class="container mt-4">
				<h2 class="mb-3">통계 페이지</h2>

				<!-- 기간 선택 -->
				<div style="margin-bottom: 15px; display:flex; align-items:center; gap:10px;">
					<label>시작일: <input type="date" id="startDate"></label>
					<label>종료일: <input type="date" id="endDate"></label>
					<button id="searchBtn">조회</button>
					<button onclick="loadStats()">전체</button>
				</div>

				<!-- 그래프 -->
				<div class="chart-container">
					<div class="chart-box">
						<canvas id="doughnutChart"></canvas>
					</div>
					<div class="chart-box">
						<canvas id="barChart"></canvas>
					</div>
				</div>

				<%@ include file="/WEB-INF/views/include/footer.jsp"%>
			</div>
        </div>
    </div>




<script>
	Chart.register(ChartDataLabels);
	let doughnutChart = null;
	let barChart = null;

	function loadStats(startDate, endDate){
		let url = '${pageContext.request.contextPath}/statsData';
		if(startDate && endDate){
			url += `?startDate=${startDate}&endDate=${endDate}`;
		}
		
		fetch(url)
			.then(res => res.json())
			.then(res => {
				console.log(res);
				const data = res.data;
				if(!data || data.length === 0){
					console.warn("데이터가 없습니다.");
					return;
				}

				// -----------[도넛 그래프]-----------
				data.sort((a, b) => b.totalCount - a.totalCount);

				const top10 = data.slice(0, 10);
				const etc = data.slice(10);
				const etcSum = etc.reduce((sum, item) => sum + item.totalCount, 0);

				const doughnutLabels = top10.map(d => d.keyword);
				const doughnutData = top10.map(d => d.totalCount);

				if(etcSum > 0){
					doughnutLabels.push("기타");
					doughnutData.push(etcSum);
				}
				
				const doughnutCtx = document.getElementById('doughnutChart').getContext('2d')
				if(doughnutChart) doughnutChart.destroy();
				doughnutChart = new Chart(doughnutCtx, {
					type: 'doughnut',
					data: {
						labels: doughnutLabels,
						datasets: [{
							data: doughnutData,
							backgroundColor: [
								'#FF6384','#36A2EB','#FFCE56','#4BC0C0','#9966FF',
								'#FF9F40','#C9CBCF','#8A89A6','#FF6F61','#9CCC65','#AAAAAA'
							],
							datalabels: {
							    color: '#fff',       
							    font: { weight: 'bold', size: 16 },
							    display: true,
							    anchor: 'center',
							    align: 'center',
							    offset: 0,           // 라벨 위치 조정						    
							    formatter: (value, context) => {
							        const data = context.dataset.data;           // dataset 데이터 배열
							        const total = data.reduce((a,b)=>a+b,0);    // 전체 합
							        const currentValue = data[context.dataIndex]; // 현재 값
							        const percent = total ? ((currentValue / total) * 100).toFixed(1) : 0;
									console.log("라벨커런트값: ", currentValue, "라벨퍼센트: ", percent);

							       // return `${currentValue} (${percent}%)`;
							        return `${currentValue}`;
							    }
							}
						}]
					},
					options: { 
						responsive: true,
						maintainAspectRatio: false,
						plugins: {
							title: {
								display: true,
								text: 'TOP10 키워드 클릭 비율'
							},
							legend: { position: 'top' },
							tooltip:{
								callbacks:{
									label: function(context){
										const dataset = context.dataset.data;
										const total = context.dataset.data.reduce((a,b)=>a+b,0);
										const value = context.raw;
										const percent = total ? ((value / total) * 100).toFixed(1) : 0;
										console.log("옵션토탈: ", total, "옵션현재 값: ", value, "옵션퍼센트: ", percent);
									//	return `${context.label}: ${value} (${percent}%)`;
										return `${context.label}: ${value} `;
									}
								}
							}
						}
					}
				});

				// -----------[막대 그래프]-----------
				const barCtx = document.getElementById('barChart').getContext('2d');
				const barData = data.slice(10, 25);
				const etcBarSum = data.slice(25).reduce((sum, d) => sum + d.totalCount, 0);
				const barLabels = barData.map(d => d.keyword);
				const barCounts = barData.map(d => d.totalCount);

				if(etcBarSum > 0){
					barLabels.push("기타");
					barCounts.push(etcBarSum);
				}

				if(barChart) barChart.destroy();
				barChart = new Chart(barCtx, {
					type: 'bar',
					data: {
						labels: barLabels,
						datasets: [{
							label: '클릭 수',
							data: barCounts,
							backgroundColor:'#36A2EB'
						}]
					},
					options: {
						responsive:true,
						maintainAspectRatio: false,
						plugins:{
							title: {display:true, text: '11~25위 키워드 클릭 수'},
							legend: {display: false}
						},
						scales:{y:{beginAtZero:true}}
					}
				});
			})
			.catch(err => {
				console.error("데이터 로드 실패: ", err);
				alert("통계 데이터를 불러오지 못했습니다.");
			});
	}

	// 페이지 로드시 전체 데이터
	window.onload = () => loadStats();

	// 기간 조회 버튼
	document.getElementById('searchBtn').onclick = () => {
		const start = document.getElementById('startDate').value;
		const end = document.getElementById('endDate').value;
		if(!start || !end){
			alert("기간을 선택해주세요.");
			return;
		}
		loadStats(start, end);
	}
</script>
</body>
</html>
