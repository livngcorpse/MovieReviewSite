<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User,model.Movie,model.Review, java.util.List" %>
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
    
    // Check if current user already reviewed this movie
    boolean userHasReviewed = false;
    Review userReview = null;
    if (reviews != null) {
        for (Review r : reviews) {
            if (r.getUserId() == user.getUserId()) {
                userHasReviewed = true;
                userReview = r;
                break;
            }
        }
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
    <style>
        .movie-poster-large {
            width: 100%;
            max-width: 350px;
            border-radius: 1rem;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.5);
        }
        
        .poster-placeholder-large {
            width: 100%;
            max-width: 350px;
            height: 500px;
            background: linear-gradient(135deg, #5b21b6 0%, #06b6d4 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 6rem;
            border-radius: 1rem;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.5);
        }
        
        .star-rating {
            color: #eab308;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <!-- Include Common Navigation Bar -->
	<jsp:include page="navbar.jsp" />
    
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
                    You have already reviewed this movie. You can edit your existing review.
                <% } else if ("review_failed".equals(request.getParameter("error"))) { %>
                    Failed to add review. Please try again.
                <% } else if ("update_failed".equals(request.getParameter("error"))) { %>
                    Failed to update review. Please try again.
                <% } else if ("delete_failed".equals(request.getParameter("error"))) { %>
                    Failed to delete review. Please try again.
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <!-- Back Button -->
        <div class="mb-3">
            <a href="movie_list.jsp" class="btn btn-secondary">← Back to Movies</a>
        </div>
        
        <!-- Movie Details -->
        <div class="row mb-4">
            <div class="col-md-4 mb-4 mb-md-0">
                <!-- Movie Poster -->
                <% if (movie.getPosterUrl() != null && !movie.getPosterUrl().trim().isEmpty()) { %>
                    <img src="<%= movie.getPosterUrl() %>" 
                         class="movie-poster-large" 
                         alt="<%= movie.getTitle() %> Poster"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                    <div class="poster-placeholder-large" style="display: none;">
                        🎬
                    </div>
                <% } else { %>
                    <div class="poster-placeholder-large">
                        🎬
                    </div>
                <% } %>
            </div>
            
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h2 class="card-title mb-3"><%= movie.getTitle() %></h2>
                        <h5 class="card-subtitle mb-3 text-muted">
                            Directed by <%= movie.getDirector() %> (<%= movie.getYear() %>)
                        </h5>
                        
                        <div class="mb-4">
                            <% if (movie.getReviewCount() > 0) { %>
                                <div class="star-rating mb-2">
                                    ⭐ <%= String.format("%.1f", movie.getAvgRating()) %>/5
                                </div>
                                <p class="text-muted mb-0">Based on <%= movie.getReviewCount() %> review<%= movie.getReviewCount() != 1 ? "s" : "" %></p>
                            <% } else { %>
                                <p class="text-muted">No reviews yet. Be the first to review!</p>
                            <% } %>
                        </div>
                        
                        <h6 class="fw-bold mb-2">Synopsis:</h6>
                        <p class="card-text"><%= movie.getDescription() %></p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add/Edit Review Form -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <% if (userHasReviewed) { %>
                                Edit Your Review
                            <% } else { %>
                                Write a Review
                            <% } %>
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="ReviewServlet" method="post">
                            <input type="hidden" name="action" value="<%= userHasReviewed ? "update" : "add" %>">
                            <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">
                            <% if (userHasReviewed) { %>
                                <input type="hidden" name="reviewId" value="<%= userReview.getReviewId() %>">
                            <% } %>
                            
                            <div class="mb-3">
                                <label for="rating" class="form-label">Rating *</label>
                                <select class="form-select" id="rating" name="rating" required>
                                    <option value="">Select Rating</option>
                                    <option value="5" <%= userHasReviewed && userReview.getRating() == 5 ? "selected" : "" %>>⭐⭐⭐⭐⭐ (5 - Masterpiece)</option>
                                    <option value="4" <%= userHasReviewed && userReview.getRating() == 4 ? "selected" : "" %>>⭐⭐⭐⭐ (4 - Great)</option>
                                    <option value="3" <%= userHasReviewed && userReview.getRating() == 3 ? "selected" : "" %>>⭐⭐⭐ (3 - Good)</option>
                                    <option value="2" <%= userHasReviewed && userReview.getRating() == 2 ? "selected" : "" %>>⭐⭐ (2 - Fair)</option>
                                    <option value="1" <%= userHasReviewed && userReview.getRating() == 1 ? "selected" : "" %>>⭐ (1 - Poor)</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="comment" class="form-label">Your Review *</label>
                                <textarea class="form-control" id="comment" name="comment" rows="4" required><%= userHasReviewed ? userReview.getComment() : "" %></textarea>
                            </div>
                            
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <%= userHasReviewed ? "Update Review" : "Submit Review" %>
                                </button>
                                <% if (userHasReviewed) { %>
                                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                        Delete Review
                                    </button>
                                <% } %>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- All Reviews -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">All Reviews (<%= movie.getReviewCount() %>)</h5>
                    </div>
                    <div class="card-body">
                        <% if (reviews == null || reviews.isEmpty()) { %>
                            <p class="text-muted text-center my-4">No reviews yet. Be the first to review this movie!</p>
                        <% } else {
                            for (Review review : reviews) { %>
                                <div class="review-item border rounded p-3 mb-3">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h6 class="mb-1"><strong><%= review.getUsername() %></strong></h6>
                                            <div class="star-rating" style="font-size: 1rem;">
                                                <% for (int i = 0; i < review.getRating(); i++) { %>⭐<% } %>
                                                <span class="text-muted ms-2"><%= review.getRating() %>/5</span>
                                            </div>
                                        </div>
                                        <small class="text-muted">
                                            <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(review.getCreatedAt()) %>
                                        </small>
                                    </div>
                                    <p class="mb-0"><%= review.getComment() %></p>
                                </div>
                            <% }
                        } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <% if (userHasReviewed) { %>
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete your review? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form action="ReviewServlet" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="reviewId" value="<%= userReview.getReviewId() %>">
                        <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">
                        <button type="submit" class="btn btn-danger">Delete Review</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% } %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>