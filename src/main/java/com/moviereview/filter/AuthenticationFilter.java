package com.moviereview.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

/**
 * Authentication Filter - Protects secured pages
 * Checks if user is logged in before accessing protected resources
 */
@WebFilter(urlPatterns = {"/home.jsp", "/movie_list.jsp", "/movie_details.jsp", 
                          "/admin_dashboard.jsp", "/add_movie.jsp", "/edit_movie.jsp",
                          "/MovieServlet", "/MovieDetailsServlet", "/ReviewServlet"})
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AuthenticationFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        
        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        if (isLoggedIn) {
            // User is authenticated, proceed
            chain.doFilter(request, response);
        } else {
            // User not authenticated, redirect to login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/LoginServlet");
        }
    }
    
    @Override
    public void destroy() {
        System.out.println("AuthenticationFilter destroyed");
    }
}