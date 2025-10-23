<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="dao.MovieDAO" %>
<jsp:useBean id="movieDAO" class="dao.MovieDAO" />
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
        <h2 class="mb-4">All Movies</h2>
        
        <div class="row">
            <c:choose>
                <c:when test="${empty movies}">
                    <div class="col-12">
                        <div class="alert alert-info">No movies available yet.</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="movie" items="${movies}">
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="card h-100 shadow-sm">
                                <div class="card-body">
                                    <h5 class="card-title"><c:out value="${movie.title}"/></h5>
                                    <h6 class="card-subtitle mb-2 text-muted">
                                        Director: <c:out value="${movie.director}"/> (<c:out value="${movie.year}"/>)
                                    </h6>
                                    <p class="card-text"><c:out value="${movie.description}"/></p>
                                    
                                    <div class="mb-3">
                                        <c:choose>
                                            <c:when test="${movie.reviewCount > 0}">
                                                <span class="badge bg-warning text-dark">
                                                    ⭐ <fmt:formatNumber value="${movie.avgRating}" pattern="0.0"/>/5
                                                </span>
                                                <span class="badge bg-secondary">
                                                    ${movie.reviewCount} Reviews
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">No reviews yet</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <a href="MovieDetailsServlet?id=${movie.movieId}" class="btn btn-primary btn-sm">
                                        View Details & Reviews
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>