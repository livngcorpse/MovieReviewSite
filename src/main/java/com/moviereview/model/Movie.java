package com.moviereview.model;

public class Movie {
    private int movieId;
    private String title;
    private String director;
    private int year;
    private String description;
    private String posterUrl;  // NEW FIELD
    private double avgRating;
    private int reviewCount;
    
    public Movie() {}
    
    public Movie(int movieId, String title, String director, int year, String description) {
        this.movieId = movieId;
        this.title = title;
        this.director = director;
        this.year = year;
        this.description = description;
    }
    
    // Getters and Setters
    public int getMovieId() {
        return movieId;
    }
    
    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDirector() {
        return director;
    }
    
    public void setDirector(String director) {
        this.director = director;
    }
    
    public int getYear() {
        return year;
    }
    
    public void setYear(int year) {
        this.year = year;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getPosterUrl() {
        return posterUrl;
    }
    
    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }
    
    public double getAvgRating() {
        return avgRating;
    }
    
    public void setAvgRating(double avgRating) {
        this.avgRating = avgRating;
    }
    
    public int getReviewCount() {
        return reviewCount;
    }
    
    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }
}