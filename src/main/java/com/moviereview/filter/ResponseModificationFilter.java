package com.moviereview.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.CharArrayWriter;
import java.io.PrintWriter;

/**
 * Response Modification Filter - Adds security headers and footer to responses
 * Demonstrates response modification capability
 */
@WebFilter(urlPatterns = {"*.jsp"})
public class ResponseModificationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("ResponseModificationFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Add security headers to response
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("X-Frame-Options", "DENY");
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
        
        // Create a wrapper to capture response
        CharResponseWrapper wrappedResponse = new CharResponseWrapper(httpResponse);
        
        // Continue with the filter chain
        chain.doFilter(request, wrappedResponse);
        
        // Get the captured content
        String content = wrappedResponse.toString();
        
        // Modify response by adding footer comment
        if (content.contains("</body>")) {
            String footer = "\n<!-- Page processed by ResponseModificationFilter at " + 
                          new java.util.Date() + " -->\n";
            content = content.replace("</body>", footer + "</body>");
        }
        
        // Write modified content
        response.getWriter().write(content);
    }
    
    @Override
    public void destroy() {
        System.out.println("ResponseModificationFilter destroyed");
    }
    
    /**
     * Response wrapper to capture output
     */
    private static class CharResponseWrapper extends HttpServletResponseWrapper {
        private CharArrayWriter output;
        
        public CharResponseWrapper(HttpServletResponse response) {
            super(response);
            output = new CharArrayWriter();
        }
        
        @Override
        public PrintWriter getWriter() {
            return new PrintWriter(output);
        }
        
        @Override
        public String toString() {
            return output.toString();
        }
    }
}