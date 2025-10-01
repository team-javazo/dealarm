<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

                <h2>매칭된 딜</h2>

    <c:if test="${empty list}">
        <p>매칭된 딜이 없습니다.</p>
    </c:if>

    <c:forEach var="deal" items="${list}">
        <div>
            <p>ID: ${deal.id}</p>
            <p>제목: ${deal.title}</p>
            <p>가격: ${deal.price}</p>
            <p>사이트: ${deal.site}</p>
            <p>URL: ${deal.url}</p>
            <p>등록일: ${deal.postedAt}</p>
            <p>생성일: ${deal.createdAt}</p>
            <p>좋아요: ${deal.likes}</p>
            <p>이미지: ${deal.img}</p>
            <hr>
        </div>
    </c:forEach>
