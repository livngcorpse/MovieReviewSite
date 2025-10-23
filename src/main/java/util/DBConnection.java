package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility Class
 * Provides JDBC connection to MySQL/MariaDB database
 * Uses try-with-resources for proper resource management
 */
public class DBConnection {
    // JDBC Configuration
    private static final String URL = "jdbc:mariadb://localhost:3306/movie_review_db";
    private static final String USER = "root";
    private static final String PASSWORD = "277353";
    private static final String DRIVER = "org.mariadb.jdbc.Driver";
    
    // Static block to load JDBC driver
    static {
        try {
            // Load and register JDBC driver
            Class.forName(DRIVER);
            System.out.println("✓ MariaDB JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("✗ MariaDB JDBC Driver not found!");
            e.printStackTrace();
            throw new RuntimeException("Failed to load database driver", e);
        }
    }
    
    /**
     * Get a new database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✓ Database connection established");
            return conn;
        } catch (SQLException e) {
            System.err.println("✗ Failed to connect to database");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            throw e;
        }
    }
    
    /**
     * Test database connection
     * @return true if connection successful
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Close connection safely
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("✓ Connection closed");
            } catch (SQLException e) {
                System.err.println("✗ Error closing connection: " + e.getMessage());
            }
        }
    }
}