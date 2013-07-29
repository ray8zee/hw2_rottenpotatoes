class MoviesController < ApplicationController
  helper_method :sort_column

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @sort_column = sort_column
    @checked_ratings, checked = checked_ratings
    @movies = @sort_column || checked ?
      Movie.where(rating: @checked_ratings.keys).order(@sort_column) : 
      Movie.all
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

  def sort_column 
    sort = params[:sort] || session[:sort]
    session[:sort] = sort if sort
    %w[title release_date].include?(sort) ? sort : nil
  end

  def checked_ratings
     ratings = params[:ratings] || session[:ratings] || {}
     if ratings.empty?
       Movie.all_ratings.each {|r| ratings[r] = 1 }
       checked = false
     else
       checked = true
     end
     session[:ratings] = ratings
     return ratings, checked
  end

end
