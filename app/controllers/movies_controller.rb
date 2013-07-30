class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings      = Movie.all_ratings
    @sort             = sanitize_sort    params[:sort]    || session[:sort]
    @ratings          = sanitize_ratings params[:ratings] || session[:ratings]
    session[:sort]    = @sort
    session[:ratings] = @ratings

    if params[:sort] == @sort && params[:ratings] == @ratings
      @movies = Movie.where(rating: @ratings.keys).order(@sort)
    else
      flash.keep
      redirect_to movies_path(:sort => @sort, :ratings => @ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  private

  def sanitize_sort(sort)
    %w[title release_date].include?(sort) ? sort : 'title'
  end

  def sanitize_ratings(ratings)
    ratings ||= {}
    if ratings != {}
      ratings.delete_if { |r,v| not @all_ratings.include?(r) }
    end
    if ratings.empty?
      ratings = Hash[@all_ratings.map { |rating| [rating, 1] }]
    end
    return ratings
  end
end
