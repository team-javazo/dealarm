<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<div id="mainContainerWrapper" style="width: 1220px; margin: 0 auto; padding-top:20px;">

    <!-- 왼쪽 영역: 딜 리스트 -->
    <div id="leftContainer" style="flex: 1; min-width: 600px; max-width: 900px; border: 1px solid #ccc; padding: 10px; box-sizing: border-box;">
        
        <!-- 액션 영역: 세련된 버튼 스타일 -->
        <div id="actionContainer" style="margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
            <label style="display:flex; align-items:center; cursor:pointer; font-size:14px;">
                <input type="checkbox" id="selectAll" style="margin-right:5px; accent-color:#007BFF; width:16px; height:16px;">
                전체 선택
            </label>
            <button type="button" id="deleteSelected" style="padding:5px 12px; background-color:#28a745; color:white; border:none; border-radius:4px; cursor:pointer; font-size:14px; transition:0.2s;">
                선택 담기
            </button>
        </div>

        <!-- 딜 리스트 스크롤 영역 -->
        <div id="dealContainer" style="overflow-y: auto; padding-right:5px; height: 410px; box-sizing:border-box;">
            <c:if test="${empty list}">
                <p id="noDeals" style="font-size: 13px; color: #666;">불러올 딜이 없습니다.</p>
            </c:if>

            <c:forEach var="deal" items="${list}">
                <div class="deal-card" data-id="${deal.id}"
                     style="display: flex; align-items:flex-start; border: 1px solid #ccc; padding: 5px; margin-bottom: 5px; border-radius: 8px; position:relative;">
                    
                    <div style="flex: 0 0 120px; margin-right: 10px; text-align: center;">
                        <input type="checkbox" class="deal-check" value="${deal.id}" style="margin-bottom: 5px; accent-color:#007BFF; width:16px; height:16px;">
                        <img src="<c:url value='${deal.img}'/>" alt="${deal.title}" style="width: 120px; height: 120px; object-fit: cover; border-radius:4px;">
                    </div>
                    
                    <div style="flex: 1; font-size: 12px; line-height: 1.2; padding-right:60px; position:relative;">
                        <p style="margin: 0;">ID: ${deal.id}</p>
                        <p style="margin: 0;">제목: ${deal.title}</p>
                        <p style="margin: 0;">가격: ${deal.price}</p>
                        <p style="margin: 0;">사이트: ${deal.site}</p>
                        <p style="margin: 0;">URL: <a href="${deal.url}" target="_blank">${deal.url}</a></p>
                        <p style="margin: 0;">등록일: ${deal.posted_at}</p>
                        <p style="margin: 0;">생성일: ${deal.created_at}</p>
                        <p style="margin: 0;">좋아요: ${deal.likes}</p>
                        
                        <!-- 카드 삭제 버튼: 오른쪽 상단에 고정 -->
                        <button type="button" class="deleteBtn" 
                                style="position:absolute; top:5px; right:5px; padding:4px 8px; background-color:#28a745; color:white; border:none; border-radius:4px; font-size:12px; cursor:pointer; transition:0.2s;">
                            관심상품 등록
                        </button>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- 접기/펴기 버튼: 컨테이너 폭 전체, 세련된 스타일 -->
        <div style="text-align:center; margin-top:5px;">
            <button type="button" id="toggleDealContainer" 
                    style="width:100%; padding:8px 0; background-color:#007BFF; color:white; border:none; border-radius:4px; font-size:14px; cursor:pointer; transition:0.2s;">
                펼치기
            </button>
        </div>
        
    </div>
</div>

<script>
$(document).ready(function() {
    const $dealContainer = $('#dealContainer');
    const defaultHeight = 420; // 기본 높이
    let expanded = false;

    // 접기/펴기 기능
    $('#toggleDealContainer').on('click', function() {
        const fullHeight = $dealContainer.get(0).scrollHeight;
        if(!expanded){
            $dealContainer.stop().animate({height: fullHeight + 'px'}, 400);
            $(this).text('접기');
        } else {
            $dealContainer.stop().animate({height: defaultHeight + 'px'}, 400);
            $(this).text('펼치기');
        }
        expanded = !expanded;
    });

    // 전체 선택
    $('#selectAll').on('change', function() {
        $('.deal-check').prop('checked', $(this).prop('checked'));
    });

    // 선택 담기(미구현) 추후지원지능
    $('#deleteSelected').on('click', function() {
    //   $('.deal-check:checked').each(function() {
    //        $(this).closest('.deal-card').remove();
    //    });
    	alert("추후 지원될 기능 입니다.");
    
    });

    // 단일 담기
    $('#dealContainer').on('click', '.deleteBtn', function() {
    //    $(this).closest('.deal-card').remove();
    	alert("추후 지원될 기능 입니다.");	
    });

    // 버튼 호버 효과
    $('button').hover(function(){
        $(this).css('opacity', '0.85');
    }, function(){
        $(this).css('opacity', '1');
    });
});
</script>
