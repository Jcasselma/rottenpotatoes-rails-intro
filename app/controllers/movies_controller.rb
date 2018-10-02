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
    if (params[:sort])
      sort_choice = params[:sort]
      if (sort_choice == 'title')
        @sorted_order = ".order(title: :asc)"
        session[:sorted_order] = @sorted_order
        @title = 'hilite'
        session[:title] = @title
        session[:release] = @release
      end
      if (sort_choice == 'release')
        @sorted_order = ".order(release_date: :asc)"
        session[:sorted_order] = @sorted_order
        @release = 'hilite'
        session[:title] = @title 
        session[:release] = @release
      end
      session[:sort_params] = params[:sort]
    end
    if (!params[:sort])
      if (session[:sorted_order])
        @sorted_order = session[:sorted_order]
        @title = session[:title]
        @release = session[:release]
      end
      if (!session[:sorted_order])
        @sorted_order = ".all"
      end
    end
  
    #FILTER BY AGE RATING    
    @all_ratings = Movie.distinct.pluck(:rating)
    @rating_choice = []
    if (params[:ratings])
      @rating_choice = ".where(:rating => #{params[:ratings].keys})"
      session[:rating_choice] = @rating_choice
      session[:ratings_params] = params[:ratings]
    end
    if (!params[:ratings])
      if (session[:rating_choice])
        @rating_choice = session[:rating_choice]
      end
      if (!session[:rating_choice])
        @rating_choice = ""
      end
    end
  
    #PASS SORT + FILTER TOGETHER TO THE VIEW
    movies_query = "Movie" +"#{@sorted_order}" + "#{@rating_choice}"
    @movies = eval movies_query
    #render :text => movies_query.inspect
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
