package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Movie;
import util.DBConnection;

/**
 * Data Access Object for Movie operations
 * Handles all CRUD operations for Movies with proper JDBC practices
 */
public class MovieDAO {
    
    /**
     * CREATE - Add a new movie
     * @param movie Movie object to add
     * @return true if successful, false otherwise
     */
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
            System.err.println("Error in addMovie: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * READ ALL - Get all movies with AVG rating and review count (JOIN + AGGREGATION)
     * @return List of all movies
     */
    public List<Movie> getAllMovies() {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT m.*, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                     "FROM Movies m LEFT JOIN Reviews r ON m.movie_id = r.movie_id " +
                     "GROUP BY m.movie_id ORDER BY m.title";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Movie movie = extractMovieFromResultSet(rs);
                movies.add(movie);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllMovies: " + e.getMessage());
            e.printStackTrace();
        }
        return movies;
    }
    
    /**
     * READ ONE - Get movie by ID with AVG rating (JOIN + AGGREGATION)
     * @param movieId Movie's ID
     * @return Movie object if found, null otherwise
     */
    public Movie getMovieById(int movieId) {
        String sql = "SELECT m.*, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                     "FROM Movies m LEFT JOIN Reviews r ON m.movie_id = r.movie_id " +
                     "WHERE m.movie_id = ? GROUP BY m.movie_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, movieId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractMovieFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getMovieById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * UPDATE - Update existing movie
     * @param movie Movie object with updated data
     * @return true if successful, false otherwise
     */
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
            System.err.println("Error in updateMovie: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * DELETE - Delete movie by ID (CASCADE deletes reviews)
     * @param movieId Movie's ID
     * @return true if successful, false otherwise
     */
    public boolean deleteMovie(int movieId) {
        String sql = "DELETE FROM Movies WHERE movie_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, movieId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error in deleteMovie: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Helper method to extract Movie object from ResultSet
     * @param rs ResultSet containing movie data
     * @return Movie object
     * @throws SQLException if column not found
     */
    private Movie extractMovieFromResultSet(ResultSet rs) throws SQLException {
        Movie movie = new Movie();
        movie.setMovieId(rs.getInt("movie_id"));
        movie.setTitle(rs.getString("title"));
        movie.setDirector(rs.getString("director"));
        movie.setYear(rs.getInt("year"));
        movie.setDescription(rs.getString("description"));
        movie.setPosterUrl(rs.getString("poster_url"));
        movie.setAvgRating(rs.getDouble("avg_rating"));
        movie.setReviewCount(rs.getInt("review_count"));
        return movie;
    }
}