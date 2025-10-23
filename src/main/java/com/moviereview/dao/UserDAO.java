package com.moviereview.dao;

import java.sql.*;

import com.moviereview.model.User;
import com.moviereview.util.DBConnection;

/**
 * Data Access Object for User operations
 * Handles all database operations related to Users
 * Uses PreparedStatement and try-with-resources for proper JDBC handling
 */
public class UserDAO {
    
    /**
     * Authenticate user with username and password
     * @param username User's username
     * @param password User's password
     * @return User object if authentication successful, null otherwise
     */
    public User authenticate(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        
        // Try-with-resources ensures automatic closing of resources
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Set parameters using PreparedStatement (prevents SQL injection)
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            // Execute query and process ResultSet
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in authenticate: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Register a new user
     * @param username New user's username
     * @param password New user's password
     * @return true if registration successful, false otherwise
     */
    public boolean register(String username, String password) {
        String sql = "INSERT INTO Users (username, password, role) VALUES (?, ?, 'USER')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error in register: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if username already exists
     * @param username Username to check
     * @return true if username exists, false otherwise
     */
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in usernameExists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get user by ID
     * @param userId User's ID
     * @return User object if found, null otherwise
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getUserById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}