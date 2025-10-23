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
    <title>Admin Dashboard - Movie Review Site</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Include Common Navigation Bar -->
    <jsp:include page="navbar.jsp" />
    
    <!-- Main Content -->
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Admin Dashboard - Manage Movies</h2>
            
            <!-- URL Rewriting for Add Movie -->
            <c:url var="addMovieUrl" value="add_movie.jsp">
                <c:param name="source" value="dashboard"/>
            </c:url>
            <a href="${addMovieUrl}" class="btn btn-success">+ Add New Movie</a>
        </div>
        
        <!-- Success Message using JSTL -->
        <c:if test="${param.success eq 'updated'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Movie updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Statistics Cards using JSTL -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="card-title text-primary">
                            <c:out value="${fn:length(movies)}"/>
                        </h3>
                        <p class="card-text text-muted">Total Movies</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="card-title text-success">
                            <!-- Calculate total reviews -->
                            <c:set var="totalReviews" value="0"/>
                            <c:forEach var="movie" items="${movies}">
                                <c:set var="totalReviews" value="${totalReviews + movie.reviewCount}"/>
                            </c:forEach>
                            ${totalReviews}
                        </h3>
                        <p class="card-text text-muted">Total Reviews</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="card-title text-warning">
                            <!-- Calculate movies with reviews -->
                            <c:set var="moviesWithReviews" value="0"/>
                            <c:forEach var="movie" items="${movies}">
                                <c:if test="${movie.reviewCount > 0}">
                                    <c:set var="moviesWithReviews" value="${moviesWithReviews + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${moviesWithReviews}
                        </h3>
                        <p class="card-text text-muted">Reviewed Movies</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="card-title text-info">
                            <!-- Calculate average rating -->
                            <c:set var="totalRating" value="0"/>
                            <c:set var="ratedMovies" value="0"/>
                            <c:forEach var="movie" items="${movies}">
                                <c:if test="${movie.reviewCount > 0}">
                                    <c:set var="totalRating" value="${totalRating + movie.avgRating}"/>
                                    <c:set var="ratedMovies" value="${ratedMovies + 1}"/>
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${ratedMovies > 0}">
                                    <fmt:formatNumber value="${totalRating / ratedMovies}" pattern="0.0"/>
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="card-text text-muted">Avg Rating</p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Director</th>
                                <th>Year</th>
                                <th>Avg Rating</th>
                                <th>Reviews</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty movies}">
                                    <tr>
                                        <td colspan="7" class="text-center">No movies found.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="movie" items="${movies}" varStatus="status">
                                        <tr class="${status.index % 2 == 0 ? 'table-light' : ''}">
                                            <td><c:out value="${movie.movieId}"/></td>
                                            <td>
                                                <strong><c:out value="${movie.title}"/></strong>
                                                <c:if test="${movie.reviewCount == 0}">
                                                    <span class="badge bg-secondary ms-2">New</span>
                                                </c:if>
                                            </td>
                                            <td><c:out value="${movie.director}"/></td>
                                            <td><c:out value="${movie.year}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${movie.reviewCount > 0}">
                                                        <span class="badge bg-warning text-dark">
                                                            ⭐ <fmt:formatNumber value="${movie.avgRating}" pattern="0.0"/>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">
                                                    <c:out value="${movie.reviewCount}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <!-- URL Rewriting for all action links -->
                                                <c:url var="viewUrl" value="MovieDetailsServlet">
                                                    <c:param name="id" value="${movie.movieId}"/>
                                                </c:url>
                                                <a href="${viewUrl}" class="btn btn-sm btn-info">View</a>
                                                
                                                <c:url var="editUrl" value="MovieServlet">
                                                    <c:param name="action" value="edit"/>
                                                    <c:param name="id" value="${movie.movieId}"/>
                                                </c:url>
                                                <a href="${editUrl}" class="btn btn-sm btn-warning">Edit</a>
                                                
                                                <c:url var="deleteUrl" value="MovieServlet">
                                                    <c:param name="action" value="delete"/>
                                                    <c:param name="id" value="${movie.movieId}"/>
                                                </c:url>
                                                <a href="${deleteUrl}" 
                                                   class="btn btn-sm btn-danger" 
                                                   onclick="return confirm('Are you sure you want to delete this movie? All ${movie.reviewCount} reviews will be deleted too.');">
                                                    Delete
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>