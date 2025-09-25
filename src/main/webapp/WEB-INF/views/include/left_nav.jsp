<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 좌측 네비바 -->
<div class="d-flex">
    <!-- Sidebar -->
    <nav class="d-flex flex-column flex-shrink-0 p-3 bg-light" 
         style="width: 250px; min-height: 100vh;">
         
        <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
            <span class="fs-4">Dealarm</span>
        </a>
        <hr>
        <ul class="nav nav-pills flex-column mb-auto">
            <li class="nav-item">
                <a href="/" class="nav-link active" aria-current="page">
                    홈
                </a>
            </li>
            <li>
                <a href="/about" class="nav-link link-dark">
                    소개
                </a>
            </li>
            <li>
                <a href="/shop" class="nav-link link-dark">
                    쇼핑
                </a>
            </li>
            <li>
                <a href="/contact" class="nav-link link-dark">
                    문의
                </a>
            </li>
        </ul>
        <hr>
        <div>
            <a href="/member/login" class="btn btn-outline-primary w-100">로그인</a>
        </div>
    </nav>

