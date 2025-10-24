<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.moviereview.dao.MovieDAO" %>
<jsp:useBean id="movieDAO" class="com.moviereview.dao.MovieDAO" />
<c:set var="movies" value="${movieDAO.allMovies}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSTL Demo - All Tags Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    
    <div class="container mt-4">
        <h1 class="mb-4">🏷️ JSTL Tags Demonstration</h1>
        
        <!-- ========== CORE TAGS (c:) ========== -->
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h3>1. Core Tags (c:set, c:out, c:if, c:choose, c:forEach)</h3>
            </div>
            <div class="card-body">
                <!-- c:set - Set Variables -->
                <h5>c:set - Setting Variables</h5>
                <c:set var="siteName" value="CineReview" />
                <c:set var="totalMovies" value="${fn:length(movies)}" />
                <c:set var="userRole" value="${sessionScope.role}" />
                <p>Site Name: <code><c:out value="${siteName}"/></code></p>
                <p>Total Movies: <code><c:out value="${totalMovies}"/></code></p>
                
                <!-- c:out - Output with escaping -->
                <h5 class="mt-3">c:out - Safe Output</h5>
                <p>Username: <c:out value="${sessionScope.username}" default="Guest"/></p>
                
                <!-- c:if - Conditional -->
                <h5 class="mt-3">c:if - Simple Condition</h5>
                <c:if test="${not empty sessionScope.user}">
                    <div class="alert alert-success">✓ User is logged in</div>
                </c:if>
                <c:if test="${empty sessionScope.user}">
                    <div class="alert alert-warning">⚠ No user logged in</div>
                </c:if>
                
                <!-- c:choose - Multiple Conditions -->
                <h5 class="mt-3">c:choose/c:when/c:otherwise - Multiple Conditions</h5>
                <c:choose>
                    <c:when test="${userRole eq 'ADMIN'}">
                        <span class="badge bg-danger">Admin Access</span>
                    </c:when>
                    <c:when test="${userRole eq 'USER'}">
                        <span class="badge bg-success">User Access</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-secondary">Guest</span>
                    </c:otherwise>
                </c:choose>
                
                <!-- c:forEach - Loop with varStatus -->
                <h5 class="mt-3">c:forEach - Iteration with Status</h5>
                <table class="table table-sm table-bordered">
                    <thead>
                        <tr>
                            <th>Index</th>
                            <th>Count</th>
                            <th>Movie Title</th>
                            <th>First?</th>
                            <th>Last?</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="movie" items="${movies}" varStatus="status" begin="0" end="4">
                            <tr>
                                <td>${status.index}</td>
                                <td>${status.count}</td>
                                <td><c:out value="${movie.title}"/></td>
                                <td><c:if test="${status.first}">✓</c:if></td>
                                <td><c:if test="${status.last}">✓</c:if></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <!-- c:forTokens - String Tokenization -->
                <h5 class="mt-3">c:forTokens - String Splitting</h5>
                <c:set var="genres" value="Action,Comedy,Drama,Horror,Sci-Fi" />
                <c:forTokens var="genre" items="${genres}" delims=",">
                    <span class="badge bg-info me-2">${genre}</span>
                </c:forTokens>
                
                <!-- c:url - URL Rewriting -->
                <h5 class="mt-3">c:url - URL Construction with Parameters</h5>
                <c:url var="movieUrl" value="MovieDetailsServlet">
                    <c:param name="id" value="1"/>
                    <c:param name="source" value="jstl_demo"/>
                </c:url>
                <p>Generated URL: <code>${movieUrl}</code></p>
                <a href="${movieUrl}" class="btn btn-sm btn-primary">Test URL</a>
                
                <!-- c:import - Include Content -->
                <h5 class="mt-3">c:import - Dynamic Content Import</h5>
                <div class="border p-2">
                    <c:import url="navbar.jsp" />
                </div>
                
                <!-- c:redirect - Conditional Redirect -->
                <h5 class="mt-3">c:redirect - Redirect Example (commented out)</h5>
                <code>&lt;c:redirect url="home.jsp"&gt;</code>
                
                <!-- c:remove - Remove Variable -->
                <h5 class="mt-3">c:remove - Variable Removal</h5>
                <c:set var="tempVar" value="Temporary Data" />
                <p>Before: ${tempVar}</p>
                <c:remove var="tempVar" />
                <p>After: ${empty tempVar ? 'Variable removed' : tempVar}</p>
            </div>
        </div>
        
        <!-- ========== FORMATTING TAGS (fmt:) ========== -->
        <div class="card mb-4">
            <div class="card-header bg-success text-white">
                <h3>2. Formatting Tags (fmt:formatNumber, fmt:formatDate)</h3>
            </div>
            <div class="card-body">
                <!-- fmt:formatNumber -->
                <h5>fmt:formatNumber - Number Formatting</h5>
                <c:set var="avgRating" value="4.567890" />
                <c:set var="price" value="1234567.89" />
                
                <table class="table table-sm">
                    <tr>
                        <td>Original:</td>
                        <td>${avgRating}</td>
                    </tr>
                    <tr>
                        <td>One Decimal:</td>
                        <td><fmt:formatNumber value="${avgRating}" pattern="0.0"/></td>
                    </tr>
                    <tr>
                        <td>Two Decimals:</td>
                        <td><fmt:formatNumber value="${avgRating}" pattern="0.00"/></td>
                    </tr>
                    <tr>
                        <td>Currency:</td>
                        <td><fmt:formatNumber value="${price}" type="currency" currencySymbol="$"/></td>
                    </tr>
                    <tr>
                        <td>Percentage:</td>
                        <td><fmt:formatNumber value="${avgRating/5}" type="percent"/></td>
                    </tr>
                </table>
                
                <!-- fmt:formatDate -->
                <h5 class="mt-3">fmt:formatDate - Date Formatting</h5>
                <jsp:useBean id="now" class="java.util.Date" />
                <table class="table table-sm">
                    <tr>
                        <td>Short Date:</td>
                        <td><fmt:formatDate value="${now}" type="date" dateStyle="short"/></td>
                    </tr>
                    <tr>
                        <td>Medium Date:</td>
                        <td><fmt:formatDate value="${now}" type="date" dateStyle="medium"/></td>
                    </tr>
                    <tr>
                        <td>Long Date:</td>
                        <td><fmt:formatDate value="${now}" type="date" dateStyle="long"/></td>
                    </tr>
                    <tr>
                        <td>Custom Pattern:</td>
                        <td><fmt:formatDate value="${now}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    </tr>
                    <tr>
                        <td>Custom Pattern 2:</td>
                        <td><fmt:formatDate value="${now}" pattern="EEEE, MMMM dd, yyyy"/></td>
                    </tr>
                </table>
                
                <!-- fmt:parseNumber -->
                <h5 class="mt-3">fmt:parseNumber - String to Number</h5>
                <c:set var="stringNumber" value="12345.67" />
                <fmt:parseNumber var="parsedNum" value="${stringNumber}" />
                <p>Parsed: ${parsedNum * 2}</p>
                
                <!-- fmt:parseDate -->
                <h5 class="mt-3">fmt:parseDate - String to Date</h5>
                <fmt:parseDate value="2025-01-15" pattern="yyyy-MM-dd" var="parsedDate" />
                <p>Parsed Date: <fmt:formatDate value="${parsedDate}" pattern="MMMM dd, yyyy"/></p>
            </div>
        </div>
        
        <!-- ========== FUNCTION TAGS (fn:) ========== -->
        <div class="card mb-4">
            <div class="card-header bg-warning text-dark">
                <h3>3. Function Tags (fn:length, fn:substring, fn:split, etc.)</h3>
            </div>
            <div class="card-body">
                <c:set var="movieTitle" value="The Shawshank Redemption" />
                <c:set var="description" value="Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency." />
                
                <!-- fn:length -->
                <h5>fn:length - Get Length</h5>
                <p>Movies Count: <strong>${fn:length(movies)}</strong></p>
                <p>Title Length: <strong>${fn:length(movieTitle)}</strong></p>
                
                <!-- fn:substring -->
                <h5 class="mt-3">fn:substring - Extract Substring</h5>
                <p>First 10 chars: <code>${fn:substring(movieTitle, 0, 10)}</code></p>
                
                <!-- fn:substringBefore / fn:substringAfter -->
                <h5 class="mt-3">fn:substringBefore / fn:substringAfter</h5>
                <p>Before "Shawshank": <code>${fn:substringBefore(movieTitle, "Shawshank")}</code></p>
                <p>After "Shawshank": <code>${fn:substringAfter(movieTitle, "Shawshank")}</code></p>
                
                <!-- fn:toLowerCase / fn:toUpperCase -->
                <h5 class="mt-3">fn:toLowerCase / fn:toUpperCase</h5>
                <p>Lowercase: <code>${fn:toLowerCase(movieTitle)}</code></p>
                <p>Uppercase: <code>${fn:toUpperCase(movieTitle)}</code></p>
                
                <!-- fn:contains / fn:containsIgnoreCase -->
                <h5 class="mt-3">fn:contains / fn:containsIgnoreCase</h5>
                <p>Contains "Shawshank": ${fn:contains(movieTitle, "Shawshank") ? '✓ Yes' : '✗ No'}</p>
                <p>Contains "shawshank" (ignore case): ${fn:containsIgnoreCase(movieTitle, "shawshank") ? '✓ Yes' : '✗ No'}</p>
                
                <!-- fn:startsWith / fn:endsWith -->
                <h5 class="mt-3">fn:startsWith / fn:endsWith</h5>
                <p>Starts with "The": ${fn:startsWith(movieTitle, "The") ? '✓ Yes' : '✗ No'}</p>
                <p>Ends with "Redemption": ${fn:endsWith(movieTitle, "Redemption") ? '✓ Yes' : '✗ No'}</p>
                
                <!-- fn:indexOf -->
                <h5 class="mt-3">fn:indexOf - Find Position</h5>
                <p>Position of "Shawshank": ${fn:indexOf(movieTitle, "Shawshank")}</p>
                
                <!-- fn:replace -->
                <h5 class="mt-3">fn:replace - Replace String</h5>
                <p>Original: ${movieTitle}</p>
                <p>Replaced: ${fn:replace(movieTitle, "Shawshank", "Freedom")}</p>
                
                <!-- fn:split / fn:join -->
                <h5 class="mt-3">fn:split - String to Array</h5>
                <c:set var="words" value="${fn:split(movieTitle, ' ')}" />
                <p>Word Count: ${fn:length(words)}</p>
                <c:forEach var="word" items="${words}" varStatus="status">
                    <span class="badge bg-secondary">${status.count}. ${word}</span>
                </c:forEach>
                
                <!-- fn:trim -->
                <h5 class="mt-3">fn:trim - Remove Whitespace</h5>
                <c:set var="messy" value="  Trimmed Text  " />
                <p>Original: "<code>${messy}</code>"</p>
                <p>Trimmed: "<code>${fn:trim(messy)}</code>"</p>
                
                <!-- fn:escapeXml -->
                <h5 class="mt-3">fn:escapeXml - Escape HTML/XML</h5>
                <c:set var="htmlCode" value="<script>alert('XSS')</script>" />
                <p>Escaped: <code>${fn:escapeXml(htmlCode)}</code></p>
            </div>
        </div>
        
        <!-- ========== COMBINED EXAMPLE ========== -->
        <div class="card mb-4">
            <div class="card-header bg-info text-white">
                <h3>4. Combined JSTL Example - Movie Statistics</h3>
            </div>
            <div class="card-body">
                <!-- Calculate statistics using JSTL -->
                <c:set var="totalReviews" value="0" />
                <c:set var="totalRating" value="0" />
                <c:set var="moviesWithReviews" value="0" />
                
                <c:forEach var="movie" items="${movies}">
                    <c:set var="totalReviews" value="${totalReviews + movie.reviewCount}" />
                    <c:if test="${movie.reviewCount > 0}">
                        <c:set var="totalRating" value="${totalRating + movie.avgRating}" />
                        <c:set var="moviesWithReviews" value="${moviesWithReviews + 1}" />
                    </c:if>
                </c:forEach>
                
                <div class="row">
                    <div class="col-md-3">
                        <div class="card text-center">
                            <div class="card-body">
                                <h2 class="text-primary">${fn:length(movies)}</h2>
                                <p class="text-muted">Total Movies</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-center">
                            <div class="card-body">
                                <h2 class="text-success">${totalReviews}</h2>
                                <p class="text-muted">Total Reviews</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-center">
                            <div class="card-body">
                                <h2 class="text-warning">${moviesWithReviews}</h2>
                                <p class="text-muted">Reviewed Movies</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-center">
                            <div class="card-body">
                                <h2 class="text-info">
                                    <c:choose>
                                        <c:when test="${moviesWithReviews > 0}">
                                            <fmt:formatNumber value="${totalRating / moviesWithReviews}" pattern="0.0"/>
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </h2>
                                <p class="text-muted">Avg Rating</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Top Rated Movies -->
                <h5 class="mt-4">Top 5 Rated Movies</h5>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Title</th>
                            <th>Rating</th>
                            <th>Reviews</th>
                            <th>Year</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="movie" items="${movies}" varStatus="status" begin="0" end="4">
                            <c:if test="${movie.reviewCount > 0}">
                                <tr>
                                    <td>${status.count}</td>
                                    <td>
                                        <strong><c:out value="${movie.title}"/></strong>
                                        <c:if test="${fn:length(movie.title) > 30}">
                                            <small class="text-muted">(Long Title)</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="badge bg-warning text-dark">
                                            ⭐ <fmt:formatNumber value="${movie.avgRating}" pattern="0.0"/>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">${movie.reviewCount}</span>
                                    </td>
                                    <td>${movie.year}</td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- ========== SESSION & REQUEST INFO ========== -->
        <div class="card mb-4">
            <div class="card-header bg-secondary text-white">
                <h3>5. Session & Request Information</h3>
            </div>
            <div class="card-body">
                <table class="table table-sm">
                    <tr>
                        <td><strong>Session ID:</strong></td>
                        <td><code>${pageContext.session.id}</code></td>
                    </tr>
                    <tr>
                        <td><strong>Username:</strong></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty sessionScope.username}">
                                    <span class="badge bg-success">${sessionScope.username}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Guest</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>User Role:</strong></td>
                        <td>
                            <c:if test="${not empty sessionScope.role}">
                                <span class="badge bg-primary">${sessionScope.role}</span>
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Request URI:</strong></td>
                        <td><code>${pageContext.request.requestURI}</code></td>
                    </tr>
                    <tr>
                        <td><strong>Context Path:</strong></td>
                        <td><code>${pageContext.request.contextPath}</code></td>
                    </tr>
                    <tr>
                        <td><strong>Server Info:</strong></td>
                        <td><code>${pageContext.servletContext.serverInfo}</code></td>
                    </tr>
                </table>
            </div>
        </div>
        
        <div class="alert alert-success">
            <h4>✓ All JSTL Tags Demonstrated!</h4>
            <p class="mb-0">This page showcases: c:set, c:out, c:if, c:choose, c:forEach, c:forTokens, c:url, c:import, 
            fmt:formatNumber, fmt:formatDate, fmt:parseNumber, fmt:parseDate, 
            fn:length, fn:substring, fn:contains, fn:startsWith, fn:endsWith, fn:toLowerCase, fn:toUpperCase, 
            fn:replace, fn:split, fn:trim, fn:escapeXml, and more!</p>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>