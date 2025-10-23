<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.moviereview.model.User,com.moviereview.model.Movie" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect("home.jsp");
        return;
    }
    
    Movie movie = (Movie) request.getAttribute("movie");
    if (movie == null) {
        response.sendRedirect("admin_dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Movie - Movie Review Site</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Include Common Navigation Bar -->
	<jsp:include page="navbar.jsp" />
    
    <!-- Main Content -->
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Edit Movie</h4>
                    </div>
                    <div class="card-body">
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger" role="alert">
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        
                        <form action="MovieServlet" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">
                            
                            <div class="mb-3">
                                <label for="title" class="form-label">Movie Title *</label>
                                <input type="text" class="form-control" id="title" name="title" value="<%= movie.getTitle() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="director" class="form-label">Director *</label>
                                <input type="text" class="form-control" id="director" name="director" value="<%= movie.getDirector() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="year" class="form-label">Release Year *</label>
                                <input type="number" class="form-control" id="year" name="year" value="<%= movie.getYear() %>" min="1900" max="2100" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description *</label>
                                <textarea class="form-control" id="description" name="description" rows="4" required><%= movie.getDescription() %></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="posterUrl" class="form-label">Poster URL (Optional)</label>
                                <input type="url" class="form-control" id="posterUrl" name="posterUrl" 
                                       value="<%= movie.getPosterUrl() != null ? movie.getPosterUrl() : "" %>" 
                                       placeholder="https://example.com/poster.jpg">
                                <small class="form-text text-muted">Enter a valid image URL for the movie poster</small>
                            </div>
                            
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">Update Movie</button>
                                <a href="admin_dashboard.jsp" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>