<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<div id="mainContainer" style="width:1220px; margin:0 auto; display:flex; gap:20px; padding-top:20px;">
    <div id="leftContainer" style="width:900px;">
        <div id="actionContainer" style="margin-bottom:15px; display:flex; align-items:center; gap:10px;">
            <input type="checkbox" id="selectAll"> 전체 선택
            <button type="button" id="deleteSelected">선택 삭제</button>
        </div>

        <div id="dealContainer" style="padding:10px;">
            <c:if test="${empty list}">
                <p id="noDeals" style="font-size:13px; color:#666;">매칭된 딜이 없습니다.</p>
            </c:if>

            <c:forEach var="deal" items="${list}">
                <div class="deal-card" data-id="${deal.id}" style="display:flex; border:1px solid #ccc; padding:5px; margin-bottom:5px; border-radius:8px;">
                    <div style="flex:0 0 120px; margin-right:10px; text-align:center;">
                        <input type="checkbox" class="deal-check" value="${deal.id}" style="margin-bottom:5px;">
                        <img src="${deal.img}" alt="${deal.title}" style="width:120px; height:120px; object-fit:cover;">
                    </div>
                    <div style="flex:1; font-size:12px; line-height:1.2;">
                        <p style="margin:0;">ID: ${deal.id}</p>
                        <p style="margin:0;">제목: ${deal.title}</p>
                        <p style="margin:0;">가격: ${deal.price}</p>
                        <p style="margin:0;">사이트: ${deal.site}</p>
                        <p style="margin:0;">URL: <a href="${deal.url}" target="_blank">${deal.url}</a></p>
                        <p style="margin:0;">등록일: ${deal.posted_at}</p>
                        <p style="margin:0;">생성일: ${deal.created_at}</p>
                        <p style="margin:0;">좋아요: ${deal.likes}</p>
                        <button type="button" class="deleteBtn" style="margin-top:2px; font-size:12px;">삭제</button>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <div id="rightContainer" style="width:300px;">
        <div style="padding:10px;"></div>
    </div>
</div>

<script>
$(document).ready(function(){
    // 초기 offset 계산
    let offset = ${list != null ? list.size() : 0};
    if(isNaN(offset)) offset = 0;
    let limit = 5;
    let loading = false;
    let allLoaded = false;

    // 카드 생성 함수
    function appendDealCard(deal){
        const postedAt = deal.postedAt || '';
        const createdAt = deal.createdAt || '';

        const cardHtml = `
            <div class="deal-card" data-id="${deal.id}" style="display:flex; border:1px solid #ccc; padding:5px; margin-bottom:5px; border-radius:8px;">
                <div style="flex:0 0 120px; margin-right:10px; text-align:center;">
                    <input type="checkbox" class="deal-check" value="${deal.id}" style="margin-bottom:5px;">
                    <img src="${deal.img}" alt="${deal.title}" style="width:120px; height:120px; object-fit:cover;">
                </div>
                <div style="flex:1; font-size:12px; line-height:1.2;">
                    <p style="margin:0;">ID: ${deal.id}</p>
                    <p style="margin:0;">제목: ${deal.title}</p>
                    <p style="margin:0;">가격: ${deal.price}</p>
                    <p style="margin:0;">사이트: ${deal.site}</p>
                    <p style="margin:0;">URL: <a href="${deal.url}" target="_blank">${deal.url}</a></p>
                    <p style="margin:0;">등록일: ${postedAt}</p>
                    <p style="margin:0;">생성일: ${createdAt}</p>
                    <p style="margin:0;">좋아요: ${deal.likes}</p>
                    <button type="button" class="deleteBtn" style="margin-top:2px; font-size:12px;">삭제</button>
                </div>
            </div>`;

        const $card = $(cardHtml);
        $('#dealContainer').append($card);

        // 🔹 강제로 리플로우 + 렌더링
        $card[0].offsetHeight;   // DOM 읽기 → 브라우저가 레이아웃 계산
        $card.css('opacity', 0);
        setTimeout(() => {
            $card.css({'opacity': 1, 'transition': 'opacity 0.3s ease'});
        }, 10);

        console.log('Appended deal:', deal.id);
        
    }
    // AJAX로 딜 로드
    function loadDeals(){
        if(loading || allLoaded) return;
        loading = true;

        $.ajax({
            url: '${pageContext.request.contextPath}/main/dealMatch',
            type: 'GET',
            data: { offset: offset, limit: limit },
            dataType: 'json',
            success: function(data){
                console.log('AJAX Data:', data);
                console.log('dealContainer exists:', $('#dealContainer').length);
                console.log('dealContainer html:', $('#dealContainer').html());
				
                if(!data || data.length === 0){
                    if(offset === 0){
                        $('#dealContainer').html('<p id="noDeals" style="font-size:13px; color:#666;">매칭된 딜이 없습니다.</p>');
                    } else if(!allLoaded){
                        $('#dealContainer').append('<hr><p style="color:#666; font-size:12px;">더 이상 딜이 없습니다.</p>');
                        allLoaded = true;
                    }
                    loading = false;
                    return;
                }

                $('#noDeals').remove();
                data.forEach(appendDealCard);
                
                offset += data.length;
                loading = false;
            },
            error: function(err){
                console.error('AJAX Error:', err);
                loading = false;
            }
        });
    }

    // 스크롤 감지
    $(window).on('scroll', function(){
        if($(window).scrollTop() + $(window).height() >= $(document).height() - 50){
//        	appendDealCard(deal);
        	loadDeals();
        	        	
        }
    });

    // 전체 선택
    $('#selectAll').on('change', function(){
        $('.deal-check').prop('checked', $(this).prop('checked'));
    });

    // 선택 삭제
    $('#deleteSelected').on('click', function(){
        $('.deal-check:checked').each(function(){
            $(this).closest('.deal-card').remove();
        });
    });

    // 단일 삭제
    $('#dealContainer').on('click', '.deleteBtn', function(){
        $(this).closest('.deal-card').remove();
    });
});
</script>