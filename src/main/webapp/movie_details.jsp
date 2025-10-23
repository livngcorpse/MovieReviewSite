<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.moviereview.model.User, com.moviereview.model.Movie, com.moviereview.model.Review, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    Movie movie = (Movie) request.getAttribute("movie");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    
    if (movie == null) {
        response.sendRedirect("movie_list.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= movie.getTitle() %> - Movie Review Site</title>
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
        <!-- Success/Error Messages -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <% if ("review_added".equals(request.getParameter("success"))) { %>
                    Review added successfully!
                <% } else if ("review_updated".equals(request.getParameter("success"))) { %>
                    Review updated successfully!
                <% } else if ("review_deleted".equals(request.getParameter("success"))) { %>
                    Review deleted successfully!
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <% if ("already_reviewed".equals(request.getParameter("error"))) { %>
                    You have already reviewed this movie!
                <% } else { %>
                    An error occurred. Please try again.
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <!-- Movie Details -->
        <div class="card mb-4">
            <div class="card-body">
                <h1 class="card-title"><%= movie.getTitle() %></h1>
                <h5 class="card-subtitle mb-3 text-muted">
                    Directed by <%= movie.getDirector() %> (<%= movie.getYear() %>)
                </h5>
                <p class="card-text"><%= movie.getDescription() %></p>
                
                <div class="mb-3">
                    <% if (movie.getReviewCount() > 0) { %>
                        <h3>
                            <span class="badge bg-warning text-dark">
                                ⭐ <%= String.format("%.1f", movie.getAvgRating()) %>/5
                            </span>
                            <span class="badge bg-secondary">
                                <%= movie.getReviewCount() %> Reviews
                            </span>
                        </h3>
                    <% } else { %>
                        <span class="badge bg-secondary">No reviews yet - Be the first to review!</span>
                    <% } %>
                </div>
                
                <a href="movie_list.jsp" class="btn btn-secondary">← Back to Movies</a>
            </div>
        </div>
        
        <!-- Add Review Form -->
        <%
            boolean hasReviewed = false;
            Review userReview = null;
            for (Review r : reviews) {
                if (r.getUserId() == user.getUserId()) {
                    hasReviewed = true;
                    userReview = r;
                    break;
                }
            }
        %>
        
        <% if (!hasReviewed) { %>
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Write a Review</h5>
            </div>
            <div class="card-body">
                <form action="ReviewServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">
                    
                    <div class="mb-3">
                        <label for="rating" class="form-label">Rating</label>
                        <select class="form-select" id="rating" name="rating" required>
                            <option value="">Select rating...</option>
                            <option value="5">⭐⭐⭐⭐⭐ (5 - Excellent)</option>
                            <option value="4">⭐⭐⭐⭐ (4 - Very Good)</option>
                            <option value="3">⭐⭐⭐ (3 - Good)</option>
                            <option value="2">⭐⭐ (2 - Fair)</option>
                            <option value="1">⭐ (1 - Poor)</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label for="comment" class="form-label">Your Review</label>
                        <textarea class="form-control" id="comment" name="comment" rows="4" required></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Submit Review</button>
                </form>
            </div>
        </div>
        <% } %>
        
        <!-- All Reviews -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">All Reviews</h5>
            </div>
            <div class="card-body">
                <% if (reviews.isEmpty()) { %>
                    <p class="text-muted">No reviews yet. Be the first to review this movie!</p>
                <% } else {
                    for (Review review : reviews) { 
                        boolean isOwner = review.getUserId() == user.getUserId();
                %>
                    <div class="review-item mb-4 p-3 border rounded" id="review-<%= review.getReviewId() %>">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1"><%= review.getUsername() %></h6>
                                <div class="mb-2">
                                    <% for (int i = 0; i < review.getRating(); i++) { %>
                                        <span class="text-warning">⭐</span>
                                    <% } %>
                                    <span class="text-muted">(<%= review.getRating() %>/5)</span>
                                </div>
                            </div>
                            <small class="text-muted"><%= review.getCreatedAt() %></small>
                        </div>
                        <p class="mb-2"><%= review.getComment() %></p>
                        
                        <% if (isOwner) { %>
                            <div class="mt-2">
                                <button class="btn btn-sm btn-warning" onclick="editReview(<%= review.getReviewId() %>, <%= review.getRating() %>, '<%= review.getComment().replace("'", "\\'").replace("\n", "\\n") %>')">
                                    Edit
                                </button>
                                <form action="ReviewServlet" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this review?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                                    <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">
                                    <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                </form>
                            </div>
                        <% } %>
                    </div>
                <% } 
                } %>
            </div>
        </div>
    </div>
    
    <!-- Edit Review Modal -->
    <div class="modal fade" id="editReviewModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ReviewServlet" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="reviewId" id="editReviewId">
                        <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">
                        
                        <div class="mb-3">
                            <label for="editRating" class="form-label">Rating</label>
                            <select class="form-select" id="editRating" name="rating" required>
                                <option value="5">⭐⭐⭐⭐⭐ (5 - Excellent)</option>
                                <option value="4">⭐⭐⭐⭐ (4 - Very Good)</option>
                                <option value="3">⭐⭐⭐ (3 - Good)</option>
                                <option value="2">⭐⭐ (2 - Fair)</option>
                                <option value="1">⭐ (1 - Poor)</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editComment" class="form-label">Your Review</label>
                            <textarea class="form-control" id="editComment" name="comment" rows="4" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Review</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editReview(reviewId, rating, comment) {
            document.getElementById('editReviewId').value = reviewId;
            document.getElementById('editRating').value = rating;
            document.getElementById('editComment').value = comment;
            new bootstrap.Modal(document.getElementById('editReviewModal')).show();
        }
    </script>
</body>
</html>