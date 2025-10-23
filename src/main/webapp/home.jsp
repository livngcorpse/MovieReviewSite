<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Movie Review Site</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<c:url value='/home.jsp'/>">🎬 CineReview</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="<c:url value='/home.jsp'/>">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/movie_list.jsp'/>">Movies</a>
                    </li>
                    <c:if test="${sessionScope.user.admin}">
                        <li class="nav-item">
                            <a class="nav-link" href="<c:url value='/admin_dashboard.jsp'/>">Dashboard</a>
                        </li>
                    </c:if>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <span class="navbar-text me-3">Welcome, <strong><c:out value="${sessionScope.user.username}"/></strong></span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/LogoutServlet'/>">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="container mt-5 fade-in">
        <!-- Hero Section -->
        <div class="row mb-5">
            <div class="col-12">
                <div class="jumbotron text-center">
                    <h1 class="display-3 mb-3" style="font-weight: 800;">Welcome to CineReview</h1>
                    <p class="lead mb-4" style="font-size: 1.25rem;">Discover amazing movies, share your thoughts, and connect with fellow film enthusiasts</p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap">
                        <!-- URL Rewriting examples -->
                        <a class="btn btn-light btn-lg px-4" href="${pageContext.request.contextPath}/movie_list.jsp;jsessionid=${pageContext.session.id}" style="font-weight: 600;">
                            🎥 Browse Movies
                        </a>
                        <a class="btn btn-outline-light btn-lg px-4" href="<c:url value='/movie_list.jsp'/>" style="font-weight: 600;">
                            ✍️ Write Review
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Feature Cards -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card feature-card text-center">
                    <div class="card-body p-4">
                        <div class="display-1 mb-3">🎬</div>
                        <h4 class="card-title mb-3">Extensive Collection</h4>
                        <p class="card-text text-muted">Explore our curated selection of movies spanning all genres and eras</p>
                        <a href="<c:url value='/movie_list.jsp'/>" class="btn btn-outline-primary mt-2">View All Movies</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card feature-card text-center">
                    <div class="card-body p-4">
                        <div class="display-1 mb-3">⭐</div>
                        <h4 class="card-title mb-3">Rate & Review</h4>
                        <p class="card-text text-muted">Share your honest opinions and discover what others think</p>
                        <a href="<c:url value='/movie_list.jsp'/>" class="btn btn-outline-primary mt-2">Start Rating</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card feature-card text-center">
                    <div class="card-body p-4">
                        <div class="display-1 mb-3">👥</div>
                        <h4 class="card-title mb-3">Join Community</h4>
                        <p class="card-text text-muted">Connect with fellow movie lovers and engage in discussions</p>
                        <a href="<c:url value='/movie_list.jsp'/>" class="btn btn-outline-primary mt-2">Get Started</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <div class="container mt-5 mb-4">
        <div class="text-center text-muted">
            <p class="mb-0">© 2025 CineReview - Your Movie Companion</p>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>