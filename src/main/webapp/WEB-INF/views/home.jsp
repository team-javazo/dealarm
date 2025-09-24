<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<html>
<head>

        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
    <title>홈 화면</title>
        <!-- Favicon-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        
<!--    <link rel="icon" type="image/x-icon" href="assets/favicon.ico" /> -->
        <!-- Bootstrap icons-->
<!--    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />   --> 
        <!-- Core theme CSS (includes Bootstrap)-->
		<link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
		
</head>
<body>
	<!-- =======================[바디시작]================================ -->
         <a href="<c:url value='/main'/>">메인view페이지로 이동</a> |

	<!-- =================== [메인 영역 시작]==================================-->
   				<h1>홈 화면</h1>

   <!-- 로그인 여부에 따라 다른 화면 출력 -->
   <c:choose>
      <c:when test="${empty sessionScope.id}">
         <a href="<c:url value='/member/join'/>">회원가입</a> |
            <a href="<c:url value='/member/login'/>">로그인</a>
      </c:when>
      <c:when test="${sessionScope.role eq 'ADMIN'}">
         <p>
            <b>${sessionScope.role}</b> 님, 환영합니다!
         </p>
         <a href="<c:url value='/member/members'/>">회원목록</a> |
            <a href="<c:url value='/member/logout'/>">로그아웃</a> |
            <a href="<c:url value='/member/mypage'/>">마이페이지</a>
      </c:when>
      <c:otherwise>
         <p>
            <b>${sessionScope.name}</b> 님, 환영합니다!
         </p>
         <a href="<c:url value='/member/logout'/>">로그아웃</a> |
            <a href="<c:url value='/member/mypage'/>">마이페이지</a>

         <!-- 키워드 등록 -->
         <h3>키워드 등록</h3>
         <form id="addKeywordForm">
            <input type="hidden" name="userId" value="${sessionScope.id}" /> <input
               type="text" id="keyword" name="keyword" placeholder="키워드 입력"
               required />
            <button type="submit">추가</button>
         </form>

         <h3>키워드 관리</h3>
         <!-- 키워드 리스트 -->
         <ul id="keywordList">
            <!-- 키워드 목록이 동적으로 삽입됩니다. -->
         </ul>

         <script>
            // 키워드 추가
            $('#addKeywordForm')
                  .on(
                        'submit',
                        function(e) {
                           e.preventDefault(); // 폼 제출 기본 동작 방지
                           const keyword = $('#keyword').val().trim();
                           const userId = "${sessionScope.id}"; // 세션에서 사용자 ID 가져오기

                           if (keyword) {
                              // 키워드 추가 API 호출
                              $
                                    .ajax({
                                       url : '${pageContext.request.contextPath}/keywords/add',
                                       method : 'POST',
                                       contentType : 'application/json',
                                       data : JSON.stringify({
                                          userId : userId,
                                          keyword : keyword
                                       }),
                                       success : function(response) {
                                          if (response.success) {
                                             alert('키워드가 추가되었습니다.');
                                             loadKeywords(); // 키워드 리스트 새로고침
                                          } else {
                                             alert(response.message); // 에러 메시지 출력
                                          }
                                       },
                                       error : function() {
                                          alert('서버 오류가 발생했습니다.');
                                       }
                                    });
                           } else {
                              alert('키워드를 입력해주세요.');
                           }
                        });

            // 키워드 삭제
            $(document)
                  .on(
                        'click',
                        '.deleteBtn',
                        function() {
                           const keywordId = $(this).data('id');
                           if (confirm('이 키워드를 삭제하시겠습니까?')) {
                              // 키워드 삭제 API 호출
                              $
                                    .ajax({
                                       url : '${pageContext.request.contextPath}/keywords/delete/'
                                             + keywordId,
                                       method : 'POST',
                                       success : function(response) {
                                          if (response.success) {
                                             alert('키워드가 삭제되었습니다.');
                                             loadKeywords(); // 키워드 리스트 새로고침
                                          } else {
                                             alert('삭제 실패');
                                          }
                                       },
                                       error : function() {
                                          alert('서버 오류가 발생했습니다.');
                                       }
                                    });
                           }
                        });

            // 키워드 리스트 불러오기            
            function loadKeywords() {
               var userId = "${sessionScope.id}";
               var url = "${pageContext.request.contextPath}/keywords/list?userId="
                     + userId;

               console.log("Ajax 요청 URL:", url);

               $
                     .ajax({
                        url : url,
                        type : 'GET',
                        dataType : 'json',
                        success : function(response) {
                           console.log("서버 응답:", response);
                           var htmls = "";

                           if (response.keywords
                                 && response.keywords.length > 0) {
                              $(response.keywords)
                                    .each(
                                          function() {
                                             console
                                                   .log(
                                                         "Keyword object:",
                                                         this);

                                             let id = this.id ? this.id
                                                   : "ID 없음";
                                             let keywordUserId = this.userId ? this.userId
                                                   : "User ID 없음";
                                             let keywordValue = this.keyword ? this.keyword
                                                   : "키워드 없음";
                                             let createdAtStr = this.createdAt ? new Date(
                                                   this.createdAt)
                                                   .toLocaleString()
                                                   : "날짜 없음";

                                             htmls += '<li>';
                                             htmls += id
                                                   + ', '
                                                   + keywordUserId
                                                   + ', '
                                                   + keywordValue
                                                   + ', '
                                                   + createdAtStr;
                                             htmls += ' <button class="deleteBtn" data-id="' + id + '">삭제</button>';
                                             htmls += '</li>';
                                          });
                           } else {
                              htmls = "<li>등록된 키워드가 없습니다.</li>";
                           }

                           $("#keywordList").html(htmls);
                        },
                        error : function(xhr, status, error) {
                           alert("키워드 목록 불러오기 실패: " + error);
                           console.error("에러 상태:", status, error);
                        }
                     });
            }

            // 페이지 로딩 시 키워드 리스트 불러오기
            $(document).ready(function() {
               loadKeywords(); // 키워드 리스트 불러오기
            });
         </script>
      </c:otherwise>
   </c:choose>

 

</body>
</html>
    