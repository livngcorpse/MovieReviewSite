package servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.MovieDAO;
import dao.ReviewDAO;
import model.Movie;
import model.Review;

@WebServlet("/MovieDetailsServlet")
public class MovieDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MovieDAO movieDAO = new MovieDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        
        int movieId = Integer.parseInt(request.getParameter("id"));
        
        // Get movie details with average rating (JOIN operation)
        Movie movie = movieDAO.getMovieById(movieId);
        
        // Get all reviews for this movie (JOIN operation to get username)
        List<Review> reviews = reviewDAO.getReviewsByMovieId(movieId);
        
        request.setAttribute("movie", movie);
        request.setAttribute("reviews", reviews);
        
        request.getRequestDispatcher("movie_details.jsp").forward(request, response);
    }
}