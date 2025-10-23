package com.moviereview.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.moviereview.dao.ReviewDAO;
import com.moviereview.model.Review;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReviewDAO reviewDAO = new ReviewDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        
        String action = request.getParameter("action");
        int userId = (Integer) session.getAttribute("userId");
        
        if ("add".equals(action)) {
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            // Check if user already reviewed this movie
            if (reviewDAO.hasUserReviewedMovie(userId, movieId)) {
                response.sendRedirect("MovieDetailsServlet?id=" + movieId + "&error=already_reviewed");
                return;
            }
            
            Review review = new Review();
            review.setMovieId(movieId);
            review.setUserId(userId);
            review.setRating(rating);
            review.setComment(comment);
            
            boolean success = reviewDAO.addReview(review);
            if (success) {
                response.sendRedirect("MovieDetailsServlet?id=" + movieId + "&success=review_added");
            } else {
                response.sendRedirect("MovieDetailsServlet?id=" + movieId + "&error=review_failed");
            }
            
        } else if ("update".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            Review review = new Review();
            review.setReviewId(reviewId);
            review.setUserId(userId);
            review.setRating(rating);
            review.setComment(comment);
            
            boolean success = reviewDAO.updateReview(review);
            if (success) {
                response.sendRedirect("MovieDetailsServlet?id=" + movieId + "&success=review_updated");
            } else {
                response.sendRedirect("MovieDetailsServlet?id=" + movieId + "&error=update_failed");
            }
            
        } else if ("delete".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            
            boolean success = reviewDAO.deleteReview(reviewId, userId);
            if (success) {
                response.sendRedirect("MovieDetailsServlet?id=" + movieId + "&success=review_deleted");
            } else {
                response.sendRedirect("MovieDetailsServlet?id=" + movieId + "&error=delete_failed");
            }
        }
    }
}