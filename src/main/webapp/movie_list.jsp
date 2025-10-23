<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.moviereview.dao.MovieDAO" %>
<jsp:useBean id="movieDAO" class="com.moviereview.dao.MovieDAO" />
<c:set var="movies" value="${movieDAO.allMovies}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movies - Movie Review Site</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Include Common Navigation Bar -->
    <jsp:include page="navbar.jsp" />
    
    <!-- Main Content -->
    <div class="container mt-4">
        <h2 class="mb-4">All Movies (<c:out value="${fn:length(movies)}" />)</h2>
        
        <div class="row">
            <c:choose>
                <c:when test="${empty movies}">
                    <div class="col-12">
                        <div class="alert alert-info">No movies available yet.</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="movie" items="${movies}" varStatus="status">
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="card h-100 shadow-sm">
                                <c:if test="${not empty movie.posterUrl}">
                                    <img src="${movie.posterUrl}" 
                                         class="card-img-top" 
                                         alt="${movie.title} Poster"
                                         style="height: 300px; object-fit: cover;"
                                         onerror="this.style.display='none';">
                                </c:if>
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <c:out value="${movie.title}"/>
                                        <c:if test="${status.index < 3}">
                                            <span class="badge bg-danger">New</span>
                                        </c:if>
                                    </h5>
                                    <h6 class="card-subtitle mb-2 text-muted">
                                        Director: <c:out value="${movie.director}"/> 
                                        (<c:out value="${movie.year}"/>)
                                    </h6>
                                    <p class="card-text">
                                        <c:choose>
                                            <c:when test="${fn:length(movie.description) > 100}">
                                                ${fn:substring(movie.description, 0, 100)}...
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${movie.description}"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    
                                    <div class="mb-3">
                                        <c:choose>
                                            <c:when test="${movie.reviewCount > 0}">
                                                <span class="badge bg-warning text-dark">
                                                    ⭐ <fmt:formatNumber value="${movie.avgRating}" pattern="0.0"/>/5
                                                </span>
                                                <span class="badge bg-secondary">
                                                    <c:out value="${movie.reviewCount}"/> 
                                                    <c:choose>
                                                        <c:when test="${movie.reviewCount == 1}">Review</c:when>
                                                        <c:otherwise>Reviews</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">No reviews yet</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <!-- URL REWRITING: Using multiple techniques -->
                                    
                                    <!-- Method 1: response.encodeURL() -->
                                    <c:url var="detailsUrl" value="MovieDetailsServlet">
                                        <c:param name="id" value="${movie.movieId}"/>
                                    </c:url>
                                    <a href="${detailsUrl}" class="btn btn-primary btn-sm">
                                        View Details
                                    </a>
                                    
                                    <!-- Method 2: jsessionid in URL -->
                                    <a href="MovieDetailsServlet;jsessionid=${pageContext.session.id}?id=${movie.movieId}" 
                                       class="btn btn-outline-primary btn-sm">
                                        Quick View
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Pagination using JSTL -->
        <c:if test="${fn:length(movies) > 0}">
            <div class="mt-4 text-center">
                <p class="text-muted">
                    Showing <strong>${fn:length(movies)}</strong> movies
                </p>
            </div>
        </c:if>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>