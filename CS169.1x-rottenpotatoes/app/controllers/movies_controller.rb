class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sortedby = params[:sortedby] || session[:sortedby]
    if sortedby == 'title'
      @title_header = 'hilite'
    elsif sortedby == 'release_date'
      @release_date_header = 'hilite'
    end

    @all_ratings = Movie.AllRatings
    @selected_ratings = params[:ratings] || session[:ratings]

    if @selected_ratings.nil?
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:ratings] != session[:ratings] || params[:sortedby] != session[:sortedby]
      session[:ratings] = params[:ratings]
      session[:sortedby] = params[:sortedby]
      redirect_to :sortedby => sortedby, :ratings => @selected_ratings and return
    end
    #debugger
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, :order => sortedby)
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

end
