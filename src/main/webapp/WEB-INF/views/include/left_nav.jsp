<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 좌측 네비바 -->
<div class="d-flex">
    <!-- Sidebar -->
    <nav class="d-flex flex-column flex-shrink-0 p-3 bg-light" 
         style="width: 250px; min-height: 100vh;">
         
        <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
            <span class="fs-4">MENU</span>
        </a>
        <hr>
        <ul class="nav nav-pills flex-column">
            <li class="nav-item">
                <a href="/" class="nav-link active" aria-current="page"> 카테고리</a>
            </li>
            
            <li>
                <a href="/about" class="nav-link link-dark">소개</a>
            </li>
            
            <li>
                <a href="/shop" class="nav-link link-dark">쇼핑</a>
            </li>
            
            <li>
            	<a href="/contact" class="nav-link link-dark">문의</a>
            </li>
        </ul>
        
        <hr>
        <ul class="nav nav-pills flex-cloumn mb-auto">
        	<li class="nav-item dropdown">
        		<a class="nav-link dropdown-toggle" id="myKeywordDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
				   My키워드</a>
                <ul class="dropdown-menu" aria-labelledby="myKeywordDropdown">
                	<c:choose>
                		<c:when test="${empty sessionScope.id}">
                			<li><span class="dropdown-item text-muted">로그인 후 이용 가능</span></li>
                		</c:when>
                		<c:otherwise>
                    <!-- 서브메뉴 -->
                    <li class="dropdown-submenu">
                        <form id="addKeywordForm" class="px-2 py-2">
                            <input type="hidden" name="userId" value="${sessionScope.id}" />
                            <div class="mb-2">
                                <input type="text" id="keyword" name="keyword" class="form-control form-control-sm" placeholder="키워드 입력" required />
                            </div>
                            <button type="submit" class="btn btn-primary btn-sm w-100">추가</button>
                        </form>
                    </li>
                    <li class="dropdown-submenu">
					  
					</li>

                    <li><a class="dropdown-item" href="#">키워드2</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/keyword">키워드페이지</a></li>
                </c:otherwise>
                	</c:choose>
                </ul>
        	</li>
        		<c:choose>
	       			<c:when test="${empty sessionScope.id}">
          				<a href="${pageContext.request.contextPath}/member/login" class="btn btn-outline-primary w-100">로그인</a>
					</c:when>
        		</c:choose>
       	</ul>
        
    </nav>



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
