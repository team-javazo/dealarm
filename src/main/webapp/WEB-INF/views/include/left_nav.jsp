<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<div class="d-flex">
	<nav class="d-flex flex-column flex-shrink-0 p-3 bg-light"
		style="width: 250px; min-height: 700px;">

		<a href="/"
			class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
			<span class="fs-4">Dealarm</span>
		</a>
		<hr>

		<ul class="nav nav-pills flex-column">
			<li><a href="${pageContext.request.contextPath}/inquiry/list"
				class="nav-link link-dark">고객문의</a></li>
			<li><a href="/dong/news" class="nav-link link-dark">뉴스 검색</a></li>
			<li><a href="/dong/newDeal" class="nav-link link-dark">NEW
					DEAL </a></li>
		</ul>
		<hr>
		<div class="p-3 bg-white border rounded mb-3"
			style="width: 100%; max-height: 400px; overflow-y: auto;">

			<h6 class="fw-bold" id="trendToggle" style="cursor: pointer;">
				카테고리 인기 키워드 <i class="bi bi-chevron-down"></i>
			</h6>

			<div id="trendSection" style="display: block;">

				<form id="trendForm" class="mb-2">
					<select id="gender" class="form-select mb-2">
						<option value="all">전체</option>
						<option value="m">남성</option>
						<option value="f">여성</option>
					</select>  <select id="ages" multiple class="form-select mb-2">
						<option value="all">전체</option>
						<option value="10">10대</option>
						<option value="20">20대</option>
						<option value="30">30대</option>
						<option value="40">40대</option>
						<option value="50">50대</option>
						<option value="60">60대</option>
					</select>

					<button type="submit" class="btn btn-primary w-100">조회</button>
				</form>

			</div>
		</div>


		<%-- 🆕 My 키워드 기반 추천 섹션 (로그인 시 노출) --%>
		<c:if test="${not empty sessionScope.id}">
			<div class="p-3 bg-white border rounded mb-3"
				style="width: 100%; max-height: 250px; overflow-y: auto;">

				<h6 class="fw-bold" id="myRecommendationToggle"
					style="cursor: pointer;">
					My 키워드 기반 추천 <i class="bi bi-chevron-down"></i>
				</h6>

				<div id="myRecommendationSection" style="display: none;">
					<ul id="myKeywordRecommendation"
						class="list-group list-group-flush small">
						<li class="list-group-item px-0 py-1">추천 키워드를 로딩 중입니다...</li>
					</ul>
				</div>
			</div>
		</c:if>

		<div class="p-3 bg-white border rounded mb-3"
			style="width: 100%; max-height: 400px; overflow-y: auto;">
			<h6 class="fw-bold" id="relatedKeywordToggle"
				style="cursor: pointer;">
				🔎 연관 검색어 검색 <i class="bi bi-chevron-down"></i>
			</h6>

			<%-- ⬇️ 이 영역을 토글할 섹션으로 지정하고, id를 추가합니다. --%>
			<div id="relatedKeywordSection" style="display: none;">
				<form id="relatedKeywordForm" class="mb-2">
					<div class="input-group mb-2">
						<input type="text" id="mainKeyword" name="mainKeyword"
							class="form-control" placeholder="검색 키워드 입력" required>
						<button type="submit" class="btn btn-primary">
							<i class="bi bi-search"></i>
						</button>
					</div>
				</form>
				<hr>
				<h6 class="fw-bold small">연관 검색 결과</h6>
				<ul id="relatedKeywordResult"
					class="list-group list-group-flush small">
					<li class="list-group-item px-0 py-1">키워드를 검색해주세요.</li>
				</ul>
			</div>
			<%-- ⬆️ relatedKeywordSection 종료 --%>
		</div>

<%-- 🆕 My 키워드 섹션 (카드/토글 형태로 변경) --%>
<div class="mb-auto">
    <c:choose>
        <c:when test="${not empty sessionScope.id}">
            <div class="p-3 bg-white border rounded mb-3"
                 style="width: 100%; max-height: 400px; overflow-y: auto;">
                
                <%-- 토글 버튼: My키워드 제목 영역 --%>
                <h6 class="fw-bold" id="myKeywordToggle"
                    style="cursor: pointer;"
                    data-bs-toggle="collapse" 
                    data-bs-target="#keywordCollapseSection" 
                    aria-expanded="false" 
                    aria-controls="keywordCollapseSection">
                    🔑 My 키워드 <i class="bi bi-chevron-down"></i>
                </h6>

                <%-- ⬇️ 이 영역이 토글될 섹션입니다. (id: keywordCollapseSection) --%>
                <div id="keywordCollapseSection" class="collapse">
                    <hr>
                    <form id="addKeywordForm">
                        <input type="hidden" name="userId" value="${sessionScope.id}" />
                        <div class="mb-2">
                            <input type="text" id="keyword" name="keyword"
                                class="form-control form-control-sm" placeholder="키워드 입력" required />
                        </div>
                        <button type="submit" class="btn btn-primary btn-sm w-100">추가</button>
                    </form>
                    <hr>
                    <h6 class="fw-bold small">내 키워드 목록</h6>
                    <ul id="keywordList" class="list-unstyled small"></ul>
                </div>
                <%-- ⬆️ keywordCollapseSection 종료 --%>
            </div>
        </c:when>
        <c:otherwise>
            <div class="p-3"> <%-- 이 영역은 로그인 버튼을 감싸는 div입니다. --%>
                <a href="${pageContext.request.contextPath}/member/login"
                    class="btn btn-outline-primary w-100">로그인</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<%-- ⬆️ My 키워드 섹션 종료 --%>
	</nav>
</div>

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

//🔑 연관 검색어 클릭 시 열고/닫기 (새로 추가된 로직)
const relatedKeywordToggle = document.getElementById('relatedKeywordToggle');
const relatedKeywordSection = document.getElementById('relatedKeywordSection');

if (relatedKeywordToggle && relatedKeywordSection) {
    // 💡 localStorage에서 상태 불러와 적용
    if (localStorage.getItem("relatedKeywordOpen") === "true") {
        relatedKeywordSection.style.display = "block";
    }

    relatedKeywordToggle.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        // 💡 토글 로직
        if (relatedKeywordSection.style.display === 'none' || relatedKeywordSection.style.display === '') {
            relatedKeywordSection.style.display = 'block';
            localStorage.setItem("relatedKeywordOpen", "true");
        } else {
            relatedKeywordSection.style.display = 'none';
            localStorage.setItem("relatedKeywordOpen", "false");
        }
    });
}

//⭐ 카테고리 인기 키워드 클릭 시 열고/닫기 로직 (새로 추가)
const trendToggle = document.getElementById('trendToggle');
const trendSection = document.getElementById('trendSection');

if (trendToggle && trendSection) {
    // 기본적으로 펼쳐져 있게 하려면 아래 주석 처리
    trendSection.style.display = "block"; 
    
    // localStorage에서 상태 불러와 적용 (선택 사항)
    if (localStorage.getItem("trendOpen") === "false") {
        trendSection.style.display = "none";
    }

    trendToggle.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        if (trendSection.style.display === 'none' || trendSection.style.display === '') {
            trendSection.style.display = 'block';
            localStorage.setItem("trendOpen", "true");
        } else {
            trendSection.style.display = 'none';
            localStorage.setItem("trendOpen", "false");
        }
    });
}

//⭐ My 키워드 기반 추천 클릭 시 열고/닫기 로직 (새로 추가)
const myRecommendationToggle = document.getElementById('myRecommendationToggle');
const myRecommendationSection = document.getElementById('myRecommendationSection');

if (myRecommendationToggle && myRecommendationSection) {
    // 💡 localStorage에서 상태 불러와 적용 (선택 사항)
    if (localStorage.getItem("myRecOpen") === "true") {
        // localStorage에 'true'가 있으면 펼칩니다.
        myRecommendationSection.style.display = "block";
    } else {
        // localStorage에 값이 없거나 'false'인 경우, 
        // HTML의 기본값(display: none;)을 유지하여 접힌 상태로 시작합니다.
        myRecommendationSection.style.display = "none"; // 💡 명확하게 'none'으로 설정
    }

    myRecommendationToggle.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        // 💡 토글 로직
        if (myRecommendationSection.style.display === 'none' || myRecommendationSection.style.display === '') {
            myRecommendationSection.style.display = 'block';
            localStorage.setItem("myRecOpen", "true");
        } else {
            myRecommendationSection.style.display = 'none';
            localStorage.setItem("myRecOpen", "false");
        }
    });
}
</script>

<script>
$(function() {
	// ------------------------------------
	// 전역 변수 설정
	// ------------------------------------
	const $keywordList = $("#keywordList");
	const userId = "${sessionScope.id}"; 
	const contextPath = "${pageContext.request.contextPath}";
	const $relatedKeywordResult = $("#relatedKeywordResult");
	// 🔑 My 키워드 추천 영역 선택자 추가
	const $myKeywordRecommendation = $("#myKeywordRecommendation"); 


	// ------------------------------------
	// My 키워드 관리 로직
	// ------------------------------------
	function loadKeywords() {
        if (!userId) return; // 로그인 안 했으면 실행 안 함
        
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
				console.error("키워드 목록 불러오기 실패");
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
                    // 🔑 키워드 추가 후 추천 목록도 새로고침
                    loadMyKeywordRecommendation(); 
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
				if (response.success) {
                    loadKeywords();
                    // 🔑 키워드 삭제 후 추천 목록도 새로고침
                    loadMyKeywordRecommendation(); 
                }
				else alert("삭제 실패");
			},
			error: function() { alert("서버 오류"); }
		});
	});

	if (userId) loadKeywords(); // 로그인 했을 때만 키워드 로드


	// ------------------------------------
	// 카테고리별 인기 키워드 랭킹 로직
	// ------------------------------------
	
	// 기본값 설정 및 submit
	var defaultGender = "all"; 
	var defaultAgeRange = ["10", "20", "30", "40", "50", "60"]; 

	$("#gender").val(defaultGender);
	$("#ages").val(defaultAgeRange); 

	$("#trendForm").on("submit", function(e) {
		e.preventDefault(); 

		var gender = $("#gender").val();
		var ageRange = $("#ages").val(); 

		var startAge, endAge;

		if (ageRange.includes("all") || ageRange.length === 0) {
			startAge = 10;
			endAge = 100;
		} else {
            // 선택된 연령대를 오름차순 정렬 후 최소/최대 연령 범위 계산
            ageRange.sort((a, b) => parseInt(a) - parseInt(b));
			startAge = parseInt(ageRange[0], 10);
			endAge = parseInt(ageRange[ageRange.length - 1], 10) + 9; 
		}
		
		$.ajax({
			url: contextPath + "/keywords/ranking", 
			type: "GET",
			data: {
				gender: gender,	
				startAge: startAge,	
				endAge: endAge	
			},	
			success: function(response) {
				var html = "";
				if (response.keywordRankings && response.keywordRankings.length > 0) {
					response.keywordRankings.forEach(function(keyword) {
						html += "<li class='list-group-item d-flex justify-content-between align-items-start'>";
						 
						html += "	<div class='ms-2 me-auto'>"
							 +	 	 keyword.keyword
							 +	 	 " - "
							 +	 	 keyword.frequency
							 +	 	 "회"
							 +	 "</div>";
						html += "</li>";
					});
				} else {
					html = "<li class='list-group-item'>조회된 키워드가 없습니다.</li>";
				}

				$("#trendResultSidebar").html(html); 
			},
			error: function(xhr, status, error) {
				console.error("키워드 랭킹 조회 실패:", xhr.responseText);	
			}
		});
	});

	// 페이지 로딩 시 기본값으로 전체 유저 키워드 랭킹 불러오기
	$("#trendForm").trigger("submit");	
	
	// ------------------------------------
	// 🔑 My 키워드 기반 추천 키워드 자동 로딩 로직 (추가된 기능)
	// ------------------------------------
	function loadMyKeywordRecommendation() {
        if (!userId) return; // 로그인하지 않았으면 실행하지 않음
        
        $myKeywordRecommendation.html("<li class='list-group-item px-0 py-1'>My 키워드 분석 중...</li>"); 

		$.ajax({
			url: contextPath + "/keywords/related/user", // 💡 새로 추가한 엔드포인트 호출
			type: "GET",
			dataType: "json",
			success: function(response) {
				var html = "";
				
				if (!response.success) {
					html = "<li class='list-group-item px-0 py-1 text-danger'>" + (response.message || response.error || "알 수 없는 오류") + "</li>";
				} 
                else if (response.relatedKeywords && response.relatedKeywords.length > 0) {
					// 검색에 사용된 키워드 표시 (선택 사항) - 필요하다면 주석 해제하여 사용
                    // var searchKeywordsHtml = Array.isArray(response.searchKeywords) ? response.searchKeywords.join(', ') : (response.searchKeywords || 'N/A');
                    // html += '<li class="list-group-item px-0 py-1 text-muted small">💡 기반 키워드: ' + searchKeywordsHtml + '</li>';
                    
					// 연관 검색어 목록 표시
					$.each(response.relatedKeywords, function(i, relatedKeyword) {
						html += '<li class="list-group-item px-0 py-1" style="cursor:pointer;" data-keyword="' + relatedKeyword + '">'
							 +	 '<i class="bi bi-dot"></i> ' + relatedKeyword
							 +	 '</li>';
					});
				} else {
					html = "<li class='list-group-item px-0 py-1'>" + (response.message || "등록된 키워드가 없거나, 추천 키워드를 찾을 수 없습니다.") + "</li>";
				}

				$myKeywordRecommendation.html(html);
			},
			error: function(xhr, status, error) {
				console.error("My 키워드 연관 검색 실패:", xhr.responseText);
				$myKeywordRecommendation.html("<li class='list-group-item px-0 py-1 text-danger'>추천 키워드 조회 실패</li>");
			}
		});
	}

    // 🔑 페이지 로딩 시 My 키워드 추천 로딩
    if (userId) loadMyKeywordRecommendation();


	// ------------------------------------
	// 수동 입력 연관 검색어 검색 로직
	// ------------------------------------
	
	$("#relatedKeywordForm").on("submit", function(e) {
		e.preventDefault(); 

		var mainKeyword = $("#mainKeyword").val().trim();
		if (!mainKeyword) {
			$relatedKeywordResult.html("<li class='list-group-item px-0 py-1 text-danger'>검색 키워드를 입력해주세요.</li>");
			return;
		}

		$relatedKeywordResult.html("<li class='list-group-item px-0 py-1'>검색 중...</li>"); 

		$.ajax({
			url: contextPath + "/keywords/related",	
			type: "GET",
			data: { keyword: mainKeyword },
			success: function(response) {
				var html = "";
				
				if (response.relatedKeywords && response.relatedKeywords.length > 0) {
					$.each(response.relatedKeywords, function(i, relatedKeyword) {
						html += '<li class="list-group-item px-0 py-1" style="cursor:pointer;" data-keyword="' + relatedKeyword + '">'
							 +	 '<i class="bi bi-dot"></i> ' + relatedKeyword
							 +	 '</li>';
					});
				} else {
					html = "<li class='list-group-item px-0 py-1'>연관 검색어를 찾을 수 없습니다.</li>";
				}

				$relatedKeywordResult.html(html);
			},
			error: function(xhr, status, error) {
				console.error("연관 검색어 조회 실패:", xhr.responseText);
				$relatedKeywordResult.html("<li class='list-group-item px-0 py-1 text-danger'>연관 검색어 조회 실패 (서버 오류 또는 API 문제)</li>");
			}
		});
	});
	
	// 🔑 연관 검색어 클릭 이벤트 (My 추천과 수동 검색 결과 모두에 적용)
	$(document).on("click", "#relatedKeywordResult li[data-keyword], #myKeywordRecommendation li[data-keyword]", function() {
		var clickedKeyword = $(this).data("keyword");
		$("#mainKeyword").val(clickedKeyword); 
		$("#relatedKeywordForm").trigger("submit"); 
	});
});
</script>