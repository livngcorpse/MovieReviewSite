package com.moviereview.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.moviereview.dao.MovieDAO;
import com.moviereview.model.Movie;
import com.moviereview.model.User;

@WebServlet("/MovieServlet")
public class MovieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MovieDAO movieDAO = new MovieDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in and is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect("home.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            int movieId = Integer.parseInt(request.getParameter("id"));
            Movie movie = movieDAO.getMovieById(movieId);
            request.setAttribute("movie", movie);
            request.getRequestDispatcher("edit_movie.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            int movieId = Integer.parseInt(request.getParameter("id"));
            movieDAO.deleteMovie(movieId);
            response.sendRedirect("admin_dashboard.jsp");
        } else {
            request.getRequestDispatcher("add_movie.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in and is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect("home.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String title = request.getParameter("title");
        String director = request.getParameter("director");
        int year = Integer.parseInt(request.getParameter("year"));
        String description = request.getParameter("description");
        
        Movie movie = new Movie();
        movie.setTitle(title);
        movie.setDirector(director);
        movie.setYear(year);
        movie.setDescription(description);
        
        if ("add".equals(action)) {
            boolean success = movieDAO.addMovie(movie);
            if (success) {
                request.setAttribute("success", "Movie added successfully!");
            } else {
                request.setAttribute("error", "Failed to add movie.");
            }
            request.getRequestDispatcher("add_movie.jsp").forward(request, response);
        } else if ("update".equals(action)) {
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            movie.setMovieId(movieId);
            boolean success = movieDAO.updateMovie(movie);
            if (success) {
                response.sendRedirect("admin_dashboard.jsp?success=updated");
            } else {
                request.setAttribute("error", "Failed to update movie.");
                request.setAttribute("movie", movie);
                request.getRequestDispatcher("edit_movie.jsp").forward(request, response);
            }
        }
    }
}