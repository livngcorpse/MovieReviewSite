package com.moviereview.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.moviereview.model.Movie;
import com.moviereview.util.DBConnection;

public class MovieDAO {
    
    // CREATE - Now includes poster_url
    public boolean addMovie(Movie movie) {
        String sql = "INSERT INTO Movies (title, director, year, description, poster_url) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, movie.getTitle());
            stmt.setString(2, movie.getDirector());
            stmt.setInt(3, movie.getYear());
            stmt.setString(4, movie.getDescription());
            stmt.setString(5, movie.getPosterUrl());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // READ ALL with AVG rating and review count
    public List<Movie> getAllMovies() {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT m.*, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                     "FROM Movies m LEFT JOIN Reviews r ON m.movie_id = r.movie_id " +
                     "GROUP BY m.movie_id ORDER BY m.title";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setDirector(rs.getString("director"));
                movie.setYear(rs.getInt("year"));
                movie.setDescription(rs.getString("description"));
                movie.setPosterUrl(rs.getString("poster_url")); // NEW
                movie.setAvgRating(rs.getDouble("avg_rating"));
                movie.setReviewCount(rs.getInt("review_count"));
                movies.add(movie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }
    
    // READ ONE with AVG rating
    public Movie getMovieById(int movieId) {
        String sql = "SELECT m.*, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                     "FROM Movies m LEFT JOIN Reviews r ON m.movie_id = r.movie_id " +
                     "WHERE m.movie_id = ? GROUP BY m.movie_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, movieId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setDirector(rs.getString("director"));
                movie.setYear(rs.getInt("year"));
                movie.setDescription(rs.getString("description"));
                movie.setPosterUrl(rs.getString("poster_url")); // NEW
                movie.setAvgRating(rs.getDouble("avg_rating"));
                movie.setReviewCount(rs.getInt("review_count"));
                return movie;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // UPDATE - Now includes poster_url
    public boolean updateMovie(Movie movie) {
        String sql = "UPDATE Movies SET title = ?, director = ?, year = ?, description = ?, poster_url = ? WHERE movie_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, movie.getTitle());
            stmt.setString(2, movie.getDirector());
            stmt.setInt(3, movie.getYear());
            stmt.setString(4, movie.getDescription());
            stmt.setString(5, movie.getPosterUrl());
            stmt.setInt(6, movie.getMovieId());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // DELETE - Unchanged
    public boolean deleteMovie(int movieId) {
        String sql = "DELETE FROM Movies WHERE movie_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, movieId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}