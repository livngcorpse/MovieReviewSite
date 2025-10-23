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
            <a href="add_movie.jsp" class="btn btn-success">+ Add New Movie</a>
        </div>
        
        <c:if test="${param.success eq 'updated'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Movie updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
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
                                    <c:forEach var="movie" items="${movies}">
                                        <tr>
                                            <td>${movie.movieId}</td>
                                            <td><c:out value="${movie.title}"/></td>
                                            <td><c:out value="${movie.director}"/></td>
                                            <td>${movie.year}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${movie.reviewCount > 0}">
                                                        ⭐ <fmt:formatNumber value="${movie.avgRating}" pattern="0.0"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${movie.reviewCount}</td>
                                            <td>
                                                <a href="MovieDetailsServlet?id=${movie.movieId}" class="btn btn-sm btn-info">View</a>
                                                <a href="MovieServlet?action=edit&id=${movie.movieId}" class="btn btn-sm btn-warning">Edit</a>
                                                <a href="MovieServlet?action=delete&id=${movie.movieId}" 
                                                   class="btn btn-sm btn-danger" 
                                                   onclick="return confirm('Are you sure you want to delete this movie? All reviews will be deleted too.');">
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