package com.moviereview.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.util.Date;
import java.text.SimpleDateFormat;

/**
 * Logging Filter - Logs all requests with timestamps
 * Demonstrates filter chaining and request processing
 */
@WebFilter(urlPatterns = {"/*"})
public class LoggingFilter implements Filter {
    
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("========================================");
        System.out.println("LoggingFilter initialized at: " + dateFormat.format(new Date()));
        System.out.println("========================================");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Log request details
        String timestamp = dateFormat.format(new Date());
        String method = httpRequest.getMethod();
        String uri = httpRequest.getRequestURI();
        String queryString = httpRequest.getQueryString();
        String sessionId = httpRequest.getSession(false) != null ? 
                          httpRequest.getSession(false).getId() : "No Session";
        
        // Build log message
        StringBuilder logMessage = new StringBuilder();
        logMessage.append("\n[").append(timestamp).append("] ")
                 .append(method).append(" ")
                 .append(uri);
        
        if (queryString != null) {
            logMessage.append("?").append(queryString);
        }
        
        logMessage.append(" | Session: ").append(sessionId.substring(0, Math.min(8, sessionId.length())));
        
        // Get user info from session
        HttpSession session = httpRequest.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            logMessage.append(" | User: ").append(session.getAttribute("username"));
        }
        
        System.out.println(logMessage.toString());
        
        // Record start time
        long startTime = System.currentTimeMillis();
        
        // Continue with the filter chain
        chain.doFilter(request, response);
        
        // Calculate processing time
        long processingTime = System.currentTimeMillis() - startTime;
        
        // Log response details
        System.out.println("[Response] Status: " + httpResponse.getStatus() + 
                          " | Processing Time: " + processingTime + "ms");
    }
    
    @Override
    public void destroy() {
        System.out.println("========================================");
        System.out.println("LoggingFilter destroyed at: " + dateFormat.format(new Date()));
        System.out.println("========================================");
    }
}