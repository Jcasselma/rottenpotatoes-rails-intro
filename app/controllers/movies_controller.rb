class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
  #ORDER BY TITLE OR RELEASE
    sort_choice = params[:sort]
    case sort_choice
    when 'title'
      @sorted_order = "title: :asc"
      @title = 'hilite'
    when 'release'
      @sorted_order = "release_date: :asc"
      @release = 'hilite'
    end

  #FILTER BY AGE RATING
    @all_ratings = Movie.distinct.pluck(:rating)
    @rating_choice = []
    rating_choice = params[:ratings]
    @rating_choice = rating_choice.keys
  
    
  #PASS SORT + FILTER TOGETHER TO THE VIEW
    @movies = Movie.order(@sorted_order)
  end
    

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
