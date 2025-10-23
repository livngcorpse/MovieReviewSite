<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
    String currentPage = request.getRequestURI();
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/home.jsp'/>">🎬 CineReview</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link <%= currentPage.endsWith("home.jsp") ? "active" : "" %>" 
                       href="<c:url value='/home.jsp'/>">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= currentPage.endsWith("movie_list.jsp") ? "active" : "" %>" 
                       href="<c:url value='/movie_list.jsp'/>">Movies</a>
                </li>
                <% if (navUser != null && navUser.isAdmin()) { %>
                    <li class="nav-item">
                        <a class="nav-link <%= currentPage.endsWith("admin_dashboard.jsp") ? "active" : "" %>" 
                           href="<c:url value='/admin_dashboard.jsp'/>">Admin Dashboard</a>
                    </li>
                <% } %>
            </ul>
            <ul class="navbar-nav">
                <% if (navUser != null) { %>
                    <li class="nav-item">
                        <span class="navbar-text me-3">Welcome, <strong><%= navUser.getUsername() %></strong></span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/LogoutServlet'/>">Logout</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>