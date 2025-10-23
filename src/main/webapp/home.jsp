<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <!-- Include Common Navigation Bar -->
    <jsp:include page="navbar.jsp" />    
    
    <!-- Main Content -->
    <div class="container mt-5 fade-in">
        <!-- Hero Section -->
        <div class="row mb-5">
            <div class="col-12">
                <div class="jumbotron text-center">
                    <h1 class="display-3 mb-3" style="font-weight: 800;">
                        Welcome to CineReview
                        <c:if test="${not empty sessionScope.username}">
                            , <c:out value="${fn:toUpperCase(sessionScope.username)}"/>
                        </c:if>
                    </h1>
                    <p class="lead mb-4" style="font-size: 1.25rem;">
                        Discover amazing movies, share your thoughts, and connect with fellow film enthusiasts
                    </p>
                    
                    <!-- URL REWRITING: Using c:url tag -->
                    <div class="d-flex gap-3 justify-content-center flex-wrap">
                        <c:url var="movieListUrl" value="movie_list.jsp">
                            <c:param name="source" value="home"/>
                        </c:url>
                        <a class="btn btn-light btn-lg px-4" href="${movieListUrl}" style="font-weight: 600;">
                            🎥 Browse Movies
                        </a>
                        
                        <!-- URL with jsessionid -->
                        <a class="btn btn-outline-light btn-lg px-4" 
                           href="movie_list.jsp;jsessionid=${pageContext.session.id}?action=review" 
                           style="font-weight: 600;">
                            ✍️ Write Review
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Feature Cards with JSTL -->
        <c:set var="features" value="🎬,Extensive Collection,Explore our curated selection of movies spanning all genres and eras|⭐,Rate & Review,Share your honest opinions and discover what others think|👥,Join Community,Connect with fellow movie lovers and engage in discussions" />
        
        <div class="row g-4 mb-5">
            <c:forEach var="feature" items="${fn:split(features, '|')}" varStatus="status">
                <c:set var="parts" value="${fn:split(feature, ',')}" />
                <div class="col-md-4">
                    <div class="card feature-card text-center">
                        <div class="card-body p-4">
                            <div class="display-1 mb-3">${parts[0]}</div>
                            <h4 class="card-title mb-3">${parts[1]}</h4>
                            <p class="card-text text-muted">${parts[2]}</p>
                            
                            <!-- URL Rewriting with c:url -->
                            <c:url var="featureUrl" value="movie_list.jsp">
                                <c:param name="feature" value="${status.index}"/>
                            </c:url>
                            <a href="${featureUrl}" class="btn btn-outline-primary mt-2">
                                <c:choose>
                                    <c:when test="${status.index == 0}">View All Movies</c:when>
                                    <c:when test="${status.index == 1}">Start Rating</c:when>
                                    <c:otherwise>Get Started</c:otherwise>
                                </c:choose>
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <!-- Session Info Display using JSTL -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Session Information</h5>
                        <ul class="list-unstyled mb-0">
                            <li><strong>Session ID:</strong> 
                                <code><c:out value="${pageContext.session.id}"/></code>
                            </li>
                            <li><strong>User:</strong> 
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <span class="badge bg-success">
                                            <c:out value="${sessionScope.username}"/>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning">Guest</span>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <li><strong>Role:</strong> 
                                <c:if test="${not empty sessionScope.role}">
                                    <span class="badge bg-info">
                                        <c:out value="${sessionScope.role}"/>
                                    </span>
                                </c:if>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <div class="container mt-5 mb-4">
        <div class="text-center text-muted">
            <p class="mb-0">
                © <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy"/> CineReview - Your Movie Companion
            </p>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>