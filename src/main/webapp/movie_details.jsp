<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.moviereview.model.User, com.moviereview.model.Movie, com.moviereview.model.Review, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    Movie movie = (Movie) request.getAttribute("movie");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    
    if (movie == null) {
        response.sendRedirect("movie_list.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= movie.getTitle() %> - Movie Review Site</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .movie-poster-large {
            width: 100%;
            max-width: 350px;
            border-radius: 1rem;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.5);
        }
        
        .poster-placeholder-large {
            width: 100%;
            max-width: 350px;
            height: 500px;
            background: linear-gradient(135deg, #5b21b6 0%, #06b6d4 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 6rem;
            border-radius: 1rem;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.5);
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="home.jsp">🎬 CineReview</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="home.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="movie_list.jsp">Movies</a>
                    </li>
                    <% if (user.isAdmin()) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="admin_dashboard.jsp">Admin Dashboard</a>
                    </li>
                    <% } %>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <span class="navbar-text me-3">Welcome, <strong><%= user.getUsername() %></strong></span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="container mt-4">
        <!-- Success/Error Messages -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <% if ("review_added".equals(request.getParameter("success"))) { %>
                    Review added successfully!
                <% } else if ("review_updated".equals(request.getParameter("success"))) { %>
                    Review updated successfully!