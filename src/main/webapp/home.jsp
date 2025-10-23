<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.moviereview.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Movie Review Site</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="home.jsp">🎬 Movie Review</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="home.jsp">Home</a>
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
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-12">
                <div class="jumbotron bg-light p-5 rounded">
                    <h1 class="display-4">Welcome to Movie Review Site!</h1>
                    <p class="lead">Discover, rate, and review your favorite movies.</p>
                    <hr class="my-4">
                    <p>Browse through our collection of movies and share your thoughts with the community.</p>
                    <a class="btn btn-primary btn-lg" href="movie_list.jsp" role="button">Browse Movies</a>
                </div>
            </div>
        </div>
        
        <div class="row mt-5">
            <div class="col-md-4">
                <div class="card text-center h-100">
                    <div class="card-body">
                        <h2 class="display-1">📚</h2>
                        <h5 class="card-title">Browse Movies</h5>
                        <p class="card-text">Explore our extensive collection of movies from various genres.</p>
                        <a href="movie_list.jsp" class="btn btn-outline-primary">View All</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center h-100">
                    <div class="card-body">
                        <h2 class="display-1">⭐</h2>
                        <h5 class="card-title">Rate & Review</h5>
                        <p class="card-text">Share your opinions and help others discover great movies.</p>
                        <a href="movie_list.jsp" class="btn btn-outline-primary">Start Rating</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center h-100">
                    <div class="card-body">
                        <h2 class="display-1">💬</h2>
                        <h5 class="card-title">Join Community</h5>
                        <p class="card-text">Read reviews from other movie enthusiasts and join discussions.</p>
                        <a href="movie_list.jsp" class="btn btn-outline-primary">Explore</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>