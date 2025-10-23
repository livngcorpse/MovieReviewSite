package com.moviereview.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.moviereview.model.Review;
import com.moviereview.util.DBConnection;

/**
 * Data Access Object for Review operations
 * Handles all CRUD operations for Reviews with JOIN operations
 */
public class ReviewDAO {
    
    /**
     * CREATE - Add a new review
     * @param review Review object to add
     * @return true if successful, false otherwise
     */
    public boolean addReview(Review review) {
        String sql = "INSERT INTO Reviews (movie_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, review.getMovieId());
            stmt.setInt(2, review.getUserId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error in addReview: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * READ - Get all reviews for a movie with JOIN to get username
     * @param movieId Movie's ID
     * @return List of reviews for the movie
     */
    public List<Review> getReviewsByMovieId(int movieId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.username FROM Reviews r " +
                     "INNER JOIN Users u ON r.user_id = u.user_id " +
                     "WHERE r.movie_id = ? ORDER BY r.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, movieId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review review = extractReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getReviewsByMovieId: " + e.getMessage());
            e.printStackTrace();
        }
        return reviews;
    }
    
    /**
     * READ ONE - Get review by ID with JOIN to get username
     * @param reviewId Review's ID
     * @return Review object if found, null otherwise
     */
    public Review getReviewById(int reviewId) {
        String sql = "SELECT r.*, u.username FROM Reviews r " +
                     "INNER JOIN Users u ON r.user_id = u.user_id " +
                     "WHERE r.review_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reviewId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractReviewFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getReviewById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * UPDATE - Update existing review
     * @param review Review object with updated data
     * @return true if successful, false otherwise
     */
    public boolean updateReview(Review review) {
        String sql = "UPDATE Reviews SET rating = ?, comment = ? WHERE review_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getComment());
            stmt.setInt(3, review.getReviewId());
            stmt.setInt(4, review.getUserId());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error in updateReview: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * DELETE - Delete review by ID (with user ownership check)
     * @param reviewId Review's ID
     * @param userId User's ID (ownership verification)
     * @return true if successful, false otherwise
     */
    public boolean deleteReview(int reviewId, int userId) {
        String sql = "DELETE FROM Reviews WHERE review_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reviewId);
            stmt.setInt(2, userId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error in deleteReview: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if user already reviewed this movie
     * @param userId User's ID
     * @param movieId Movie's ID
     * @return true if user already reviewed, false otherwise
     */
    public boolean hasUserReviewedMovie(int userId, int movieId) {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE user_id = ? AND movie_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, movieId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in hasUserReviewedMovie: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Helper method to extract Review object from ResultSet
     * @param rs ResultSet containing review data
     * @return Review object
     * @throws SQLException if column not found
     */
    private Review extractReviewFromResultSet(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("review_id"));
        review.setMovieId(rs.getInt("movie_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        review.setUsername(rs.getString("username"));
        return review;
    }
}