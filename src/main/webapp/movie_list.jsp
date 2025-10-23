<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.moviereview.model.User, com.moviereview.model.Movie, com.moviereview.dao.MovieDAO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("LoginServlet");
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
    <title>Movies - Movie Review Site</title>
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
                        <a class="nav-link active" href="movie_list.jsp">Movies</a>
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
        <h2 class="mb-4">All Movies</h2>
        
        <div class="row">
            <% if (movies.isEmpty()) { %>
                <div class="col-12">
                    <div class="alert alert-info">No movies available yet.</div>
                </div>
            <% } else {
                for (Movie movie : movies) { %>
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title"><%= movie.getTitle() %></h5>
                                <h6 class="card-subtitle mb-2 text-muted">
                                    Director: <%= movie.getDirector() %> (<%= movie.getYear() %>)
                                </h6>
                                <p class="card-text"><%= movie.getDescription() %></p>
                                
                                <div class="mb-3">
                                    <% if (movie.getReviewCount() > 0) { %>
                                        <span class="badge bg-warning text-dark">
                                            ⭐ <%= String.format("%.1f", movie.getAvgRating()) %>/5
                                        </span>
                                        <span class="badge bg-secondary">
                                            <%= movie.getReviewCount() %> Reviews
                                        </span>
                                    <% } else { %>
                                        <span class="badge bg-secondary">No reviews yet</span>
                                    <% } %>
                                </div>
                                
                                <a href="MovieDetailsServlet?id=<%= movie.getMovieId() %>" class="btn btn-primary btn-sm">
                                    View Details & Reviews
                                </a>
                            </div>
                        </div>
                    </div>
                <% }
            } %>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>