class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if got_params
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

  def got_params
    @sort = params[:sort]
    @ratings = params[:ratings]
    result = @sort != nil && @ratings != nil 
    @sort ||= session[:sort]
    @ratings ||= session[:ratings] || {}
    if @ratings.empty?
      Movie.all_ratings.each {|r| @ratings[r] = 1 }
    end
    if !@sort || !%w[title release_date].include?(@sort)
      @sort = 'title'
      result = false
    end
    session[:sort] = @sort
    session[:ratings] = @ratings
    result
  end

end
