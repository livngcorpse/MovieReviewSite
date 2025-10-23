<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.moviereview.model.User, com.moviereview.model.Movie, com.moviereview.dao.MovieDAO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect("home.jsp");
        return;
    }
    
    MovieDAO movieDAO = new MovieDAO();
    List<Movie> movies = movieDAO.getAllMovies();
%>
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
                        <a class="nav-link" href="home.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="movie_list.jsp">Movies</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="admin_dashboard.jsp">Admin Dashboard</a>
                    </li>
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Admin Dashboard - Manage Movies</h2>
            <a href="add_movie.jsp" class="btn btn-success">+ Add New Movie</a>
        </div>
        
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Movie updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
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
                            <% if (movies.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" class="text-center">No movies found.</td>
                                </tr>
                            <% } else {
                                for (Movie movie : movies) { %>
                                    <tr>
                                        <td><%= movie.getMovieId() %></td>
                                        <td><%= movie.getTitle() %></td>
                                        <td><%= movie.getDirector() %></td>
                                        <td><%= movie.getYear() %></td>
                                        <td>
                                            <% if (movie.getReviewCount() > 0) { %>
                                                ⭐ <%= String.format("%.1f", movie.getAvgRating()) %>
                                            <% } else { %>
                                                -
                                            <% } %>
                                        </td>
                                        <td><%= movie.getReviewCount() %></td>
                                        <td>
                                            <a href="MovieDetailsServlet?id=<%= movie.getMovieId() %>" class="btn btn-sm btn-info">View</a>
                                            <a href="MovieServlet?action=edit&id=<%= movie.getMovieId() %>" class="btn btn-sm btn-warning">Edit</a>
                                            <a href="MovieServlet?action=delete&id=<%= movie.getMovieId() %>" 
                                               class="btn btn-sm btn-danger" 
                                               onclick="return confirm('Are you sure you want to delete this movie? All reviews will be deleted too.');">
                                                Delete
                                            </a>
                                        </td>
                                    </tr>
                                <% }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>