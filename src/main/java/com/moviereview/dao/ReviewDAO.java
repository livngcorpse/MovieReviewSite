package com.moviereview.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.moviereview.model.Review;
import com.moviereview.util.DBConnection;

public class ReviewDAO {
    
    // CREATE
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
            e.printStackTrace();
        }
        return false;
    }
    
    // READ - Get all reviews for a movie (with JOIN to get username)
    public List<Review> getReviewsByMovieId(int movieId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.username FROM Reviews r " +
                     "INNER JOIN Users u ON r.user_id = u.user_id " +
                     "WHERE r.movie_id = ? ORDER BY r.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, movieId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setMovieId(rs.getInt("movie_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setUsername(rs.getString("username"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }
    
    // READ ONE
    public Review getReviewById(int reviewId) {
        String sql = "SELECT r.*, u.username FROM Reviews r " +
                     "INNER JOIN Users u ON r.user_id = u.user_id " +
                     "WHERE r.review_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reviewId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // UPDATE
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
            e.printStackTrace();
        }
        return false;
    }
    
    // DELETE
    public boolean deleteReview(int reviewId, int userId) {
        String sql = "DELETE FROM Reviews WHERE review_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reviewId);
            stmt.setInt(2, userId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if user already reviewed this movie
    public boolean hasUserReviewedMovie(int userId, int movieId) {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE user_id = ? AND movie_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, movieId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}