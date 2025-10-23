# Movie Rating & Review Site

A dynamic web application for movie reviews and ratings built with Java Servlets, JSP, and MySQL.

## 🎯 Features

### Admin Features
- ✅ **CRUD Operations on Movies**
  - Add new movies
  - View all movies
  - Edit movie details
  - Delete movies

### User Features
- ✅ **User Registration & Authentication**
  - Register new account
  - Login with credentials
  - Remember Me (Cookies)
  - Session management

- ✅ **Review Management**
  - View all movies with average ratings
  - Read movie details with reviews (JOIN operations)
  - Create reviews (rating 1-5 + comment)
  - Update own reviews
  - Delete own reviews
  - One review per movie per user

### Technical Features
- ✅ MVC Architecture
- ✅ Session Management
- ✅ Cookie Support (Remember Me)
- ✅ JOIN Operations (Movies with Reviews)
- ✅ Aggregation (AVG rating calculation)
- ✅ Bootstrap 5 UI
- ✅ "Welcome, username" on every page

## 📋 Prerequisites

- **JDK 8 or higher**
- **Eclipse IDE for Java EE Developers**
- **Apache Tomcat 9.x**
- **MySQL 5.7 or higher**
- **MySQL Connector/J 8.0.x**
- **JSTL 1.2 JAR**

## 🚀 Installation Steps

### 1. Database Setup

```sql
-- Create database
CREATE DATABASE movie_review_db;
USE movie_review_db;

-- Create Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) DEFAULT 'USER'
);

-- Create Movies table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    director VARCHAR(100),
    year INT,
    description TEXT
);

-- Create Reviews table
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT,
    user_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Insert default admin user (username: admin, password: admin123)
INSERT INTO Users (username, password, role) 
VALUES ('admin', 'admin123', 'ADMIN');

-- Insert sample movies
INSERT INTO Movies (title, director, year, description) VALUES 
('The Shawshank Redemption', 'Frank Darabont', 1994, 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.'),
('The Godfather', 'Francis Ford Coppola', 1972, 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.'),
('The Dark Knight', 'Christopher Nolan', 2008, 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological tests.');
```

### 2. Eclipse Project Setup

1. **Open Eclipse IDE for Java EE**

2. **Create New Dynamic Web Project**
   - File → New → Dynamic Web Project
   - Project name: `MovieReviewSite`
   - Target runtime: Apache Tomcat 9.x
   - Dynamic web module version: 3.1
   - Click "Finish"

3. **Add JAR Files**
   - Right-click project → Properties → Java Build Path → Libraries
   - Add External JARs:
     - `mysql-connector-java-8.0.x.jar`
     - `jstl-1.2.jar`
   - Copy both JARs to `WebContent/WEB-INF/lib/`

### 3. Project Structure

Create the following structure:

```
MovieReviewSite/
├── src/
│   └── com/
│       └── moviereview/
│           ├── model/
│           │   ├── User.java
│           │   ├── Movie.java
│           │   └── Review.java
│           ├── dao/
│           │   ├── UserDAO.java
│           │   ├── MovieDAO.java
│           │   └── ReviewDAO.java
│           ├── servlet/
│           │   ├── LoginServlet.java
│           │   ├── RegisterServlet.java
│           │   ├── LogoutServlet.java
│           │   ├── MovieServlet.java
│           │   ├── MovieDetailsServlet.java
│           │   └── ReviewServlet.java
│           └── util/
│               └── DBConnection.java
│
└── WebContent/
    ├── WEB-INF/
    │   ├── web.xml
    │   └── lib/
    │       ├── mysql-connector-java-8.0.x.jar
    │       └── jstl-1.2.jar
    ├── css/
    │   └── style.css
    ├── index.jsp
    ├── login.jsp
    ├── register.jsp
    ├── home.jsp
    ├── movie_list.jsp
    ├── movie_details.jsp
    ├── add_movie.jsp
    ├── edit_movie.jsp
    └── admin_dashboard.jsp
```

### 4. Configure Database Connection

Edit `src/com/moviereview/util/DBConnection.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/movie_review_db";
private static final String USER = "root";
private static final String PASSWORD = "your_mysql_password"; // Change this
```

### 5. Deploy and Run

1. **Right-click project** → Run As → Run on Server
2. **Select Tomcat 9.x** → Finish
3. **Access application**: `http://localhost:8080/MovieReviewSite/`

## 👥 Default Login Credentials

### Admin Account
- **Username:** admin
- **Password:** admin123

### User Account
- Register a new account from the registration page

## 🎨 Pages Overview

| Page | URL | Access | Description |
|------|-----|--------|-------------|
| Landing | `/index.jsp` | Public | Welcome page with login/register links |
| Login | `/LoginServlet` | Public | User authentication |
| Register | `/RegisterServlet` | Public | New user registration |
| Home | `/home.jsp` | Logged In | Dashboard with welcome message |
| Movies List | `/movie_list.jsp` | Logged In | All movies with avg ratings |
| Movie Details | `/MovieDetailsServlet?id=X` | Logged In | Movie info + all reviews |
| Admin Dashboard | `/admin_dashboard.jsp` | Admin Only | Manage movies (CRUD) |
| Add Movie | `/add_movie.jsp` | Admin Only | Create new movie |
| Edit Movie | `/edit_movie.jsp?id=X` | Admin Only | Update movie details |

## 🔧 Key Technical Implementations

### 1. **Session Management**
```java
HttpSession session = request.getSession();
session.setAttribute("user", user);
session.setMaxInactiveInterval(30 * 60); // 30 minutes
```

### 2. **Cookie Support (Remember Me)**
```java
Cookie userCookie = new Cookie("username", username);
userCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
response.addCookie(userCookie);
```

### 3. **JOIN Operations**
```sql
-- Get reviews with username
SELECT r.*, u.username FROM Reviews r 
INNER JOIN Users u ON r.user_id = u.user_id 
WHERE r.movie_id = ?
```

### 4. **Aggregation (AVG)**
```sql
-- Get movie with average rating
SELECT m.*, COALESCE(AVG(r.rating), 0) as avg_rating, 
       COUNT(r.review_id) as review_count 
FROM Movies m 
LEFT JOIN Reviews r ON m.movie_id = r.movie_id 
WHERE m.movie_id = ? 
GROUP BY m.movie_id
```

## 📱 Features Demonstration

### User Flow
1. Register → Login → View Movies → Select Movie → Write Review
2. View own reviews → Edit/Delete own reviews

### Admin Flow
1. Login as admin → Admin Dashboard → Add/Edit/Delete Movies
2. View all movies with statistics

## 🎯 CRUD Operations Summary

| Entity | Create | Read | Update | Delete | Who |
|--------|--------|------|--------|--------|-----|
| **User** | ✅ Register | - | - | - | Anyone |
| **Movie** | ✅ Add | ✅ List/Details | ✅ Edit | ✅ Delete | Admin |
| **Review** | ✅ Write | ✅ View All | ✅ Edit Own | ✅ Delete Own | User |

## 🐛 Troubleshooting

### Common Issues

1. **ClassNotFoundException: com.mysql.cj.jdbc.Driver**
   - Add MySQL Connector JAR to build path and WEB-INF/lib

2. **SQLException: Access denied**
   - Check database credentials in DBConnection.java

3. **404 Error on JSP pages**
   - Verify file locations in WebContent folder
   - Check servlet mappings in web.xml

4. **Session timeout**
   - Adjust session timeout in web.xml or servlet code

5. **Bootstrap not loading**
   - Check internet connection (CDN links)
   - Or download Bootstrap locally

## 📚 Technologies Used

- **Backend:** Java Servlets, JSP, JDBC
- **Database:** MySQL 8.0
- **Frontend:** Bootstrap 5, HTML5, CSS3, JavaScript
- **Server:** Apache Tomcat 9
- **Architecture:** MVC Pattern
- **Session:** HttpSession, Cookies

## 🔐 Security Notes

⚠️ **For Production Use:**
- Implement password hashing (BCrypt)
- Use PreparedStatements (already implemented)
- Add CSRF protection
- Implement input validation
- Use HTTPS
- Add SQL injection prevention
- Implement XSS prevention

## 📄 License

This project is for educational purposes.

## 👨‍💻 Author

Created as a Java EE Web Application Demo Project

---

**Enjoy building with Movie Review Site! 🎬⭐**